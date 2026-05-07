import 'package:flutter/material.dart';
import 'package:pasti/constants/theme.dart';
import 'package:pasti/models/cart.dart';
import 'package:pasti/models/order.dart';
import 'package:pasti/shared/widgets/app_bar.dart';
import 'package:sizer/sizer.dart';

import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../screens/main_page/student/home/controller.dart';
import 'controller.dart';

class OrderDetails extends StatefulWidget {
  final bool School;
  final Order oneOrder;
  final int index;
  const OrderDetails(
      {required this.oneOrder,
      required this.index,
      required this.School,
      Key? key})
      : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  late Order order;
  String? qrSvg;
  bool isLoadingQr = false;

  @override
  void initState() {
    super.initState();
    order = widget.oneOrder;
    if (!widget.School) {
      _fetchQr();
    }
  }

  void _fetchQr() async {
    if (order.status == OrderStatus.Ended ||
        order.status == OrderStatus.Canceled) return;

    setState(() => isLoadingQr = true);
    var qrData = await getQrCodeFunction(context, order.id, widget.School);
    if (qrData != null && qrData['qr_code'] != null) {
      String base64String = qrData['qr_code'];
      if (base64String.contains(',')) {
        base64String = base64String.split(',').last;
      }
      try {
        setState(() {
          qrSvg = utf8.decode(base64.decode(base64String));
        });
      } catch (e) {
        print("Error decoding QR SVG: $e");
      }
    }
    setState(() => isLoadingQr = false);
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF121212) : Color(0xFFFAFAFA),
      appBar: order.status == OrderStatus.New
          ? appBar1('Dettagli ordine',
              orderId: order, fromSchool: widget.School)
          : appBar1('Dettagli ordine'),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.h),

                // Order Date Card
                _buildOrderDateCard(isDarkMode),

                if (!widget.School &&
                    order.status != OrderStatus.Ended &&
                    order.status != OrderStatus.Canceled)
                  _buildQrSection(isDarkMode),

                SizedBox(height: 4.h),

                // Meals Section
                _buildMealsSection(isDarkMode),

                SizedBox(height: 2.h),

                // Order Status Section
                _buildOrderStatusSection(isDarkMode),

                // if (order.status == OrderStatus.Ended &&
                //     order.deliveredBy != null &&
                //     order.deliveredBy!.isNotEmpty)
                //   _buildDeliveryPersonSection(isDarkMode),
                SizedBox(height: 3.h),

                // Total Price
                _buildTotalPrice(isDarkMode),
                SizedBox(height: 5.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderDateCard(bool isDarkMode) {
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Data dell\'ordine',
            style: TextStyle(
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '${order.day} - ${order.date}',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealsSection(bool isDarkMode) {
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
          Text(
            'Piatti ordinati',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 2.h),
          Column(
            children: List.generate(order.meals.length, (index) {
              Cart c = order.meals[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 1.5.h),
                child: Row(
                  children: [
                    Text(
                      '${index + 1}.',
                      style: TextStyle(
                        color: mainColor,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        c.name,
                        style: TextStyle(
                          color:
                              isDarkMode ? Colors.grey[300] : Colors.grey[800],
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      '${c.price} CHF',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalPrice(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Totale ordine',
            style: TextStyle(
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '${order.total.toStringAsFixed(2)} CHF',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatusSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Stato ordine',
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color:
                          _getStatusColor(order.status).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      getStatus(order.status).toUpperCase(),
                      style: TextStyle(
                        color: _getStatusColor(order.status),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              if (order.status == OrderStatus.Ended &&
                  order.deliveredBy != null &&
                  order.deliveredBy!.isNotEmpty) ...[
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Icon(
                      Icons.person_pin_circle_outlined,
                      color: Colors.green,
                      size: 18,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Consegnato da: ${order.deliveredBy}',
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),

        // Action Buttons
        if (order.status == OrderStatus.New) ...[
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    bool check = await cancelOrderFunction(
                        context, order.id, widget.School);
                    if (check) {
                      order.status = OrderStatus.Canceled;
                      if (widget.index != 0) {
                        orders[widget.index] = order;
                      }
                      setState(() {});
                    }
                  },
                  icon: Icon(Icons.cancel_outlined, size: 18),
                  label: Text('Annulla'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: BorderSide(color: Colors.red.withValues(alpha: 0.5)),
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    bool check = await endOrderFunction(
                        context, order.id, widget.School);
                    if (check) {
                      order.status = OrderStatus.Ended;
                      if (widget.index != 0) {
                        orders[widget.index] = order;
                      }
                      setState(() {});
                    }
                  },
                  icon: Icon(Icons.check_circle_outline, size: 18),
                  label: Text('Consegnato'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],

        if (order.status == OrderStatus.OnGoing) ...[
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                bool check =
                    await endOrderFunction(context, order.id, widget.School);
                if (check) {
                  order.status = OrderStatus.Ended;
                  if (widget.index != 0) {
                    orders[widget.index] = order;
                  }
                  setState(() {});
                }
              },
              icon: Icon(Icons.check_circle_outline, size: 18),
              label: Text('Segna come consegnato'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.New:
        return Colors.blue;
      case OrderStatus.OnGoing:
        return Colors.orange;
      case OrderStatus.Ended:
        return Colors.green;
      case OrderStatus.Canceled:
        return Colors.red;
    }
  }
}

String getStatus(OrderStatus status) {
  if (status == OrderStatus.New) {
    return 'nuovo';
  }
  if (status == OrderStatus.Canceled) {
    return 'annullato';
  }
  if (status == OrderStatus.Ended) {
    return 'concluso';
  }
  return "in corso";
}

extension on _OrderDetailsState {
  Widget _buildQrSection(bool isDarkMode) {
    return Column(
      children: [
        SizedBox(height: 3.h),
        Container(
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
            children: [
              Text(
                'Codice QR Consegna',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2.h),
              if (isLoadingQr)
                Container(
                  height: 150,
                  child: Center(
                    child: CircularProgressIndicator(color: mainColor),
                  ),
                )
              else if (qrSvg != null)
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SvgPicture.string(
                    qrSvg!,
                    width: 40.w,
                    height: 40.w,
                  ),
                )
              else
                Container(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.qr_code_2_rounded,
                          size: 40, color: Colors.grey),
                      SizedBox(height: 1.h),
                      Text(
                        'QR non disponibile',
                        style: TextStyle(color: Colors.grey, fontSize: 10.sp),
                      ),
                      TextButton(
                        onPressed: _fetchQr,
                        child:
                            Text('Riprova', style: TextStyle(color: mainColor)),
                      )
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
