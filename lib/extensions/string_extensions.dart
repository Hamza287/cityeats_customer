extension StringValidator on String {
  ///
  /// Custom validation for email that only allows [+, ., -, _, @] Special Characters.
  ///
  bool isValidEmail() {
    return RegExp(r'^[a-zA-Z0-9._+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(this);
  }

  ///
  /// Returns [True] if any special character included.
  ///
  bool containsAnySpecialCharacter() {
    return RegExp(r'[^\w\s]').hasMatch(this);
  }

  ///
  /// Returns [True] if any number included.
  ///
  bool containsNumber() {
    return RegExp(r'[0-9]').hasMatch(this);
  }

  ///
  /// Returns [True] if any Upper-Case Letter included.
  ///
  bool containsUpperCaseLetter() {
    return RegExp(r'[A-Z]').hasMatch(this);
  }

  ///
  /// Returns [True] if password length is not between 8 and 32.
  ///
  bool isNotPasswordLength() {
    return length < 8 || length > 32;
  }
}
