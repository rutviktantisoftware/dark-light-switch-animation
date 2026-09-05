import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dark_light_switch_animation/circular_theme_reveal/reveal_shape.dart';
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

  testWidgets('Renders all RevealShape transitions without errors',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const CustomCircularAnimatedThemeApp());

    for (final shape in RevealShape.values) {
      ThemeController.instance.setShape(shape);
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
      await tester.pumpAndSettle();
    }
  });

  testWidgets('Allows user to set custom shape via builder',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const CustomCircularAnimatedThemeApp());

    bool customBuilderCalled = false;
    ThemeController.instance.setCustomShape((size, center, fraction, maxRadius) {
      customBuilderCalled = true;
      return Path()..addOval(Rect.fromCircle(center: center, radius: maxRadius * fraction));
    });

    expect(ThemeController.instance.shape, RevealShape.custom);
    expect(ThemeController.instance.customPathBuilder, isNotNull);

    // Trigger reveal with custom shape
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(customBuilderCalled, isTrue);
    await tester.pumpAndSettle();

    // Verify ThemeSettingsScreen Custom (Heart) chip
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Custom (Heart)'), findsOneWidget);
    await tester.tap(find.text('Custom (Heart)'));
    await tester.pumpAndSettle();
    expect(ThemeController.instance.shape, RevealShape.custom);
  });
}
