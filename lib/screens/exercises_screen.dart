import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../services/fitness_provider.dart';
import '../models/exercise.dart';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  String _searchQuery = '';
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final fitnessProvider = Provider.of<FitnessProvider>(context);
    final theme = Theme.of(context);
    
    final filteredExercises = fitnessProvider.exercises.where((ex) {
      final matchesSearch = ex.name.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                           ex.target.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == null || ex.bodyPart == categoryMap[_selectedCategory];
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercises', style: TextStyle(fontFamily: 'Lora')),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search exercises...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: categoryMap.keys.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedCategory = selected ? cat : null);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredExercises.length,
              itemBuilder: (context, index) {
                final ex = filteredExercises[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ExpansionTile(
                    leading: const Icon(Icons.fitness_center),
                    title: Text(ex.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${ex.target} | ${ex.equipment}'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ex.instructions.join('\n\n')),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                TextButton.icon(
                                  onPressed: () => _launchURL('https://www.youtube.com/results?search_query=${ex.name}+tutorial'),
                                  icon: const Icon(Icons.play_circle_fill),
                                  label: const Text('YouTube'),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
