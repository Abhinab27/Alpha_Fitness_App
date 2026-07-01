import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/fitness_provider.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fitnessProvider = Provider.of<FitnessProvider>(context);
    
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Plans')),
      body: ListView.builder(
        itemCount: fitnessProvider.workouts.length,
        itemBuilder: (context, index) {
          final workout = fitnessProvider.workouts[index];
          return ListTile(
            title: Text(workout.title),
            subtitle: Text(workout.description),
            trailing: Text(workout.duration),
          );
        },
      ),
    );
  }
}
