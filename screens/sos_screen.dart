import 'package:flutter/material.dart';
import '../data/demo_data.dart';
import '../l10n/strings.dart';
import '../state/app_state.dart';

class SosBody extends StatefulWidget {
  const SosBody({super.key});

  @override
  State<SosBody> createState() => _SosBodyState();
}

class _SosBodyState extends State<SosBody> with SingleTickerProviderStateMixin {
  late final AnimationController _holdController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  );
  bool _sent = false;

  @override
  void initState() {
    super.initState();
    _holdController.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_sent) {
        _trigger();
      }
    });
  }

  @override
  void dispose() {
    _holdController.dispose();
    super.dispose();
  }

  void _trigger() {
    if (!mounted) return;
    setState(() => _sent = true);
    AppStateScope.of(context).fireSosAlert();
  }

  void _reset() {
    setState(() => _sent = false);
    _holdController.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    final emergency = DemoData.emergencyProfile;
    final s = AppStateScope.of(context).s;
    const red = Color(0xFFB3261E);

    return Container(
      color: red,
      width: double.infinity,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: _sent ? _SentState(onReset: _reset, address: emergency.registeredAddress) : _buildDial(s),
        ),
      ),
    );
  }

  Widget _buildDial(S s) {
    return Column(
      children: [
        const Spacer(),
        Text(
          s.sosLabel,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 40),
        GestureDetector(
          onTapDown: (_) => _holdController.forward(),
          onTapUp: (_) {
            if (_holdController.status != AnimationStatus.completed) _holdController.reverse();
          },
          onTapCancel: () {
            if (_holdController.status != AnimationStatus.completed) _holdController.reverse();
          },
          child: AnimatedBuilder(
            animation: _holdController,
            builder: (context, _) {
              return SizedBox(
                width: 220,
                height: 220,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 220,
                      height: 220,
                      child: CircularProgressIndicator(
                        value: _holdController.value,
                        strokeWidth: 6,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                    Container(
                      width: 180,
                      height: 180,
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: const Text(
                        'SOS',
                        style: TextStyle(color: Color(0xFFB3261E), fontSize: 40, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        Text(s.sosHoldInstruction, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        const Spacer(),
        Row(
          children: [
            Expanded(child: _quickDial(s.quickDialHall, Icons.home_work_outlined)),
            const SizedBox(width: 10),
            Expanded(child: _quickDial(s.quickDialHealth, Icons.local_hospital_outlined)),
            const SizedBox(width: 10),
            Expanded(child: _quickDial('911', Icons.call_outlined)),
          ],
        ),
      ],
    );
  }

  Widget _quickDial(String label, IconData icon) {
    return Builder(builder: (context) {
      return OutlinedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Calling $label…')));
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white54),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.white), textAlign: TextAlign.center),
          ],
        ),
      );
    });
  }
}

class _SentState extends StatelessWidget {
  final VoidCallback onReset;
  final String address;
  const _SentState({required this.onReset, required this.address});

  @override
  Widget build(BuildContext context) {
    final s = AppStateScope.of(context).s;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.check_circle_rounded, color: Colors.white, size: 72),
        const SizedBox(height: 16),
        Text(s.sosTriggered, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text(
          address,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(height: 4),
        const Text(
          'Live GPS shared with the Barangay Emergency Response Team.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(height: 28),
        OutlinedButton(
          onPressed: onReset,
          style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white54)),
          child: const Text('Reset (demo)'),
        ),
      ],
    );
  }
}
