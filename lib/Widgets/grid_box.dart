import 'package:flutter/material.dart';

class SynthiaGridBox extends StatelessWidget {
  const SynthiaGridBox({
    required this.leftBox,
    required this.bottomRightBox,
    required this.topRightBox,
  }) : super();

  final Widget leftBox;
  final Widget topRightBox;
  final Widget bottomRightBox;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildLeftBox(context),
        _buildRightBoxes(context),
      ],
    );
  }

  Widget _buildLeftBox(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Theme.of(context).accentColor,
        ),
        height: (MediaQuery.of(context).size.width * 0.4) + 5,
        width: MediaQuery.of(context).size.width * 0.4,
        child: leftBox,
      ),
    );
  }

  Widget _buildRightBoxes(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 16.0, 16.0, 16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.orange.shade700,
              ),
              height: MediaQuery.of(context).size.width * 0.2,
              width: double.infinity,
              child: topRightBox,
            ),
            const SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.green.shade600,
              ),
              height: MediaQuery.of(context).size.width * 0.2,
              width: double.infinity,
              child: bottomRightBox,
            ),
          ],
        ),
      ),
    );
  }
}
