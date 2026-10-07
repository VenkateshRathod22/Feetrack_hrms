import 'dart:developer';

import 'package:intl/intl.dart';

class DateFormatters {
  DateFormat yMD = DateFormat('yyyy-MM-dd');
  DateFormat mD = DateFormat('MMMM dd');
  DateFormat dM = DateFormat('dd MMMM');
  DateFormat hMA = DateFormat('hh:mm a');
  DateFormat hMs = DateFormat('hh:mm:ss');
  DateFormat ms = DateFormat('mm:ss');
  DateFormat dMy = DateFormat('dd MMM yyyy');
  DateFormat mdy = DateFormat('MMM dd, yyyy');
  // ignore: non_constant_identifier_names
  DateFormat My = DateFormat('MMMM yyyy');
  DateFormat dM2 = DateFormat('dd MMM');
  DateFormat dMyDash = DateFormat('dd-MM-yyyy');
  DateFormat dMonthYear = DateFormat('dd MMMM yyyy');
  DateFormat dateTime = DateFormat('dd MMM yyyy, hh:mm a');
  DateFormat dayDMY = DateFormat('EEE,  dd MMM yyyy');
  DateFormat dayDateTime = DateFormat('EEE,  dd MMM yyyy, hh:mm a');
  DateFormat day = DateFormat('EEE');
  DateFormat dayFull = DateFormat('EEE');
  DateFormat dayDate = DateFormat('EEE, dd');
  DateFormat dateDay = DateFormat('dd, EEEE');
  DateFormat month = DateFormat('MMMM');
  DateFormat date = DateFormat('dd');
  // DateFormat week = DateFormat('dd');
  week(DateTime dateTime) {
    if (dateTime.day < 8) {
      return '1';
    }
    if (dateTime.day < 15) {
      return '2';
    }
    if (dateTime.day < 22) {
      return '3';
    }
    return '4';
  }
}

double getDifferenceInDays({required DateTime date, DateTime? currentDate}) {
  // DateTime _myTime;
  // DateTime _ntpTime;
  DateTime dateTimeCreatedAt = date;
  DateTime dateTimeNow = currentDate ?? DateTime.now();
  int differenceInDays = dateTimeCreatedAt.difference(dateTimeNow).inDays;
  return double.parse("$differenceInDays");
}

String getSlotTime({required DateTime one, required DateTime two}) {
  return "${DateFormatters().hMA.format(one)} - ${DateFormatters().hMA.format(two)}";
}

bool compareDates(
    {required DateTime one,
    required DateTime two,
    bool year = true,
    bool logData = false}) {
  if (logData) {
    log("${DateFormatters().dMy.format(one)}  ${DateFormatters().dMy.format(two)}");
  }
  if (year) {
    return DateFormatters().dMy.format(one) == DateFormatters().dMy.format(two);
  } else {
    return DateFormatters().dM.format(one) == DateFormatters().dM.format(two);
  }
}

DateTime getDateTime() {
  return DateTime.now();
}

String convertTo12HourFormat({
  String? time24,
  bool isShowAMPM = true,
}) {
  if (time24 == null || time24.isEmpty) return '';

  try {
    final format = time24.split(':').length == 3 ? "HH:mm:ss" : "HH:mm";

    final dateTime = DateFormat(format).parse(time24);

    return isShowAMPM
        ? DateFormat("hh:mm a").format(dateTime)
        : DateFormat("hh:mm").format(dateTime);
  } catch (e) {
    return time24;
  }
}

String convertTo24Hour(String time12Hour) {
  try {
    final dateTime = DateFormat('hh:mm a').parse(time12Hour.trim());

    return DateFormat('HH:mm').format(dateTime);
  } catch (e) {
    return '';
  }
}

String formatDateTime(String dateTime) {
  final DateTime utcTime = DateTime.parse(dateTime);

  // Convert UTC to local time
  final DateTime localTime = utcTime.toLocal();

  return DateFormat("dd MMM yyyy, hh:mm a").format(localTime);
}

String formatMinutesToHours(int? minutes) {
  if (minutes == null || minutes <= 0) {
    return "0m";
  }

  final hours = minutes ~/ 60;
  final remainingMinutes = minutes % 60;

  if (hours == 0) {
    return "${remainingMinutes}m";
  }

  if (remainingMinutes == 0) {
    return "${hours}h";
  }

  return "${hours}h ${remainingMinutes}m";
}

String getWorkingTime(String? punchInTime) {
  if (punchInTime == null || punchInTime.isEmpty) {
    return "--";
  }

  try {
    final now = DateTime.now();

    final parts = punchInTime.split(":");

    final checkIn = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
      parts.length > 2 ? int.parse(parts[2]) : 0,
    );

    final difference = now.difference(checkIn);

    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;
    final seconds = difference.inSeconds % 60;

    return "${hours}h ${minutes}m ${seconds}s";
  } catch (_) {
    return "--";
  }
}
