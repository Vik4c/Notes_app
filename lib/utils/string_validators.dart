class StringValidators {
  StringValidators._(); // private constructor
  static final instance = StringValidators._(); // single instance of the class

  titleValidator(String? value) {
    if (value == null || value == '') {
      return 'Enter title';
    } else if (value.isNotEmpty) {
      String pattern = '[0-9]';
      var regex = RegExp(pattern);
      if (!regex.hasMatch(value)) {
        return "Enter title value";
      }
    }
    return null;
  }

  contentValidator(value) {
    if (value!.isEmpty) {
      // popUp('Note content has not been entered');
    } else {
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
            return null;
          } else {
            // popUp('The content must contain special characters!');
          }
        } else {
          // popUp('The first letter of the conent must be capital!');
        }
      } else {
        // popUp('The lenght of the content must not exceed 150 characters!');
      }
    }
    return null;
  }
}
