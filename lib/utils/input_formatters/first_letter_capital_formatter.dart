import 'package:flutter/services.dart';

class FirstLetterCapitalFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    
    // Capitalize the first letter and keep the rest as it is
    String text = newValue.text;
    if (text.isNotEmpty) {
      text = text[0].toUpperCase() + text.substring(1);
    }
    
    return newValue.copyWith(
      text: text,
      selection: newValue.selection,
    );
  }
}
