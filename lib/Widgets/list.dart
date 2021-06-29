import 'package:flutter/material.dart';

class SynthiaList extends StatelessWidget {
  const SynthiaList({
    required this.itemCount,
    required this.itemBuilder,
    this.header,
    this.footer,
    this.isScrollable = true,
    this.shrinkWrap = false,
    this.scrollController,
  }) : super();

  final int itemCount;
  final bool shrinkWrap;
  final Widget Function(int index) itemBuilder;
  final Widget? header;
  final bool isScrollable;
  final ScrollController? scrollController;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      physics: isScrollable ? null : const NeverScrollableScrollPhysics(),
      shrinkWrap: !shrinkWrap
          // ignore: avoid_bool_literals_in_conditional_expressions
          ? isScrollable
              ? false
              : true
          : shrinkWrap,
      itemCount:
          itemCount + (header == null ? 0 : 1) + (footer == null ? 0 : 1),
      itemBuilder: (context, index) {
        if (header != null && index <= 0) {
          return header!;
        } else if (footer != null &&
            index + 1 ==
                itemCount +
                    (header == null ? 0 : 1) +
                    (footer == null ? 0 : 1)) {
          return footer!;
        } else {
          index = index - (header == null ? 0 : 1);
          return itemBuilder(index);
        }
      },
    );
  }
}
