import 'package:flutter/material.dart';
import 'package:pasti/screens/main_page/school/all_meals/controller.dart';
import 'package:pasti/screens/main_page/school/home/controller.dart';
import 'package:pasti/shared/widgets/app_bar.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/theme.dart';
import '../../../../models/meal.dart';

class NewMeals extends StatefulWidget {
  final List<Meal> meal;
  const NewMeals({required this.meal, Key? key}) : super(key: key);

  @override
  _NewMealsState createState() => _NewMealsState();
}

class _NewMealsState extends State<NewMeals> {
  List<Meal> meals = [];

  @override
  void initState() {
    super.initState();
    meals = widget.meal;
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF121212) : Color(0xFFFAFAFA),
      appBar: appBar1('Nuovo Menù'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: meals.isEmpty
              ? _buildEmptyState(isDarkMode)
              : SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 2.h),

                      // Header Card
                      _buildHeaderCard(isDarkMode),

                      SizedBox(height: 4.h),

                      // Meals List
                      Column(
                        children: List.generate(meals.length, (index) {
                          return _buildMealCard(
                              meals[index], index, isDarkMode);
                        }),
                      ),

                      SizedBox(height: 6.h),
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
            height: 75,
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
                //       width: 14.w,
                //       height: 14.w,
                //       decoration: BoxDecoration(
                //         gradient: LinearGradient(
                //           colors: [mainColor, mainColor.withValues(alpha: 0.8)],
                //           begin: Alignment.topLeft,
                //           end: Alignment.bottomRight,
                //         ),
                //         borderRadius: BorderRadius.circular(14),
                //       ),
                //       child: Center(
                //         child: Icon(
                //           Icons.menu_book_rounded,
                //           color: Colors.white,
                //           size: 6.w,
                //         ),
                //       ),
                //     ),
                //     SizedBox(width: 4.w),
                //     Expanded(
                //       child: Text(
                //         'Richieste Menu',
                //         style: TextStyle(
                //           color: isDarkMode ? Colors.white : Colors.black,
                //           fontSize: 14.sp,
                //           fontWeight: FontWeight.w700,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(height: 2.h),
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[900] : Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
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
                        child: Text(
                          meals.length.toString(),
                          style: TextStyle(
                            color: mainColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nuovi piatti in attesa',
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Revisiona le richieste',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
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
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard(Meal meal, int index, bool isDarkMode) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                  ],
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Text(
                      '${meal.price} CHF',
                      style: TextStyle(
                        color: mainColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (meal.date != null) ...[
                      SizedBox(width: 2.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color:
                              isDarkMode ? Colors.grey[800] : Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          meal.date!,
                          style: TextStyle(
                            color: isDarkMode
                                ? Colors.grey[300]
                                : Colors.grey[600],
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (meal.description.isNotEmpty) ...[
                  SizedBox(height: 1.5.h),
                  Text(
                    meal.description,
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 11.sp,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 3.w),
          Column(
            children: [
              IconButton.filled(
                onPressed: () async {
                  await mealUpdateFunction(context, meal, true).then((value) {
                    if (value) {
                      newMeals--;
                      meals.removeAt(index);
                      setState(() {});
                    }
                  });
                },
                style: IconButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: Size(11.w, 11.w),
                ),
                icon: Icon(Icons.check, size: 20),
              ),
              SizedBox(height: 1.5.h),
              IconButton.filled(
                onPressed: () {
                  mealUpdateFunction(context, meal, false).then((value) {
                    if (value) {
                      newMeals--;
                      meals.removeAt(index);
                      setState(() {});
                    }
                  });
                },
                style: IconButton.styleFrom(
                  backgroundColor: Colors.red.withValues(alpha: 0.1),
                  foregroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.red.withValues(alpha: 0.5)),
                  ),
                  minimumSize: Size(11.w, 11.w),
                ),
                icon: Icon(Icons.close, size: 20),
              ),
            ],
          ),
        ],
      ),
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
              color: mainColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.check_circle_outline_rounded,
                size: 15.w,
                color: mainColor,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Nessuna richiesta in attesa',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Tutte le richieste sono state gestite',
            style: TextStyle(
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              fontSize: 10.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
