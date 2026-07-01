import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress Analytics')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 70),
                  FlSpot(1, 72),
                  FlSpot(2, 71),
                  FlSpot(3, 75),
                  FlSpot(4, 74),
                ],
                isCurved: true,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
