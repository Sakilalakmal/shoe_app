import 'package:flutter/material.dart';

class CustomCurvedEdge extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

   
    path.lineTo(0, size.height);

    // Left curve
    final firstCurve = Offset(0, size.height - 20);
    final secondPoint = Offset(30, size.height - 20);
    path.quadraticBezierTo(
      firstCurve.dx,
      firstCurve.dy,
      secondPoint.dx,
      secondPoint.dy,
    );

    
    final thirdPoint = Offset(size.width - 30, size.height - 20);
    path.lineTo(thirdPoint.dx, thirdPoint.dy);

    // Right curve
    final fourthPoint = Offset(size.width, size.height - 20);
    path.quadraticBezierTo(
      fourthPoint.dx,
      fourthPoint.dy,
      size.width,
      size.height,
    );

    // Top-right 
    path.lineTo(size.width, 0);

    
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
