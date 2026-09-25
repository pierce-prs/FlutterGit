/// Senior citizen profile — Screens 2, 3, 5, 6.
class SeniorProfile {
  final String fullName;
  final String preferredName;
  final int age;
  final String purok;
  final String scId; // TAB-SC-YYYY-NNNN
  final String mobileNumber;
  final bool verified;
  final String address;

  const SeniorProfile({
    required this.fullName,
    required this.preferredName,
    required this.age,
    required this.purok,
    required this.scId,
    required this.mobileNumber,
    required this.verified,
    required this.address,
  });
}

/// A single maintenance medication — Screen 4.
class Medication {
  final String name;
  final String dose;
  final String schedule;
  bool takenToday;

  Medication({
    required this.name,
    required this.dose,
    required this.schedule,
    this.takenToday = false,
  });
}

enum BpStatus { normal, elevated, high }

/// One monthly systolic BP reading point — Screen 4 trend chart.
class BpPoint {
  final String monthLabel;
  final double systolic;
  final BpStatus status;

  const BpPoint({required this.monthLabel, required this.systolic, required this.status});
}

/// A senior's health record — Screen 4.
class HealthRecord {
  final List<Medication> medications;
  final List<BpPoint> bpTrend;
  final String latestBp;
  final String latestSugar;
  final String encodedByName;
  final String encodedByStation;

  const HealthRecord({
    required this.medications,
    required this.bpTrend,
    required this.latestBp,
    required this.latestSugar,
    required this.encodedByName,
    required this.encodedByStation,
  });
}

/// A quarterly benefit voucher — Screen 5.
class BenefitVoucher {
  final String quarterLabel;
  final int cashAmount;
  final String inKindItems;
  final String claimLocation;
  final String claimDate;
  final bool deliveryExempt;
  bool claimed;

  BenefitVoucher({
    required this.quarterLabel,
    required this.cashAmount,
    required this.inKindItems,
    required this.claimLocation,
    required this.claimDate,
    this.deliveryExempt = false,
    this.claimed = false,
  });
}

/// Emergency contact/registration profile — Screen 6.
class EmergencyProfile {
  final String registeredAddress;
  final String emergencyContactName;
  final String emergencyContactNumber;
  final String barangayHallNumber;
  final String healthStationNumber;

  const EmergencyProfile({
    required this.registeredAddress,
    required this.emergencyContactName,
    required this.emergencyContactNumber,
    required this.barangayHallNumber,
    required this.healthStationNumber,
  });
}

/// One live SOS event shown in Admin → SOS Alerts (Screen 7).
class SosAlert {
  final String seniorName;
  final String address;
  final String gpsLabel;
  final DateTime timestamp;

  const SosAlert({
    required this.seniorName,
    required this.address,
    required this.gpsLabel,
    required this.timestamp,
  });
}
