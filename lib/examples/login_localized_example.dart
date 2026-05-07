import 'package:flutter/material.dart';
import 'package:pasti/constants/theme.dart';
import 'package:pasti/helper_functions/navigation.dart';
import 'package:pasti/helper_functions/localizer.dart'; // Import the localizer
import 'package:pasti/providers/change_language.dart';
import 'package:pasti/screens/auth/login/controller.dart';
import 'package:pasti/screens/auth/register/student_register.dart';
import 'package:pasti/shared/widgets/buttons.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../constants/var.dart';

/// EXAMPLE: Login Screen with Localization
/// This is an example of how to convert the existing login screen to use translations
///
/// BEFORE: Hardcoded Italian strings
/// AFTER: Using tr() function for bilingual support (Italian/Arabic)

class LoginLocalized extends StatefulWidget {
  const LoginLocalized({Key? key}) : super(key: key);

  @override
  State<LoginLocalized> createState() => _LoginLocalizedState();
}

class _LoginLocalizedState extends State<LoginLocalized> {
  List<TextEditingController> list1 =
      List.generate(2, (index) => TextEditingController());
  List<FocusNode> list2 = List.generate(2, (index) => FocusNode());
  final _formKey = GlobalKey<FormState>();

  // BEFORE: Hardcoded Italian strings
  // List<Map<String,String>> list = [
  //   {"title":"Nome utente","image":"assets/person_icon.png"},
  //   {"title":"Password","image":"assets/pass_icon.png"},
  // ];

  // AFTER: Using translation keys
  List<Map<String, String>> get list => [
        {"title": tr('auth.username'), "image": "assets/person_icon.png"},
        {"title": tr('auth.password'), "image": "assets/pass_icon.png"},
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SizedBox(
            width: 100.w,
            height: 100.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/login.png',
                        fit: BoxFit.contain,
                        width: isTablet ? 43.w : 55.w,
                      ),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),

                    // BEFORE: Text('Bentornato !',...)
                    // AFTER: Using translation
                    Text(
                      tr('auth.welcome_back'),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17.sp,
                      ),
                    ),

                    SizedBox(
                      height: 3.h,
                    ),
                    Column(
                      children: List.generate(
                        list.length,
                        (i) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 1.h),
                          child: TextFormField(
                            controller: list1[i],
                            focusNode: list2[i],
                            cursorColor: mainColor,
                            style:
                                TextStyle(fontSize: 11.sp, color: Colors.grey),
                            validator: (value) {
                              if (value!.isEmpty) {
                                // BEFORE: return 'Deve riempire il campo';
                                // AFTER: Using translation
                                return tr('validation.field_required');
                              }
                              return null;
                            },
                            onEditingComplete: () {
                              FocusScope.of(context).unfocus();
                              if (i != list2.length - 1) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            decoration: inputDecoration1(
                                label: list[i]['title'],
                                prefixIcon: Image.asset(
                                  list[i]['image']!,
                                  color: mainColor,
                                )),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),

                    // BEFORE: button1('Login',...)
                    // AFTER: Using translation
                    button1(tr('auth.login'), onTap: () {
                      if (_formKey.currentState!.validate()) {
                        loginFunction(context,
                            userName: list1.first.text,
                            pass: list1.last.text,
                            fromLogin: true);
                      }
                    }),

                    SizedBox(
                      height: 12.h,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: InkWell(
                        child: RichText(
                          text: TextSpan(
                            onEnter: (v) {},
                            children: [
                              // BEFORE: TextSpan(text: 'Non hai account ? ',...)
                              // AFTER: Using translation
                              TextSpan(
                                text: tr('auth.no_account'),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.sp,
                                    color: Colors.black),
                              ),

                              // BEFORE: TextSpan(text: 'Registrati ora',...)
                              // AFTER: Using translation
                              TextSpan(
                                  text: tr('auth.register_now'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.sp,
                                      color: mainColor),
                                  onEnter: (v) {}),
                            ],
                          ),
                        ),
                        onTap: () {
                          navP(context, StudentRegister());
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// EXAMPLE: How to use translations in controllers
///
/// BEFORE (in controller):
/// showSnackBar(context, 'Il tuo account è in fase di revisione');
///
/// AFTER:
/// showSnackBar(context, tr('auth.account_under_review'));

/// EXAMPLE: How to use translations with dynamic data
///
/// String userName = "Mario";
/// Text("Ciao, $userName!") // Hardcoded
///
/// // For now, use string interpolation:
/// Text("${tr('common.hello')}, $userName!")
///
/// // Future: Add placeholder support
/// Text(tr('common.hello_user', args: {'name': userName}))

/// EXAMPLE: Language Switcher Widget
class LanguageSwitcherExample extends StatefulWidget {
  @override
  State<LanguageSwitcherExample> createState() =>
      _LanguageSwitcherExampleState();
}

class _LanguageSwitcherExampleState extends State<LanguageSwitcherExample> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () async {
            // Switch to Italian
            await Provider.of<AppLanguage>(context, listen: false)
                .changeLanguage(const Locale('it'));
            await AppLocalizer.load('it');
            setState(() {}); // Rebuild to show new language
          },
          child: Text('🇮🇹 Italiano'),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () async {
            // Switch to Arabic
            await Provider.of<AppLanguage>(context, listen: false)
                .changeLanguage(const Locale('ar'));
            await AppLocalizer.load('ar_new');
            setState(() {}); // Rebuild to show new language
          },
          child: Text('🇸🇦 العربية'),
        ),
      ],
    );
  }
}

/// MIGRATION CHECKLIST FOR EACH SCREEN:
/// 
/// 1. Import localizer: import 'package:pasti/helper_functions/localizer.dart';
/// 2. Find all hardcoded Italian strings
/// 3. Replace with tr('key.subkey')
/// 4. Test with both Italian and Arabic
/// 5. Add missing keys to it.json and ar_new.json if needed
/// 
/// COMMON REPLACEMENTS:
/// - "Bentornato !" → tr('auth.welcome_back')
/// - "Nome utente" → tr('auth.username')
/// - "Password" → tr('auth.password')
/// - "Login" → tr('auth.login')
/// - "Registrati" → tr('auth.register')
/// - "Confermare" → tr('auth.confirm')
/// - "Deve riempire il campo" → tr('validation.field_required')
/// - "Operazione riuscita" → tr('school.operation_success')
/// - "L`ordine è stato inviato con successo" → tr('student.order_sent')
