import 'package:flutter/material.dart';

class SynthiaChip extends StatelessWidget {
  final String text;
  final Color color;
  final bool display;

  const SynthiaChip({
    required this.text,
    this.color = const Color(0xff388D3B),
    this.display = true,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: display,
      child: Chip(
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: color.withOpacity(0.71),
      ),
    );
  }
}
