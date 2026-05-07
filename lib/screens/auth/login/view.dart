import 'package:flutter/material.dart';
import 'package:pasti/constants/theme.dart';
import 'package:pasti/helper_functions/navigation.dart';
import 'package:pasti/screens/auth/login/controller.dart';
import 'package:pasti/screens/auth/register/student_register.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/services.dart';
import '../../../constants/var.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  List<TextEditingController> list1 =
      List.generate(2, (index) => TextEditingController());
  List<FocusNode> list2 = List.generate(2, (index) => FocusNode());
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _isLoading = false;
  double _logoOffset = -50;
  double _opacity = 0;

  List<Map<String, String>> list = [
    {"title": "Nome utente", "image": "assets/person_icon.png"},
    {"title": "Password", "image": "assets/pass_icon.png"},
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _logoOffset = 0;
        _opacity = 1;
      });
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(Duration(milliseconds: 500));
      try {
        await loginFunction(context,
            userName: list1.first.text, pass: list1.last.text, fromLogin: true);
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              isDarkMode ? Brightness.light : Brightness.dark,
        ),
        child: Form(
          key: _formKey,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDarkMode
                      ? [
                          Color(0xFF1a1a2e),
                          Color(0xFF16213e),
                          Color(0xFF0f3460),
                        ]
                      : [
                          Colors.white,
                          Color(0xFFf8f9fa),
                          Color(0xFFe9ecef),
                        ],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 2.h),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 800),
                          curve: Curves.easeOutCubic,
                          transform:
                              Matrix4.translationValues(0, _logoOffset, 0),
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 800),
                            opacity: _opacity,
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      mainColor.withValues(alpha: 0.2),
                                      mainColor.withValues(alpha: 0.8),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: mainColor.withValues(alpha: 0.3),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(isTablet ? 20 : 15),
                                child: Image.asset(
                                  'assets/login.png',
                                  fit: BoxFit.contain,
                                  width: isTablet ? 30.w : 45.w,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        AnimatedOpacity(
                          duration: Duration(milliseconds: 600),
                          opacity: _opacity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bentornato!',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20.sp,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                'Accedi al tuo account',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 4.h),
                        AnimatedOpacity(
                          duration: Duration(milliseconds: 700),
                          opacity: _opacity,
                          child: Column(
                            children: List.generate(
                              list.length,
                              (i) => Padding(
                                padding: EdgeInsets.only(bottom: 2.h),
                                child: Material(
                                  elevation: 2,
                                  borderRadius: BorderRadius.circular(16),
                                  shadowColor: mainColor.withValues(alpha: 0.1),
                                  child: TextFormField(
                                    controller: list1[i],
                                    focusNode: list2[i],
                                    cursorColor: mainColor,
                                    obscureText: i == 1 ? _obscureText : false,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.grey[800],
                                      fontWeight: FontWeight.w500,
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Deve riempire il campo';
                                      }
                                      return null;
                                    },
                                    onEditingComplete: () {
                                      FocusScope.of(context).unfocus();
                                      if (i != list2.length - 1) {
                                        FocusScope.of(context).nextFocus();
                                      }
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: isDarkMode
                                          ? Colors.white.withValues(alpha: 0.05)
                                          : Colors.white,
                                      hintText: list[i]['title'],
                                      hintStyle: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 11.sp,
                                      ),
                                      prefixIcon: Container(
                                        width: 60,
                                        child: Row(
                                          children: [
                                            SizedBox(width: 20),
                                            Image.asset(
                                              list[i]['image']!,
                                              color: mainColor,
                                              height: 20,
                                            ),
                                            SizedBox(width: 15),
                                            Container(
                                              width: 1,
                                              height: 20,
                                              color: Colors.grey[300],
                                            ),
                                          ],
                                        ),
                                      ),
                                      suffixIcon: i == 1
                                          ? IconButton(
                                              icon: Icon(
                                                _obscureText
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                color: Colors.grey[500],
                                              ),
                                              onPressed:
                                                  _togglePasswordVisibility,
                                            )
                                          : null,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          color: mainColor,
                                          width: 1.5,
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: isTablet ? 22 : 18,
                                        horizontal: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 3.h),
                        AnimatedOpacity(
                          duration: Duration(milliseconds: 800),
                          opacity: _opacity,
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mainColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shadowColor: mainColor.withValues(alpha: 0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: isTablet ? 20 : 18,
                                ),
                              ),
                              child: _isLoading
                                  ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Login',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        AnimatedOpacity(
                          duration: Duration(milliseconds: 900),
                          opacity: _opacity,
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.grey[300],
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  'Oppure',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.grey[300],
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 4.h),
                        AnimatedOpacity(
                          duration: Duration(milliseconds: 1000),
                          opacity: _opacity,
                          child: Center(
                            child: GestureDetector(
                              onTap: _isLoading
                                  ? null
                                  : () => navP(context, StudentRegister()),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 24,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: mainColor.withValues(alpha: 0.3),
                                    width: 1.5,
                                  ),
                                  color: mainColor.withValues(alpha: 0.05),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person_add,
                                      color: mainColor,
                                      size: 16,
                                    ),
                                    SizedBox(width: 8),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Non hai account? ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11.sp,
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.grey[700],
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'Registrati ora',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 11.sp,
                                              color: mainColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5.h),
                        AnimatedOpacity(
                          duration: Duration(milliseconds: 1100),
                          opacity: _opacity,
                          child: Center(
                            child: Text(
                              '© 2024 Pasti. Tutti i diritti riservati',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 10.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
