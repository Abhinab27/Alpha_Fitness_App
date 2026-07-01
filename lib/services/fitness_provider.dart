import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exercise.dart';
import '../api/exercise_db.dart';

class FitnessProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  ThemeMode get themeMode => _themeMode;

  List<Exercise> _exercises = [];
  List<Exercise> get exercises => _exercises;

  FitnessProvider() {
    _init();
  }

  Future<void> _init() async {
    // Load local exercises
    _exercises = rawFallbackDB.map((e) => Exercise.fromJson(e)).toList();
    
    // Load theme preference
    final prefs = await SharedPreferences.getInstance();
    final themeStr = prefs.getString('themeMode') ?? 'dark';
    _themeMode = themeStr == 'light' ? ThemeMode.light : ThemeMode.dark;
    
    notifyListeners();
  }

  void toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', _themeMode == ThemeMode.light ? 'light' : 'dark');
  }
}
