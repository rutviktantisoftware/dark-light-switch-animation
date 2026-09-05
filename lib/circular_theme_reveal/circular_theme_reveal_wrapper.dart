import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'circular_reveal_clipper.dart';
import 'circular_theme_reveal_controller.dart';
import 'reveal_mode.dart';

/// Rock-solid, hardware-accelerated Circular Theme Reveal widget.
/// Wraps MaterialApp.builder or any screen and delegates all animation properties
/// (duration, curve, revealMode) cleanly to [CircularThemeRevealController].
class CircularThemeReveal extends StatefulWidget {
  final Widget child;
  final CircularThemeRevealController? controller;

  const CircularThemeReveal({
    super.key,
    required this.child,
    this.controller,
  });

  /// Access CircularThemeRevealState from descendants
  static CircularThemeRevealState of(BuildContext context) {
    final state = context.findAncestorStateOfType<CircularThemeRevealState>();
    assert(
      state != null,
      'No CircularThemeReveal found in context. Wrap your MaterialApp.builder with CircularThemeReveal.',
    );
    return state!;
  }

  static CircularThemeRevealState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<CircularThemeRevealState>();
  }

  @override
  State<CircularThemeReveal> createState() => CircularThemeRevealState();
}

class CircularThemeRevealState extends State<CircularThemeReveal>
    with SingleTickerProviderStateMixin
    implements CircularThemeRevealDelegate {
  final GlobalKey _boundaryKey = GlobalKey();

  late CircularThemeRevealController _internalController;
  late AnimationController _animController;
  CurvedAnimation? _curvedAnimation;
  late Animation<double> _animation;

  ui.Image? _snapshotImage;
  bool _isTransitioning = false;
  bool _isExpanding = true;
  Offset _center = Offset.zero;

  CircularThemeRevealController get activeController =>
      widget.controller ?? _internalController;

  bool get isTransitioning => _isTransitioning;

  /// Direct access to the active [CircularThemeRevealController]
  CircularThemeRevealController get revealController => activeController;

  /// Direct access to the underlying Flutter [AnimationController]
  AnimationController get animController => _animController;

  /// Direct access to the active [Animation]
  Animation<double> get animation => _animation;

  @override
  void initState() {
    super.initState();
    _internalController = widget.controller ?? CircularThemeRevealController();

    _animController = AnimationController(
      vsync: this,
      duration: activeController.duration,
    );

    _updateCurve();

    activeController.addListener(_onControllerUpdated);
    activeController.attach(this);

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isTransitioning = false;
          _snapshotImage?.dispose();
          _snapshotImage = null;
          _animController.reset();
        });
      }
    });
  }

  void _onControllerUpdated() {
    if (mounted) {
      if (_animController.duration != activeController.duration) {
        _animController.duration = activeController.duration;
      }
      _updateCurve();
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(CircularThemeReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      (oldWidget.controller ?? _internalController).detach();
      (oldWidget.controller ?? _internalController)
          .removeListener(_onControllerUpdated);
      activeController.addListener(_onControllerUpdated);
      activeController.attach(this);
    }
    if (_animController.duration != activeController.duration) {
      _animController.duration = activeController.duration;
    }
    _updateCurve();
  }

  void _updateCurve({Curve? customCurve}) {
    final targetCurve = customCurve ?? activeController.curve;
    if (_curvedAnimation == null) {
      _curvedAnimation = CurvedAnimation(
        parent: _animController,
        curve: targetCurve,
      );
      _animation = _curvedAnimation!;
    } else {
      _curvedAnimation!.curve = targetCurve;
    }
  }

  @override
  void dispose() {
    activeController.detach();
    activeController.removeListener(_onControllerUpdated);
    if (widget.controller == null) {
      _internalController.dispose();
    }
    _animController.dispose();
    _curvedAnimation?.dispose();
    _snapshotImage?.dispose();
    super.dispose();
  }

  /// 🚀 **1-Line Trigger Method**:
  /// Calculates origin from [fromKey], [fromContext], or [center],
  /// captures the snapshot BEFORE state changes, then executes [onToggle] and runs circular reveal!
  @override
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
    // Immediate lock prevents rapid double-tap race conditions
    if (_isTransitioning) return;
    _isTransitioning = true;

    // 1. Calculate the exact origin center from key, context, or explicit center
    Offset? origin = center;

    if (origin == null) {
      final BuildContext? targetContext = fromKey?.currentContext ?? fromContext;
      if (targetContext != null) {
        final renderBox = targetContext.findRenderObject() as RenderBox?;
        if (renderBox != null && renderBox.hasSize) {
          final pos = renderBox.localToGlobal(Offset.zero);
          final size = renderBox.size;
          origin = Offset(
            pos.dx + size.width / 2,
            pos.dy + size.height / 2,
          );
        }
      }
    }

    if (origin == null) {
      final boundary = _boundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary != null && boundary.hasSize) {
        origin = Offset(boundary.size.width / 2, boundary.size.height / 2);
      } else {
        final size = MediaQuery.sizeOf(context);
        origin = Offset(size.width / 2, size.height / 2);
      }
    }

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final mode = revealMode ?? activeController.revealMode;
    switch (mode) {
      case RevealMode.expandAndCollapse:
        _isExpanding = !isDark;
        break;
      case RevealMode.alwaysExpandOut:
        _isExpanding = true;
        break;
      case RevealMode.alwaysCollapseIn:
        _isExpanding = false;
        break;
    }

    _center = origin;

    // 2. Capture screenshot of the CURRENT theme BEFORE switching
    try {
      final boundary = _boundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary != null && boundary.hasSize) {
        final devicePixelRatio =
            MediaQuery.maybeDevicePixelRatioOf(context) ?? 1.0;
        final double targetPixelRatio = maxPixelRatio != null
            ? devicePixelRatio.clamp(1.0, maxPixelRatio)
            : devicePixelRatio.clamp(1.0, 2.0);
        _snapshotImage = await boundary.toImage(pixelRatio: targetPixelRatio);
      }
    } catch (e) {
      debugPrint('Snapshot capture error: $e');
      _snapshotImage = null;
    }

    // Free native GPU memory immediately if widget unmounted during async capture
    if (!mounted) {
      _snapshotImage?.dispose();
      _snapshotImage = null;
      _isTransitioning = false;
      return;
    }

    // 3. Immediately switch theme
    onToggle();

    if (_snapshotImage == null) {
      _isTransitioning = false;
      return;
    }

    // 4. Run circular reveal animation
    if (duration != null) {
      _animController.duration = duration;
    } else {
      _animController.duration = activeController.duration;
    }

    _updateCurve(customCurve: curve);

    setState(() {});

    _animController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isTransitioning || _snapshotImage == null) {
      return RepaintBoundary(
        key: _boundaryKey,
        child: widget.child,
      );
    }

    final snapshotWidget = RawImage(
      image: _snapshotImage,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );

    return AbsorbPointer(
      absorbing: _isTransitioning,
      child: _isExpanding
          ? Stack(
              fit: StackFit.expand,
              children: [
                snapshotWidget,
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return ClipPath(
                      clipper: CircularRevealClipper(
                        fraction: _animation.value,
                        center: _center,
                      ),
                      child: child,
                    );
                  },
                  child: RepaintBoundary(
                    key: _boundaryKey,
                    child: widget.child,
                  ),
                ),
              ],
            )
          : Stack(
              fit: StackFit.expand,
              children: [
                RepaintBoundary(
                  key: _boundaryKey,
                  child: widget.child,
                ),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return ClipPath(
                      clipper: CircularRevealClipper(
                        fraction: (1.0 - _animation.value).clamp(0.0, 1.0),
                        center: _center,
                      ),
                      child: snapshotWidget,
                    );
                  },
                ),
              ],
            ),
    );
  }
}
