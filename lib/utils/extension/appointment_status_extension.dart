import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/enum_constant.dart';

extension AppointmentStatusX on AppointmentStatus {
  String get label {
    switch (this) {
      case AppointmentStatus.confirmed:
        return 'Confirmed';
      case AppointmentStatus.unconfirmed:
        return 'Unconfirmed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get color {
    switch (this) {
      case AppointmentStatus.confirmed:
        return AppColors.greenColor;
      case AppointmentStatus.unconfirmed:
        return AppColors.orangeColor;
      case AppointmentStatus.cancelled:
        return AppColors.redColor;
    }
  }
}
