import 'package:QoshKel/common/custom_shapes/containers/circle_container.dart';
import 'package:QoshKel/common/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:QoshKel/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class TPrimaryheaderContainer extends StatelessWidget {
  const TPrimaryheaderContainer({
    super.key, required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TCurvedEdgeWidget(
      child: Container(
        color: TColors.primary,
        padding: const EdgeInsets.all(0),
        child: SizedBox(
          height: 400,
          child: Stack(
            children: [
              Positioned(top: -150, right: -250, child: TCircleContainer(backgroundColor: TColors.textWhite.withOpacity(0.1))),
              Positioned(top: 100, right: -300, child: TCircleContainer(backgroundColor: TColors.textWhite.withOpacity(0.1))),
      
    ],
              ),
            ),
          ),
    );
  }
}