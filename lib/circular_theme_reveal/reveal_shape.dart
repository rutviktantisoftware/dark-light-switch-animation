import 'package:flutter/material.dart';

/// Function signature for building arbitrary custom reveal paths.
///
/// [size] is the total viewport or render boundary size.
/// [center] is the origin coordinate where the user tapped or where the widget is located.
/// [fraction] is the animation progress from 0.0 to 1.0.
/// [maxRadius] is the distance from [center] to the furthest corner of [size].
typedef CustomRevealPathBuilder = Path Function(
  Size size,
  Offset center,
  double fraction,
  double maxRadius,
);

/// Defines the geometric shape used for the theme reveal transition animation.
enum RevealShape {
  /// Standard smooth expanding/collapsing circle.
  circle,

  /// Smooth corner-rounded rectangle.
  roundedRectangle,

  /// Smooth corner-curved triangle.
  triangle,

  /// Multi-point decorative star.
  star,

  /// User-defined custom path via [CustomRevealPathBuilder].
  custom,
}
