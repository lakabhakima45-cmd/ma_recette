import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe.dart';

class AppState extends ChangeNotifier {
  static final AppState instance = AppState._internal();
  AppState._internal();

  // ================= USER =================
  String? firstName;
  String? lastName;
  String? email;
  String? birthDate;

  // ⭐ PHOTO PROFIL
  String? profileImagePath;

  bool get isLoggedIn => email != null;

  String get username {
    final fn = (firstName ?? '').trim();
    final ln = (lastName ?? '').trim();
    final full = ('$fn $ln').trim();
    if (full.isNotEmpty) return full;
    return email?.split('@').first ?? "Utilisateur";
  }

  // ================= CALORIES =================
  double todayCalories = 0;
  double dailyGoal = 1400;

  Map<String, double> history = {};

  double get remainingCalories => dailyGoal - todayCalories;

  String _todayKey() {
    final d = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    return "${d.year}-${two(d.month)}-${two(d.day)}";
  }

  // ================= FAVORITES =================
  final List<Recipe> favoriteRecipes = [];

  void toggleFavorite(Recipe recipe) {
    if (favoriteRecipes.contains(recipe)) {
      favoriteRecipes.remove(recipe);
    } else {
      favoriteRecipes.add(recipe);
    }
    notifyListeners();
  }

  // ================= LOAD PREFS =================
  Future<void> loadFromPrefs() async {
    final sp = await SharedPreferences.getInstance();

    firstName = sp.getString('firstName');
    lastName = sp.getString('lastName');
    email = sp.getString('email');
    birthDate = sp.getString('birthDate');

    // ⭐ Charger la photo profil
    profileImagePath = sp.getString('profileImage');

    dailyGoal = sp.getDouble('dailyGoal') ?? 1400;

    final historyStr = sp.getString('history_json');

    if (historyStr != null && historyStr.isNotEmpty) {
      final decoded = jsonDecode(historyStr) as Map<String, dynamic>;
      history =
          decoded.map((k, v) => MapEntry(k, (v as num).toDouble()));
    } else {
      history = {};
    }

    todayCalories = history[_todayKey()] ?? 0;

    notifyListeners();
  }

  Future<void> _saveHistory() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString('history_json', jsonEncode(history));
  }

  // ================= PHOTO PROFIL =================
  Future<void> setProfileImage(String path) async {
    profileImagePath = path;

    final sp = await SharedPreferences.getInstance();
    await sp.setString('profileImage', path);

    notifyListeners();
  }

  // ================= REGISTER =================
  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String birthDate,
  }) async {

    final sp = await SharedPreferences.getInstance();

    // 🔥 RESET anciennes données
    await sp.remove('history_json');
    await sp.remove('dailyGoal');
    await sp.remove('profileImage');

    history = {};
    todayCalories = 0;
    dailyGoal = 1400;
    profileImagePath = null;

    await sp.setString('firstName', firstName.trim());
    await sp.setString('lastName', lastName.trim());
    await sp.setString('email', email.trim().toLowerCase());
    await sp.setString('password', password);
    await sp.setString('birthDate', birthDate);

    this.firstName = firstName.trim();
    this.lastName = lastName.trim();
    this.email = email.trim().toLowerCase();
    this.birthDate = birthDate;

    notifyListeners();
  }

  // ================= LOGIN =================
  Future<bool> login({
    required String email,
    required String password,
  }) async {

    final sp = await SharedPreferences.getInstance();

    final savedEmail = sp.getString('email');
    final savedPass = sp.getString('password');

    if (savedEmail == null || savedPass == null) return false;

    final ok =
        savedEmail == email.trim().toLowerCase() &&
            savedPass == password;

    if (!ok) return false;

    await loadFromPrefs();
    return true;
  }

  // ================= LOGOUT =================
  Future<void> logout() async {

    email = null;
    firstName = null;
    lastName = null;
    birthDate = null;

    todayCalories = 0;
    history = {};

    notifyListeners();
  }

  // ================= CALORIES ACTIONS =================
  Future<void> addCalories(double calories) async {

    todayCalories += calories;

    final key = _todayKey();
    history[key] = (history[key] ?? 0) + calories;

    await _saveHistory();

    notifyListeners();
  }

  Future<void> resetToday() async {

    todayCalories = 0;

    final key = _todayKey();
    history[key] = 0;

    await _saveHistory();

    notifyListeners();
  }

  Future<void> setDailyGoal(double value) async {

    dailyGoal = value;

    final sp = await SharedPreferences.getInstance();
    await sp.setDouble('dailyGoal', value);

    notifyListeners();
  }

  // ================= RECOMMENDATION =================
  List<Recipe> recommendRecipes(List<Recipe> allRecipes) {

    final remaining = remainingCalories;

    if (remaining <= 0) return [];

    return allRecipes
        .where((r) => r.calories <= remaining)
        .toList()
      ..sort((a, b) => b.protein.compareTo(a.protein));
  }
}