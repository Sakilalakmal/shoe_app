import 'package:flutter/material.dart';
import 'package:shoe_app_assigment/views/components/curved_edge/curved_edge_clipper.dart';

class CurvedEdgeWidget extends StatelessWidget {
  const CurvedEdgeWidget({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(clipper: CustomCurvedEdge(), child: child);
  }
}
