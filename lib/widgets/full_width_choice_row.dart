import 'package:flutter/material.dart';

class FullWidthChoiceRow extends StatelessWidget {
  final List<Widget> children;

  const FullWidthChoiceRow({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: children
          .expand(
            (child) => [
              child,
              if (child != children.last) const SizedBox(width: 12),
            ],
          )
          .toList(),
    );
  }
}
