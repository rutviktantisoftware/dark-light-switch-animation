import 'package:flutter/material.dart';
import 'reveal_mode.dart';

/// Delegate interface for triggering circular theme reveals.
abstract class CircularThemeRevealDelegate {
  Future<void> toggle({
    required VoidCallback onToggle,
    GlobalKey? fromKey,
    BuildContext? fromContext,
    Offset? center,
    RevealMode? revealMode,
    Duration? duration,
    Curve? curve,
    double? maxPixelRatio,
  });
}

/// Dedicated controller for [CircularThemeReveal].
/// Manages animation duration, curve, reveal mode, and triggers reveals directly.
class CircularThemeRevealController extends ChangeNotifier {
  Duration _duration;
  Curve _curve;
  RevealMode _revealMode;
  CircularThemeRevealDelegate? _delegate;

  CircularThemeRevealController({
    Duration duration = const Duration(milliseconds: 700),
    Curve curve = Curves.easeInOutCubic,
    RevealMode revealMode = RevealMode.expandAndCollapse,
  })  : _duration = duration,
        _curve = curve,
        _revealMode = revealMode;

  Duration get duration => _duration;
  double get durationMs => _duration.inMilliseconds.toDouble();
  Curve get curve => _curve;
  RevealMode get revealMode => revealModeValue;
  RevealMode get revealModeValue => _revealMode;

  /// Whether a visual reveal widget is currently attached to this controller
  bool get isAttached => _delegate != null;

  /// Attaches the active [CircularThemeRevealDelegate]
  void attach(CircularThemeRevealDelegate delegate) {
    _delegate = delegate;
  }

  /// Detaches the active [CircularThemeRevealDelegate]
  void detach() {
    _delegate = null;
  }

  /// Triggers the circular reveal animation directly from the controller.
  /// If no widget is attached, safely falls back to executing [onToggle] directly.
  Future<void> toggle({
    required VoidCallback onToggle,
    GlobalKey? fromKey,
    BuildContext? fromContext,
    Offset? center,
    RevealMode? revealMode,
    Duration? duration,
    Curve? curve,
    double? maxPixelRatio,
  }) async {
    if (_delegate != null) {
      await _delegate!.toggle(
        onToggle: onToggle,
        fromKey: fromKey,
        fromContext: fromContext,
        center: center,
        revealMode: revealMode,
        duration: duration,
        curve: curve,
        maxPixelRatio: maxPixelRatio,
      );
    } else {
      onToggle();
    }
  }

  /// Updates animation duration
  void setDuration(Duration newDuration) {
    if (_duration != newDuration) {
      _duration = newDuration;
      notifyListeners();
    }
  }

  /// Updates animation duration in milliseconds
  void setDurationMs(double ms) {
    setDuration(Duration(milliseconds: ms.toInt()));
  }

  /// Updates animation curve
  void setCurve(Curve newCurve) {
    if (_curve != newCurve) {
      _curve = newCurve;
      notifyListeners();
    }
  }

  /// Updates circular reveal direction mode
  void setRevealMode(RevealMode newMode) {
    if (_revealMode != newMode) {
      _revealMode = newMode;
      notifyListeners();
    }
  }
}
