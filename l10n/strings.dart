/// The two languages the storyboard's onboarding screen offers.
enum AppLanguage { tagalog, english }

extension AppLanguageLabel on AppLanguage {
  String get flag => this == AppLanguage.tagalog ? '🇵🇭' : '🇬🇧';
  String get label => this == AppLanguage.tagalog ? 'Tagalog' : 'English';
}

/// A small hand-rolled dictionary rather than a full intl/ARB pipeline —
/// this is a single-screen-pair prototype, so a flat key/value map keeps
/// every string visible in one place instead of scattered resource files.
class S {
  final AppLanguage lang;
  const S(this.lang);

  String _t(String tl, String en) => lang == AppLanguage.tagalog ? tl : en;

  String get appName => 'Tabun SeniorCare';
  String get tagline => _t(
        'Isang app para sa iyong pensyon, kalusugan, benepisyo, at kaligtasan.',
        'One app for your pension, health, benefits, and safety.',
      );
  String get welcome => _t('Maligayang pagdating sa Tabun SeniorCare', 'Welcome to Tabun SeniorCare');
  String get chooseLanguage => _t('Pumili ng wika', 'Choose your language');
  String get continueLabel => _t('Magpatuloy →', 'Continue →');
  String get goToAdmin => _t('Pumunta sa Admin Portal', 'Go to Admin Portal');
  String get prototypeNotice =>
      _t('Prototype v1.1 · Demo data lamang', 'Prototype v1.1 · Demo data only');

  String get loginTitle => _t('Pag-login ng Senior Citizen', 'Senior Citizen Login');
  String get loginInstruction => _t(
        'Ilagay ang Senior Citizen ID o i-scan ang QR code sa iyong barangay ID.',
        'Enter your Senior Citizen ID or scan the QR code on your barangay ID.',
      );
  String get idFieldLabel => _t('Barangay Senior Citizen ID Number', 'Barangay Senior Citizen ID Number');
  String get mobileFieldLabel => _t('Numero ng Cellphone', 'Mobile Number');
  String get scanQr => _t('I-scan ang QR Code sa ID', 'Scan QR Code on ID');
  String get sendOtp => _t('Magpadala ng OTP Code', 'Send OTP Code');
  String get demoLoginMaria => _t('Mag-login bilang Nanay Maria', 'Login as Nanay Maria');

  String greeting(String name) => _t('Magandang araw, $name!', 'Good day, $name!');
  String get verifiedBadge => _t('Beripikadong Senior Citizen', 'Verified Senior Citizen');
  String get nextPension => _t('Susunod na Pensyon', 'Next Pension');
  String get lastCheckup => _t('Huling Check-up', 'Last Check-up');
  String get advisory => _t(
        'Ang Q4 pension distribution ay sa Okt. 15.',
        'Q4 pension distribution is on Oct 15.',
      );

  String get navHome => _t('Tahanan', 'Home');
  String get navKonsulta => 'Konsulta';
  String get navSos => 'SOS';
  String get navAgape => 'Agape';
  String get navPambakal => 'Pambakal';

  String get tilePambakal => 'Pambakal';
  String get tilePambakalSub => _t('Cash Aid at Bitamina', 'Cash Aid & Vitamins');
  String get tileKonsulta => 'Konsulta';
  String get tileKonsultaSub => _t('Talaan ng Kalusugan', 'Health Records');
  String get tileAgape => _t('Agape / Mga Kaganapan', 'Agape / Events');
  String get tileAgapeSub => _t('Mga Gawain ng Barangay', 'Barangay Activities');
  String get tileSos => _t('Emergency SOS', 'Emergency SOS');
  String get tileSosSub => 'Bantay Lolo/Lola';

  String get konsultaSubtitle => _t(
        'Ang iyong BP, blood sugar, at gamot',
        'Your BP, blood sugar, and medicines',
      );
  String get maintenanceMeds => _t('Pangaraw-araw na Gamot', 'Maintenance Meds');
  String get takeAction => _t('Inumin', 'Take');
  String get bpTrendTitle => _t('Takbo ng Blood Pressure (Systolic)', 'Blood Pressure Trend (Systolic)');
  String get recentReadings => _t('Kamakailang Sukat', 'Recent Readings');
  String encodedBy(String name, String station) => _t('Isinulat ni $name ($station)', 'Encoded by $name ($station)');

  String get pambakalSubtitle => _t('Mga Benepisyo at Tulong Pinansyal', 'Benefits & Financial Aid');
  String get voucherReady => _t('Handa nang Kunin', 'Ready to Claim');
  String get voucherClaimed => _t('Nakuha na', 'Claimed');
  String get accessibilityNote => _t(
        'Ang mga senior na bedridden o wheelchair-bound ay awtomatikong bibisitahin sa bahay para sa delivery.',
        'Bedridden/wheelchair-bound seniors get automatic house-to-house delivery instead of claiming in person.',
      );

  String get sosLabel => _t('Pindutin Kung May Sakuna (Emergency)', 'Press & Hold for Emergency');
  String get sosHoldInstruction => _t('Pindutin nang 3 segundo', 'Press and hold for 3 seconds');
  String get sosTriggered => _t('Naipadala ang Alerto!', 'Alert Sent!');
  String get quickDialHall => _t('Barangay Hall', 'Barangay Hall');
  String get quickDialHealth => _t('Health Station', 'Health Station');

  String get adminPortalTitle => 'Admin Portal';
  String get adminSosFeed => _t('Live na Alerto', 'SOS Alerts');
  String get adminDistribution => 'Distribution';
  String get adminNoAlerts => _t('Walang alertong natatanggap sa ngayon.', 'No SOS alerts yet.');
  String get adminScanVoucher => _t('I-scan ang Voucher QR', 'Scan Voucher QR');
  String get adminMarkClaimed => _t('Markahan bilang Nakuha', 'Mark as Claimed');
  String get adminAlreadyClaimed => _t('Nakuha na ang voucher na ito', 'This voucher is already claimed');

  String get senior => _t('Senior App', 'Senior App');
  String get admin => _t('Admin Portal', 'Admin Portal');
}
