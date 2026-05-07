import 'package:flutter/material.dart';
import 'package:pasti/constants/theme.dart';
import 'package:pasti/models/meal.dart';
import 'package:pasti/screens/main_page/school/home/controller.dart';
import 'package:pasti/shared/widgets/app_bar.dart';
import 'package:sizer/sizer.dart';

class AllMeals extends StatefulWidget {
  const AllMeals({Key? key}) : super(key: key);
  @override
  _AllMealsState createState() => _AllMealsState();
}

class _AllMealsState extends State<AllMeals> {
  int total = 0;

  @override
  void initState() {
    super.initState();
    {
      total = 0;
      for (var m in mealsList) {
        total += m.count;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF121212) : Color(0xFFFAFAFA),
      appBar: appBar2('Tutti i pasti', filter: () async {
        await getMealFunction(context, filter: true, from: from, to: to);
        setState(() {
          total = 0;
          for (var m in mealsList) {
            total += m.count;
          }
        });
      }, fromSchool: true),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: RefreshIndicator(
            onRefresh: () async {
              await getMealFunction(context, load: false);
              setState(() {
                total = 0;
                for (var m in mealsList) {
                  total += m.count;
                }
              });
            },
            color: mainColor,
            backgroundColor: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 2.h),

                  // Summary Card
                  _buildSummaryCard(isDarkMode),

                  SizedBox(height: 4.h),

                  // Meals List
                  if (mealsList.isEmpty) _buildEmptyState(isDarkMode),
                  if (mealsList.isNotEmpty)
                    Column(
                      children: List.generate(mealsList.length, (i) {
                        return _buildMealCard(mealsList[i], i, isDarkMode);
                      }),
                    ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(bool isDarkMode) {
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
            height: 80,
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
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        mainColor.withValues(alpha: 0.1),
                        mainColor.withValues(alpha: 0.2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: mainColor.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ordini totali oggi',
                            style: TextStyle(
                              color: isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '$total',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: mainColor.withValues(alpha: 0.2),
                        ),
                        child: Text(
                          '${mealsList.length}',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
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
    );
  }

  Widget _buildMealCard(Meal meal, int index, bool isDarkMode) {
    final totalPrice = (num.parse(meal.price) * meal.count).toStringAsFixed(2);

    return Container(
      margin: EdgeInsets.only(bottom: 2.5.h),
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
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Name and Total Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    meal.name,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.black.withValues(alpha: 0.3)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$totalPrice CHF',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 1.5.h),

            // Order Count Badge
            Row(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.6.h),
                  decoration: BoxDecoration(
                    color: mainColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: mainColor.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.shopping_bag_outlined,
                          color: mainColor, size: 10.sp),
                      SizedBox(width: 1.5.w),
                      Text(
                        '${meal.count} ordini',
                        style: TextStyle(
                          color: mainColor,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (meal.students.isNotEmpty) ...[
              SizedBox(height: 2.h),
              Divider(
                  height: 1,
                  thickness: 0.5,
                  color: isDarkMode ? Colors.grey[800] : Colors.grey[200]),
              SizedBox(height: 1.5.h),
              Wrap(
                spacing: 2.w,
                runSpacing: 1.h,
                children: meal.students.map((student) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 2.5.w, vertical: 0.6.h),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: isDarkMode
                              ? Colors.grey[800]!
                              : Colors.grey[200]!),
                    ),
                    child: Text(
                      '${student.lastName} ${student.name}',
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],

            if (meal.schools.isNotEmpty) ...[
              SizedBox(height: 2.h),
              Wrap(
                spacing: 2.w,
                runSpacing: 1.h,
                children: meal.schools.map((school) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 2.5.w, vertical: 0.6.h),
                    decoration: BoxDecoration(
                      color: secColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: secColor.withValues(alpha: 0.2)),
                    ),
                    child: Text(
                      school.name ?? '',
                      style: TextStyle(
                        color: secColor,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Container(
      height: 40.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 25.w,
              height: 25.w,
              decoration: BoxDecoration(
                color: mainColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.restaurant_menu_rounded,
                  size: 15.w,
                  color: mainColor,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Nessun pasto ordinato',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'I pasti ordinati appariranno qui',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontSize: 10.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
