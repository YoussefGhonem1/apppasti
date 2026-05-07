// import 'package:pasti/models/meal.dart';
import 'package:pasti/models/school.dart';
import '../../../../helper_functions/api.dart';
import '../../../../helper_functions/loading.dart';
import '../../../../helper_functions/navigation.dart';
import '../../../../shared/dialogs.dart';

class KitchenOrder {
  int id;
  String name;
  String description;
  int count;

  KitchenOrder({
    required this.id,
    required this.name,
    required this.description,
    required this.count,
  });

  factory KitchenOrder.fromJson(Map<String, dynamic> json) {
    return KitchenOrder(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      count: int.tryParse(json['orders_count'].toString()) ?? 0,
    );
  }
}

List<KitchenOrder> kitchenMeals = [];
int totalOrders = 0;
String executionMode = 'manual';
bool startedPreparation = false;

Future getKitchenStats(context, {bool load = true, DateTime? date}) async {
  if (load) loading(context);
  kitchenMeals.clear();
  totalOrders = 0;
  executionMode = 'manual'; // Default
  startedPreparation = false;

  String dateStr = (date ?? DateTime.now()).toIso8601String().substring(0, 10);

  try {
    Map apiData = await handleApi(context,
        route: 'kitchen/orders?date=$dateStr',
        header: {"Authorization": school.token},
        isPost: false);
    if (load) navPop(context);

    if (apiData['status'] == 1) {
      var data = apiData['data']['data'];

      if (data != null) {
        if (data['execution_mode'] != null) {
          executionMode = data['execution_mode'].toString();
        }
        if (data['started_preparation'] != null) {
          startedPreparation = data['started_preparation'] == true ||
              data['started_preparation'] == 'true' ||
              data['started_preparation'] == 1;
        }
      }

      if (data != null && data['menus'] != null) {
        for (var l in data['menus']) {
          KitchenOrder m = KitchenOrder.fromJson(l);
          kitchenMeals.add(m);
          totalOrders += m.count;
        }
      }
    } else if (apiData['status'] == 2) {
      showSnackBar(context, apiData['message']);
    }
  } catch (e) {
    print(e);
    if (load) navPop(context);
  }
}

Future<bool> setPreparationStatus(context, {DateTime? date}) async {
  loading(context);
  String dateStr = (date ?? DateTime.now()).toIso8601String().substring(0, 10);
  try {
    // Endpoint to manually set orders to 'ongoing' (In Preparation)
    Map apiData = await handleApi(context,
        route: 'kitchen/orders/manual-execute',
        header: {"Authorization": school.token},
        data: {'date': dateStr});

    navPop(context);
    if (apiData['status'] == 1) {
      showSnackBar(context, 'Ordini impostati in preparazione');
      return true;
    } else {
      showSnackBar(
          context, apiData['message'] ?? 'Errore durante l\'aggiornamento');
    }
  } catch (e) {
    navPop(context);
  }
  return false;
}
