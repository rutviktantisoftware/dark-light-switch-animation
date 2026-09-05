import 'package:flutter/material.dart';
import '../circular_theme_reveal/reveal_mode.dart';
import '../circular_theme_reveal/reveal_shape.dart';
import '../theme/theme_controller.dart';

/// Screen for customizing circular reveal settings and testing trigger coordinates
class ThemeSettingsScreen extends StatefulWidget {
  const ThemeSettingsScreen({super.key});

  @override
  State<ThemeSettingsScreen> createState() => _ThemeSettingsScreenState();
}

class _ThemeSettingsScreenState extends State<ThemeSettingsScreen> {
  final ThemeController _themeCtrl = ThemeController.instance;
  final GlobalKey _appBarActionKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    debugPrint('ThemeSettingsScreen initState called');
  }

  void _triggerFromKey(GlobalKey key) {
    _themeCtrl.changeTheme(fromKey: key);
  }

  void _triggerFromContext(BuildContext context) {
    _themeCtrl.changeTheme(fromContext: context);
  }

  void _triggerFromCenter(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    _themeCtrl.changeTheme(center: Offset(size.width / 2, size.height / 2));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _themeCtrl,
      builder: (context, _) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final isDark = _themeCtrl.isDarkMode;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Theme & Animation Settings',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: IconButton.filledTonal(
                  key: _appBarActionKey,
                  tooltip: isDark ? 'Switch to Light' : 'Switch to Dark',
                  onPressed: () => _triggerFromKey(_appBarActionKey),
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                      key: ValueKey<bool>(isDark),
                      color: isDark
                          ? const Color(0xFFFFD166)
                          : colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Mode Status Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isDark
                                ? Icons.nightlight_round
                                : Icons.wb_sunny_rounded,
                            size: 32,
                            color: isDark
                                ? const Color(0xFFFFD166)
                                : const Color(0xFFF59E0B),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isDark
                                    ? '🌙 Dark Theme Active'
                                    : '☀️ Light Theme Active',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${_themeCtrl.durationMs.toInt()} ms  •  ${_curveName(_themeCtrl.selectedCurve)}  •  ${_shapeName(_themeCtrl.shape)}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Reveal Shape Selector Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.category_rounded,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Reveal Shape',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Choose the geometric shape used for the ripple transition:',
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _shapeOptionChip(
                              label: 'Circle',
                              icon: Icons.circle_outlined,
                              shape: RevealShape.circle,
                              colorScheme: colorScheme,
                            ),
                            _shapeOptionChip(
                              label: 'Star',
                              icon: Icons.star_border_rounded,
                              shape: RevealShape.star,
                              colorScheme: colorScheme,
                            ),
                            _shapeOptionChip(
                              label: 'Rounded Rect',
                              icon: Icons.crop_square_rounded,
                              shape: RevealShape.roundedRectangle,
                              colorScheme: colorScheme,
                            ),
                            _shapeOptionChip(
                              label: 'Triangle',
                              icon: Icons.change_history_rounded,
                              shape: RevealShape.triangle,
                              colorScheme: colorScheme,
                            ),
                            ChoiceChip(
                              avatar: Icon(
                                Icons.favorite_rounded,
                                size: 18,
                                color: _themeCtrl.shape == RevealShape.custom
                                    ? colorScheme.onPrimary
                                    : colorScheme.primary,
                              ),
                              label: const Text('Custom (Heart)'),
                              selected:
                                  _themeCtrl.shape == RevealShape.custom,
                              onSelected: (selected) {
                                if (selected) {
                                  _themeCtrl.setCustomShape(_buildHeartPath);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Direction Mode Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.swap_calls_rounded,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Reveal Direction Mode',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _buildModeOption(
                          title: 'Expand OUT & Collapse IN',
                          subtitle:
                              'Light ➔ Dark expands OUT, Dark ➔ Light collapses IN',
                          mode: RevealMode.expandAndCollapse,
                          colorScheme: colorScheme,
                        ),
                        const Divider(height: 20),
                        _buildModeOption(
                          title: 'Always Expand OUT',
                          subtitle:
                              'Both theme switches expand outward from origin',
                          mode: RevealMode.alwaysExpandOut,
                          colorScheme: colorScheme,
                        ),
                        const Divider(height: 20),
                        _buildModeOption(
                          title: 'Always Collapse IN',
                          subtitle:
                              'Both theme switches shrink inward to origin',
                          mode: RevealMode.alwaysCollapseIn,
                          colorScheme: colorScheme,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Animation Speed & Curve Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.tune_rounded, color: colorScheme.primary),
                            const SizedBox(width: 8),
                            Text(
                              'Speed & Easing Curve',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Duration:',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '${_themeCtrl.durationMs.toInt()} ms',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: _themeCtrl.durationMs.clamp(200.0, 5000.0),
                          min: 200,
                          max: 5000,
                          divisions: 24,
                          label: '${_themeCtrl.durationMs.toInt()} ms',
                          onChanged: (ms) => _themeCtrl.setDurationMs(ms),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _speedPresetChip('Fast (350ms)', 350),
                            _speedPresetChip('Balanced (700ms)', 700),
                            _speedPresetChip('Dramatic (1200ms)', 1200),
                            _speedPresetChip('Slow-Mo (2500ms)', 2500),
                          ],
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Curve Easing:',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _curveChip('easeInOutCubic', Curves.easeInOutCubic),
                            _curveChip('easeOutQuart', Curves.easeOutQuart),
                            _curveChip('fastOutSlowIn', Curves.fastOutSlowIn),
                            _curveChip('linear', Curves.linear),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Interactive Trigger Playground
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.touch_app_rounded,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Trigger Playground',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Test circular reveal animations initiated from different UI coordinates:',
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(height: 16),

                        // Switch Tile
                        Builder(
                          builder: (tileContext) {
                            return SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('In-Line Switch Trigger'),
                              subtitle: const Text('Reveals outward from switch toggle'),
                              value: isDark,
                              onChanged: (_) => _triggerFromContext(tileContext),
                            );
                          },
                        ),

                        const Divider(height: 24),

                        // Primary Button Trigger
                        Builder(
                          builder: (btnContext) {
                            return FilledButton.icon(
                              style: FilledButton.styleFrom(
                                minimumSize: const Size.fromHeight(48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () => _triggerFromContext(btnContext),
                              icon: Icon(
                                isDark
                                    ? Icons.light_mode_rounded
                                    : Icons.dark_mode_rounded,
                              ),
                              label: Text(
                                isDark
                                    ? 'Switch to Light from this Button'
                                    : 'Switch to Dark from this Button',
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 12),

                        // Center of Screen Trigger
                        Builder(
                          builder: (btnContext) {
                            return OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size.fromHeight(46),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () => _triggerFromCenter(btnContext),
                              icon: const Icon(Icons.filter_center_focus_rounded),
                              label: const Text('Reveal from Screen Center'),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _speedPresetChip(String label, double ms) {
    final isSelected = (_themeCtrl.durationMs - ms).abs() < 25;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => _themeCtrl.setDurationMs(ms),
    );
  }

  Widget _curveChip(String name, Curve curve) {
    final isSelected = _themeCtrl.selectedCurve == curve;
    return ChoiceChip(
      label: Text(name),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) _themeCtrl.setCurve(curve);
      },
    );
  }

  Widget _shapeOptionChip({
    required String label,
    required IconData icon,
    required RevealShape shape,
    required ColorScheme colorScheme,
  }) {
    final isSelected = _themeCtrl.shape == shape;
    return ChoiceChip(
      avatar: Icon(
        icon,
        size: 18,
        color: isSelected ? colorScheme.onPrimary : colorScheme.primary,
      ),
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) _themeCtrl.setShape(shape);
      },
    );
  }

  String _shapeName(RevealShape shape) {
    switch (shape) {
      case RevealShape.circle:
        return 'Circle';
      case RevealShape.star:
        return 'Star';
      case RevealShape.roundedRectangle:
        return 'Rounded Rect';
      case RevealShape.triangle:
        return 'Triangle';
      case RevealShape.custom:
        return 'Custom (Heart)';
    }
  }

  /// Example user-defined custom path builder creating a scalable heart shape
  static Path _buildHeartPath(
      Size size, Offset center, double fraction, double maxRadius) {
    final double targetDimension = maxRadius * 2.6 * fraction;
    const double baseWidth = 100.0;
    const double baseHeight = 100.0;
    const double baseCenterX = 50.0;
    const double baseCenterY = 45.0;

    final double scaleX = targetDimension / baseWidth;
    final double scaleY = targetDimension / baseHeight;

    final double translateX = center.dx - (baseCenterX * scaleX);
    final double translateY = center.dy - (baseCenterY * scaleY);

    final Path path = Path();
    path.moveTo(translateX + (50 * scaleX), translateY + (30 * scaleY));
    path.cubicTo(
      translateX + (47 * scaleX),
      translateY + (12 * scaleY),
      translateX + (20 * scaleX),
      translateY + (10 * scaleY),
      translateX + (10 * scaleX),
      translateY + (35 * scaleY),
    );
    path.cubicTo(
      translateX + (0 * scaleX),
      translateY + (60 * scaleY),
      translateX + (30 * scaleX),
      translateY + (80 * scaleY),
      translateX + (50 * scaleX),
      translateY + (98 * scaleY),
    );
    path.cubicTo(
      translateX + (70 * scaleX),
      translateY + (80 * scaleY),
      translateX + (100 * scaleX),
      translateY + (60 * scaleY),
      translateX + (90 * scaleX),
      translateY + (35 * scaleY),
    );
    path.cubicTo(
      translateX + (80 * scaleX),
      translateY + (10 * scaleY),
      translateX + (53 * scaleX),
      translateY + (12 * scaleY),
      translateX + (50 * scaleX),
      translateY + (30 * scaleY),
    );
    path.close();
    return path;
  }

  String _curveName(Curve curve) {
    if (curve == Curves.easeInOutCubic) return 'easeInOutCubic';
    if (curve == Curves.easeOutQuart) return 'easeOutQuart';
    if (curve == Curves.fastOutSlowIn) return 'fastOutSlowIn';
    if (curve == Curves.linear) return 'linear';
    return 'Custom Curve';
  }

  Widget _buildModeOption({
    required String title,
    required String subtitle,
    required RevealMode mode,
    required ColorScheme colorScheme,
  }) {
    final isSelected = _themeCtrl.revealMode == mode;
    return InkWell(
      onTap: () => _themeCtrl.setRevealMode(mode),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? colorScheme.primary : Colors.grey,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.primary,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected ? colorScheme.primary : null,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
