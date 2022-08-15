class StringValidators {
  StringValidators._(); // private constructor
  static final instance = StringValidators._(); // single instance of the class

  titleValidator(String? value) {
    if (value == null || value == '') {
      return 'Enter note title';
    } else if (value.isNotEmpty) {
      if (value.length >= 6) {
        if (value.contains('0') ||
            value.contains('1') ||
            value.contains('2') ||
            value.contains('3') ||
            value.contains('4') ||
            value.contains('5') ||
            value.contains('6') ||
            value.contains('7') ||
            value.contains('8') ||
            value.contains('9')) {
          return "Title must NOT contain numbers";
        }
      } else {
        return "Minimum length of 6 characters";
      }
    }
    return null;
  }

  contentValidator(value) {
    if (value!.isEmpty) {
      return 'Enter note content';
    } else if (value.isNotEmpty) {
      if (value.length <= 150) {
        if (value[0].contains(RegExp('[A-Z]'))) {
          if (value.contains('!') ||
              value.contains('@') ||
              value.contains('#') ||
              value.contains('\$}') ||
              value.contains('%') ||
              value.contains('^') ||
              value.contains('&') ||
              value.contains('*')) {
          } else {
            return "Content must contain special characters";
          }
        } else {
          return 'First letter must be capital';
        }
      } else {
        return "Maximum length of 150 characters";
      }
    }
    return null;
  }
}
