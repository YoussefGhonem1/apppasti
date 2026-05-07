import 'package:flutter/material.dart';
import 'package:pasti/helper_functions/navigation.dart';
import 'package:pasti/helper_functions/small_functions.dart';
import 'package:pasti/models/classes.dart';
import 'package:pasti/models/new_student.dart';
import 'package:pasti/models/school.dart';
import 'package:pasti/screens/auth/register/school_register.dart';
import 'package:pasti/screens/main_page/school/home/controller.dart';
import 'package:pasti/screens/main_page/school/settings/classes.dart';
import 'package:pasti/screens/main_page/school/settings/new_students/view.dart';
import 'package:pasti/shared/dialogs.dart';
import 'package:pasti/shared/screens/account/controller.dart';
import 'package:pasti/shared/screens/account/web_view.dart';
import 'package:pasti/shared/widgets/app_bar.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/theme.dart';
import '../../../constants/var.dart';
import '../../../helper_functions/loading.dart';
import 'contact_us/contact.dart';

class MyAccount extends StatefulWidget {
  final bool fromSchool;
  final School school;
  const MyAccount({required this.fromSchool, required this.school, Key? key})
      : super(key: key);

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  late School schoolInfo;

  @override
  void initState() {
    super.initState();
    schoolInfo = widget.school;
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF121212) : Color(0xFFFAFAFA),
      appBar: appBar1('Il mio account'),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            children: [
              SizedBox(height: 0.75.h),

              // School Info Card
              _buildSchoolInfoCard(isDarkMode),

              SizedBox(height: 1.h),

              // Menu Items
              _buildMenuItems(isDarkMode),

              SizedBox(height: 1.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSchoolInfoCard(bool isDarkMode) {
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
      child: Row(
        children: [
          Container(
            width: 4,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [mainColor, secColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row(
                //   children: [
                //     Container(
                //       width: 12.w,
                //       height: 12.w,
                //       decoration: BoxDecoration(
                //         color: mainColor.withValues(alpha: 0.1),
                //         shape: BoxShape.circle,
                //       ),
                //       child: Center(
                //         child: Icon(
                //           Icons.business_rounded,
                //           color: mainColor,
                //           size: 4.w,
                //         ),
                //       ),
                //     ),
                //     SizedBox(width: 4.w),
                //     Expanded(
                //       child: Text(
                //         'Informazioni Azienda',
                //         style: TextStyle(
                //           color: isDarkMode ? Colors.white : Colors.black,
                //           fontSize: 12.sp,
                //           fontWeight: FontWeight.w700,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(height: 1.h),
                Container(
                  padding: EdgeInsets.all(1.5.w),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[900] : Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: isTablet ? 14.w : 20.w,
                        height: isTablet ? 14.w : 20.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: mainColor.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            schoolInfo.image ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: mainColor.withValues(alpha: 0.1),
                                child: Icon(
                                  Icons.business,
                                  color: mainColor,
                                  size: 24,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              schoolInfo.name ?? '',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 1.h),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 0.8.h),
                                  decoration: BoxDecoration(
                                    color: mainColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Codice: ${widget.school.code}',
                                    style: TextStyle(
                                      color: mainColor,
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            if (schoolInfo.address != null &&
                                schoolInfo.address!.isNotEmpty)
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_rounded,
                                    color: Colors.grey[500],
                                    size: 14,
                                  ),
                                  SizedBox(width: 2.w),
                                  Expanded(
                                    child: Text(
                                      schoolInfo.address!,
                                      style: TextStyle(
                                        color: isDarkMode
                                            ? Colors.grey[400]
                                            : Colors.grey[600],
                                        fontSize: 10.sp,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(bool isDarkMode) {
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
          if (widget.fromSchool)
            _buildMenuItem(
              icon: Icons.edit_rounded,
              iconColor: mainColor,
              backgroundColor: mainColor.withValues(alpha: 0.1),
              title: 'Modifica account',
              onTap: () {
                navP(
                    context,
                    SchoolRegister(
                      school: schoolInfo,
                    ), then: () {
                  setState(() {
                    schoolInfo = school;
                  });
                });
              },
              isDarkMode: isDarkMode,
            ),
          if (widget.fromSchool) SizedBox(height: 1.h),
          if (widget.fromSchool)
            _buildMenuItem(
              icon: Icons.person_add_rounded,
              iconColor: Color(0xff00AB07),
              backgroundColor: Color(0xff00AB07).withValues(alpha: 0.1),
              title: 'Nuovi Collaboratori',
              badgeCount: newStudents,
              onTap: () async {
                List<NewStudent> students = await newStudentsFunction(context);
                navP(
                    context,
                    NewStudents(
                      list: students,
                    ), then: () {
                  setState(() {});
                });
              },
              isDarkMode: isDarkMode,
            ),
          if (widget.fromSchool) SizedBox(height: 1.h),
          if (widget.fromSchool)
            _buildMenuItem(
              icon: Icons.business_rounded,
              iconColor: mainColor,
              backgroundColor: mainColor.withValues(alpha: 0.1),
              title: 'Sede',
              onTap: () async {
                List<Classes> list = await Classes.getClasses();
                navP(context, ClassesPage(classes: list));
              },
              isDarkMode: isDarkMode,
            ),
          if (widget.fromSchool) SizedBox(height: 1.h),
          _buildMenuItem(
            icon: Icons.contact_support_rounded,
            iconColor: Colors.blue,
            backgroundColor: Colors.blue.withValues(alpha: 0.1),
            title: 'Contattaci',
            onTap: () {
              navP(
                  context,
                  ContactUs(
                    fromSchool: widget.fromSchool,
                  ));
            },
            isDarkMode: isDarkMode,
          ),
          SizedBox(height: 1.h),
          _buildMenuItem(
            icon: Icons.description_rounded,
            iconColor: Colors.orange,
            backgroundColor: Colors.orange.withValues(alpha: 0.1),
            title: 'Termini & Condizioni',
            onTap: () async {
              navP(context, WebViewPage());
            },
            isDarkMode: isDarkMode,
          ),
          SizedBox(height: 1.h),
          _buildMenuItem(
            icon: Icons.delete_forever_rounded,
            iconColor: Color(0xffFF0005),
            backgroundColor: Color(0xffFF0005).withValues(alpha: 0.1),
            title: 'Cancella il tuo account',
            onTap: () async {
              loading(context);
              await delay(3000);
              navPop(context);
              successDialog(context,
                  msg:
                      "La tua richiesta è stata inviata e l'amministrazione ti contatterà presto");
            },
            isDarkMode: isDarkMode,
          ),
          SizedBox(height: 1.h),
          _buildMenuItem(
            icon: Icons.logout_rounded,
            iconColor: Colors.red,
            backgroundColor: Colors.red.withValues(alpha: 0.1),
            title: 'Disconnettersi',
            onTap: () async {
              logoutFunction(context, widget.fromSchool, null);
            },
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String title,
    int? badgeCount,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isDarkMode ? Colors.grey[900] : Colors.grey[50],
          ),
          child: Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 5.5.w,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (badgeCount != null && badgeCount > 0)
                Container(
                  margin: EdgeInsets.only(right: 2.w),
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [mainColor, mainColor.withValues(alpha: 0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      badgeCount > 9 ? '9+' : badgeCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: isDarkMode ? Colors.grey[500] : Colors.grey[400],
                size: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
