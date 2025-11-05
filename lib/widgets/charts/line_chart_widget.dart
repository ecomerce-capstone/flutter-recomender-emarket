import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineChartWidget extends StatelessWidget {
  final List<double> points;
  LineChartWidget({required this.points});

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return Center(child: Text('No data'));
    final spots = List.generate(
      points.length,
      (i) => FlSpot(i.toDouble(), points[i]),
    );
    return Padding(
      padding: EdgeInsets.all(12),
      child: LineChart(
        LineChartData(
          lineBarsData: [LineChartBarData(spots: spots, isCurved: true)],
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          ),
        ),
      ),
    );
  }
}
