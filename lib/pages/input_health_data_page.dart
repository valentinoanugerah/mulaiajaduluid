import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/health_metric.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InputHealthDataPage extends StatefulWidget {
  @override
  _InputHealthDataPageState createState() => _InputHealthDataPageState();
}

class _InputHealthDataPageState extends State<InputHealthDataPage> {
  final FirestoreService _firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _heartRateController = TextEditingController();
  final TextEditingController _sleepDurationController = TextEditingController();
  final TextEditingController _caloriesBurnedController = TextEditingController();
  final TextEditingController _stepsController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  TimeOfDay? _sleepStartTime;
  bool _isLoading = false;

  final double _minHeartRate = 40;
  final double _maxHeartRate = 220;
  final double _maxSleepDuration = 24;
  final double _maxCalories = 10000;
  final int _maxSteps = 100000;
  final double _maxWeight = 300;
  final double _maxHeight = 250;

  Future<void> _selectSleepStartTime(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: _sleepStartTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              dayPeriodBorderSide: BorderSide(color: Colors.blue),
            ),
          ),
          child: child!,
        );
      },
    );
    if (selectedTime != null) {
      setState(() {
        _sleepStartTime = selectedTime;
      });
    }
  }

  String? _validateNumericInput(String? value, String fieldName, double min, double max) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final number = double.tryParse(value);
    if (number == null) {
      return '$fieldName harus berupa angka';
    }

    if (number < min) {
      return '$fieldName tidak boleh kurang dari $min';
    }

    if (number > max) {
      return '$fieldName tidak boleh lebih dari $max';
    }

    return null;
  }

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    bool hasData = _heartRateController.text.isNotEmpty ||
        _sleepDurationController.text.isNotEmpty ||
        _caloriesBurnedController.text.isNotEmpty ||
        _stepsController.text.isNotEmpty ||
        _weightController.text.isNotEmpty ||
        _heightController.text.isNotEmpty ||
        _sleepStartTime != null;

    if (!hasData) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Masukkan setidaknya satu data kesehatan'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      DateTime? sleepStartDateTime;
      if (_sleepStartTime != null) {
        final now = DateTime.now();
        sleepStartDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          _sleepStartTime!.hour,
          _sleepStartTime!.minute,
        );
      }

      final healthMetric = HealthMetric(
        date: DateTime.now(),
        heartRate: _heartRateController.text.isNotEmpty 
          ? double.parse(_heartRateController.text) 
          : 0,
        sleepDuration: _sleepDurationController.text.isNotEmpty 
          ? double.parse(_sleepDurationController.text) 
          : 0,
        caloriesBurned: _caloriesBurnedController.text.isNotEmpty 
          ? double.parse(_caloriesBurnedController.text) 
          : 0,
        steps: _stepsController.text.isNotEmpty 
          ? int.parse(_stepsController.text) 
          : 0,
        weight: _weightController.text.isNotEmpty 
          ? double.parse(_weightController.text) 
          : 0,
        height: _heightController.text.isNotEmpty 
          ? double.parse(_heightController.text) 
          : 0,
        sleepStartTime: sleepStartDateTime ?? DateTime.now(),
      );

      await _firestoreService.saveHealthData(healthMetric);
      _resetForm();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data berhasil disimpan!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan data: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _resetForm() {
    _heartRateController.clear();
    _sleepDurationController.clear();
    _caloriesBurnedController.clear();
    _stepsController.clear();
    _weightController.clear();
    _heightController.clear();
    setState(() {
      _sleepStartTime = null;
    });
  }

  @override
  void dispose() {
    _heartRateController.dispose();
    _sleepDurationController.dispose();
    _caloriesBurnedController.dispose();
    _stepsController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / 402;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          'Input Data Kesehatan',
          style: TextStyle(
            fontSize: 20 * scaleFactor,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.blue),
            onPressed: _resetForm,
            tooltip: 'Reset Form',
          ),
        ],
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0 * scaleFactor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputCard(
                    title: 'Vital Signs',
                    icon: Icons.favorite,
                    color: Colors.blue,
                    children: [
                      _buildInputField(
                        controller: _heartRateController,
                        label: 'Detak Jantung',
                        hint: 'Masukkan BPM',
                        icon: Icons.favorite,
                        suffix: 'BPM',
                        validator: (value) => _validateNumericInput(
                          value, 'Detak jantung', _minHeartRate, _maxHeartRate),
                        scaleFactor: scaleFactor,
                      ),
                    ],
                  ),
                  SizedBox(height: 16 * scaleFactor),
                  _buildInputCard(
                    title: 'Sleep Data',
                    icon: Icons.bedtime,
                    color: Colors.indigo,
                    children: [
                      _buildInputField(
                        controller: _sleepDurationController,
                        label: 'Durasi Tidur',
                        hint: 'Masukkan jam',
                        icon: Icons.bedtime,
                        suffix: 'jam',
                        validator: (value) => _validateNumericInput(
                          value, 'Durasi tidur', 0, _maxSleepDuration),
                        scaleFactor: scaleFactor,
                      ),
                      SizedBox(height: 16 * scaleFactor),
                      _buildTimePickerField(scaleFactor),
                    ],
                  ),
                  SizedBox(height: 16 * scaleFactor),
                  _buildInputCard(
                    title: 'Activity Data',
                    icon: Icons.directions_run,
                    color: Colors.green,
                    children: [
                      _buildInputField(
                        controller: _caloriesBurnedController,
                        label: 'Kalori Terbakar',
                        hint: 'Masukkan kalori',
                        icon: Icons.local_fire_department,
                        suffix: 'kcal',
                        validator: (value) => _validateNumericInput(
                          value, 'Kalori', 0, _maxCalories),
                        scaleFactor: scaleFactor,
                      ),
                      SizedBox(height: 16 * scaleFactor),
                      _buildInputField(
                        controller: _stepsController,
                        label: 'Langkah',
                        hint: 'Masukkan jumlah langkah',
                        icon: Icons.directions_walk,
                        suffix: 'steps',
                        validator: (value) => _validateNumericInput(
                          value, 'Langkah', 0, _maxSteps.toDouble()),
                        scaleFactor: scaleFactor,
                      ),
                    ],
                  ),
                  SizedBox(height: 16 * scaleFactor),
                  _buildInputCard(
                    title: 'Body Measurements',
                    icon: Icons.height,
                    color: Colors.purple,
                    children: [
                      _buildInputField(
                        controller: _weightController,
                        label: 'Berat Badan',
                        hint: 'Masukkan berat badan',
                        icon: Icons.scale,
                        suffix: 'kg',
                        validator: (value) => _validateNumericInput(
                          value, 'Berat badan', 0, _maxWeight),
                        scaleFactor: scaleFactor,
                      ),
                      SizedBox(height: 16 * scaleFactor),
                      _buildInputField(
                        controller: _heightController,
                        label: 'Tinggi Badan',
                        hint: 'Masukkan tinggi badan',
                        icon: Icons.height,
                        suffix: 'cm',
                        validator: (value) => _validateNumericInput(
                          value, 'Tinggi badan', 0, _maxHeight),
                        scaleFactor: scaleFactor,
                      ),
                    ],
                  ),
                  SizedBox(height: 24 * scaleFactor),
                  _buildSaveButton(scaleFactor),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInputCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: color),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String suffix,
    required String? Function(String?)? validator,
    required double scaleFactor,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.blue),
        suffixText: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      validator: validator,
      style: TextStyle(fontSize: 16 * scaleFactor),
    );
  }

  Widget _buildTimePickerField(double scaleFactor) {
    return InkWell(
      onTap: () => _selectSleepStartTime(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Waktu Mulai Tidur',
          prefixIcon: Icon(Icons.access_time, color: Colors.blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _sleepStartTime != null
                ? '${_sleepStartTime!.format(context)}'
                : 'Pilih waktu',
              style: TextStyle(
                fontSize: 16 * scaleFactor,
                color: _sleepStartTime != null ? Colors.black87 : Colors.grey[600],
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(double scaleFactor) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16 * scaleFactor),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveData,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: EdgeInsets.symmetric(
            horizontal: 32 * scaleFactor, 
            vertical: 16 * scaleFactor
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              Padding(
                padding: EdgeInsets.only(right: 8.0 * scaleFactor),
                child: SizedBox(
                  width: 20 * scaleFactor,
                  height: 20 * scaleFactor,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ),
                ),
              ),
            Text(
              _isLoading ? 'Menyimpan...' : 'Simpan Data',
              style: TextStyle(fontSize: 16 * scaleFactor),
            ),
          ],
        ),
      ),
    );
  }
}
