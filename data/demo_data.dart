import '../models/models.dart';

/// All demo content lives here so every screen reads from one source —
/// matches the storyboard's "working demo, v1.1, demo data only" status.
class DemoData {
  static final seniorProfile = const SeniorProfile(
    fullName: 'Maria D. Santos',
    preferredName: 'Nanay Maria',
    age: 70,
    purok: 'Purok 3',
    scId: 'TAB-SC-2024-0142',
    mobileNumber: '0917 123 4567',
    verified: true,
    address: '25 Sampaguita St., Purok 3, Brgy. Tabun',
  );

  static final healthRecord = HealthRecord(
    medications: [
      Medication(name: 'Amlodipine', dose: '5 mg', schedule: 'Every day, 6:00 PM'),
      Medication(name: 'Metformin', dose: '500 mg', schedule: 'Every day, 8:00 AM'),
    ],
    bpTrend: const [
      BpPoint(monthLabel: 'Feb', systolic: 118, status: BpStatus.normal),
      BpPoint(monthLabel: 'Mar', systolic: 122, status: BpStatus.normal),
      BpPoint(monthLabel: 'Apr', systolic: 130, status: BpStatus.elevated),
      BpPoint(monthLabel: 'May', systolic: 128, status: BpStatus.elevated),
      BpPoint(monthLabel: 'Jun', systolic: 142, status: BpStatus.high),
      BpPoint(monthLabel: 'Jul', systolic: 135, status: BpStatus.elevated),
      BpPoint(monthLabel: 'Aug', systolic: 124, status: BpStatus.elevated),
      BpPoint(monthLabel: 'Sep', systolic: 120, status: BpStatus.normal),
    ],
    latestBp: '120/80 mmHg',
    latestSugar: '95 mg/dL',
    encodedByName: 'BHW Liza Manalo',
    encodedByStation: 'Brgy. Health Station',
  );

  static final benefitVoucher = BenefitVoucher(
    quarterLabel: 'Q4 2026',
    cashAmount: 1000,
    inKindItems: 'Rice 5kg + Vitamin Pack',
    claimLocation: 'Brgy. Tabun Covered Court',
    claimDate: 'Oct 15',
    deliveryExempt: false,
  );

  static final emergencyProfile = const EmergencyProfile(
    registeredAddress: '25 Sampaguita St., Purok 3, Brgy. Tabun',
    emergencyContactName: 'Juan Santos (Anak)',
    emergencyContactNumber: '0918 555 2211',
    barangayHallNumber: '(044) 555 0101',
    healthStationNumber: '(044) 555 0102',
  );

  /// Seed alerts so the Admin feed isn't empty before the demo SOS is fired.
  static final List<SosAlert> seedSosAlerts = [
    SosAlert(
      seniorName: 'Pedro Ramos',
      address: 'Purok 1, Brgy. Tabun',
      gpsLabel: '14.5995° N, 120.9842° E',
      timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
    ),
  ];
}
