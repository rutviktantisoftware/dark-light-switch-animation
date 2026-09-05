import 'dart:math';
import 'package:flutter/material.dart';

/// Custom Clipper that draws an expanding or shrinking circle from a given center point
class CircularRevealClipper extends CustomClipper<Path> {
  final double fraction;
  final Offset center;

  CircularRevealClipper({required this.fraction, required this.center});

  @override
  Path getClip(Size size) {
    final path = Path();
    if (fraction <= 0.0) return path;

    final maxRadius = _calcMaxRadius(center, size);
    final currentRadius = maxRadius * fraction.clamp(0.0, 1.0);

    path.addOval(Rect.fromCircle(center: center, radius: currentRadius));
    return path;
  }

  /// Calculates the distance from center to the furthest corner of the screen
  double _calcMaxRadius(Offset center, Size size) {
    final dx = max(center.dx, size.width - center.dx);
    final dy = max(center.dy, size.height - center.dy);
    return sqrt(dx * dx + dy * dy);
  }

  @override
  bool shouldReclip(CircularRevealClipper oldClipper) {
    return oldClipper.fraction != fraction || oldClipper.center != center;
  }
}
