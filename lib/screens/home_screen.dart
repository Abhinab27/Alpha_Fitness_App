import 'package:flutter/material.dart';
import 'workout_screen.dart';
import 'bmi_screen.dart';
import 'progress_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alpha Fitness')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildCard(context, 'Workouts', Icons.fitness_center, const WorkoutScreen()),
          _buildCard(context, 'BMI Calculator', Icons.calculate, const BMIScreen()),
          _buildCard(context, 'Progress', Icons.show_chart, const ProgressScreen()),
          _buildCard(context, 'Diet Plan', Icons.restaurant, null),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon, Widget? screen) {
    return Card(
      child: InkWell(
        onTap: screen != null ? () => Navigator.push(context, MaterialPageRoute(builder: (context) => screen)) : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 10),
            Text(title),
          ],
        ),
      ),
    );
  }
}
