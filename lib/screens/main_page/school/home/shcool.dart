import 'package:flutter/material.dart';
import 'package:pasti/helper_functions/navigation.dart';
import 'package:pasti/models/school.dart';
import 'package:pasti/screens/main_page/school/all_meals/new_meals.dart';
import 'package:pasti/screens/main_page/school/all_meals/view.dart';
import 'package:pasti/screens/main_page/school/home/add_order/view.dart';
import 'package:pasti/screens/main_page/school/students/view.dart';
import 'package:pasti/screens/main_page/school/qr_scanner/view.dart';
import 'package:pasti/screens/main_page/student/home/controller.dart';
import 'package:pasti/screens/main_page/student/home/menu/check_out/controller.dart';
import 'package:pasti/shared/screens/account/controller.dart';
import 'package:pasti/shared/screens/account/view.dart';
import 'package:pasti/models/notification.dart';
import 'package:pasti/screens/main_page/student/notification/view.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/theme.dart';
import '../../../../models/meal.dart';
import '../../../../models/new_student.dart';
import '../../../../shared/screens/info/view.dart';
import '../settings/new_students/view.dart';
import '../statistics/view.dart';
import 'controller.dart';

class SchoolHome extends StatefulWidget {
  const SchoolHome({Key? key}) : super(key: key);

  @override
  _SchoolHomeState createState() => _SchoolHomeState();
}

class _SchoolHomeState extends State<SchoolHome> {
  late School schoolInfo;

  @override
  void initState() {
    super.initState();
    schoolInfo = school;
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF121212) : Color(0xFFFAFAFA),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: Icon(Icons.add, size: 20),
        label: Text(
          'Ordina ora',
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () async {
          List<MealStudent> list = await getSchoolMenuFunction(context);
          cart.clear();
          navP(context, AddOrder(mealsList: list, fromSchool: true));
        },
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Background decorative elements
            Positioned(
              bottom: -5.w,
              left: -5.w,
              child: Opacity(
                opacity: 0.1,
                child: Image.asset(
                  'assets/hot_plate.png',
                  width: 40.w,
                ),
              ),
            ),

            RefreshIndicator(
              onRefresh: () async {
                await countsFunction(context, load: false);
                setState(() {});
              },
              color: mainColor,
              backgroundColor: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 2.h),

                    // Header Card
                    _buildHeaderCard(isDarkMode),

                    SizedBox(height: 4.h),

                    // Stats Cards Grid
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Column(
                        children: [
                          // First Row - Orders & Menu
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatsCard(
                                  icon: 'assets/food3.png',
                                  title: 'Ordini di oggi',
                                  count: meals,
                                  unit: 'pasti',
                                  color: mainColor,
                                  isDarkMode: isDarkMode,
                                  onTap: () async {
                                    await getMealFunction(context);
                                    navP(context, AllMeals());
                                  },
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: _buildStatsCard(
                                  icon: 'assets/food5.png',
                                  title: 'Nuovo Menù',
                                  count: newMeals,
                                  unit: 'pasti',
                                  color: Colors.green,
                                  isDarkMode: isDarkMode,
                                  onTap: () async {
                                    List<Meal> meal =
                                        await getNewMealFunction(context);
                                    navP(context, NewMeals(meal: meal),
                                        then: () {
                                      setState(() {});
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 3.h),

                          // Second Row - Students
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatsCard(
                                  icon: 'assets/student_group.png',
                                  title: 'Collaboratori',
                                  count: students,
                                  unit: 'Collaboratori',
                                  color: Colors.blue,
                                  isDarkMode: isDarkMode,
                                  onTap: () async {
                                    await getStudentFunction(context);
                                    navP(context, AllStudents());
                                  },
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: _buildStatsCard(
                                  icon: 'assets/student_group.png',
                                  title: 'Nuovi Collaboratori',
                                  count: newStudents,
                                  unit: 'Collaboratori',
                                  color: Colors.orange,
                                  isDarkMode: isDarkMode,
                                  onTap: () async {
                                    List<NewStudent> students =
                                        await newStudentsFunction(context);
                                    navP(context, NewStudents(list: students),
                                        then: () {
                                      setState(() {});
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 3.h),

                          // Company Meals Card
                          _buildCompanyMealsCard(isDarkMode),

                          SizedBox(height: 10.h), // Space for FAB
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(bool isDarkMode) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
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
            width: 17.w,
            height: 17.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: mainColor.withValues(alpha: 0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: mainColor.withValues(alpha: 0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
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
                      size: 28,
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
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                        color: mainColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.waving_hand_rounded,
                        color: mainColor,
                        size: 16,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Bentornato,',
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      schoolInfo.name ?? '',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: mainColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        child: Icon(
                          Icons.qr_code_scanner,
                          color: mainColor,
                          size: 20,
                        ),
                        onTap: () {
                          navP(context, QRScannerPage());
                        },
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Container(
                      padding: EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: mainColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        child: Icon(
                          Icons.bar_chart_rounded,
                          color: mainColor,
                          size: 20,
                        ),
                        onTap: () {
                          navP(context, SchoolStatistics());
                        },
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Container(
                      padding: EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: mainColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        child: Icon(
                          Icons.notifications_outlined,
                          color: mainColor,
                          size: 20,
                        ),
                        onTap: () async {
                          List<NotificationClass> list =
                              await getNotificationSchoolFunction(context);
                          navP(context, NotificationPage(list: list));
                        },
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Container(
                      padding: EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: mainColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        child: Icon(
                          Icons.settings_outlined,
                          color: mainColor,
                          size: 20,
                        ),
                        onTap: () async {
                          navP(context,
                              MyAccount(fromSchool: true, school: school),
                              then: () {
                            setState(() {
                              schoolInfo = school;
                            });
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard({
    required String icon,
    required String title,
    required int count,
    required String unit,
    required Color color,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDarkMode ? 0.2 : 0.05),
                blurRadius: 15,
                offset: Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 14.w,
                    height: 14.w,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(
                        icon,
                        width: 6.w,
                      ),
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: isDarkMode ? Colors.grey[500] : Colors.grey[400],
                    size: 16,
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                title,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 1.h),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$count ',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(
                      text: unit,
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color.withValues(alpha: 0.1),
                    foregroundColor: color,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: color, width: 1.5),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  ),
                  child: Text(
                    'Mostra tutti',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyMealsCard(bool isDarkMode) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          await getOrdersSchoolFunction(context);
          navP(
            context,
            StudentInfo(
              id: 0,
              name: school.name ?? '',
              fromSchool: true,
              schoolOrders: true,
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDarkMode ? 0.2 : 0.05),
                blurRadius: 15,
                offset: Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 14.w,
                height: 14.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    'assets/food.png',
                    width: 6.w,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pasti per l\'azienda',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Visualizza tutti gli ordini',
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 9.5.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 1.w),
              ElevatedButton(
                onPressed: () async {
                  await getOrdersSchoolFunction(context);
                  navP(
                    context,
                    StudentInfo(
                      id: 0,
                      name: school.name ?? '',
                      fromSchool: true,
                      schoolOrders: true,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.withValues(alpha: 0.1),
                  foregroundColor: Colors.purple,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.purple, width: 1.5),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Vedi',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    Icon(Icons.arrow_forward, size: 14),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
