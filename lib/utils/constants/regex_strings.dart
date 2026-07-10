class RegexStrings {
  RegexStrings._();

  /// Common strings & regular expressions
  static final emailCharSet = RegExp(r"[a-zA-Z0-9.@!#$%&'*+/=?^_`{|}~-]");
  static final emailRegEx = RegExp(
    r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|"
    r"[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+"
    r"(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|"
    r"[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|"
    r"((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?"
    r"(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]"
    r"|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])"
    r"|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|"
    r"[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*"
    r"(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))"
    r"@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|"
    r"(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])"
    r"([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*"
    r"([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)"
    r"+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]"
    r"|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|"
    r"[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|"
    r"[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$",
  );
  static final nameRegEx = RegExp('[a-z A-Z]');
  static final numberRegEx = RegExp('[0-9]');
  static final gradeRegEx = RegExp(r'^[1-9]$|^10$|^11$|^12$');
  static final ifscRegEx = RegExp("^[A-Z]{4}0[A-Z0-9]{6}");
  static final normalizationRegEx = RegExp('-|_');
  static final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static const space = ' ';
  static final RegExp passwordRegEx = RegExp(r'^\d{6}$');
  static final RegExp isName = RegExp(r"^[a-zA-Z\s]{2,}$");
  static final internationalNumber = RegExp(
      r'^\+?\d{1,4}?[-.\s]?\(?\d{1,3}?\)?[-.\s]?\d{1,4}[-.\s]?\d{1,4}[-.\s]?\d{1,9}$');
}
