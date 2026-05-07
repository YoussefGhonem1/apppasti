import 'package:flutter/material.dart';
import 'package:pasti/shared/screens/account/controller.dart';
import 'package:pasti/shared/widgets/app_bar.dart';
import 'package:sizer/sizer.dart';

import '../../../../../constants/theme.dart';

class ContactUs extends StatefulWidget {
  final bool fromSchool;
  const ContactUs({required this.fromSchool, Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  List<Map<String, String>> list = [
    {"title": "Nome", "image": "assets/person_icon.png"},
    {"title": "E-mail", "image": "assets/email_icon.png"},
    {"title": "Oggetto", "image": "assets/title_icon.png"},
    {"title": "Descrizione", "image": "assets/title_icon.png"},
  ];

  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> list1 =
      List.generate(4, (index) => TextEditingController());
  List<FocusNode> list2 = List.generate(4, (index) => FocusNode());

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: isDarkMode ? Color(0xFF121212) : Color(0xFFFAFAFA),
        appBar: appBar1('Contattaci'),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 2.h),

                  // Header Card
                  _buildHeaderCard(isDarkMode),

                  SizedBox(height: 4.h),

                  // Contact Form
                  _buildContactForm(isDarkMode),

                  SizedBox(height: 6.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDarkMode ? 0.2 : 0.05),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: mainColor.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  mainColor.withValues(alpha: 0.1),
                  mainColor.withValues(alpha: 0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.contact_support_rounded,
                color: mainColor,
                size: 12.w,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Contattaci',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Compila il modulo sottostante e ti risponderemo al più presto',
            style: TextStyle(
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContactForm(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDarkMode ? 0.2 : 0.05),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 14.w,
                height: 14.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [mainColor, mainColor.withValues(alpha: 0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Icon(
                    Icons.edit_note_rounded,
                    color: Colors.white,
                    size: 6.w,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  'Compila il modulo',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Column(
            children: List.generate(list.length, (i) {
              final isDescription = i == 3;
              return Padding(
                padding: EdgeInsets.only(bottom: 3.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 2.w, bottom: 1.h),
                      child: Text(
                        list[i]['title']!,
                        style: TextStyle(
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Material(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.transparent,
                      child: TextFormField(
                        cursorColor: mainColor,
                        controller: list1[i],
                        focusNode: list2[i],
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isDarkMode ? Colors.white : Colors.black,
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
                        maxLines: isDescription ? 7 : 1,
                        minLines: isDescription ? 5 : 1,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: isDarkMode
                              ? Colors.white.withValues(alpha: 0.05)
                              : Colors.white,
                          hintText:
                              "Inserisci ${list[i]['title']?.toLowerCase()}",
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 11.sp,
                          ),
                          prefixIcon: Container(
                            width: 60,
                            child: Row(
                              children: [
                                SizedBox(width: 4.w),
                                Image.asset(
                                  list[i]['image']!,
                                  width: 5.w,
                                  color: mainColor,
                                ),
                                SizedBox(width: 4.w),
                                Container(
                                  width: 1,
                                  height: 20,
                                  color: Colors.grey[300],
                                ),
                              ],
                            ),
                          ),
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
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: isDescription ? 3.h : 2.5.h,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          SizedBox(height: 2.h),
          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  FocusScope.of(context).unfocus();
                  contactUsFunction(context,
                      inputs: list1, fromSchool: widget.fromSchool);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shadowColor: mainColor.withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.symmetric(vertical: 2.5.h),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Invia messaggio',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Icon(
                    Icons.send_rounded,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
