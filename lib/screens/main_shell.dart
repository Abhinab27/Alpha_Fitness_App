import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/fitness_provider.dart';
import 'exercises_screen.dart';
import 'routine_planner_screen.dart';
import 'fit_corner_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const ExercisesScreen(),
    const RoutinePlannerScreen(),
    const FitCornerScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final fitnessProvider = Provider.of<FitnessProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: theme.primaryColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Exercises',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Planner',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Fit Corner',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => fitnessProvider.toggleTheme(),
        mini: true,
        child: Icon(
          fitnessProvider.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
        ),
      ),
    );
  }
}
