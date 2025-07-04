// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsGraph extends StatefulWidget {
  const AnalyticsGraph({super.key});

  @override
  State<AnalyticsGraph> createState() => AnalyticsGraphState();
}

class AnalyticsGraphState extends State<AnalyticsGraph> {
  final List<String> weekDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];

  // Mock data: keyIn and keyOut for each day of the week
  final List<int> keyInData = [250, 255, 240, 280, 275, 240, 235];
  final List<int> keyOutData = [205, 253, 250, 200, 210, 12, 50];
  final List<int> onDeliveryData = [205, 253, 250, 200, 210, 100, 50];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Material(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Weekly Stat (BETA)',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                AspectRatio(
                  aspectRatio: 16 / 4.5,
                  child: Padding(
                    padding: EdgeInsetsGeometry.fromLTRB(5, 0, 5, 0),
                    child: BarChart(
                      BarChartData(
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                if (index < 0 || index >= weekDays.length)
                                  return Container();
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(weekDays[index]),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize:
                                  40, // Reserve space to prevent overflow
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toInt().toString(),
                                  style: TextStyle(fontSize: 12),
                                  overflow:
                                      TextOverflow.ellipsis, // Prevent overflow
                                );
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        barGroups: List.generate(7, (index) {
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: keyInData[index].toDouble(),
                                color: Colors.blue,
                                width: 8,
                              ),
                              BarChartRodData(
                                toY: keyOutData[index].toDouble(),
                                color: Colors.orange,
                                width: 8,
                              ),
                              BarChartRodData(
                                toY: onDeliveryData[index].toDouble(),
                                color: Colors.green,
                                width: 8,
                              ),
                            ],
                            // barsSpace: 4,
                          );
                        }),
                        gridData: FlGridData(show: true),
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.square, color: Colors.blue, size: 16),
                    SizedBox(width: 4),
                    Text('Key In'),
                    SizedBox(width: 16),
                    Icon(Icons.circle, color: Colors.orange, size: 16),
                    SizedBox(width: 4),
                    Text('Key Out'),
                    SizedBox(width: 16),
                    Icon(Icons.square, color: Colors.green, size: 16),
                    SizedBox(width: 4),
                    Text('On Delivery'),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            )));
  }
}
