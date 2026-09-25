import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../data/demo_data.dart';
import '../state/app_state.dart';

class PambakalBody extends StatelessWidget {
  const PambakalBody({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppStateScope.of(context);
    final s = app.s;
    final scheme = Theme.of(context).colorScheme;
    final profile = DemoData.seniorProfile;

    return AnimatedBuilder(
      animation: app,
      builder: (context, _) {
        final voucher = app.voucher;
        final claimed = voucher.claimed;
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pambakal', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(s.pambakalSubtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [scheme.primary, scheme.primaryContainer],
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  children: [
                    Text(
                      '${voucher.quarterLabel} — ₱${voucher.cashAmount} Cash Aid',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: scheme.onPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '+ ${voucher.inKindItems}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onPrimary.withValues(alpha: 0.9)),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                      child: Opacity(
                        opacity: claimed ? 0.35 : 1,
                        child: QrImageView(
                          data: '${profile.scId}|${profile.fullName}|${voucher.quarterLabel}',
                          size: 168,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${profile.fullName} · ${profile.scId}\n${profile.purok}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onPrimary.withValues(alpha: 0.9)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: claimed ? scheme.surfaceContainerHigh : scheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(claimed ? Icons.check_circle_rounded : Icons.schedule_rounded,
                        color: claimed ? scheme.onSurfaceVariant : scheme.onTertiaryContainer),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        claimed
                            ? s.voucherClaimed
                            : '${s.voucherReady} — ${voucher.claimDate}, ${voucher.claimLocation}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: claimed ? scheme.onSurfaceVariant : scheme.onTertiaryContainer,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.local_shipping_outlined, color: scheme.onSurfaceVariant),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        s.accessibilityNote,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
