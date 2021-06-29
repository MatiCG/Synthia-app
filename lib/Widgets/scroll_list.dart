import 'package:flutter/material.dart';

class ScrollSection {
  final String title;
  final List<dynamic> items;

  ScrollSection({
    required this.title,
    required this.items,
  });
}

class SynthiaScrollList extends StatelessWidget {
  final List<ScrollSection> sections;
  final Widget Function(int index) headerBuilder;
  final Widget Function(int headerIndex, int index) itemBuilder;

  const SynthiaScrollList({
    required this.sections,
    required this.headerBuilder,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        sections.length,
        (headerIndex) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headerBuilder(headerIndex),
            Column(
              children: List.generate(
                sections[headerIndex].items.length,
                (itemIndex) => itemBuilder(headerIndex, itemIndex),
              ),
            )
          ],
        ),
      ),
    );
  }
}
