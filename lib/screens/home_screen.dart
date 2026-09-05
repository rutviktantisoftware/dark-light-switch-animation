import 'package:flutter/material.dart';
import '../circular_theme_reveal/reveal_mode.dart';
import '../circular_theme_reveal/reveal_shape.dart';
import '../theme/theme_controller.dart';
import 'theme_settings_screen.dart';

/// Main Dashboard showcase with adaptive UI components, quick controls, and Floating Action Button
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey _fabKey = GlobalKey();
  final ThemeController _themeCtrl = ThemeController.instance;

  @override
  void initState() {
    super.initState();
    debugPrint('HomeScreen initState called - (verified: called only once!)');
  }

  void _navigateToSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ThemeSettingsScreen()),
    );
  }

  /// 🎯 Triggers circular reveal directly from the FAB's exact center coordinates!
  void _triggerCircularReveal() {
    _themeCtrl.changeTheme(fromKey: _fabKey);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _themeCtrl,
      builder: (context, _) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final isDarkMode = _themeCtrl.isDarkMode;

        final nextActionDesc = isDarkMode
            ? (_themeCtrl.revealMode == RevealMode.alwaysExpandOut
                ? 'Expands OUT to Light'
                : 'Collapses IN to Light')
            : (_themeCtrl.revealMode == RevealMode.alwaysCollapseIn
                ? 'Collapses IN to Dark'
                : 'Expands OUT to Dark');

        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isDarkMode
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  color: colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  isDarkMode ? 'Dark Theme' : 'Light Theme',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: FilledButton.tonalIcon(
                  onPressed: _navigateToSettings,
                  icon: const Icon(Icons.tune_rounded, size: 18),
                  label: const Text('Settings'),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Status Hero Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorScheme.primary.withValues(alpha: 0.12),
                          ),
                          child: Icon(
                            isDarkMode
                                ? Icons.nightlight_round
                                : Icons.wb_sunny_rounded,
                            size: 52,
                            color: isDarkMode
                                ? const Color(0xFFFFD166)
                                : const Color(0xFFF59E0B),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          isDarkMode
                              ? '🌙 Dark Mode Active'
                              : '☀️ Light Mode Active',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isDarkMode
                                    ? Icons.compress_rounded
                                    : Icons.expand_rounded,
                                size: 16,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  'Next FAB tap: $nextActionDesc',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.primary,
                                  ),
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

                // Navigation Card to Theme Settings & Playground
                Card(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.45),
                  child: InkWell(
                    onTap: _navigateToSettings,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.science_rounded,
                              color: colorScheme.onPrimary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Theme Settings & Playground',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Tune curves, durations & test triggers from any widget',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: colorScheme.primary,
                            size: 28,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Adaptive UI Showcase Grid
                Text(
                  'Adaptive UI Elements',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        title: 'Speed',
                        value: '${_themeCtrl.durationMs.toInt()} ms',
                        icon: Icons.speed_rounded,
                        colorScheme: colorScheme,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildMetricCard(
                        title: 'Shape',
                        value: _shapeLabel(_themeCtrl.shape),
                        icon: _shapeIcon(_themeCtrl.shape),
                        colorScheme: colorScheme,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildMetricCard(
                        title: 'Curve',
                        value: _curveLabel(_themeCtrl.selectedCurve),
                        icon: Icons.timeline_rounded,
                        colorScheme: colorScheme,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Direction Mode Quick Selector
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
                              'Circular Direction Mode',
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
                          subtitle: 'Both switches expand outward from FAB',
                          mode: RevealMode.alwaysExpandOut,
                          colorScheme: colorScheme,
                        ),
                        const Divider(height: 20),
                        _buildModeOption(
                          title: 'Always Collapse IN',
                          subtitle: 'Both switches shrink inward to FAB',
                          mode: RevealMode.alwaysCollapseIn,
                          colorScheme: colorScheme,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 80), // Bottom padding for FAB
              ],
            ),
          ),

          // Pure Circular Floating Action Button
          floatingActionButton: FloatingActionButton(
            key: _fabKey,
            onPressed: _triggerCircularReveal,
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            elevation: 6,
            shape: const CircleBorder(),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, anim) => RotationTransition(
                turns: anim,
                child: ScaleTransition(scale: anim, child: child),
              ),
              child: Icon(
                isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                key: ValueKey<bool>(isDarkMode),
                size: 28,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required ColorScheme colorScheme,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: colorScheme.primary),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  String _curveLabel(Curve curve) {
    if (curve == Curves.easeInOutCubic) return 'easeInOut';
    if (curve == Curves.easeOutQuart) return 'easeOut';
    if (curve == Curves.fastOutSlowIn) return 'fastOutSlow';
    if (curve == Curves.linear) return 'linear';
    return 'custom';
  }

  String _shapeLabel(RevealShape shape) {
    switch (shape) {
      case RevealShape.circle:
        return 'Circle';
      case RevealShape.star:
        return 'Star';
      case RevealShape.roundedRectangle:
        return 'R-Rect';
      case RevealShape.triangle:
        return 'Triangle';
      case RevealShape.custom:
        return 'Custom';
    }
  }

  IconData _shapeIcon(RevealShape shape) {
    switch (shape) {
      case RevealShape.circle:
        return Icons.circle_outlined;
      case RevealShape.star:
        return Icons.star_border_rounded;
      case RevealShape.roundedRectangle:
        return Icons.crop_square_rounded;
      case RevealShape.triangle:
        return Icons.change_history_rounded;
      case RevealShape.custom:
        return Icons.favorite_border_rounded;
    }
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
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w600,
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
