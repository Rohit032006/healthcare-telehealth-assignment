import 'dart:math' as math;

import 'package:flutter/services.dart';
class PhoneWithOptionalPlusFormatter extends TextInputFormatter {
  const PhoneWithOptionalPlusFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String rawText = newValue.text;

    final String digitsOnly = rawText.replaceAll(RegExp(r'[^0-9]'), '');

    final String primaryTenDigits =
        digitsOnly.length > 10 ? digitsOnly.substring(0, 10) : digitsOnly;

    final bool plusRequested = rawText.contains('+');
    final bool canShowPlus = digitsOnly.length >= 10;
    final bool includePlus = plusRequested && canShowPlus;

    final String extraDigits = includePlus && digitsOnly.length > 10
        ? digitsOnly.substring(10)
        : '';

    final String formatted = includePlus
        ? ('$primaryTenDigits+$extraDigits')
        : primaryTenDigits;

    final int selectionIndex = math.min(
      formatted.length,
      newValue.selection.baseOffset,
    );

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: selectionIndex),
      composing: TextRange.empty,
    );
  }
}


