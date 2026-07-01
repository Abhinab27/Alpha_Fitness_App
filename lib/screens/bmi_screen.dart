import 'package:flutter/material.dart';

class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key});

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  double? _bmi;

  void _calculateBMI() {
    final height = double.tryParse(_heightController.text) ?? 0;
    final weight = double.tryParse(_weightController.text) ?? 0;
    if (height > 0 && weight > 0) {
      setState(() {
        _bmi = weight / ((height / 100) * (height / 100));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BMI Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _heightController, decoration: const InputDecoration(labelText: 'Height (cm)')),
            TextField(controller: _weightController, decoration: const InputDecoration(labelText: 'Weight (kg)')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _calculateBMI, child: const Text('Calculate')),
            if (_bmi != null) Text('Your BMI: ${_bmi!.toStringAsFixed(2)}', style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}
