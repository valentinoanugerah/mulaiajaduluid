import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'dart:math' as math;
import '../services/firestore_service.dart';
import '../models/health_metric.dart';

class HealthStatisticsPage extends StatefulWidget {
  const HealthStatisticsPage({super.key});

  @override
  State<HealthStatisticsPage> createState() => _HealthStatisticsPageState();
}

class _HealthStatisticsPageState extends State<HealthStatisticsPage> {
  final _firestoreService = FirestoreService();
  late Future<void> _dataFuture;
  List<HealthMetric> _metrics = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _dataFuture = _fetchAllHealthData();
  }

  Future<void> _fetchAllHealthData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final metrics = await _firestoreService.getWeeklyMetrics();
      
      if (!mounted) return;

      setState(() {
        _metrics = metrics;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog('Error Loading Data', e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Map<String, HealthSummary> _calculateDailySummaries() {
    final summaries = <String, HealthSummary>{};
    
    for (var metric in _metrics) {
      final dateKey = DateFormat('yyyy-MM-dd').format(metric.date);
      final current = summaries[dateKey] ?? HealthSummary();
      
      summaries[dateKey] = current.addMetric(metric);
    }
    
    return summaries;
  }

  Future<List<FlSpot>> _processMetricsData(
    double? Function(HealthMetric) getValue,
    MetricType type,
  ) async {
    if (_metrics.isEmpty) return [];
    
    return compute(
      (Map<String, dynamic> data) {
        final metrics = data['metrics'] as List<HealthMetric>;
        final getValue = data['getValue'] as double? Function(HealthMetric);
        final type = data['type'] as MetricType;

        var processedMetrics = metrics
            .where((metric) {
              final value = getValue(metric);
              return value != null && !value.isNaN && !value.isInfinite;
            })
            .map((metric) {
              return FlSpot(
                metric.date.millisecondsSinceEpoch.toDouble(),
                getValue(metric)!,
              );
            })
            .toList();

        processedMetrics.sort((a, b) => a.x.compareTo(b.x));
        return processedMetrics;
      },
      {
        'metrics': _metrics,
        'getValue': getValue,
        'type': type,
      },
    );
  }

  LineChartData _createChartData({
    required Color color,
    required List<FlSpot> spots,
    required MetricType type,
  }) {
    if (spots.isEmpty) {
      return LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: const [],
      );
    }

    final maxY = spots.map((e) => e.y).reduce((a, b) => math.max(a, b));
    final minY = spots.map((e) => e.y).reduce((a, b) => math.min(a, b));
    final padding = (maxY - minY) * 0.1;

    return LineChartData(
      gridData: _createGridData(),
      titlesData: _createTitlesData(spots, type, maxY, minY),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey.shade300),
      ),
      minX: spots.first.x,
      maxX: spots.last.x,
      minY: minY > 0 ? minY - padding : 0,
      maxY: maxY + padding,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          color: color,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: color,
                strokeWidth: 2,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: false,
          ),
        ),
      ],
    );
  }

  FlGridData _createGridData() => FlGridData(
    show: true,
    drawVerticalLine: false,
    horizontalInterval: 1,
    getDrawingHorizontalLine: (value) => FlLine(
      color: Colors.grey.shade300,
      strokeWidth: 1,
    ),
  );

  FlTitlesData _createTitlesData(
    List<FlSpot> spots,
    MetricType type,
    double maxY,
    double minY,
  ) {
    final totalYSpan = maxY - minY;
    final leftInterval = math.max(totalYSpan / 5, 1.0);
    
    double bottomInterval;
    switch (type) {
      case MetricType.sleepDuration:
        bottomInterval = 24 * 60 * 60 * 1000;
        break;
      case MetricType.heartRate:
        bottomInterval = 6 * 60 * 60 * 1000;
        break;
      case MetricType.calories:
        bottomInterval = 24 * 60 * 60 * 1000;
        break;
    }

    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 42,
          interval: bottomInterval,
          getTitlesWidget: (value, meta) => _buildBottomTitle(value, type),
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 45,
          interval: leftInterval,
          getTitlesWidget: (value, meta) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              _formatMetricValue(value, type),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  String _formatMetricValue(double value, MetricType type) {
    switch (type) {
      case MetricType.sleepDuration:
        return '${value.toStringAsFixed(1)}h';
      case MetricType.heartRate:
        return value.toStringAsFixed(0);
      case MetricType.calories:
        return value.toStringAsFixed(0);
    }
  }

  Widget _buildBottomTitle(double value, MetricType type) {
    final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    final format = type == MetricType.heartRate 
        ? DateFormat('HH:mm')
        : DateFormat('MMM d');
    
    return Text(
      format.format(date),
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDailySummary() {
    final summaries = _calculateDailySummaries();
    if (summaries.isEmpty) return const SizedBox();

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final todaySummary = summaries[today];

    if (todaySummary == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No data available for today'),
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Today\'s Health Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildSummaryItem(
              icon: Icons.bedtime,
              title: 'Sleep',
              value: '${todaySummary.avgSleep.toStringAsFixed(1)} hours',
              color: Colors.blue,
            ),
            const SizedBox(height: 8),
            _buildSummaryItem(
              icon: Icons.favorite,
              title: 'Heart Rate',
              value: '${todaySummary.avgHeartRate.toStringAsFixed(0)} BPM',
              subtitle: 'Range: ${todaySummary.minHeartRate.toStringAsFixed(0)} - ${todaySummary.maxHeartRate.toStringAsFixed(0)} BPM',
              color: Colors.red,
            ),
            const SizedBox(height: 8),
            _buildSummaryItem(
              icon: Icons.local_fire_department,
              title: 'Calories',
              value: '${todaySummary.totalCalories.toStringAsFixed(0)} cal',
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String title,
    required String value,
    String? subtitle,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Statistics'),
        actions: [
          IconButton(
            icon: _isLoading 
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _fetchAllHealthData,
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && _metrics.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError && _metrics.isEmpty) {
            return const Center(child: Text('Failed to load data'));
          }
          
          return _buildHealthStatisticsContent();
        },
      ),
    );
  }

  Widget _buildHealthStatisticsContent() {
    final charts = [
      _ChartConfig(
        title: "Sleep Duration",
        subtitle: "Hours per day",
        getValue: (metric) => metric.sleepDuration,
        color: Colors.blue,
        type: MetricType.sleepDuration,
      ),
      _ChartConfig(
        title: "Heart Rate",
        subtitle: "BPM over time",
        getValue: (metric) => metric.heartRate,
        color: Colors.red,
        type: MetricType.heartRate,
      ),
      _ChartConfig(
        title: "Calories Burned",
        subtitle: "Calories per day",
        getValue: (metric) => metric.caloriesBurned,
        color: Colors.green,
        type: MetricType.calories,
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: charts.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        if (index == 0) return _buildDailySummary();
        return _buildChartSection(charts[index - 1]);
      },
    );
  }

  Widget _buildChartSection(_ChartConfig config) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              config.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              config.subtitle,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<FlSpot>>(
              future: _processMetricsData(config.getValue, config.type),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return const SizedBox(
                    height: 200,
                    child: Center(child: Text('Error')),
                  );
                }

                return SizedBox(
                  height: 200,
                  child: LineChart(
                    _createChartData(
                      color: config.color,
                      spots: snapshot.data ?? [],
                      type: config.type,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HealthSummary {
  double totalSleep = 0;
  int sleepCount = 0;
  double totalHeartRate = 0;
  int heartRateCount = 0;
  double minHeartRate = double.infinity;
  double maxHeartRate = -double.infinity;
  double totalCalories = 0;

  double get avgSleep => sleepCount > 0 ? totalSleep / sleepCount : 0;
  double get avgHeartRate => heartRateCount > 0 ? totalHeartRate / heartRateCount : 0;

  HealthSummary addMetric(HealthMetric metric) {
    if (metric.sleepDuration != null) {
      totalSleep += metric.sleepDuration!;
      sleepCount++;
    }

    if (metric.heartRate != null) {
      totalHeartRate += metric.heartRate!;
      heartRateCount++;
      minHeartRate = math.min(minHeartRate, metric.heartRate!);
      maxHeartRate = math.max(maxHeartRate, metric.heartRate!);
    }

    if (metric.caloriesBurned != null) {
      totalCalories += metric.caloriesBurned!;
    }

    return this;
  }
}

enum MetricType {
  sleepDuration,
  heartRate,
  calories,
}

class _ChartConfig {
  final String title;
  final String subtitle;
  final double? Function(HealthMetric) getValue;
  final Color color;
  final MetricType type;

  const _ChartConfig({
    required this.title,
    required this.subtitle,
    required this.getValue,
    required this.color,
    required this.type,
  });
}