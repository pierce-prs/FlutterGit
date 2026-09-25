import 'package:flutter/material.dart';
import '../state/app_state.dart';

class AgapeBody extends StatelessWidget {
  const AgapeBody({super.key});

  static const _events = [
    (title: 'Zumba for Seniors', when: 'Every Tue & Thu, 6:00 AM', where: 'Covered Court'),
    (title: 'Bingo Social', when: 'Sep 27, 2:00 PM', where: 'Brgy. Hall Function Room'),
    (title: 'Monthly Wellness Fair', when: 'Oct 3, 8:00 AM', where: 'Covered Court'),
  ];

  @override
  Widget build(BuildContext context) {
    final s = AppStateScope.of(context).s;
    final scheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(s.tileAgape, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(s.tileAgapeSub, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 20),
          ..._events.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: scheme.secondaryContainer, shape: BoxShape.circle),
                        child: const Icon(Icons.celebration_rounded, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.title, style: Theme.of(context).textTheme.titleSmall),
                            const SizedBox(height: 2),
                            Text(e.when, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                            Text(e.where, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
