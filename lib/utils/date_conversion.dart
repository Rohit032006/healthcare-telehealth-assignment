// import 'package:intl/intl.dart';

// class DateTimeConversion {
//   DateTimeConversion._internal();

//   static final DateTimeConversion _instance = DateTimeConversion._internal();

//   factory DateTimeConversion() => _instance;

//   static String _dateFormat = 'yyyy-MM-dd';

//   /// Setter to update date format dynamically
//   // static set dateFormat(String value) {
//   //   if (value.isNotEmpty) {
//   //     _dateFormat = value;
//   //   }
//   // }

//   static set dateFormat(String value) {
//   if (value.isNotEmpty) {
//     LoggerService.log('📅 DateTimeConversion.dateFormat set to: $value'); // Optional
//     _dateFormat = value;
//   }
// }


//   /// Getter for current date format
//   static String get dateFormat => _dateFormat;

//   /// Formats [dateStr] to the current date format. Returns '--' if parse fails.
//   static String formatDateString(String? dateStr) {
//     if (dateStr == null || dateStr.isEmpty) return '--';
//     try {
//       final date = DateTime.parse(dateStr);
//       return DateFormat(_dateFormat).format(date);
//     } catch (_) {
//       return '--';
//     }
//   }

//   static String dateformat(String? dateStr) {
//     if (dateStr == null || dateStr.isEmpty) return '--';
//     try {
//       final date = DateTime.parse(dateStr);
//       return DateFormat(_dateFormat).format(date);
//     } catch (_) {
//       return '--';
//     }
//   }

//    static String formatDateTime(DateTime? date) {
//   if (date == null) return '--';
//   try {
//     return DateFormat(_dateFormat).format(date);
//   } catch (_) {
//     return '--';
//   }
// }

 

//   static String formatDateStringProfile(String? dateStr) {
//     if (dateStr == null || dateStr.isEmpty) return '--';
//     try {
//       final date = DateTime.parse(dateStr)
//           .toLocal(); // optional: convert to local timezone
//       return DateFormat(_dateFormat).format(date);
//     } catch (_) {
//       return '--';
//     }
//   }

//   /// Formats ISO string to local time in 'h:mm a'.
//   static String formatIsoTime(String? isoTime) {
//     if (isoTime == null || isoTime.isEmpty) return "--";
//     try {
//       final dateTime = DateTime.parse(isoTime).toLocal();
//       return DateFormat('h:mm a').format(dateTime);
//     } catch (_) {
//       return "--";
//     }
//   }

//   static String formatIsoTimeParticipents(String? isoTime) {
//     if (isoTime == null || isoTime.isEmpty) return "--";
//     try {
//       final dateTime = DateTime.parse(isoTime).toLocal();
//       return DateFormat('h:mm a').format(dateTime);
//     } catch (_) {
//       return "--";
//     }
//   }

//   /// Maps availability shift status to display string.
//   static String mapShiftStatus(String shift) {
//     switch (shift) {
//       case "available":
//         return "Available";
//       case "less-preferred":
//         return "Less Preferred";
//       case "not-available":
//         return "Not Available";
//       default:
//         return "--- : ---";
//     }
//   }

//   /// Formats [date] to 'dd / MM / yyyy'.
//   static String formatDate(DateTime? date) {
//     if (date == null) return "--";
//     return "${date.day.toString().padLeft(2, '0')} / "
//         "${date.month.toString().padLeft(2, '0')} / "
//         "${date.year}";
//   }

//   /// Formats [time] to 'HH:MM'.
//   static String formatTime(DateTime? time) {
//     if (time == null) return "--";
//     return "${time.hour.toString().padLeft(2, '0')}:"
//         "${time.minute.toString().padLeft(2, '0')}";
//   }

//   static String formatHeaderDate(DateTime date) {
//     final day = DateFormat('d').format(date);
//     final month = DateFormat('MMMM').format(date);
//     final year = date.year.toString();
//     return '$day $month $year';
//   }

//   static String libraryformatDate(DateTime date) {
//     return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
//   }

//   static String librarytruncateId(String id) {
//     return id.length > 8 ? '${id.substring(0, 8)}...' : id;
//   }

// static String formatDateTimeString(String? dateStr) {
//   if (dateStr == null || dateStr.isEmpty) return "--";
//   try {
//     final dateTime = DateTime.parse(dateStr).toLocal();
//     final datePart = DateFormat(_dateFormat).format(dateTime);
//     final timePart = DateFormat('hh:mm a').format(dateTime);
//     return "$datePart $timePart";
//   } catch (_) {
//     return "--";
//   }
// }
// }



import 'package:intl/intl.dart';

import 'logger_service.dart';

class DateTimeConversion {
  DateTimeConversion._internal();
  static final DateTimeConversion _instance = DateTimeConversion._internal();
  factory DateTimeConversion() => _instance;

  static String _dateFormat = 'dd-MM-yyyy'; // Default format

  /// ✅ Setter to update date format dynamically from API
  static set dateFormat(String value) {
    if (value.isNotEmpty) {
      LoggerService.log('📅 DateTimeConversion.dateFormat set to: $value');
      _dateFormat = value;
    }
  }

  static String get dateFormat => _dateFormat;

  /// Reset to default format
  static void resetToDefault() {
    _dateFormat = 'dd-MM-yyyy';
  }

  static String formatDateString(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '--';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat(_dateFormat).format(date);
    } catch (e) {
      LoggerService.log('Error formatting date string: $e');
      return '--';
    }
  }

  static String formatDateTime(DateTime? date) {
    if (date == null) return '--';
    try {
      return DateFormat(_dateFormat).format(date);
    } catch (e) {
      LoggerService.log('Error formatting DateTime: $e');
      return '--';
    }
  }

static String formatDateStringS(String? dateString) {
  if (dateString == null || dateString.isEmpty) return '--';
  try {
    final date = DateTime.parse(dateString);
    // Optionally, convert to local time if you want to show local time:
    // final localDate = date.toLocal();
    return DateFormat(_dateFormat).format(date);
  } catch (e) {
    LoggerService.log('Error formatting Date String: $e');
    return '--';
  }
}

  static String formatDateStringProfile(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '--';
    try {
      final date = DateTime.parse(dateStr).toLocal();
      return DateFormat(_dateFormat).format(date);
    } catch (e) {
      LoggerService.log('Error formatting profile date: $e');
      return '--';
    }
  }

  static String formatIsoTime(String? isoTime) {
    if (isoTime == null || isoTime.isEmpty) return "--";
    try {
      final dateTime = DateTime.parse(isoTime).toLocal();
      return DateFormat('h:mm:ss a').format(dateTime);
    } catch (e) {
      LoggerService.log('Error formatting ISO time: $e');
      return "--";
    }
  }

  static String formatDate(DateTime? date) {
    if (date == null) return "--";
    try {
      return DateFormat(_dateFormat).format(date);
    } catch (e) {
      LoggerService.log('Error formatting date: $e');
      return "--";
    }
  }

  static String formatTime(DateTime? time) {
    if (time == null) return "--";
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  static String formatHeaderDate(DateTime date) {
    try {
      final day = DateFormat('d').format(date);
      final month = DateFormat('MMMM').format(date);
      final year = date.year.toString();
      return '$year $month $day';
    } catch (e) {
      LoggerService.log('Error formatting header date: $e');
      return '--';
    }
  }

  static String libraryformatDate(DateTime date) {
    try {
      return DateFormat('$_dateFormat HH:mm').format(date);
    } catch (e) {
      LoggerService.log('Error formatting library date: $e');
      return '--';
    }
  }

  static String formatDateTimeString(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "--";
    try {
      final dateTime = DateTime.parse(dateStr).toLocal();
      final datePart = DateFormat(_dateFormat).format(dateTime);
      final timePart = DateFormat('hh:mm a').format(dateTime);
      return "$datePart $timePart";
    } catch (e) {
      LoggerService.log('Error formatting date time string: $e');
      return "--";
    }
  }

  static String mapShiftStatus(String shift) {
    switch (shift.toLowerCase()) {
      case "available":
        return "Available";
      case "less-preferred":
        return "Less Preferred";
      case "not-available":
        return "Not Available";
      default:
        return "--- : ---";
    }
  }

  static String librarytruncateId(String id) {
    return id.length > 8 ? '${id.substring(0, 8)}...' : id;
  }



static String formatFlexibleDateString(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty) return '--';
  try {
    // Try ISO first
    return DateFormat(_dateFormat).format(DateTime.parse(dateStr));
  } catch (_) {
    try {
      // Try custom format
      final inputFormat = DateFormat('yyyy MMMM dd');
      final date = inputFormat.parse(dateStr);
      return DateFormat(_dateFormat).format(date);
    } catch (e) {
      LoggerService.log('Error formatting flexible date string: $e');
      return '--';
    }
  }
}
static String formatBackendDateTimeWithIST(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty) return '--';
  
  try {
    final utcDate = DateTime.parse(dateStr);
    final istDate = convertUTCToIST(utcDate);
    final datePart = DateFormat(_dateFormat).format(istDate);
    final timePart = DateFormat('hh:mm a').format(istDate);
    return "$datePart $timePart";
  } catch (e) {
    LoggerService.log('Error formatting backend date time with IST: $e');
    return '--';
  }
}


static String formatDateStrings(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty) return '--';
  DateTime? date;
  // Try ISO first
  try {
    date = DateTime.parse(dateStr);
  } catch (_) {
    
    final formats = [
      DateFormat('dd MMM yyyy'),   
      DateFormat('yyyy-MM-dd'),    
      DateFormat('yyyy/MM/dd'),    
      DateFormat('yyyy MMM dd'),   
      DateFormat('yyyy MMMM dd'),  
      DateFormat('dd-MM-yyyy'),    
      DateFormat('dd/MM/yyyy'),    
    ];
    for (final format in formats) {
      try {
        date = format.parse(dateStr);
        break;
      } catch (_) {}
    }
  }
  if (date == null) {
    LoggerService.log('Error formatting date string: Could not parse $dateStr');
    return '--';
  }
  return DateFormat(_dateFormat).format(date);
}

static String formatDateStringsWithIST(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty) return '--';
  DateTime? date;
  
  try {
    date = DateTime.parse(dateStr);
  } catch (_) {
    final formats = [
      DateFormat('dd MMM yyyy'),   
      DateFormat('yyyy-MM-dd'),    
      DateFormat('yyyy/MM/dd'),    
      DateFormat('yyyy MMM dd'),   
      DateFormat('yyyy MMMM dd'),  
      DateFormat('dd-MM-yyyy'),    
      DateFormat('dd/MM/yyyy'),    
    ];
    for (final format in formats) {
      try {
        date = format.parse(dateStr);
        break;
      } catch (_) {}
    }
  }
  
  if (date == null) {
    LoggerService.log('Error formatting date string: Could not parse $dateStr');
    return '--';
  }
  
  final istDate = date.toUtc().add(const Duration(hours: 5, minutes: 30));
  
  return DateFormat(_dateFormat).format(istDate);
}

static String formatDateTimeWithIST(DateTime? date) {
  if (date == null) return '--';
  
  
  final localDate = date.toLocal();
  
  return DateFormat(_dateFormat).format(localDate);
}

static DateTime convertUTCToIST(DateTime utcDate) {
  return utcDate.toUtc().add(const Duration(hours: 5, minutes: 30));
}


static String formatBackendDateWithIST(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty) return '--';
  
  try {
    // Parse the date string (assuming it's in UTC from backend)
    final utcDate = DateTime.parse(dateStr);
    
    // Convert to IST
    final istDate = convertUTCToIST(utcDate);
    
    // Format using the current date format
    return DateFormat(_dateFormat).format(istDate);
  } catch (e) {
    LoggerService.log('Error formatting backend date with IST: $e');
    return '--';
  }
}


static String formatDateDynamic(String? dateStr, {String? outputFormat}) {
  if (dateStr == null || dateStr.isEmpty) return '--';
  DateTime? date;

  // Helper to capitalize month if needed (for e.g. "2025 jul 21")
  String capitalizeMonth(String input) {
    final parts = input.split(' ');
    if (parts.length == 3) {
      parts[1] = parts[1][0].toUpperCase() + parts[1].substring(1).toLowerCase();
      return parts.join(' ');
    }
    return input;
  }

  // 1. Try parsing with the dynamic _dateFormat first
  try {
    date = DateFormat(_dateFormat).parse(dateStr);
  } catch (_) {
    // 2. Try ISO format
    try {
      date = DateTime.parse(dateStr);
    } catch (_) {
      // 3. Try other common formats, including capitalized month
      final fallbackFormats = [
        DateFormat('yyyy-MM-dd'),
        DateFormat('yyyy/MM/dd'),
        DateFormat('yyyy MMMM dd'),
        DateFormat('yyyy MMM dd'),
        DateFormat('dd-MM-yyyy'),
        DateFormat('dd/MM/yyyy'),
        DateFormat('dd MMM yyyy'),
        DateFormat('yyyy-MM-ddTHH:mm:ss'),
        DateFormat('yyyy-MM-dd HH:mm:ss'),
      ];
      for (final format in fallbackFormats) {
        try {
          date = format.parse(dateStr);
          break;
        } catch (_) {
          // Try with capitalized month
          try {
            date = format.parse(capitalizeMonth(dateStr));
            break;
          } catch (_) {}
        }
      }
    }
  }

  if (date == null) return '--';
  final formatString = outputFormat ?? _dateFormat;
  LoggerService.log('📅 formatDateDynamic using format: $formatString for date: $dateStr');
  return DateFormat(formatString).format(date);
}

static String formatCalendarHeader(DateTime date) {
  try {
    return DateFormat('d MMM yyyy').format(date);
  } catch (e) {
    LoggerService.log('Error formatting calendar header date: $e');
    return '--';
  }
}

/// Convert UTC time string to IST and format as 12-hour time (e.g., "09:30 AM", "09:20 PM")
static String formatTimeStringWithIST(String? timeStr) {
  if (timeStr == null || timeStr.isEmpty) return 'N/A';
  try {
    // Parse the time string as UTC (assuming format like "09:30:00" or "21:20:00")
    DateTime utcTime;
    if (timeStr.contains('T')) {
      // Full datetime string
      utcTime = DateTime.parse(timeStr);
    } else {
      // Just time string, create a date with it
      utcTime = DateTime.parse("2023-01-01 $timeStr");
    }
    // Convert to IST (add 5:30 hours)
    final istTime = utcTime.add(const Duration(hours: 5, minutes: 30));
    // Format as 12-hour time
    return DateFormat('hh:mm a').format(istTime);
  } catch (e) {
    LoggerService.log('Error formatting time string with IST: $e');
    return timeStr; // Return original if parsing fails
  }
}

/// Convert DateTime to local time and format as 12-hour time (e.g., "05:08 PM")
static String formatTimeWithIST(DateTime? time) {
  if (time == null) return 'N/A';
  try {
   
    final localTime = time.toLocal();
    return DateFormat('hh:mm a').format(localTime);
  } catch (e) {
    LoggerService.log('Error formatting time with IST: $e');
    return 'N/A';
  }
}

}