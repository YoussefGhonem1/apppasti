import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '../../../../models/meal.dart';
import '../home/controller.dart' as home_ctrl;

class DailyStat {
  final String dayName;
  final String date;
  final int totalOrders;

  DailyStat(this.dayName, this.date, this.totalOrders);
}

class MealStat {
  final String name;
  final int count;
  final Color color;

  MealStat(this.name, this.count, this.color);
}

bool isLoading = false;
List<DailyStat> weeklyStats = [];
List<MealStat> popularMeals = [];
int totalOrdersPeriod = 0;
int averageOrdersPerDay = 0;

final List<Color> chartColors = [
  Color(0xFF4338CA), // Indigo
  Color(0xFFEC4899), // Pink
  Color(0xFF10B981), // Emerald
  Color(0xFFF59E0B), // Amber
  Color(0xFF6366F1), // Indigo Light
];

Future<void> loadStatistics(BuildContext context, VoidCallback onUpdate) async {
  isLoading = true;
  onUpdate();

  try {
    await initializeDateFormatting('it_IT', null);

    DateTime now = DateTime.now();
    DateTime sevenDaysAgo = now.subtract(Duration(days: 6));

    String from = DateFormat('yyyy-MM-dd').format(sevenDaysAgo);
    String to = DateFormat('yyyy-MM-dd').format(now);

    // Use the existing controller function to fetch meals
    await home_ctrl.getMealFunction(context,
        filter: true, from: from, to: to, load: false);

    List<Meal> allMeals = home_ctrl.mealsList;

    // Process Daily Stats
    Map<String, int> dailyCounts = {};

    // Initialize last 7 days
    for (int i = 0; i < 7; i++) {
      DateTime d = sevenDaysAgo.add(Duration(days: i));
      String key = DateFormat('yyyy-MM-dd').format(d);
      dailyCounts[key] = 0;
    }

    // Process Popular Meals
    Map<String, int> typeCounts = {};

    totalOrdersPeriod = 0;

    for (var meal in allMeals) {
      if (meal.date != null) {
        String d = meal.date!;
        if (dailyCounts.containsKey(d)) {
          dailyCounts[d] = (dailyCounts[d] ?? 0) + meal.count;
        }
      }

      typeCounts[meal.name] = (typeCounts[meal.name] ?? 0) + meal.count;
      totalOrdersPeriod += meal.count;
    }

    averageOrdersPerDay = (totalOrdersPeriod / 7).round();

    // Convert to List<DailyStat>
    weeklyStats = dailyCounts.entries.map((e) {
      DateTime d = DateTime.parse(e.key);
      String dayName = DateFormat('E', 'it').format(d);
      return DailyStat(dayName, e.key, e.value);
    }).toList();

    // Sort and convert Popular Meals
    var sortedMeals = typeCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    popularMeals = sortedMeals.take(5).toList().asMap().entries.map((entry) {
      int idx = entry.key;
      var e = entry.value;
      return MealStat(e.key, e.value, chartColors[idx % chartColors.length]);
    }).toList();
  } catch (e) {
    print("Error loading stats: $e");
  } finally {
    isLoading = false;
    onUpdate();
  }
}
