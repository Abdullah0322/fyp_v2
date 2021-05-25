import 'package:flutter/material.dart';

class NewScreen extends StatelessWidget {
  String payload;

  NewScreen({
    this.payload,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(payload),
      ),
    );
  }
}
