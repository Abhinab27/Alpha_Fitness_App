import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/fitness_provider.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => FitnessProvider(),
      child: const AlphaFitnessApp(),
    ),
  );
}

class AlphaFitnessApp extends StatelessWidget {
  const AlphaFitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    final fitnessProvider = Provider.of<FitnessProvider>(context);
    
    return MaterialApp(
      title: 'Alpha Fitness Lite',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: fitnessProvider.themeMode,
      home: const SplashScreen(),
    );
  }
}
