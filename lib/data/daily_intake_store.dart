import 'package:flutter/foundation.dart';
import '../models/recipe.dart';

class DailyIntakeStore {
  DailyIntakeStore._();
  static final DailyIntakeStore instance = DailyIntakeStore._();

  final ValueNotifier<int> calories = ValueNotifier<int>(0);
  final ValueNotifier<int> protein = ValueNotifier<int>(0);
  final ValueNotifier<int> carbs = ValueNotifier<int>(0);
  final ValueNotifier<int> fat = ValueNotifier<int>(0);

  void addRecipe(Recipe r) {
    calories.value += r.calories;
    protein.value += r.protein;
    carbs.value += r.carbs;
    fat.value += r.fat;
  }

  void reset() {
    calories.value = 0;
    protein.value = 0;
    carbs.value = 0;
    fat.value = 0;
  }
}