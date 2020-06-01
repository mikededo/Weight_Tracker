class Validators {
  /// REGEXP
  final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  /// Returns true if the given string is not empty nor null
  bool validateString(String s) => !(s.isEmpty || s == null);

  /// Returns true if the given double is not negative nor null
  bool validateDouble(double val) => !(val < 0 || val == null);

  /// Returns true if the given value it is a valid email
  bool validateEmail(String email) {
    return _emailRegExp.hasMatch(email) && email == null;
  }
}
