import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pasti/constants/theme.dart';
import 'package:pasti/helper_functions/navigation.dart';
import 'package:pasti/main.dart';
import 'package:pasti/models/order.dart';
import 'package:pasti/screens/main_page/school/home/add_order/view.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as date;
import '../../models/meal.dart';
import '../../models/notification.dart';
import '../../screens/main_page/student/home/controller.dart';
import '../../screens/main_page/student/home/menu/check_out/controller.dart';
import '../../screens/main_page/student/notification/view.dart';
import '../screens/order/controller.dart';

PreferredSizeWidget appBar1(String title,
    {void Function()? onPressed,
    bool fromSchoolSettings = false,
    Order? orderId,
    bool? fromSchool}) {
  final brightness = GlobalVariable.navState.currentContext != null
      ? Theme.of(GlobalVariable.navState.currentContext!).brightness
      : Brightness.light;
  final isDarkMode = brightness == Brightness.dark;

  return AppBar(
    backgroundColor: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
    elevation: 0,
    title: Text(
      title,
      style: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black,
        fontSize: 15.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
    ),
    centerTitle: true,
    leading: Container(
      margin: EdgeInsets.only(left: 4.w),
      child: IconButton(
        icon: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDarkMode ? Colors.white : Colors.black,
            size: 16,
          ),
        ),
        onPressed: onPressed ??
            () => Navigator.maybePop(GlobalVariable.navState.currentContext!),
      ),
    ),
    actions: fromSchoolSettings
        ? [
            _buildNotificationBadge(isDarkMode),
            // SizedBox(width: 4.w),
          ]
        : orderId != null
            ? actions(orderId, fromSchool!)
            : null,
  );
}

Widget _buildNotificationBadge(bool isDarkMode) {
  return StatefulBuilder(builder: (context, setState) {
    return Container(
      margin: EdgeInsets.only(right: 4.w),
      child: badge.Badge(
        showBadge: unRead > 0,
        badgeContent: Text(
          unRead.toString(),
          style: TextStyle(color: Colors.white, fontSize: 8.sp),
        ),
        badgeStyle: badge.BadgeStyle(
          badgeColor: mainColor,
          padding: EdgeInsets.all(6),
        ),
        position: badge.BadgePosition.topEnd(top: -5, end: -5),
        child: IconButton(
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.notifications_outlined,
              color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
              size: 20,
            ),
          ),
          onPressed: () async {
            List<NotificationClass> list = await getNotificationSchoolFunction(
                GlobalVariable.navState.currentContext!);
            navP(GlobalVariable.navState.currentContext!,
                NotificationPage(list: list), then: () {
              setState(() {
                unRead = 0;
              });
            });
          },
        ),
      ),
    );
  });
}

List<Widget> actions(Order orderId, bool fromSchool) {
  if (orderId.status != OrderStatus.New) {
    return [];
  }
  return [
    Container(
      margin: EdgeInsets.only(right: 4.w),
      child: IconButton(
        onPressed: () async {
          List<MealStudent> list = await getOrderMeal(
              GlobalVariable.navState.currentContext!, orderId, fromSchool);
          cart.clear();
          navP(
              GlobalVariable.navState.currentContext!,
              AddOrder(
                mealsList: list,
                updateOrder: true,
                fromSchool: fromSchool,
                orderId: orderId.id,
              ));
        },
        icon: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [mainColor, mainColor.withValues(alpha: 0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: mainColor.withValues(alpha: 0.3),
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.edit,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    ),
  ];
}

late String from, to;
PreferredSizeWidget appBar2(String title,
    {void Function()? onPressed,
    required void Function() filter,
    required bool fromSchool,
    void Function(int val)? monthFilter}) {
  final brightness = GlobalVariable.navState.currentContext != null
      ? Theme.of(GlobalVariable.navState.currentContext!).brightness
      : Brightness.light;
  final isDarkMode = brightness == Brightness.dark;

  return AppBar(
    backgroundColor: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
    elevation: 0,
    title: Text(
      title,
      style: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black,
        fontSize: 15.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
    ),
    centerTitle: true,
    leading: Container(
      margin: EdgeInsets.only(left: 4.w),
      child: IconButton(
        icon: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDarkMode ? Colors.white : Colors.black,
            size: 16,
          ),
        ),
        onPressed: onPressed ??
            () => Navigator.maybePop(GlobalVariable.navState.currentContext!),
      ),
    ),
    actions: [
      // Container(
      //   margin: EdgeInsets.only(right: 4.w),
      //   child: InkWell(
      //     onTap: () {
      //       if (fromSchool) {
      //         filterSchool(filter);
      //       } else {
      //         filterStudent((val) {
      //           monthFilter!(val);
      //         });
      //       }
      //     },
      //     child: Container(
      //       padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      //       decoration: BoxDecoration(
      //         gradient: LinearGradient(
      //           colors: [mainColor, mainColor.withValues(alpha: 0.8)],
      //           begin: Alignment.topLeft,
      //           end: Alignment.bottomRight,
      //         ),
      //         borderRadius: BorderRadius.circular(30),
      //         boxShadow: [
      //           BoxShadow(
      //             color: mainColor.withValues(alpha: 0.2),
      //             blurRadius: 8,
      //             offset: Offset(0, 3),
      //           ),
      //         ],
      //       ),
      //       child: Row(
      //         children: [
      //           Icon(
      //             Icons.filter_alt_rounded,
      //             color: Colors.white,
      //             size: 16,
      //           ),
      //           SizedBox(width: 2.w),
      //           Text(
      //             'Filtro',
      //             style: TextStyle(
      //               color: Colors.white,
      //               fontSize: 11.sp,
      //               fontWeight: FontWeight.w600,
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    ],
    toolbarHeight: 9.h,
  );
}

void filterSchool(void Function() filter) {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  final brightness = GlobalVariable.navState.currentContext != null
      ? Theme.of(GlobalVariable.navState.currentContext!).brightness
      : Brightness.light;
  final isDarkMode = brightness == Brightness.dark;

  showModalBottomSheet(
    context: GlobalVariable.navState.currentContext!,
    backgroundColor: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
    isScrollControlled: true,
    builder: (context) {
      return Container(
        width: 100.w,
        constraints: BoxConstraints(
          maxHeight: 50.h,
          minHeight: 50.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  margin: EdgeInsets.only(top: 2.h),
                  width: 40.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: 3.h),
                // Header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: mainColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.filter_list_rounded,
                          color: mainColor,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Filtra per data',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4.h),
                // Content
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Column(
                      children: [
                        _buildDateField(
                          controller: controller1,
                          label: 'Data inizio',
                          isDarkMode: isDarkMode,
                          context: context,
                        ),
                        SizedBox(height: 3.h),
                        _buildDateField(
                          controller: controller2,
                          label: 'Data fine',
                          isDarkMode: isDarkMode,
                          context: context,
                        ),
                        SizedBox(height: 6.h),
                        // Apply button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (controller1.text != '' &&
                                  controller2.text != '') {
                                from = controller1.text;
                                to = controller2.text;
                                navPop(context);
                                filter();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 2.5.h),
                            ),
                            child: Text(
                              'Applica filtro',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildDateField({
  required TextEditingController controller,
  required String label,
  required bool isDarkMode,
  required BuildContext context,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(left: 3.w, bottom: 1.h),
        child: Text(
          label,
          style: TextStyle(
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      InkWell(
        onTap: () async {
          String? t1 = await pickDate(context);
          if (t1 == null && controller.text == "") {
            controller.clear();
          } else {
            if (t1 != null) {
              controller.text = t1;
            }
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Color(0xFF2D2D2D) : Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: mainColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.calendar_today,
                    color: mainColor,
                    size: 18,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    controller.text.isEmpty
                        ? 'Seleziona data'
                        : controller.text,
                    style: TextStyle(
                      color: controller.text.isEmpty
                          ? (isDarkMode ? Colors.grey[500] : Colors.grey[400])
                          : (isDarkMode ? Colors.white : Colors.black),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: mainColor,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

void filterStudent(void Function(int val) monthFilter) {
  int index = DateTime.now().month - 1; // Default to current month
  final brightness = GlobalVariable.navState.currentContext != null
      ? Theme.of(GlobalVariable.navState.currentContext!).brightness
      : Brightness.light;
  final isDarkMode = brightness == Brightness.dark;

  showModalBottomSheet(
    context: GlobalVariable.navState.currentContext!,
    backgroundColor: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
    builder: (context) {
      return Container(
        width: 100.w,
        constraints: BoxConstraints(
          maxHeight: 50.h,
          minHeight: 50.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                margin: EdgeInsets.only(top: 2.h),
                width: 40.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 3.h),
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: mainColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.calendar_month_rounded,
                        color: mainColor,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Filtra per mese',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4.h),
              // Month selector
              StatefulBuilder(builder: (context, set) {
                return Container(
                  height: 15.h,
                  child: ListView.builder(
                    itemCount: 12,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    itemBuilder: (ctx, i) {
                      final isSelected = index == i;
                      return Padding(
                        padding: EdgeInsets.only(right: 3.w),
                        child: InkWell(
                          onTap: () {
                            set(() {
                              index = i;
                            });
                          },
                          child: Container(
                            width: 22.w,
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? LinearGradient(
                                      colors: [
                                        mainColor,
                                        mainColor.withValues(alpha: 0.8)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                              color: isSelected
                                  ? null
                                  : (isDarkMode
                                      ? Color(0xFF2D2D2D)
                                      : Colors.grey[100]),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? mainColor
                                    : (isDarkMode
                                        ? Colors.grey[800]!
                                        : Colors.grey[300]!),
                                width: isSelected ? 0 : 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: mainColor.withValues(alpha: 0.3),
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormat('MMM', 'it').format(DateTime(
                                      DateTime.now().year,
                                      i + 1,
                                      DateTime.now().day)),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    color: isSelected
                                        ? Colors.white
                                        : (isDarkMode
                                            ? Colors.grey[300]
                                            : Colors.grey[700]),
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  (i + 1).toString(),
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w800,
                                    color: isSelected
                                        ? Colors.white.withValues(alpha: 0.8)
                                        : (isDarkMode
                                            ? Colors.grey[500]
                                            : Colors.grey[400]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
              SizedBox(height: 6.h),
              // Apply button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      navPop(context);
                      monthFilter(index + 1);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 2.5.h),
                    ),
                    child: Text(
                      'Applica filtro',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      );
    },
  );
}

Future<String?> pickDate(context) async {
  int month = DateTime.now().month;
  int year = DateTime.now().year;
  int day = DateTime.now().day;
  DateTime? t = await date.DatePicker.showDatePicker(
    context,
    showTitleActions: true,
    minTime: DateTime(year - 5),
    theme: date.DatePickerTheme(
      doneStyle: TextStyle(
        color: mainColor,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      itemStyle: TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      cancelStyle: TextStyle(
        color: Colors.grey[600],
        fontSize: 14,
      ),
      backgroundColor: Colors.white,
      containerHeight: 250,
    ),
    maxTime: DateTime(year, month, day),
    onChanged: (date) {
      print('change $date');
    },
    onConfirm: (date) {
      print('confirm $date');
    },
    currentTime: DateTime.now(),
    locale: date.LocaleType.it,
  );
  if (t == null) {
    return null;
  }

  return DateFormat('dd/MM/yyyy').format(t);
}
