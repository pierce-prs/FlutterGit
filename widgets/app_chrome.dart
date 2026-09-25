import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

/// Present on every Senior App screen, per the storyboard's design system:
/// Senior App / Admin Portal toggle, palette picker, font-size A−/A+
/// controls, and a light/dark toggle.
class GlobalChromeBar extends StatelessWidget implements PreferredSizeWidget {
  const GlobalChromeBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    final app = AppStateScope.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(bottom: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.5))),
      ),
      child: Row(
        children: [
          Expanded(
            child: _PortalSwitch(
              isAdmin: app.portal == Portal.admin,
              seniorLabel: app.s.senior,
              adminLabel: app.s.admin,
              onChanged: (isAdmin) => app.setPortal(isAdmin ? Portal.admin : Portal.senior),
            ),
          ),
          IconButton(
            tooltip: 'Palette',
            icon: const Icon(Icons.palette_outlined, size: 20),
            onPressed: () => _showPalettePicker(context),
          ),
          IconButton(
            tooltip: 'A-',
            icon: const Text('A-', style: TextStyle(fontWeight: FontWeight.w700)),
            onPressed: app.decreaseTextScale,
          ),
          IconButton(
            tooltip: 'A+',
            icon: const Text('A+', style: TextStyle(fontWeight: FontWeight.w700)),
            onPressed: app.increaseTextScale,
          ),
          IconButton(
            tooltip: 'Light/Dark',
            icon: Icon(app.brightness == Brightness.dark ? Icons.dark_mode : Icons.light_mode_outlined, size: 20),
            onPressed: app.toggleBrightness,
          ),
        ],
      ),
    );
  }

  void _showPalettePicker(BuildContext context) {
    final app = AppStateScope.of(context);
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Theme palette', style: Theme.of(sheetContext).textTheme.titleMedium),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children: kAppPalettes.map((p) {
                    final selected = p.id == app.palette.id;
                    return GestureDetector(
                      onTap: () => app.setPalette(p),
                      child: Column(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: p.seed,
                              shape: BoxShape.circle,
                              border: selected
                                  ? Border.all(color: Theme.of(sheetContext).colorScheme.onSurface, width: 3)
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(p.label, style: Theme.of(sheetContext).textTheme.labelSmall),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PortalSwitch extends StatelessWidget {
  final bool isAdmin;
  final String seniorLabel;
  final String adminLabel;
  final ValueChanged<bool> onChanged;

  const _PortalSwitch({
    required this.isAdmin,
    required this.seniorLabel,
    required this.adminLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(color: scheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(3),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        _segment(context, seniorLabel, !isAdmin, () => onChanged(false)),
        _segment(context, adminLabel, isAdmin, () => onChanged(true)),
      ]),
    );
  }

  Widget _segment(BuildContext context, String label, bool active, VoidCallback onTap) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? scheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: active ? scheme.onPrimary : scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

/// A status summary tile used on the Senior Dashboard (e.g. "Next Pension",
/// "Last Check-up").
class StatusTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? valueSubtext;
  final Color? accent;

  const StatusTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.valueSubtext,
    this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tint = accent ?? scheme.primary;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: tint, size: 20),
          const SizedBox(height: 10),
          Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
          if (valueSubtext != null) ...[
            const SizedBox(height: 2),
            Text(valueSubtext!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: tint)),
          ],
        ],
      ),
    );
  }
}

/// One tile of the Senior Dashboard's 2×2 action grid.
class ActionGridTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const ActionGridTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 14),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom nav: Home · Konsulta · SOS · Agape · Pambakal.
class SeniorBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<String> labels;

  const SeniorBottomNav({super.key, required this.currentIndex, required this.onTap, required this.labels});

  @override
  Widget build(BuildContext context) {
    const icons = [Icons.home_rounded, Icons.favorite_rounded, Icons.sos_rounded, Icons.celebration_rounded, Icons.payments_rounded];
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      height: 68,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: List.generate(
        labels.length,
        (i) => NavigationDestination(icon: Icon(icons[i]), label: labels[i]),
      ),
    );
  }
}
