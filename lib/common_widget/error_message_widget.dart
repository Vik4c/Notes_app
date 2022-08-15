import 'package:flutter/material.dart';

class ErrorMessageWidget extends StatelessWidget {
  const ErrorMessageWidget({Key? key, required this.errorMessage})
      : super(key: key);
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Text(errorMessage);
  }
}
