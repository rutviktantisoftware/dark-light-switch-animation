import 'dart:math';
import 'package:flutter/material.dart';
import 'reveal_shape.dart';

/// Multi-Shape Clipper that draws an expanding or shrinking shape from a given center point
class CircularRevealClipper extends CustomClipper<Path> {
  final double fraction;
  final Offset center;
  final RevealShape shape;
  final CustomRevealPathBuilder? customPathBuilder;

  CircularRevealClipper({
    required this.fraction,
    required this.center,
    this.shape = RevealShape.circle,
    this.customPathBuilder,
  });

  @override
  Path getClip(Size size) {
    if (fraction <= 0.0) return Path();
    if (fraction >= 1.0) {
      return Path()..addRect(Offset.zero & size);
    }

    final maxRadius = _calcMaxRadius(center, size);
    final clampedFraction = fraction.clamp(0.0, 1.0);

    switch (shape) {
      case RevealShape.circle:
        return _buildCirclePath(maxRadius * clampedFraction);
      case RevealShape.roundedRectangle:
        return _buildRoundedRectPath(maxRadius, clampedFraction);
      case RevealShape.triangle:
        return _buildTrianglePath(maxRadius, clampedFraction);
      case RevealShape.star:
        return _buildStarPath(maxRadius, clampedFraction);
      case RevealShape.custom:
        if (customPathBuilder != null) {
          return customPathBuilder!(size, center, clampedFraction, maxRadius);
        }
        return _buildCirclePath(maxRadius * clampedFraction);
    }
  }

  Path _buildCirclePath(double radius) {
    return Path()..addOval(Rect.fromCircle(center: center, radius: radius));
  }

  Path _buildRoundedRectPath(double maxRadius, double fraction) {
    // 18.0x18.0 base SVG dimensions
    const double svgWidth = 18.0;
    const double svgHeight = 18.0;
    const double baseCenterX = 9.0;
    const double baseCenterY = 9.0;

    // Scale to ensure screen coverage at fraction 1.0
    final double targetDimension = maxRadius * 2.1 * fraction;
    final double scaleX = targetDimension / svgWidth;
    final double scaleY = targetDimension / svgHeight;

    final double translateX = center.dx - (baseCenterX * scaleX);
    final double translateY = center.dy - (baseCenterY * scaleY);

    final Path path = Path();
    path.moveTo(translateX + (0 * scaleX), translateY + (17 * scaleY));
    path.lineTo(translateX + (0 * scaleX), translateY + (1 * scaleY));

    path.arcToPoint(
      Offset(translateX + (1 * scaleX), translateY + 0),
      radius: Radius.elliptical(1 * scaleX, 1 * scaleY),
      clockwise: true,
    );

    path.lineTo(translateX + (17 * scaleX), translateY + 0);

    path.arcToPoint(
      Offset(translateX + (18 * scaleX), translateY + (1 * scaleY)),
      radius: Radius.elliptical(1 * scaleX, 1 * scaleY),
      clockwise: true,
    );

    path.lineTo(translateX + (18 * scaleX), translateY + (17 * scaleY));

    path.arcToPoint(
      Offset(translateX + (17 * scaleX), translateY + (18 * scaleY)),
      radius: Radius.elliptical(1 * scaleX, 1 * scaleY),
      clockwise: true,
    );

    path.lineTo(translateX + (1 * scaleX), translateY + (18 * scaleY));

    path.arcToPoint(
      Offset(translateX + 0, translateY + (17 * scaleY)),
      radius: Radius.elliptical(1 * scaleX, 1 * scaleY),
      clockwise: true,
    );

    path.close();
    return path;
  }

  Path _buildTrianglePath(double maxRadius, double fraction) {
    // 456.4 x 410.7 base SVG dimensions
    const double svgWidth = 456.4;
    const double svgHeight = 410.7;
    const double baseCenterX = 228.2;
    const double baseCenterY = 240.0;

    final double targetDimension = maxRadius * 3.8 * fraction;
    final double scaleX = targetDimension / svgWidth;
    final double scaleY = targetDimension / svgHeight;

    final double translateX = center.dx - (baseCenterX * scaleX);
    final double translateY = center.dy - (baseCenterY * scaleY);

    final Path path = Path();
    path.moveTo(translateX + (246.31 * scaleX), translateY + (11.69 * scaleY));

    path.arcToPoint(
      Offset(translateX + (262.19 * scaleX), translateY + (27.57 * scaleY)),
      radius: Radius.elliptical(42.67 * scaleX, 42.67 * scaleY),
      clockwise: true,
    );

    path.lineTo(
      translateX + (444.67 * scaleX),
      translateY + (346.90 * scaleY),
    );

    path.cubicTo(
      translateX + (456.36 * scaleX),
      translateY + (367.36 * scaleY),
      translateX + (449.25 * scaleX),
      translateY + (393.43 * scaleY),
      translateX + (428.79 * scaleX),
      translateY + (405.12 * scaleY),
    );

    path.arcToPoint(
      Offset(translateX + (407.62 * scaleX), translateY + (410.74 * scaleY)),
      radius: Radius.elliptical(42.67 * scaleX, 42.67 * scaleY),
      clockwise: true,
    );

    path.lineTo(
      translateX + (42.67 * scaleX),
      translateY + (410.74 * scaleY),
    );

    path.cubicTo(
      translateX + (19.10 * scaleX),
      translateY + (410.74 * scaleY),
      translateX + 0,
      translateY + (391.64 * scaleY),
      translateX + 0,
      translateY + (368.07 * scaleY),
    );

    path.arcToPoint(
      Offset(translateX + (5.62 * scaleX), translateY + (346.90 * scaleY)),
      radius: Radius.elliptical(42.67 * scaleX, 42.67 * scaleY),
      clockwise: true,
    );

    path.lineTo(
      translateX + (188.10 * scaleX),
      translateY + (27.57 * scaleY),
    );

    path.cubicTo(
      translateX + (199.79 * scaleX),
      translateY + (7.11 * scaleY),
      translateX + (225.85 * scaleX),
      translateY + 0,
      translateX + (246.31 * scaleX),
      translateY + (11.69 * scaleY),
    );

    path.close();
    return path;
  }

  Path _buildStarPath(double maxRadius, double fraction) {
    // True geometric bounds of this star path:
    // X from 4.80 to 16.00 (width 11.20)
    // Y from 0.00 to 11.70 (height 11.70)
    // Geometric Center: (10.40, 5.85)
    const double baseCenterX = 10.40;
    const double baseCenterY = 5.85;
    const double baseDimension = 11.70;

    // Scale outward around the exact center of tap
    final double targetDimension = maxRadius * 3.0 * fraction;
    final double scale = targetDimension / baseDimension;

    final double translateX = center.dx - (baseCenterX * scale);
    final double translateY = center.dy - (baseCenterY * scale);

    final Path path = Path();
    path.moveTo(translateX + (7.39 * scale), translateY + (3.41 * scale));
    path.cubicTo(
      translateX + (8.66 * scale),
      translateY + (1.14 * scale),
      translateX + (9.29 * scale),
      translateY + 0,
      translateX + (10.24 * scale),
      translateY + 0,
    );
    path.lineTo(translateX + (10.56 * scale), translateY + (0.59 * scale));
    path.cubicTo(
      translateX + (10.92 * scale),
      translateY + (1.23 * scale),
      translateX + (11.10 * scale),
      translateY + (1.56 * scale),
      translateX + (11.38 * scale),
      translateY + (1.77 * scale),
    );
    path.lineTo(translateX + (12.02 * scale), translateY + (1.91 * scale));
    path.cubicTo(
      translateX + (14.48 * scale),
      translateY + (2.47 * scale),
      translateX + (15.71 * scale),
      translateY + (2.75 * scale),
      translateX + (16.00 * scale),
      translateY + (3.69 * scale),
    );
    path.lineTo(translateX + (15.57 * scale), translateY + (4.20 * scale));
    path.cubicTo(
      translateX + (15.09 * scale),
      translateY + (4.75 * scale),
      translateX + (14.85 * scale),
      translateY + (5.03 * scale),
      translateX + (14.75 * scale),
      translateY + (5.38 * scale),
    );
    path.lineTo(translateX + (14.81 * scale), translateY + (6.05 * scale));
    path.cubicTo(
      translateX + (15.06 * scale),
      translateY + (8.67 * scale),
      translateX + (15.19 * scale),
      translateY + (9.98 * scale),
      translateX + (14.43 * scale),
      translateY + (10.56 * scale),
    );
    path.lineTo(translateX + (13.83 * scale), translateY + (10.29 * scale));
    path.cubicTo(
      translateX + (13.17 * scale),
      translateY + (9.98 * scale),
      translateX + (12.85 * scale),
      translateY + (9.83 * scale),
      translateX + (12.50 * scale),
      translateY + (9.83 * scale),
    );
    path.lineTo(translateX + (11.90 * scale), translateY + (10.11 * scale));
    path.cubicTo(
      translateX + (9.60 * scale),
      translateY + (11.17 * scale),
      translateX + (8.45 * scale),
      translateY + (11.70 * scale),
      translateX + (7.68 * scale),
      translateY + (11.12 * scale),
    );
    path.lineTo(translateX + (7.75 * scale), translateY + (10.44 * scale));
    path.cubicTo(
      translateX + (7.82 * scale),
      translateY + (9.70 * scale),
      translateX + (7.86 * scale),
      translateY + (9.33 * scale),
      translateX + (7.75 * scale),
      translateY + (8.98 * scale),
    );
    path.lineTo(translateX + (7.32 * scale), translateY + (8.47 * scale));
    path.cubicTo(
      translateX + (5.64 * scale),
      translateY + (6.51 * scale),
      translateX + (4.80 * scale),
      translateY + (5.53 * scale),
      translateX + (5.09 * scale),
      translateY + (4.59 * scale),
    );
    path.lineTo(translateX + (5.73 * scale), translateY + (4.45 * scale));
    path.cubicTo(
      translateX + (6.43 * scale),
      translateY + (4.29 * scale),
      translateX + (6.78 * scale),
      translateY + (4.21 * scale),
      translateX + (7.06 * scale),
      translateY + (4.00 * scale),
    );
    path.close();
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
    return oldClipper.fraction != fraction ||
        oldClipper.center != center ||
        oldClipper.shape != shape ||
        oldClipper.customPathBuilder != customPathBuilder;
  }
}
