import 'package:flutter/material.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/views/components/circular_widget/circular_container.dart';
import 'package:shoe_app_assigment/views/components/curved_edge/curved_edge_widget.dart';

class PrimaryHeaderContainer extends StatelessWidget {
  const PrimaryHeaderContainer({
    super.key, required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CurvedEdgeWidget(
      child: Container(
        color: TColors.newBlue,
        padding: EdgeInsets.all(0),
        child: SizedBox(
          height: 400,
          child: Stack(
            children: [
              Positioned(
                top: -200,
                left: -250,
                child: CircularContainer(
                  width: 400,
                  height: 400,
                  backGroundColor: TColors.textWhite.withOpacity(0.1),
                ),
              ),
              Positioned(
                top: 100,
                left: -320,
                child: CircularContainer(
                  width: 400,
                  height: 400,
                  backGroundColor: TColors.textWhite.withOpacity(0.1),
                ),
              ),

              Positioned(child: child)
            ],
          ),
        ),
      ),
    );
  }
}

