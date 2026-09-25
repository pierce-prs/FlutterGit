import 'package:flutter/material.dart';
import '../data/demo_data.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../widgets/app_chrome.dart';

/// Screen 7 — not detailed in the original storyboard beyond two required
/// capabilities (a live SOS feed and a voucher-claiming Distribution view),
/// built here as mobile UI to match the rest of the app rather than a web
/// dashboard.
class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final s = AppStateScope.of(context).s;

    return Scaffold(
      appBar: const GlobalChromeBar(),
      body: IndexedStack(
        index: _index,
        children: const [_SosFeedTab(), _DistributionTab()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        height: 64,
        destinations: [
          NavigationDestination(icon: const Icon(Icons.sos_rounded), label: s.adminSosFeed),
          NavigationDestination(icon: const Icon(Icons.qr_code_scanner_rounded), label: s.adminDistribution),
        ],
      ),
    );
  }
}

class _SosFeedTab extends StatelessWidget {
  const _SosFeedTab();

  String _timeAgo(DateTime t) {
    final diff = DateTime.now().difference(t);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final app = AppStateScope.of(context);
    final s = app.s;
    final scheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: app,
      builder: (context, _) {
        final alerts = app.sosAlerts;
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(s.adminSosFeed, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(width: 8),
                  if (alerts.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFFB3261E), borderRadius: BorderRadius.circular(10)),
                      child: Text('${alerts.length}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Barangay Emergency Response Team dispatch queue',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: alerts.isEmpty
                    ? Center(
                        child: Text(s.adminNoAlerts, style: TextStyle(color: scheme.onSurfaceVariant)),
                      )
                    : ListView.separated(
                        itemCount: alerts.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, i) => _AlertCard(
                          alert: alerts[i],
                          isNewest: i == 0,
                          timeLabel: _timeAgo(alerts[i].timestamp),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AlertCard extends StatelessWidget {
  final SosAlert alert;
  final bool isNewest;
  final String timeLabel;
  const _AlertCard({required this.alert, required this.isNewest, required this.timeLabel});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    const red = Color(0xFFB3261E);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isNewest ? red.withValues(alpha: 0.08) : scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isNewest ? red.withValues(alpha: 0.4) : scheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: red, shape: BoxShape.circle),
            child: const Icon(Icons.sos_rounded, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(alert.seniorName, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 2),
                Text(alert.address, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                const SizedBox(height: 2),
                Text('GPS: ${alert.gpsLabel}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
              ],
            ),
          ),
          Text(
            timeLabel,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _DistributionTab extends StatelessWidget {
  const _DistributionTab();

  Future<void> _simulateScan(BuildContext context) async {
    final app = AppStateScope.of(context);
    final profile = DemoData.seniorProfile;
    final voucher = app.voucher;

    if (voucher.claimed) {
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(app.s.adminScanVoucher),
          content: Text(app.s.adminAlreadyClaimed),
          actions: [FilledButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('OK'))],
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(app.s.adminScanVoucher),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 120,
              child: Center(child: Icon(Icons.qr_code_scanner_rounded, size: 72)),
            ),
            const SizedBox(height: 12),
            Text('${profile.fullName} · ${profile.scId}'),
            Text('${voucher.quarterLabel} — ₱${voucher.cashAmount} + ${voucher.inKindItems}'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: Text(app.s.adminMarkClaimed)),
        ],
      ),
    );

    if (confirmed == true) {
      app.markVoucherClaimed();
    }
  }

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
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.adminDistribution, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(
                '${voucher.quarterLabel} · ${voucher.claimLocation}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
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
                    CircleAvatar(radius: 20, backgroundColor: scheme.primaryContainer, child: Text(profile.preferredName.substring(0, 1))),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(profile.fullName, style: Theme.of(context).textTheme.titleSmall),
                          Text(profile.scId, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: voucher.claimed ? scheme.surfaceContainerHigh : scheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        voucher.claimed ? s.voucherClaimed : s.voucherReady,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => _simulateScan(context),
                      icon: const Icon(Icons.qr_code_scanner_rounded),
                      label: Text(s.adminScanVoucher),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
