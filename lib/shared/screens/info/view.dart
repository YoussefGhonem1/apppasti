import 'package:flutter/material.dart';
import 'package:pasti/models/student.dart';
import 'package:pasti/shared/widgets/app_bar.dart';
import 'package:sizer/sizer.dart';
import 'package:timelines_plus/timelines_plus.dart';

import '../../../../../constants/theme.dart';
import '../../../../../shared/screens/order/view.dart';
import '../../../models/order.dart';
import '../../../screens/main_page/student/home/controller.dart';

class StudentInfo extends StatefulWidget {
  final int id;
  final String name;
  final bool fromSchool;
  final bool schoolOrders;
  final Student? student;
  const StudentInfo(
      {required this.id,
      required this.name,
      required this.fromSchool,
      this.schoolOrders = false,
      this.student,
      Key? key})
      : super(key: key);
  @override
  _StudentInfoState createState() => _StudentInfoState();
}

class _StudentInfoState extends State<StudentInfo> {
  num total = 0;

  @override
  void initState() {
    super.initState();
    for (var o in orders) {
      if (o.status == OrderStatus.Ended) {
        total += o.total;
      }
    }
  }

  Future refresh(bool load) async {
    if (!widget.schoolOrders) {
      await getOrdersFunction(context,
          fromSchool: widget.fromSchool, id: widget.id, load: load);
      total = 0;
      for (var o in orders) {
        if (o.status == OrderStatus.Ended) {
          total += o.total;
        }
      }
      setState(() {});
    } else {
      await getOrdersSchoolFunction(context);
      total = 0;
      for (var o in orders) {
        if (o.status == OrderStatus.Ended) {
          total += o.total;
        }
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF121212) : Color(0xFFFAFAFA),
      appBar: widget.fromSchool && !widget.schoolOrders
          ? appBar2(widget.name, filter: () async {
              if (widget.fromSchool && !widget.schoolOrders) {
                await getOrdersFunction(context,
                    fromSchool: widget.fromSchool,
                    id: widget.id,
                    filter: true,
                    from: from,
                    to: to);
                total = 0;
                for (var o in orders) {
                  if (o.status == OrderStatus.Ended) {
                    total += o.total;
                  }
                }
                setState(() {});
              }
            }, fromSchool: widget.fromSchool)
          : !widget.fromSchool
              ? appBar2(widget.name, filter: () async {
                  await getOrdersMonthFunction(context,
                      filter: true, from: from, to: to);
                  total = 0;
                  for (var o in orders) {
                    if (o.status == OrderStatus.Ended) {
                      total += o.total;
                    }
                  }
                  setState(() {});
                }, fromSchool: widget.fromSchool)
              : appBar1(widget.name),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: RefreshIndicator(
            onRefresh: () async {
              refresh(false);
            },
            color: mainColor,
            backgroundColor: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  if (widget.id != 0 &&
                      widget.fromSchool &&
                      widget.student != null)
                    SizedBox(height: 2.h),

                  // Student Info Card
                  if (widget.id != 0 &&
                      widget.fromSchool &&
                      widget.student != null)
                    _buildStudentInfoCard(isDarkMode),

                  if (widget.id != 0 &&
                      widget.fromSchool &&
                      widget.student != null)
                    SizedBox(height: 4.h),

                  // Orders Timeline
                  _buildOrdersTimeline(isDarkMode),

                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(isDarkMode),
    );
  }

  Widget _buildStudentInfoCard(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: mainColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.person_rounded,
                    color: mainColor,
                    size: 6.w,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                'Informazioni Collaboratore',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildInfoRow(
            icon: Icons.person_outline_rounded,
            label: 'Nome',
            value: widget.student!.name,
            isDarkMode: isDarkMode,
          ),
          SizedBox(height: 1.5.h),
          _buildInfoRow(
            icon: Icons.person_outline_rounded,
            label: 'Cognome',
            value: widget.student!.lastName,
            isDarkMode: isDarkMode,
          ),
          SizedBox(height: 1.5.h),
          _buildInfoRow(
            icon: Icons.badge_rounded,
            label: 'N. personale',
            value: widget.student!.personalId,
            isDarkMode: isDarkMode,
          ),
          SizedBox(height: 1.5.h),
          _buildInfoRow(
            icon: Icons.business_rounded,
            label: 'Sede',
            value: widget.student!.className,
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDarkMode,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: mainColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: mainColor,
                size: 14,
              ),
              SizedBox(width: 2.w),
              Text(
                label,
                style: TextStyle(
                  color: mainColor,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildOrdersTimeline(bool isDarkMode) {
    return orders.isEmpty
        ? _buildEmptyOrdersState(isDarkMode)
        : FixedTimeline.tileBuilder(
            theme: TimelineThemeData(
              nodePosition: 0,
              indicatorPosition: 0,
              connectorTheme: ConnectorThemeData(
                thickness: 3.0,
                color: secColor.withValues(alpha: 0.5),
              ),
              indicatorTheme: IndicatorThemeData(
                size: 20.0,
                color: secColor,
              ),
            ),
            builder: TimelineTileBuilder.connectedFromStyle(
              contentsAlign: ContentsAlign.basic,
              contentsBuilder: (context, i) {
                String title = '';
                for (int index = 0; index < orders[i].meals.length; index++) {
                  title += orders[i].meals[index].name +
                      (index == orders[i].meals.length - 1 ? '' : ' & ');
                }
                if (title.isNotEmpty) title.substring(0, title.length - 3);

                return _buildOrderCard(orders[i], i, title, isDarkMode);
              },
              connectorStyleBuilder: (context, index) =>
                  ConnectorStyle.solidLine,
              indicatorStyleBuilder: (context, index) => IndicatorStyle.dot,
              itemCount: orders.length,
            ),
          );
  }

  Widget _buildOrderCard(
      Order order, int index, String title, bool isDarkMode) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h, left: 3.w, right: 3.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDarkMode ? 0.3 : 0.05),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${order.day} - ${order.date}',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    '${order.total.toStringAsFixed(2)} CHF',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
                decoration: BoxDecoration(
                  color: (order.status == OrderStatus.Ended
                          ? Colors.green
                          : order.status == OrderStatus.Canceled
                              ? Colors.red
                              : Colors.orange)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  order.status == OrderStatus.Ended
                      ? 'Completato'
                      : order.status == OrderStatus.Canceled
                          ? 'Cancellato'
                          : 'In Corso',
                  style: TextStyle(
                    color: order.status == OrderStatus.Ended
                        ? Colors.green
                        : order.status == OrderStatus.Canceled
                            ? Colors.red
                            : Colors.orange,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (title.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Text(
              title,
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontSize: 11.sp,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => OrderDetails(
                      oneOrder: order,
                      index: index,
                      School: widget.fromSchool,
                    ),
                  ),
                ).then((value) {
                  if (value == 'Update') {
                    refresh(true);
                  }
                  setState(() {});
                });
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: mainColor,
                side: BorderSide(color: mainColor.withValues(alpha: 0.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
              ),
              child: Text(
                'Mostra dettagli',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyOrdersState(bool isDarkMode) {
    return Container(
      height: 40.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Center(
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
                  Icons.shopping_bag_outlined,
                  size: 15.w,
                  color: mainColor,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Nessun ordine trovato',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Gli ordini del collaboratore appariranno qui',
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

  Widget _buildBottomBar(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
            width: 1.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 25,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  mainColor.withValues(alpha: 0.1),
                  mainColor.withValues(alpha: 0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: mainColor.withValues(alpha: 0.25),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: mainColor.withValues(alpha: 0.1),
                  blurRadius: 15,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: mainColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.local_atm,
                      color: Colors.white,
                      size: 7.w,
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Totale speso:',
                        style: TextStyle(
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        '${total.toStringAsFixed(2)} CHF',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        secColor.withValues(alpha: 0.1),
                        secColor.withValues(alpha: 0.2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: secColor.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    '${orders.length}',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
