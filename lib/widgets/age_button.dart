import 'package:flutter/material.dart';

class AgeButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const AgeButton({super.key, 
    required this.icon,
    required this.onTap,
  });

  @override
  State<AgeButton> createState() => AgeButtonState();
}

class AgeButtonState extends State<AgeButton> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: hovered ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Icon(
            widget.icon,
            color: hovered ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}