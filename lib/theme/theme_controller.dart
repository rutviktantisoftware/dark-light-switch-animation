import 'package:flutter/material.dart';
import '../circular_theme_reveal/circular_theme_reveal_controller.dart';
import '../circular_theme_reveal/reveal_mode.dart';

/// Theme state and animation coordinator. Can be instantiated locally or accessed via singleton.
class ThemeController extends ChangeNotifier {
  ThemeController({
    Duration duration = const Duration(milliseconds: 700),
    Curve curve = Curves.easeInOutCubic,
    RevealMode revealMode = RevealMode.expandAndCollapse,
  }) : revealController = CircularThemeRevealController(
          duration: duration,
          curve: curve,
          revealMode: revealMode,
        ) {
    revealController.addListener(notifyListeners);
  }

  static final ThemeController instance = ThemeController();

  final CircularThemeRevealController revealController;

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;
  RevealMode get revealMode => revealController.revealMode;
  Duration get duration => revealController.duration;
  double get durationMs => revealController.durationMs;
  Curve get selectedCurve => revealController.curve;

  /// Toggles theme mode (or sets it explicitly if [isDark] is provided)
  void toggleTheme({bool? isDark}) {
    _isDarkMode = isDark ?? !_isDarkMode;
    notifyListeners();
  }

  /// 🎯 1-line API to toggle theme with circular reveal animation!
  ///
  /// Specify [fromKey], [fromContext], or [center] to set the animation origin.
  Future<void> changeTheme({
    bool? isDark,
    GlobalKey? fromKey,
    BuildContext? fromContext,
    Offset? center,
    RevealMode? revealMode,
    Duration? duration,
    Curve? curve,
    double? maxPixelRatio,
  }) {
    return revealController.toggle(
      onToggle: () => toggleTheme(isDark: isDark),
      fromKey: fromKey,
      fromContext: fromContext,
      center: center,
      revealMode: revealMode,
      duration: duration,
      curve: curve,
      maxPixelRatio: maxPixelRatio,
    );
  }

  /// Sets the global animation duration
  void setDuration(Duration duration) {
    revealController.setDuration(duration);
  }

  /// Sets the global animation duration in milliseconds
  void setDurationMs(double ms) {
    revealController.setDurationMs(ms);
  }

  /// Sets the global animation curve
  void setCurve(Curve curve) {
    revealController.setCurve(curve);
  }

  /// Sets the global circular reveal mode
  void setRevealMode(RevealMode mode) {
    revealController.setRevealMode(mode);
  }
}
