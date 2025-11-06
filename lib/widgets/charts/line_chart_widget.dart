import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineChartWidget extends StatelessWidget {
  final List<double> points;
  const LineChartWidget({required this.points, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return Center(child: Text('No data'));
    final spots = List.generate(
      points.length,
      (i) => FlSpot(i.toDouble(), points[i]),
    );
    return Padding(
      padding: EdgeInsets.all(8),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 22),
            ),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              dotData: FlDotData(show: false),
            ),
          ],
          borderData: FlBorderData(show: true),
        ),
      ),
    );
  }
}
