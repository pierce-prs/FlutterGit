import 'package:flutter/material.dart';
import '../data/demo_data.dart';
import '../l10n/strings.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

enum Portal { senior, admin }

/// A single ChangeNotifier holding both the display/accessibility settings
/// (palette, brightness, text scale, language, portal) and the small
/// pieces of demo state that need to be shared live between the Senior App
/// and the Admin Portal — the SOS alert feed and the voucher claim status —
/// so the storyboard's "full loop" test flow actually works end to end.
class AppState extends ChangeNotifier {
  AppPalette _palette = kAppPalettes[1]; // green is the default per the storyboard
  Brightness _brightness = Brightness.light;
  double _textScale = 1.0;
  AppLanguage _language = AppLanguage.english;
  Portal _portal = Portal.senior;

  final List<SosAlert> _sosAlerts = List.of(DemoData.seedSosAlerts);
  final BenefitVoucher _voucher = DemoData.benefitVoucher;

  AppPalette get palette => _palette;
  Brightness get brightness => _brightness;
  double get textScale => _textScale;
  AppLanguage get language => _language;
  Portal get portal => _portal;
  List<SosAlert> get sosAlerts => List.unmodifiable(_sosAlerts.reversed);
  BenefitVoucher get voucher => _voucher;
  S get s => S(_language);

  void setPalette(AppPalette p) {
    _palette = p;
    notifyListeners();
  }

  void toggleBrightness() {
    _brightness = _brightness == Brightness.light ? Brightness.dark : Brightness.light;
    notifyListeners();
  }

  static const double _minScale = 0.85;
  static const double _maxScale = 1.4;

  void increaseTextScale() {
    _textScale = (_textScale + 0.1).clamp(_minScale, _maxScale).toDouble();
    notifyListeners();
  }

  void decreaseTextScale() {
    _textScale = (_textScale - 0.1).clamp(_minScale, _maxScale).toDouble();
    notifyListeners();
  }

  void setLanguage(AppLanguage lang) {
    _language = lang;
    notifyListeners();
  }

  void setPortal(Portal p) {
    _portal = p;
    notifyListeners();
  }

  /// Screen 6 → Screen 7 loop: press-and-hold SOS pushes a live alert into
  /// the Admin feed.
  void fireSosAlert() {
    _sosAlerts.add(SosAlert(
      seniorName: DemoData.seniorProfile.preferredName,
      address: DemoData.emergencyProfile.registeredAddress,
      gpsLabel: '14.5995° N, 120.9842° E',
      timestamp: DateTime.now(),
    ));
    notifyListeners();
  }

  /// Screen 7 → Screen 5 loop: scanning the voucher in Admin → Distribution
  /// flips the Senior App voucher status to "Claimed" instantly.
  void markVoucherClaimed() {
    _voucher.claimed = true;
    notifyListeners();
  }
}

/// Makes [AppState] available to the whole widget tree and rebuilds
/// dependents whenever it changes.
class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({super.key, required AppState super.notifier, required super.child});

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'AppStateScope not found in context');
    return scope!.notifier!;
  }
}
