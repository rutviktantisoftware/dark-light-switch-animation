# 🌓 Circular Theme Reveal Animation for Flutter

A rock-solid, hardware-accelerated **Circular Theme Reveal** animation for Flutter. Seamlessly switch between Light and Dark themes with an expanding or collapsing circular ripple originating from the exact position of your tap, button, or switch—similar to Telegram and X (Twitter).

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android%20%7C%20Web%20%7C%20macOS%20%7C%20Windows%20%7C%20Linux-blue)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-purple.svg)](LICENSE)

---

https://github.com/user-attachments/assets/27368ed5-a335-40ed-be49-923de5fa27b4

---

## ✨ Features

- 🚀 **1-Line Trigger API**: Trigger the reveal from anywhere via `themeCtrl.changeTheme(fromKey: key)` or `fromContext: context`.
- ⚡ **60/120 FPS Hardware Accelerated**: Captures an instant snapshot of the outgoing theme and clips the incoming theme using an optimized `CustomClipper<Path>`.
- 🎯 **Pinpoint Origin Detection**: Automatically computes exact button center coordinates from any `GlobalKey`, `BuildContext`, or custom `Offset`.
- 🔄 **3 Reveal Direction Modes**:
  - `RevealMode.expandAndCollapse`: Light ➔ Dark expands outward, Dark ➔ Light collapses inward.
  - `RevealMode.alwaysExpandOut`: Both theme changes expand outward from the origin.
  - `RevealMode.alwaysCollapseIn`: Both theme changes collapse inward to the origin.
- 🛡️ **Race-Condition & Leak-Proof**:
  - Instant re-entrancy locking prevents duplicate transitions from rapid double-taps.
  - Safe disposal of native GPU `ui.Image` bitmaps on unmount.
  - Lifecycle management of `CurvedAnimation` to prevent listener accumulation.
  - `AbsorbPointer` protection during transitions to prevent accidental taps mid-animation.
- 🎛️ **Live Playground & Settings Screen**: Included interactive test suite to adjust duration, easing curves, and trigger positions in real time.

---

## 📸 Screenshots & Architecture

```
lib/
├── circular_theme_reveal/
│   ├── circular_reveal_clipper.dart          # High-performance path clipper
│   ├── circular_theme_reveal.dart            # Export barrel file
│   ├── circular_theme_reveal_controller.dart # Standalone controller & delegate
│   ├── circular_theme_reveal_wrapper.dart    # Core transition wrapper widget
│   └── reveal_mode.dart                     # Direction mode enum
├── screens/
│   ├── home_screen.dart                     # Showcase dashboard with FAB trigger
│   └── theme_settings_screen.dart           # Interactive animation playground
├── theme/
│   ├── app_themes.dart                      # Cached Light & Dark ThemeData
│   └── theme_controller.dart                # Global theme & reveal coordinator
└── main.dart                                # App entry point
```

---

## 🚀 Quick Start

### 1. Wrap your `MaterialApp.builder`

Wrap your application inside `CircularThemeReveal` using your controller:

```dart
import 'package:flutter/material.dart';
import 'circular_theme_reveal/circular_theme_reveal.dart';
import 'theme/theme_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = ThemeController.instance;

    return ListenableBuilder(
      listenable: themeCtrl,
      builder: (context, _) {
        return MaterialApp(
          theme: ThemeData.light(useMaterial3: true),
          darkTheme: ThemeData.dark(useMaterial3: true),
          themeMode: themeCtrl.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          builder: (context, child) {
            return CircularThemeReveal(
              controller: themeCtrl.revealController,
              child: child ?? const SizedBox.shrink(),
            );
          },
          home: const HomeScreen(),
        );
      },
    );
  }
}
```

---

### 2. Trigger the Reveal from Any Widget

#### Option A: Trigger from a `GlobalKey` (e.g., Floating Action Button)
```dart
final GlobalKey _fabKey = GlobalKey();

FloatingActionButton(
  key: _fabKey,
  onPressed: () {
    themeCtrl.changeTheme(fromKey: _fabKey);
  },
  child: Icon(Icons.brightness_6),
)
```

#### Option B: Trigger from a `BuildContext` (e.g., any Button or ListTile)
```dart
Builder(
  builder: (btnContext) {
    return FilledButton(
      onPressed: () {
        themeCtrl.changeTheme(fromContext: btnContext);
      },
      child: const Text('Toggle Theme'),
    );
  },
)
```

#### Option C: Trigger from an explicit screen coordinate
```dart
themeCtrl.changeTheme(center: const Offset(200, 400));
```

---

## ⚙️ Customization

### Animation Settings
You can customize the duration, curve, and reveal mode globally or on a per-toggle basis:

```dart
// Globally via controller:
themeCtrl.setDuration(const Duration(milliseconds: 700));
themeCtrl.setCurve(Curves.easeInOutCubic);
themeCtrl.setRevealMode(RevealMode.expandAndCollapse);

// Or per individual toggle:
themeCtrl.changeTheme(
  fromKey: _btnKey,
  duration: const Duration(milliseconds: 1000),
  curve: Curves.easeOutQuart,
  revealMode: RevealMode.alwaysExpandOut,
);
```

### Supported Reveal Modes
| Mode | Behavior |
| :--- | :--- |
| `RevealMode.expandAndCollapse` | Light ➔ Dark expands OUTward, Dark ➔ Light collapses INward |
| `RevealMode.alwaysExpandOut` | Both Light ➔ Dark and Dark ➔ Light expand OUTward |
| `RevealMode.alwaysCollapseIn` | Both Light ➔ Dark and Dark ➔ Light collapse INward |

---

## 🧪 Testing

The package includes full automated unit and widget test coverage:

```bash
# Run static analysis
flutter analyze

# Run unit and widget tests
flutter test
```

---

## 📄 License

This project is licensed under the MIT License - feel free to use it in your personal and commercial projects!
