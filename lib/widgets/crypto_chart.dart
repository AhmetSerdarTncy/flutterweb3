import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CryptoChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 2),
                FlSpot(1, 2.5),
                FlSpot(2, 2.2),
                FlSpot(3, 3.1),
                FlSpot(4, 2.8),
                FlSpot(5, 3.5),
                FlSpot(6, 4),
              ],
              isCurved: true,
              color: Colors.deepPurple,
              barWidth: 4,
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
} 