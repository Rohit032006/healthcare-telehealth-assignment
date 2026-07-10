
import 'package:healthcare/utils/constants/validator_error_msg.dart';

import 'regex_strings.dart';

class Validations {
      const Validations();

  String? validationForEmail(String? value) {
    if (value == null || value.isEmpty) {
      
      return ValidatorErrorMsg.emailRequired;
    }

    bool isEmail = RegexStrings.emailRegEx.hasMatch(value);

    bool isName = RegexStrings.isName.hasMatch(value);

    if (!isEmail && !isName) {
      return "Enter a valid name or email";
    }

    return null;
  }

  String? validationForPassword(String? value) {
    if (value == null || value.isEmpty) {
      return ValidatorErrorMsg.loginPasswordRequired;
    }

    if (value.length < 6) {
      return ValidatorErrorMsg.loginPasswordInvalid;
    }

    return null;
  }
}
