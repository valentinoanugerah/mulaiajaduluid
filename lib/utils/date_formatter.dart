import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatShortDate(DateTime date) {
    return DateFormat('dd/MM').format(date);
  }
}