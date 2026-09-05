import 'package:flutter/material.dart';
import 'circular_theme_reveal/circular_theme_reveal.dart';
import 'screens/home_screen.dart';
import 'theme/app_themes.dart';
import 'theme/theme_controller.dart';

void main() {
  runApp(const CustomCircularAnimatedThemeApp());
}

/// Main Application converted to [StatefulWidget]
class CustomCircularAnimatedThemeApp extends StatefulWidget {
  const CustomCircularAnimatedThemeApp({super.key});

  @override
  State<CustomCircularAnimatedThemeApp> createState() =>
      _CustomCircularAnimatedThemeAppState();
}

class _CustomCircularAnimatedThemeAppState
    extends State<CustomCircularAnimatedThemeApp> {
  // Owned and managed within this StatefulWidget lifecycle:
  late final ThemeController _themeCtrl;

  @override
  void initState() {
    super.initState();
    _themeCtrl = ThemeController.instance;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _themeCtrl,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Circular Animated Theme Demo',
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: _themeCtrl.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          builder: (context, child) {
            return CircularThemeReveal(
              controller: _themeCtrl.revealController,
              child: child ?? const SizedBox.shrink(),
            );
          },
          home: const HomeScreen(),
        );
      },
    );
  }
}
