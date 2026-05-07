import 'package:flutter/material.dart';
import 'package:pasti/constants/theme.dart';
import 'package:sizer/sizer.dart';

import '../../../../models/notification.dart';

class NotificationPage extends StatelessWidget {
  final List<NotificationClass> list;
  const NotificationPage({required this.list, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF121212) : Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        title: Text(
          'Notifiche',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: isDarkMode ? Colors.white : Colors.black,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: isDarkMode ? Colors.white : Colors.black,
              size: 16,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: list.isEmpty
          ? _buildEmptyState(isDarkMode)
          : _buildNotificationsList(isDarkMode, context),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 25.w,
            height: 25.w,
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
                Icons.notifications_off_rounded,
                size: 15.w,
                color: mainColor.withValues(alpha: 0.5),
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Nessuna notifica',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Quando riceverai nuove notifiche,\nle troverai qui',
            style: TextStyle(
              fontSize: 10.sp,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(bool isDarkMode, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          SizedBox(height: 2.h),
          // Header with notification count
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            decoration: BoxDecoration(
              color: mainColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: mainColor.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: mainColor.withValues(alpha: 0.1),
                  ),
                  child: Icon(
                    Icons.notifications_active_rounded,
                    color: mainColor,
                    size: 18,
                  ),
                ),
                SizedBox(width: 3.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notifiche',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    Text(
                      '${list.length} ${list.length == 1 ? 'notifica' : 'notifiche'}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          // Notifications list
          Expanded(
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              itemCount: list.length,
              separatorBuilder: (context, index) => SizedBox(height: 2.h),
              itemBuilder: (ctx, i) {
                return _buildNotificationCard(list[i], i, isDarkMode, context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(NotificationClass notification, int index,
      bool isDarkMode, BuildContext context) {
    DateTime noti = DateTime(
      int.parse(notification.time.split('-')[0]),
      int.parse(notification.time.split('-')[1]),
      int.parse(notification.time.split('-')[2].split(' ').first),
      int.parse(notification.time.split(' ').last.split(":")[0]),
      int.parse(notification.time.split(' ').last.split(":")[1]),
      int.parse(notification.time.split(' ').last.split(":")[2]),
    );
    DateTime now = DateTime.now();

    int years = 0;
    years = now.year - noti.year;
    int month = 0;
    if (years == 0) {
      month = now.month - noti.month;
    }
    int days = 0;
    if (years == 0 && month == 0) {
      days = now.day - noti.day;
    }
    int hours = 0;
    if (days == 0) {
      hours = now.hour - noti.hour;
    }
    int min = 0;
    if (hours == 0) {
      min = now.minute - noti.minute;
    }
    int sec = 0;
    if (min == 0) {
      sec = now.second - noti.second;
    }

    String timeNumber = getTimeNumber(years, month, days, hours, min, sec);
    String timeChar = getTimeChar(years, month, days, hours, min, sec);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            // Header row with icon and time
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 11.w,
                  height: 11.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        mainColor,
                        mainColor.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.notifications_rounded,
                      color: Colors.white,
                      size: 5.w,
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 13.sp,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Time badge
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color: mainColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: timeNumber + ' ',
                                    style: TextStyle(
                                      color: mainColor,
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: timeChar,
                                    style: TextStyle(
                                      color: mainColor,
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.5.h),
                      // Message
                      Text(
                        notification.message,
                        style: TextStyle(
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          fontWeight: FontWeight.w400,
                          fontSize: 11.5.sp,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // String _formatDateTime(String timeString) {
  //   try {
  //     // Format: "2024-01-15 14:30:45" -> "15 Gen 2024, 14:30"
  //     final parts = timeString.split(' ');
  //     if (parts.length == 2) {
  //       final dateParts = parts[0].split('-');
  //       final timeParts = parts[1].split(':');
  //       if (dateParts.length == 3 && timeParts.length >= 2) {
  //         final day = dateParts[2];
  //         final month = _getMonthName(int.parse(dateParts[1]));
  //         final year = dateParts[0];
  //         final hour = timeParts[0].padLeft(2, '0');
  //         final minute = timeParts[1].padLeft(2, '0');
  //         return '$day $month $year, $hour:$minute';
  //       }
  //     }
  //   } catch (e) {
  //     print('Error formatting date: $e');
  //   }
  //   return timeString;
  // }

  // String _getMonthName(int month) {
  //   final months = [
  //     'Gen',
  //     'Feb',
  //     'Mar',
  //     'Apr',
  //     'Mag',
  //     'Giu',
  //     'Lug',
  //     'Ago',
  //     'Set',
  //     'Ott',
  //     'Nov',
  //     'Dic'
  //   ];
  //   return months[month - 1];
  // }

// Keep your existing helper functions
  String getTimeNumber(int year, int month, int day, int h, int m, int s) {
    if (year != 0) {
      return '$year';
    } else if (month != 0) {
      return '$month';
    } else if (day != 0) {
      return '$day';
    } else if (h != 0) {
      return '$h';
    } else if (m != 0) {
      return '$m';
    } else if (s != 0) {
      return '$s';
    }
    return '0';
  }

  String getTimeChar(int year, int month, int day, int h, int m, int s) {
    if (year != 0) {
      return 'A';
    } else if (month != 0) {
      return 'M';
    } else if (day != 0) {
      return 'G';
    } else if (h != 0) {
      return 'H';
    } else if (m != 0) {
      return 'm';
    } else if (s != 0) {
      return 's';
    }
    return 'Ora';
  }
}
