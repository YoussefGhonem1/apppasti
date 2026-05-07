import 'package:pasti/helper_functions/small_functions.dart';
import 'package:pasti/models/cart.dart';

class Order {
  int id;
  OrderStatus status;
  String date;
  String day;
  List<Cart> meals;
  num total;
  String? deliveredBy;

  Order({
    required this.id,
    required this.status,
    required this.date,
    required this.day,
    required this.meals,
    required this.total,
    this.deliveredBy,
  });

  factory Order.fromJson(Map data) {
    List<Cart> meals = [];
    num total = 0;
    for (var m in data['order_meals']) {
      meals.add(Cart(
          id: m['meal']['id'],
          name: m['meal']['name'],
          date: m['meal']['date'] ?? "",
          price: m['meal']['price']));

      total += num.parse(m['meal']['price']);
    }
    return Order(
        id: data['id'],
        status: data['status'] == 'new'
            ? OrderStatus.New
            : data['status'] == 'canceled'
                ? OrderStatus.Canceled
                : data['status'] == 'ended'
                    ? OrderStatus.Ended
                    : OrderStatus.OnGoing,
        date: reverseDate(data['order_date_format']['order_date']),
        day: data['order_date_format']['order_day'],
        meals: meals,
        total: total,
        deliveredBy: data['delivered_by']?.toString());
  }
}

enum OrderStatus { New, OnGoing, Ended, Canceled }
