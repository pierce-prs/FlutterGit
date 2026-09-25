import 'package:flutter/material.dart';
import '../data/demo_data.dart';
import '../state/app_state.dart';
import '../widgets/app_chrome.dart';
import 'agape_screen.dart';
import 'konsulta_screen.dart';
import 'pambakal_screen.dart';
import 'sos_screen.dart';

/// Hosts the shared chrome bar + bottom nav for Screens 3–6, switching
/// between tab bodies with an IndexedStack so each tab keeps its state.
class SeniorShell extends StatefulWidget {
  final int initialIndex;
  const SeniorShell({super.key, this.initialIndex = 0});

  @override
  State<SeniorShell> createState() => _SeniorShellState();
}

class _SeniorShellState extends State<SeniorShell> {
  late int _index = widget.initialIndex;

  void _goTo(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final s = AppStateScope.of(context).s;
    final labels = [s.navHome, s.navKonsulta, s.navSos, s.navAgape, s.navPambakal];

    return Scaffold(
      appBar: const GlobalChromeBar(),
      body: IndexedStack(
        index: _index,
        children: [
          DashboardBody(onNavigate: _goTo),
          const KonsultaBody(),
          const SosBody(),
          const AgapeBody(),
          const PambakalBody(),
        ],
      ),
      bottomNavigationBar: SeniorBottomNav(currentIndex: _index, onTap: _goTo, labels: labels),
    );
  }
}

class DashboardBody extends StatelessWidget {
  final ValueChanged<int> onNavigate;
  const DashboardBody({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final app = AppStateScope.of(context);
    final s = app.s;
    final scheme = Theme.of(context).colorScheme;
    final profile = DemoData.seniorProfile;
    final health = DemoData.healthRecord;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: scheme.primaryContainer,
                child: Text(
                  profile.preferredName.substring(0, 1),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.greeting(profile.preferredName), style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.verified_rounded, size: 14, color: scheme.primary),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            s.verifiedBadge,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.primary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${profile.fullName} · ${profile.age} yrs · ${profile.purok}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: StatusTile(
                  icon: Icons.event_available_rounded,
                  label: s.nextPension,
                  value: 'Oct 15, 2026',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatusTile(
                  icon: Icons.monitor_heart_rounded,
                  label: s.lastCheckup,
                  value: 'BP ${health.latestBp}',
                  valueSubtext: 'Normal',
                  accent: const Color(0xFF2F8F5B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 1.05,
            children: [
              ActionGridTile(
                icon: Icons.payments_rounded,
                title: s.tilePambakal,
                subtitle: s.tilePambakalSub,
                color: const Color(0xFFC5622A),
                onTap: () => onNavigate(4),
              ),
              ActionGridTile(
                icon: Icons.favorite_rounded,
                title: s.tileKonsulta,
                subtitle: s.tileKonsultaSub,
                color: const Color(0xFF1F7A73),
                onTap: () => onNavigate(1),
              ),
              ActionGridTile(
                icon: Icons.celebration_rounded,
                title: s.tileAgape,
                subtitle: s.tileAgapeSub,
                color: const Color(0xFF5B4B8A),
                onTap: () => onNavigate(3),
              ),
              ActionGridTile(
                icon: Icons.sos_rounded,
                title: s.tileSos,
                subtitle: s.tileSosSub,
                color: const Color(0xFFB3261E),
                onTap: () => onNavigate(2),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.campaign_rounded, color: scheme.onPrimaryContainer),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    s.advisory,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onPrimaryContainer),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
