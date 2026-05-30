import 'package:flutter/material.dart';

class ChoicePill extends StatefulWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const ChoicePill({super.key, 
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  State<ChoicePill> createState() => ChoicePillState();
}

class ChoicePillState extends State<ChoicePill> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.selected || hovered;

    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          height: 54,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.black, width: 1.3),
          ),
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: active ? Colors.white : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
