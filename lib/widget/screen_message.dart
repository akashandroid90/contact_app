import 'package:flutter/material.dart';

class ScreenMessage extends StatelessWidget {
  final String message;

  ScreenMessage(this.message);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message),
    );
  }
}
