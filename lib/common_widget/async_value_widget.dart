import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rest_api_app1/common_widget/error_message_widget.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T) data;
  const AsyncValueWidget({Key? key, required this.value, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      error: (error, stackTrace) =>
          Center(child: ErrorMessageWidget(errorMessage: error.toString())),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
