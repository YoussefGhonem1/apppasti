import 'package:flutter/material.dart';
import 'package:pasti/constants/theme.dart';
import 'package:pasti/models/school.dart';
import 'package:pasti/screens/kitchen/dashboard/controller.dart';
import 'package:pasti/helper_functions/api.dart';
import 'package:pasti/helper_functions/navigation.dart';
import 'package:pasti/helper_functions/shared_pref.dart';
import 'package:pasti/screens/auth/login/view.dart';

import 'package:pasti/shared/dialogs.dart';

import 'package:sizer/sizer.dart';

class KitchenDashboard extends StatefulWidget {
  const KitchenDashboard({Key? key}) : super(key: key);

  @override
  _KitchenDashboardState createState() => _KitchenDashboardState();
}

class _KitchenDashboardState extends State<KitchenDashboard> {
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    await getKitchenStats(context, load: true, date: _selectedDate);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF121212) : Color(0xFFFAFAFA),
      appBar: _buildAppBar(isDarkMode),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _isLoading = true;
              });
              await getKitchenStats(context, load: false, date: _selectedDate);
              setState(() {
                _isLoading = false;
              });
            },
            color: mainColor,
            backgroundColor: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
            child: Column(
              children: [
                SizedBox(height: 2.h),
                _buildDateSelector(isDarkMode),
                SizedBox(height: 2.h),

                Expanded(
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Info Card
                        _buildInfoCard(isDarkMode),

                        SizedBox(height: 4.h),

                        // Stats Header
                      ],
                    ),
                  ),
                ),

                // Bottom Action Button
                if (!_isLoading) _buildActionButtons(isDarkMode),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDarkMode) {
    return AppBar(
      backgroundColor: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
      elevation: 0,
      title: Text(
        'Reparto Cucina',
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
          fontSize: 15.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      actions: [
        Container(
          margin: EdgeInsets.only(right: 4.w),
          child: IconButton(
            icon: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.black.withValues(alpha: isDarkMode ? 0.2 : 0.05),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.logout_rounded,
                color: Colors.red[400],
                size: 20,
              ),
            ),
            onPressed: () {
              confirmDialog(context, 'Sei sicuro di voler uscire?', () {
                _logout();
              });
            },
          ),
        ),
      ],
    );
  }

  Future<void> _logout() async {
    try {
      // Prepare logout data - mimic generic logout but using school.id as user_id since kitchen is a user
      Map data = {"token": school.token, "user_id": school.id};

      await handleApi(context,
          route: 'logout', header: {"Authorization": school.token}, data: data);

      // Clear prefs
      await prefs.setBool('login', false);
      await prefs.setInt('id', 0);
      await prefs.setString('apiToken', '');
      await prefs.setString('pass', '');
      await prefs.setString('userName', '');
      // Keep isSchool? Previously set to true on logout by default in controller.dart?
      // In login controller we set it based on role.
      // In Shared logout function: await prefs.setBool('isSchool', true);
      await prefs.setBool('isSchool', true);

      navPRRU(context, Login());
    } catch (e) {
      print(e);
      // Force logout on error
      await prefs.setBool('login', false);
      navPRRU(context, Login());
    }
  }

  Widget _buildDateSelector(bool isDarkMode) {
    // Generate dates: Today - 2 days ... Today + 14 days
    // Or just simple Today + 14 days?
    // User said "horizontal dates that the user can select the date".
    // I'll assume a range around today or future.
    // Let's do today + 14 days.

    List<DateTime> dates =
        List.generate(15, (index) => DateTime.now().add(Duration(days: index)));

    return SizedBox(
      height: 12.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        separatorBuilder: (context, index) => SizedBox(width: 3.w),
        itemBuilder: (context, index) {
          DateTime date = dates[index];
          bool isSelected = date.year == _selectedDate.year &&
              date.month == _selectedDate.month &&
              date.day == _selectedDate.day;

          List<String> weekdays = [
            'Lun',
            'Mar',
            'Mer',
            'Gio',
            'Ven',
            'Sab',
            'Dom'
          ];
          String weekday = weekdays[date.weekday - 1];
          String day = date.day.toString();

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = date;
              });
              _loadData();
            },
            child: Container(
              width: 16.w,
              margin: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? mainColor
                    : (isDarkMode ? Color(0xFF1E1E1E) : Colors.white),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.black.withValues(alpha: isDarkMode ? 0.2 : 0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: isSelected
                      ? mainColor
                      : (isDarkMode ? Colors.grey[800]! : Colors.grey[200]!),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    weekday,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    day,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (isDarkMode ? Colors.white : Colors.black),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(bool isDarkMode) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 14.w,
                height: 14.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [mainColor, secColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Icon(
                    Icons.store_rounded,
                    color: Colors.white,
                    size: 7.w,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      school.name ?? '',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (school.address != null)
                      Padding(
                        padding: EdgeInsets.only(top: 0.5.h),
                        child: Text(
                          school.address!,
                          style: TextStyle(
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[600],
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[900] : Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Totale:',
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '$totalOrders',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          Text(
            'Elementi da preparare',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 2.h),

          // Meals List
          if (kitchenMeals.isEmpty)
            _buildEmptyState(isDarkMode)
          else
            Column(
              children: List.generate(kitchenMeals.length, (index) {
                return _buildMealItem(kitchenMeals[index], index, isDarkMode);
              }),
            ),
        ],
      ),
    );
  }

  Widget _buildMealItem(var meal, int index, bool isDarkMode) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDarkMode ? 0.2 : 0.03),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: mainColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: mainColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  meal.name,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                if (meal.description.isNotEmpty) ...[
                  SizedBox(height: 0.8.h),
                  Text(
                    meal.description,
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.3,
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 4.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: secColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'x${meal.count}',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.restaurant_menu_rounded,
              size: 40,
              color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
            ),
            SizedBox(height: 2.h),
            Text(
              'Nessun ordine presente',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(bool isDarkMode) {
    if (executionMode == 'manual' && !startedPreparation) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: isDarkMode ? Color(0xFF121212) : Color(0xFFFAFAFA),
          border: Border(
            top: BorderSide(
              color: isDarkMode ? Colors.grey[900]! : Colors.grey[200]!,
              width: 1,
            ),
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              bool success =
                  await setPreparationStatus(context, date: _selectedDate);
              if (success) {
                await _loadData(); // Reload to reflect any potential changes
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: mainColor,
              foregroundColor: Colors.white,
              elevation: 4,
              shadowColor: mainColor.withValues(alpha: 0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.symmetric(vertical: 2.5.h),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timelapse_rounded, size: 24),
                SizedBox(width: 3.w),
                Text(
                  'IN PREPARAZIONE',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (startedPreparation) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: mainColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: mainColor.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: mainColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 2.w),
                Text(
                  'Gli ordini sono in preparazione',
                  style: TextStyle(
                    color: mainColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // executionMode != 'manual' && !startedPreparation
      return Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Center(
          child: Text(
            'In attesa di avvio automatico',
            style: TextStyle(
              color: isDarkMode ? Colors.grey[500] : Colors.grey[400],
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }
  }
}
