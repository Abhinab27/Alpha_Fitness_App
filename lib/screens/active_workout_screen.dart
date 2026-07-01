import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/fitness_provider.dart';
import '../models/exercise.dart';

class ActiveWorkoutScreen extends StatefulWidget {
  final String planId;
  const ActiveWorkoutScreen({super.key, required this.planId});

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen> {
  int _currentIndex = 0;
  bool _isResting = false;
  int _restTimeLeft = 60;
  Timer? _timer;
  List<Exercise> _workoutExercises = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Populate exercises once when dependencies are available
    if (_workoutExercises.isEmpty) {
      _loadWorkoutData();
    }
  }

  void _loadWorkoutData() {
    final provider = Provider.of<FitnessProvider>(context, listen: false);
    List<Exercise> filtered = [];
    
    // Filter based on the planId passed from the Routine Planner
    if (widget.planId == 'seed-push') {
      filtered = provider.exercises.where((e) => 
        ['pectorals', 'delts', 'triceps'].contains(e.target.toLowerCase())
      ).toList();
    } else if (widget.planId == 'seed-pull') {
      filtered = provider.exercises.where((e) => 
        ['lats', 'biceps', 'spine'].contains(e.target.toLowerCase())
      ).toList();
    } else if (widget.planId == 'seed-legs') {
      filtered = provider.exercises.where((e) => 
        ['quads', 'hamstrings', 'abs'].contains(e.target.toLowerCase())
      ).toList();
    }

    if (filtered.isNotEmpty) {
      setState(() {
        _workoutExercises = filtered.take(6).toList();
      });
    }
  }

  void _startRest() {
    setState(() {
      _isResting = true;
      _restTimeLeft = 60;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_restTimeLeft > 0) {
        setState(() => _restTimeLeft--);
      } else {
        _nextExercise();
      }
    });
  }

  void _nextExercise() {
    _timer?.cancel();
    if (_currentIndex < _workoutExercises.length - 1) {
      setState(() {
        _currentIndex++;
        _isResting = false;
      });
    } else {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
        content: const Text(
          'Workout Complete! Great job finishing your routine.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Return to Planner
              },
              child: const Text('Finish & Return'),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (_workoutExercises.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Workout')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final currentExercise = _workoutExercises[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise ${_currentIndex + 1} of ${_workoutExercises.length}'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isResting ? _buildRestScreen(theme) : _buildExerciseScreen(theme, currentExercise),
    );
  }

  Widget _buildExerciseScreen(ThemeData theme, Exercise exercise) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    exercise.image,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 250,
                      width: double.infinity,
                      color: Colors.grey[800],
                      child: const Icon(Icons.fitness_center, size: 80, color: Colors.white24),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(exercise.name, style: theme.textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text('${exercise.bodyPart.toUpperCase()} • ${exercise.target.toUpperCase()}', 
                  style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 16),
                const Text('Instructions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 8),
                ...exercise.instructions.map((step) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text('• $step', style: const TextStyle(fontSize: 16, height: 1.5)),
                    )),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              if (_currentIndex > 0)
                IconButton(
                  onPressed: () => setState(() => _currentIndex--),
                  icon: const Icon(Icons.arrow_back),
                ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _startRest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                icon: const Icon(Icons.check),
                label: const Text('Complete Set', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const Spacer(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRestScreen(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('REST', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 4)),
          const SizedBox(height: 40),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  value: _restTimeLeft / 60,
                  strokeWidth: 10,
                  backgroundColor: theme.dividerColor.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                ),
              ),
              Text(
                '$_restTimeLeft',
                style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 60),
          TextButton(
            onPressed: _nextExercise,
            child: const Text('Skip Rest', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
