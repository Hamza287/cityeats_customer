import 'package:intl/intl.dart';

class DateTimeService {
  formateDate(DateTime? dateTime) {
    final dateFormat = DateFormat.yMd();
    if (dateTime != null) return dateFormat.format(dateTime);
  }
  // formateDate(DateTime? dateTime) {
  //   final dateFormat = DateFormat.yMd();
  //   if (dateTime != null) return dateFormat.format(dateTime);
  // }

  static formateDateTime(DateTime? dateTime) {
    final dateFormat = DateFormat('yyyy-MM-dd hh:mm a');
    if (dateTime != null) return dateFormat.format(dateTime);
  }

  /// Returns the day name of the given DateTime object.
  static String getDayName(DateTime dateTime) {
    final dateFormat = DateFormat('EEEE');
    return dateFormat.format(dateTime);
  }

  static DateTime parseTime(String time, {bool is24Hour = false}) {
    if (is24Hour) {
      // Convert 24-hour formatted time
      return DateFormat('HH:mm').parse(time);
    } else {
      // Convert 12-hour formatted time
      return DateFormat('hh:mm a').parse(time);
    }
  }

  static DateTime parseUTCTime(String time, {bool is24Hour = false}) {
    DateTime utcTime =
        DateFormat('HH:mm:ss').parse(time, true); // 'true' indicates UTC
    String localTime = DateFormat("HH:mm:ss").format(utcTime.toLocal());

    if (is24Hour) {
      return DateFormat('HH:mm').parse(localTime);
    } else {
      return DateFormat('hh:mm a').parse(localTime);
    }
  }

  /// 2024-12-02 13:09:40.118276 to 1970-01-01 01:09:00.000
  static DateTime getCurrentTimeFormatedObject() {
    final currentTime = DateFormat('HH:mm').format(DateTime.now());
    return DateFormat('HH:mm').parse(currentTime);
  }

  convertIntoAmPmDate(String timeString) {
    // Example time string
    // String timeString = '23:00:00';

    // Parse the time string to a DateTime object
    DateTime time = DateFormat('HH:mm:ss').parse(timeString);

    // Format the DateTime object to include AM/PM
    String formattedTime = DateFormat('h:mm a').format(time);

    return formattedTime;
  }
}
