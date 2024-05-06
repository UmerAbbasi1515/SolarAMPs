import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension on BuildContext {
  // ignore: unused_element
  int get adaptiveCrossAxisCount {
    final width = MediaQuery.of(this).size.width;
    if (width > 1024) {
      return 8;
    } else if (width > 720 && width < 1024) {
      return 6;
    } else if (width > 480) {
      return 4;
    } else if (width > 320) {
      return 3;
    }
    return 1;
  }
}

extension Extensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String formatDate(String format) {
    var dateTime = DateTime.parse(this);
    // ignore: unused_local_variable
    var diff = dateTime.difference(DateTime.now());
    // if (kDebugMode) {
    //   print('Difference ::: $diff');
    // }
    var newD = dateTime.add(const Duration(hours: 5));
    return DateFormat(format).format(newD).toString();
  }

  String getDayString() {
    DateTime dateTime = DateTime.parse(this);
    DateTime now = DateTime.now();
    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      // get diff in hours
      Duration diff = now.difference(dateTime);
      int hours = diff.inHours;
      if (hours < 1) {
        // get diff in minutes
        int minutes = diff.inMinutes;
        if (minutes < 1) {
          // get diff in seconds
          int seconds = diff.inSeconds;
          if (seconds < 5) {
            return "now";
          }
          return "$seconds seconds ago";
        }
        return "$minutes minutes ago";
      } else {
        return "Today";
      }
    } else if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day - 1) {
      return "Yesterday";
    } else {
      return DateFormat("dd-MMM-yyyy hh:mm a").format(dateTime) + " (CST)";
      // return "${dateTime.month}/${dateTime.day}/${dateTime.year}";
    }
  }
}
