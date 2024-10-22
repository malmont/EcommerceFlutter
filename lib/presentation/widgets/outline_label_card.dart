import 'package:flutter/material.dart';

import '../../design/design.dart';

class OutlineLabelCard extends StatelessWidget {
  final String title;
  final Widget child;
  final TextStyle? labelStyle;
  const OutlineLabelCard(
      {Key? key,
      required this.title,
      required this.child,
      this.labelStyle = TextStyles.interRegularBody1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelStyle: labelStyle,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        labelText: title,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      child: child,
    );
  }
}
