import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DebugAreaWidget extends StatelessWidget {
  const DebugAreaWidget({Key? key, required this.color}) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(border: Border.all(color: color)));
  }
}
