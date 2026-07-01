import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/fitness_provider.dart';

class DietTrackerScreen extends StatefulWidget {
  const DietTrackerScreen({super.key});

  @override
  State<DietTrackerScreen> createState() => _DietTrackerScreenState();
}

class _DietTrackerScreenState extends State<DietTrackerScreen> {
  late String _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  void _showAddMealModal() {
    final nameController = TextEditingController();
    final calController = TextEditingController();
    final proteinController = TextEditingController();
    final carbsController = TextEditingController();
    final fatsController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add New Meal', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 20),
              _buildTextField(nameController, 'Meal Name'),
              const SizedBox(height: 12),
              _buildTextField(calController, 'Calories', keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildTextField(proteinController, 'Prot', keyboardType: TextInputType.number)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTextField(carbsController, 'Carb', keyboardType: TextInputType.number)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTextField(fatsController, 'Fat', keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty && calController.text.isNotEmpty) {
                      Provider.of<FitnessProvider>(context, listen: false).addMeal(_selectedDate, {
                        'name': nameController.text,
                        'calories': int.tryParse(calController.text) ?? 0,
                        'protein': int.tryParse(proteinController.text) ?? 0,
                        'carbs': int.tryParse(carbsController.text) ?? 0,
                        'fats': int.tryParse(fatsController.text) ?? 0,
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save Log'),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Theme.of(context).cardTheme.color,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fitnessProvider = Provider.of<FitnessProvider>(context);
    final totals = fitnessProvider.getDailyTotals(_selectedDate);
    final goals = fitnessProvider.dailyGoals;
    final theme = Theme.of(context);
    final meals = fitnessProvider.getLogsForDate(_selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diet Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.parse(_selectedDate),
                firstDate: DateTime(2023),
                lastDate: DateTime(2030),
              );
              if (picked != null) {
                setState(() => _selectedDate = DateFormat('yyyy-MM-dd').format(picked));
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildMacroDashboard(theme, totals, goals),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Meals', style: theme.textTheme.titleLarge),
                IconButton(
                  onPressed: _showAddMealModal,
                  icon: const Icon(Icons.add_circle_outline, color: Colors.orange),
                ),
              ],
            ),
            if (meals.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Text('No meals logged.'),
              )
            else
              ...meals.asMap().entries.map((entry) => _buildMealCard(theme, entry.value, entry.key, fitnessProvider)),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroDashboard(ThemeData theme, Map<String, double> totals, Map<String, dynamic> goals) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildMacroBar('Calories', totals['calories']!, goals['calories'].toDouble(), 'kcal', theme.primaryColor),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMacroSmall('Prot', totals['protein']!, Colors.blue),
              _buildMacroSmall('Carb', totals['carbs']!, Colors.green),
              _buildMacroSmall('Fat', totals['fats']!, Colors.orange),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMacroBar(String label, double current, double goal, String unit, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text('${current.toInt()}/${goal.toInt()} $unit'),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: (current / goal).clamp(0.0, 1.0),
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation(color),
        ),
      ],
    );
  }

  Widget _buildMacroSmall(String label, double val, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        Text('${val.toInt()}g', style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildMealCard(ThemeData theme, Map<String, dynamic> meal, int index, FitnessProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.restaurant),
        title: Text(meal['name']),
        subtitle: Text('${meal['calories']} kcal'),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
          onPressed: () => provider.deleteMeal(_selectedDate, index),
        ),
      ),
    );
  }
}
