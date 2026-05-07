import 'package:flutter/material.dart';
import 'package:pasti/helper_functions/navigation.dart';
import 'package:pasti/models/notification.dart';
import 'package:pasti/models/school.dart';
import 'package:pasti/screens/main_page/student/home/menu_det.dart';
import 'package:pasti/shared/screens/info/view.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import '../../../../constants/theme.dart';
import '../../../../constants/var.dart';
import '../../../../models/cart.dart';
import '../../../../models/meal.dart';
import '../../../../models/settings.dart';
import '../../../../models/student.dart';
import '../../../../shared/screens/account/view.dart';
import '../notification/view.dart';

import 'controller.dart';
import 'menu/check_out/controller.dart';
import 'menu/check_out/view.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    deletedOrders.clear();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    await getMenuFunction(context, false);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF121212) : Color(0xFFFAFAFA),
      appBar: _buildAppBar(isDarkMode),
      body: _isLoading ? _buildLoadingState() : _buildContent(isDarkMode),
      bottomNavigationBar:
          cart.isNotEmpty ? _buildCartFooter(isDarkMode) : SizedBox(),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDarkMode) {
    return PreferredSize(
      preferredSize: Size.fromHeight(9.h),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? Color(0xFF121212) : Colors.white,
          border: Border(
            bottom: BorderSide(
              color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top row with logo and action icons
              Container(
                height: 7.h,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/app_icon.jpeg',
                      width: 16.w,
                      fit: BoxFit.contain,
                    ),
                    Expanded(child: SizedBox()),
                    _buildActionIcon(
                      icon: Icons.notifications_outlined,
                      badgeCount: unRead,
                      onTap: () async {
                        List<NotificationClass> list =
                            await getNotificationFunction(context);
                        navP(context, NotificationPage(list: list), then: () {
                          setState(() {
                            unRead = 0;
                          });
                        });
                      },
                    ),
                    _buildActionIcon(
                      icon: Icons.shopping_bag_outlined,
                      onTap: () async {
                        await getOrdersFunction(context,
                            fromSchool: false, id: student.id);
                        navP(
                          context,
                          StudentInfo(
                            id: student.id,
                            name: student.name,
                            fromSchool: false,
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 2.w),
                    GestureDetector(
                      onTap: () {
                        navP(context,
                            MyAccount(fromSchool: false, school: school));
                      },
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: mainColor,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // // Search bar
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 5.w),
              //   padding: EdgeInsets.symmetric(horizontal: 4.w),
              //   height: 6.h,
              //   decoration: BoxDecoration(
              //     color: isDarkMode ? Color(0xFF2D2D2D) : Colors.grey[100],
              //     borderRadius: BorderRadius.circular(30),
              //   ),
              //   child: Row(
              //     children: [
              //       Icon(
              //         Icons.search,
              //         color: Colors.grey[500],
              //         size: 20,
              //       ),
              //       SizedBox(width: 3.w),
              //       Expanded(
              //         child: Text(
              //           'Cerca nel menu...',
              //           style: TextStyle(
              //             color: Colors.grey[500],
              //             fontSize: 10.sp,
              //           ),
              //         ),
              //       ),
              //       Container(
              //         padding: EdgeInsets.all(1.w),
              //         decoration: BoxDecoration(
              //           shape: BoxShape.circle,
              //           color: mainColor.withValues(alpha: 0.1),
              //         ),
              //         child: Icon(
              //           Icons.filter_list,
              //           color: mainColor,
              //           size: 16,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(height: 1.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionIcon({
    required IconData icon,
    int? badgeCount,
    required VoidCallback onTap,
  }) {
    return Container(
      child: Stack(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              icon,
              color: Colors.grey[700],
              size: 28,
            ),
            onPressed: onTap,
          ),
          if (badgeCount != null && badgeCount > 0)
            Positioned(
              top: 5,
              right: 8,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    badgeCount > 9 ? '9+' : badgeCount.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 7.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: mainColor,
            strokeWidth: 2,
          ),
          SizedBox(height: 3.h),
          Text(
            'Caricamento menu...',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(bool isDarkMode) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: RefreshIndicator(
          color: mainColor,
          backgroundColor: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
          onRefresh: () async {
            cart.clear();
            await getMenuFunction(context, false);
            setState(() {});
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            child: Column(
              children: [
                _buildHeaderCard(isDarkMode),
                SizedBox(height: 3.h),
                ..._buildMealsList(isDarkMode),
                SizedBox(height: 10.h), // Space for FAB
              ],
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
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDarkMode
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
              ],
        border: Border.all(
          color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 70,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [mainColor, mainColor.withValues(alpha: 0.5)],
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
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: mainColor,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      '${timeClass.day} - ${timeClass.date}',
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
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
                          school.image ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: mainColor.withValues(alpha: 0.1),
                              child: Icon(
                                Icons.school,
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
                            school.name ?? '',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 1.h),
                          Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: Colors.orange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.orange.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: Colors.orange,
                                  size: 14,
                                ),
                                SizedBox(width: 2.w),
                                Expanded(
                                  child: Text(
                                    _getOrderingMessage(),
                                    style: TextStyle(
                                      color: Colors.orange.shade800,
                                      fontSize: 9.5.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMealsList(bool isDarkMode) {
    if (mealsList.isEmpty) {
      return [
        SizedBox(height: 10.h),
        Column(
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 40,
              color: Colors.grey[400],
            ),
            SizedBox(height: 2.h),
            Text(
              'Nessun menu disponibile',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ];
    }

    return List.generate(mealsList.length, (i) {
      MealStudent meal = mealsList[i];
      final canOrder = _canOrder(meal);

      return Container(
        margin: EdgeInsets.only(bottom: 4.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${meal.day} - ${meal.date}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (!canOrder)
                  Container(
                    margin: EdgeInsets.only(left: 2.w),
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: Colors.red.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.access_time_filled,
                            size: 12, color: Colors.red),
                        SizedBox(width: 1.w),
                        Text(
                          'Termine Scaduto',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            SizedBox(height: 2.h),
            ...List.generate(meal.meals.length, (index) {
              final mealItem = meal.meals[index];
              final isSelected = mealItem.id == meal.id;

              return _buildMealItem(
                mealItem,
                meal,
                index,
                isSelected,
                canOrder,
                isDarkMode,
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _buildMealItem(
    Meal mealItem,
    MealStudent meal,
    int index,
    bool isSelected,
    bool canOrder,
    bool isDarkMode,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h, left: 1.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkbox
          if (canOrder)
            GestureDetector(
              onTap: () {
                setState(() {
                  if (mealItem.id != meal.id) {
                    // Selecting this meal
                    List list = [];
                    for (var m in meal.meals) {
                      list.add(m.id);
                    }
                    if (deletedOrders.contains(mealItem.id)) {
                      deletedOrders.remove(mealItem.id);
                    }
                    deleteItemCart(list);
                    cart.add(Cart(
                      id: mealItem.id,
                      name: mealItem.name,
                      date: meal.date,
                      price: mealItem.price,
                    ));
                    meal.id = mealItem.id;
                  } else {
                    // Deselecting this meal
                    deleteItemCart([meal.id]);
                    deletedOrders.add(meal.id);
                    meal.id = 0;
                  }
                });
              },
              child: Transform.scale(
                scale: isTablet ? 1.3 : 1,
                child: Container(
                  width: 23,
                  height: 23,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? mainColor : Colors.grey[400]!,
                      width: 2,
                    ),
                    color: isSelected ? mainColor : Colors.transparent,
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          size: isTablet ? 3.w : 4.w,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
            )
          else
            SizedBox(width: 6.w),

          SizedBox(width: canOrder ? 1.5.w : 0),

          // Meal details - clickable to view details
          Expanded(
            child: InkWell(
              onTap: () {
                navP(context, MenuDetailsPage(meal: mealItem));
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? mainColor.withValues(alpha: 0.3)
                        : isDarkMode
                            ? Colors.grey[800]!
                            : Colors.grey[200]!,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: mainColor.withValues(alpha: 0.1),
                            blurRadius: 15,
                            offset: Offset(0, 4),
                          ),
                        ]
                      : isDarkMode
                          ? []
                          : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 10,
                                offset: Offset(0, 2),
                              ),
                            ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            mealItem.name,
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 0.8.h),
                          decoration: BoxDecoration(
                            color: mainColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${mealItem.price} CHF',
                            style: TextStyle(
                              color: mainColor,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      mealItem.description,
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.5.h),
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Tocca per i dettagli',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 9.5.sp,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(width: 2.w),

          // Lock icon for disabled items (tablet only)
          if (!canOrder && isTablet)
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.lock_clock,
                color: Colors.grey[600],
                size: 20,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCartFooter(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          top: BorderSide(
            color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: mainColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                color: mainColor,
                size: 24,
              ),
            ),
            SizedBox(width: 3.w),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Carrello',
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${cart.length} ${cart.length == 1 ? 'piatto' : 'piatti'}',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                cart.sort((a, b) => b.id.compareTo(a.id));
                navP(context, CheckOut(fromSchool: false), then: () {
                  setState(() {});
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
              ),
              child: Row(
                children: [
                  Text(
                    'Vai al checkout',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Icon(Icons.arrow_forward_rounded, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canOrder(MealStudent meal) {
    final now = DateTime.now();
    final mealDate = DateFormat('dd-MM-yyyy').parse(meal.date);
    final orderHour = int.parse(settings.orderTime.split(':').first);

    // Calculate tomorrow's date
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    // Check if the meal is for tomorrow
    final isTomorrow = mealDate.year == tomorrow.year &&
        mealDate.month == tomorrow.month &&
        mealDate.day == tomorrow.day;

    // If it's after 10:00 AM, block orders for tomorrow only
    final cutoffHour = 10;
    final isAfterCutoff = now.hour >= cutoffHour;

    if (isTomorrow && isAfterCutoff) {
      // Cannot order for tomorrow after 10 AM
      return false;
    }

    // If ordering for tomorrow before 10 AM, check against order time
    if (isTomorrow && !isAfterCutoff) {
      return now.hour < orderHour;
    }

    // For all other future days, allow ordering
    // Just make sure the meal date is in the future
    final today = DateTime(now.year, now.month, now.day);
    return mealDate.isAfter(today);
  }

  String _getOrderingMessage() {
    final now = DateTime.now();
    final cutoffHour = 10;
    final isAfterCutoff = now.hour >= cutoffHour;

    if (isAfterCutoff) {
      return 'Dopo le 10:00, non puoi ordinare per domani (puoi ordinare per gli altri giorni)';
    } else {
      return 'Hai tempo fino alle ${settings.orderTime} per ordinare il pranzo di domani';
    }
  }
}
