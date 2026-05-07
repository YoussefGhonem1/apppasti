import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../../constants/theme.dart';
import '../../../../../constants/var.dart';
import '../../../../../helper_functions/navigation.dart';
import '../../../../../models/cart.dart';
import '../../../../../models/meal.dart';
import '../../../../../models/settings.dart';
import '../../../student/home/menu/check_out/controller.dart';
import '../../../student/home/menu/check_out/view.dart';
import '../../../student/home/menu_det.dart';

class AddOrder extends StatefulWidget {
  final int? orderId;
  final bool updateOrder;
  final bool fromSchool;
  final List<MealStudent> mealsList;
  const AddOrder(
      {required this.mealsList,
      this.updateOrder = false,
      required this.fromSchool,
      this.orderId,
      Key? key})
      : super(key: key);
  @override
  _AddOrderState createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    cart.clear();
    deletedOrders.clear();
    for (var o in widget.mealsList) {
      if (o.id != 0) {
        for (var m in o.meals) {
          if (m.id == o.id) {
            cart.add(
                Cart(id: m.id, name: m.name, date: o.date, price: m.price));
          }
        }
      }
    }
  }

  bool _canOrder(MealStudent meal) {
    final now = DateTime.now();
    final mealDay = int.parse(meal.date.split('-').first);
    final orderTimeHour = int.parse(settings.orderTime.split(':').first);

    // Check if it's next day and past order time
    if ((now.day + 1) == mealDay && now.hour >= orderTimeHour) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF121212) : Color(0xFFFAFAFA),
      appBar: _buildAppBar(isDarkMode),
      body: _buildContent(isDarkMode),
      bottomNavigationBar:
          cart.isNotEmpty ? _buildCartFooter(isDarkMode) : SizedBox(),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDarkMode) {
    return AppBar(
      backgroundColor: isDarkMode ? Color(0xFF121212) : Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        widget.updateOrder ? 'Modifica la richiesta' : 'Aggiungi una richiesta',
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Container(
          color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
          height: 1,
        ),
      ),
    );
  }

  Widget _buildContent(bool isDarkMode) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              SizedBox(height: 2.h),
              ..._buildMealsList(isDarkMode),
              SizedBox(height: 10.h), // Space for FAB
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMealsList(bool isDarkMode) {
    if (widget.mealsList.isEmpty) {
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

    return List.generate(widget.mealsList.length, (i) {
      MealStudent meal = widget.mealsList[i];
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
      margin: EdgeInsets.only(bottom: 2.h),
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
                  width: 6.w,
                  height: 6.w,
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

          SizedBox(width: canOrder ? 4.w : 0),

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
                navP(
                    context,
                    CheckOut(
                        orderId: widget.orderId,
                        fromSchool: widget.fromSchool,
                        updateOrder: widget.updateOrder), then: () {
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
}
