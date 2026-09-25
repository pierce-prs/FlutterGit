import 'package:flutter/material.dart';
import '../data/demo_data.dart';
import '../state/app_state.dart';
import '../widgets/bp_trend_chart.dart';

class KonsultaBody extends StatefulWidget {
  const KonsultaBody({super.key});

  @override
  State<KonsultaBody> createState() => _KonsultaBodyState();
}

class _KonsultaBodyState extends State<KonsultaBody> {
  final health = DemoData.healthRecord;

  @override
  Widget build(BuildContext context) {
    final s = AppStateScope.of(context).s;
    final scheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Konsulta', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(s.konsultaSubtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 20),
          Text(s.maintenanceMeds, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          ...health.medications.map((med) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: scheme.tertiaryContainer, shape: BoxShape.circle),
                        child: const Icon(Icons.medication_rounded, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${med.name} ${med.dose}', style: Theme.of(context).textTheme.titleSmall),
                            Text(med.schedule, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                          ],
                        ),
                      ),
                      FilledButton.tonal(
                        onPressed: med.takenToday ? null : () => setState(() => med.takenToday = true),
                        child: Text(med.takenToday ? '✓' : s.takeAction),
                      ),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 12),
          Text(s.bpTrendTitle, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            s.encodedBy(health.encodedByName, health.encodedByStation),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 4),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
            ),
            child: Column(
              children: [
                BpTrendChart(points: health.bpTrend),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _legendDot(context, const Color(0xFF2F8F5B), 'Normal'),
                    const SizedBox(width: 14),
                    _legendDot(context, const Color(0xFFCE8A1E), 'Elevated'),
                    const SizedBox(width: 14),
                    _legendDot(context, const Color(0xFFC0392B), 'High'),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(s.recentReadings, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _readingChip(context, 'BP', health.latestBp)),
              const SizedBox(width: 12),
              Expanded(child: _readingChip(context, 'Sugar', health.latestSugar)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendDot(BuildContext context, Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _readingChip(BuildContext context, String label, String value) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
