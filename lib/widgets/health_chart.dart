import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mulaiajaduluid/models/health_metric.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HealthStatisticsPage extends StatefulWidget {
  @override
  _HealthStatisticsPageState createState() => _HealthStatisticsPageState();
}

class _HealthStatisticsPageState extends State<HealthStatisticsPage> {
  List<HealthMetric> _metrics = [];

  @override
  void initState() {
    super.initState();
    _fetchHealthData();
  }

  Future<void> _fetchHealthData() async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('health_metrics').get();
      if (snapshot.docs.isEmpty) {
        print('No data found!');
        return;
      }
      List<HealthMetric> fetchedMetrics = snapshot.docs.map((doc) {
        return HealthMetric.fromFirestore(doc);
      }).toList();

      setState(() {
        _metrics = fetchedMetrics;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  String _getLastUpdateTime() {
    return DateTime.now().toString();
  }

  Widget _buildSleepCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardHeader('Sleep Duration'),
            SizedBox(height: 16),
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true, getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.3),
                      strokeWidth: 1,
                    );
                  }),
                  titlesData: _buildChartTitles(),
                  borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.withOpacity(0.3))),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _buildSleepSpots(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.green,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.1)),
                    ),
                  ],
                  minY: 0,
                  maxY: 12,
                  clipData: FlClipData.all(),
                ),
              ),
            ),
            SizedBox(height: 16),
            _buildSleepDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          'Last updated: ${_getLastUpdateTime()}',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildSleepDetails() {
    if (_metrics.isEmpty) {
      return Text('No data available');
    }
    final sleepDuration = _metrics.last.sleepDuration;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
       _buildMetricBox(
          'Duration',
          '${(sleepDuration?.toStringAsFixed(1) ?? '0.0')}h',
          Colors.blue,
        ),

        _buildMetricBox('Quality', 'Good', Colors.green),
      ],
    );
  }

  List<FlSpot> _buildSleepSpots() {
    if (_metrics.isEmpty) return [];
    List<FlSpot> spots = [];
    for (int i = 0; i < _metrics.length; i++) {
      if (_metrics[i].sleepDuration != null) {
        spots.add(FlSpot(i.toDouble(), _metrics[i].sleepDuration!));
      }
    }
    return spots;
  }

  Widget _buildMetricBox(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 12)),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  FlTitlesData _buildChartTitles() {
    return FlTitlesData(
      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            return Text(value.toString(), style: TextStyle(fontSize: 10, color: Colors.black87));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Statistics'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildSleepCard(),
        ],
      ),
    );
  }
}
