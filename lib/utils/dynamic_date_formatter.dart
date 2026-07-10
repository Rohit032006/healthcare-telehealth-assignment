import 'package:healthcare/utils/date_conversion.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../features/configuration/controller/configuration_controller.dart';

/// Utility class for dynamic date formatting based on configuration API
class DynamicDateFormatter {
  static DynamicDateFormatter? _instance;
  static DynamicDateFormatter get instance => _instance ??= DynamicDateFormatter._internal();
  
  DynamicDateFormatter._internal();

  /// Get the current date format from configuration
  String get currentDateFormat {
    try {
      final configController = Get.find<ConfigurationController>();
      return configController.currentDateFormat;
    } catch (e) {
      // Fallback to DateTimeConversion format if configuration controller is not available
      return DateTimeConversion.dateFormat;
    }
  }

  /// Format a DateTime using the dynamic configuration format
  String formatDate(DateTime? date) {
    if (date == null) return '--';
    try {
      return DateFormat(currentDateFormat).format(date);
    } catch (e) {
      // Fallback to DateTimeConversion if there's an error
      return DateTimeConversion.formatDateTime(date);
    }
  }

  /// Format a date string using the dynamic configuration format
  String formatDateString(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '--';
    try {
      final date = DateTime.parse(dateStr);
      return formatDate(date);
    } catch (e) {
      return '--';
    }
  }

  /// Format date for API calls (always use ISO format for backend)
  String formatDateForAPI(DateTime? date) {
    if (date == null) return '';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// Format date for API calls with time (always use ISO format for backend)
  String formatDateTimeForAPI(DateTime? date) {
    if (date == null) return '';
    return DateFormat('yyyy-MM-dd\'T\'HH:mm:ss').format(date);
  }

  /// Format date for display with custom format override
  String formatDateWithOverride(DateTime? date, String? formatOverride) {
    if (date == null) return '--';
    try {
      final format = formatOverride ?? currentDateFormat;
      return DateFormat(format).format(date);
    } catch (e) {
      return DateTimeConversion.formatDateTime(date);
    }
  }

  /// Format date for display with custom format override
  String formatDateStringWithOverride(String? dateStr, String? formatOverride) {
    if (dateStr == null || dateStr.isEmpty) return '--';
    try {
      final date = DateTime.parse(dateStr);
      return formatDateWithOverride(date, formatOverride);
    } catch (e) {
      return '--';
    }
  }

  /// Get month and year format (e.g., "January 2025")
  String formatMonthYear(DateTime date) {
    try {
      return DateFormat('MMMM yyyy').format(date);
    } catch (e) {
      return '${date.month}/${date.year}';
    }
  }

  /// Get time format (e.g., "1:45 PM")
  String formatTime(DateTime date) {
    try {
      return DateFormat('h:mm a').format(date);
    } catch (e) {
      return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    }
  }

  /// Get time format in 24-hour format (e.g., "13:45")
  String formatTime24Hour(DateTime date) {
    try {
      return DateFormat('HH:mm').format(date);
    } catch (e) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
  }

  /// Get day name format (e.g., "Monday")
  String formatDayName(DateTime date) {
    try {
      return DateFormat('EEEE').format(date);
    } catch (e) {
      return 'Day ${date.weekday}';
    }
  }

  /// Get short day name format (e.g., "Mon")
  String formatShortDayName(DateTime date) {
    try {
      return DateFormat('EEE').format(date);
    } catch (e) {
      return 'D${date.weekday}';
    }
  }

  /// Get short month name format (e.g., "Jan")
  String formatShortMonthName(DateTime date) {
    try {
      return DateFormat('MMM').format(date);
    } catch (e) {
      return 'M${date.month}';
    }
  }

  /// Get full month name format (e.g., "January")
  String formatFullMonthName(DateTime date) {
    try {
      return DateFormat('MMMM').format(date);
    } catch (e) {
      return 'Month ${date.month}';
    }
  }

  /// Format date range for display
  String formatDateRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) return '--';
    
    try {
      if (startDate.year == endDate.year) {
        if (startDate.month == endDate.month) {
          // Same month and year: "Jan 15-20, 2025"
          return '${formatShortMonthName(startDate)} ${startDate.day}-${endDate.day}, ${startDate.year}';
        } else {
          // Same year, different months: "Jan 15 - Feb 20, 2025"
          return '${formatShortMonthName(startDate)} ${startDate.day} - ${formatShortMonthName(endDate)} ${endDate.day}, ${startDate.year}';
        }
      } else {
        // Different years: "Jan 15, 2024 - Feb 20, 2025"
        return '${formatShortMonthName(startDate)} ${startDate.day}, ${startDate.year} - ${formatShortMonthName(endDate)} ${endDate.day}, ${endDate.year}';
      }
    } catch (e) {
      return '${formatDate(startDate)} - ${formatDate(endDate)}';
    }
  }

  /// Format relative time (e.g., "2 hours ago", "3 days ago")
  String formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return "Just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} min${difference.inMinutes == 1 ? '' : 's'} ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago";
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return "$weeks week${weeks == 1 ? '' : 's'} ago";
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return "$months month${months == 1 ? '' : 's'} ago";
    } else {
      final years = (difference.inDays / 365).floor();
      return "$years year${years == 1 ? '' : 's'} ago";
    }
  }
}

/// Global instance for easy access
final dynamicDateFormatter = DynamicDateFormatter.instance;
