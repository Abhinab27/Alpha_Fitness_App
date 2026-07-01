import 'package:flutter/material.dart';

class FitCornerScreen extends StatefulWidget {
  const FitCornerScreen({super.key});

  @override
  State<FitCornerScreen> createState() => _FitCornerScreenState();
}

class _FitCornerScreenState extends State<FitCornerScreen> {
  final TextEditingController _weightController = TextEditingController();
  double _weight = 70;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fit Corner', style: TextStyle(fontFamily: 'Lora')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personal Estimator',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter your weight to calculate targets.',
              style: TextStyle(color: theme.hintColor),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              onChanged: (val) {
                setState(() {
                  _weight = double.tryParse(val) ?? 70;
                });
              },
              decoration: InputDecoration(
                labelText: 'Weight (kg)',
                prefixIcon: const Icon(Icons.monitor_weight),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            _buildResultCard(
              theme,
              'Daily Calories',
              '${(_weight * 33).toInt()} kcal',
              'Estimated for moderate activity.',
              Icons.local_fire_department,
              Colors.orange,
            ),
            const SizedBox(height: 16),
            _buildResultCard(
              theme,
              'Daily Protein',
              '${(_weight * 2).toInt()} grams',
              'Recommended for muscle growth.',
              Icons.restaurant,
              Colors.blue,
            ),
            const SizedBox(height: 16),
            _buildResultCard(
              theme,
              'Daily Water',
              '${((_weight * 35) / 1000).toStringAsFixed(1)} Liters',
              'Based on 35ml per kg of weight.',
              Icons.water_drop,
              Colors.cyan,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(ThemeData theme, String title, String value, String sub, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    value,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
                  ),
                  Text(sub, style: TextStyle(fontSize: 12, color: theme.hintColor)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
