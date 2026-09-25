import 'dart:async';
import 'package:flutter/material.dart';

/// Reusable Flutter wrapper that renders whatever [child] the app is
/// currently showing inside a simulated physical phone frame — this is the
/// dev utility described at the bottom of the storyboard, cleaned up and
/// wired to accept live screen content instead of a placeholder.
///
/// Frame specs: 393×852 (iPhone 15-class), 44px corner radius, drop shadow,
/// gradient wallpaper backdrop behind the content layer.
class DeviceFrame extends StatelessWidget {
  final Widget child;
  final Color wallpaperStart;
  final Color wallpaperEnd;

  const DeviceFrame({
    super.key,
    required this.child,
    this.wallpaperStart = const Color(0xFFE0C3FC),
    this.wallpaperEnd = const Color(0xFF8EC5FC),
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Container(
      color: const Color(0xFF121212),
      alignment: Alignment.center,
      child: Container(
        width: 393,
        height: 852,
        margin: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(44),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // 1. Wallpaper canvas — shows through the transparent status-bar
            // strip above, since the content column below it is opaque.
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [wallpaperStart, wallpaperEnd],
                  ),
                ),
              ),
            ),

            // 2. Status bar row + screen content, stacked so content is
            // genuinely pushed below the status bar rather than merely
            // padded (a Positioned overlay would let the two overlap).
            Column(
              children: [
                const SizedBox(height: 44, child: FakeStatusBar()),
                Expanded(
                  child: MediaQuery(
                    data: media.copyWith(padding: media.padding.copyWith(top: 0)),
                    child: child,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Live clock + signal/wifi/battery icons + a simulated Dynamic Island
/// capsule. Falls back to a 44px height when no device safe-area padding
/// is detected (e.g. web preview).
class FakeStatusBar extends StatefulWidget {
  const FakeStatusBar({super.key});

  @override
  State<FakeStatusBar> createState() => _FakeStatusBarState();
}

class _FakeStatusBarState extends State<FakeStatusBar> {
  late Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timeStr = '${_now.hour.toString().padLeft(2, '0')}:${_now.minute.toString().padLeft(2, '0')}';

    return SizedBox(
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  timeStr,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
                ),
                const Row(
                  children: [
                    Icon(Icons.signal_cellular_alt, size: 16, color: Colors.black),
                    SizedBox(width: 4),
                    Icon(Icons.wifi, size: 16, color: Colors.black),
                    SizedBox(width: 4),
                    Icon(Icons.battery_full, size: 16, color: Colors.black),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 6,
            child: Container(
              width: 110,
              height: 30,
              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ],
      ),
    );
  }
}
