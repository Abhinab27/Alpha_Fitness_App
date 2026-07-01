import 'package:flutter/material.dart';
import 'active_workout_screen.dart';

class RoutinePlannerScreen extends StatelessWidget {
  const RoutinePlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final List<Map<String, dynamic>> routines = [
      {
        'id': 'seed-push',
        'day': 'Monday & Friday',
        'title': 'Push Day',
        'subtitle': 'Chest, Shoulders, Triceps',
        'color': const Color(0xFFC97D60),
      },
      {
        'id': 'seed-pull',
        'day': 'Tuesday & Saturday',
        'title': 'Pull Day',
        'subtitle': 'Back, Biceps',
        'color': const Color(0xFF5E7B6C),
      },
      {
        'id': 'seed-legs',
        'day': 'Thursday',
        'title': 'Leg Day',
        'subtitle': 'Quads, Hamstrings, Core',
        'color': Colors.blueGrey,
      },
      {
        'id': 'rest',
        'day': 'Wednesday & Sunday',
        'title': 'Rest Day',
        'subtitle': 'Recovery & Mobility',
        'color': Colors.grey,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Routine Planner', style: TextStyle(fontFamily: 'Lora')),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: routines.length,
        itemBuilder: (context, index) {
          final routine = routines[index];
          final isRest = routine['id'] == 'rest';

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              onTap: isRest ? null : () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ActiveWorkoutScreen(planId: routine['id']),
                  ),
                );
              },
              leading: CircleAvatar(
                backgroundColor: routine['color'],
                child: Icon(
                  isRest ? Icons.nightlight_round : Icons.play_arrow, 
                  size: 20, 
                  color: Colors.white
                ),
              ),
              title: Text(routine['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${routine['day']}\n${routine['subtitle']}'),
              trailing: isRest ? null : const Icon(Icons.arrow_forward_ios, size: 14),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
