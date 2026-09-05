import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dark_light_switch_animation/main.dart';
import 'package:dark_light_switch_animation/theme/theme_controller.dart';

void main() {
  testWidgets(
      'CustomCircularAnimatedThemeApp loads and runs smoothly',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const CustomCircularAnimatedThemeApp());

    // Verify HomeScreen loaded
    expect(find.text('☀️ Light Mode Active'), findsOneWidget);

    // Tap the FloatingActionButton to trigger circular reveal
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.pumpAndSettle();

    // Verify Dark Mode active
    expect(find.text('🌙 Dark Mode Active'), findsOneWidget);

    // Test controller-driven changeTheme back to light mode
    await tester.runAsync(() async {
      await ThemeController.instance.changeTheme();
    });
    await tester.pumpAndSettle();
    expect(find.text('☀️ Light Mode Active'), findsOneWidget);
  });

  test('ThemeController.changeTheme works headlessly when detached', () async {
    final controller = ThemeController();
    expect(controller.isDarkMode, isFalse);

    await controller.changeTheme();
    expect(controller.isDarkMode, isTrue);

    await controller.changeTheme(isDark: false);
    expect(controller.isDarkMode, isFalse);
  });

  testWidgets('Navigates to ThemeSettingsScreen and toggles theme',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const CustomCircularAnimatedThemeApp());

    // Tap the Settings button in AppBar
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    // Verify ThemeSettingsScreen opened
    expect(find.text('Theme & Animation Settings'), findsOneWidget);
    expect(find.text('Reveal Direction Mode'), findsOneWidget);

    // Pop back to HomeScreen
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('☀️ Light Mode Active'), findsOneWidget);
  });
}
