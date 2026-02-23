import '../../../expenses/domain/expense.dart';
import '../../../settings/domain/app_preferences.dart';
import '../../../vehicles/domain/vehicle.dart';
import '../reminder_candidate.dart';

class ReminderComputationService {
  const ReminderComputationService({
    this.serviceDueSoonWindowKm = 500,
    this.licenseDueSoonWindowDays = 30,
  });

  final int serviceDueSoonWindowKm;
  final int licenseDueSoonWindowDays;

  ReminderCandidate? upcomingServiceReminderCandidate({
    required Vehicle vehicle,
    required List<Expense> expenses,
    required AppPreferences preferences,
  }) {
    if (!preferences.serviceReminderEnabled) {
      return null;
    }

    final intervalKm = vehicle.serviceIntervalKm;
    if (intervalKm == null || intervalKm <= 0) {
      return null;
    }

    final currentMileage = _currentMileage(vehicle, expenses);
    final baselineMileage =
        vehicle.lastServiceMileage ?? vehicle.initialMileage;
    final dueMileage = baselineMileage + intervalKm;
    final remainingKm = dueMileage - currentMileage;

    if (remainingKm > serviceDueSoonWindowKm) {
      return null;
    }

    return ReminderCandidate(
      vehicleId: vehicle.id,
      type: ReminderType.service,
      urgency: remainingKm <= 0
          ? ReminderUrgency.overdue
          : ReminderUrgency.upcoming,
      remainingDistanceKm: remainingKm,
      dueMileage: dueMileage,
      dueDate: vehicle.lastServiceDate,
    );
  }

  ReminderCandidate? upcomingLicenseReminderCandidate({
    required Vehicle vehicle,
    required AppPreferences preferences,
  }) {
    if (!preferences.licenseReminderEnabled) {
      return null;
    }

    final expiryDate = vehicle.licenseExpiryDate;
    if (expiryDate == null) {
      return null;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final normalizedExpiry = DateTime(
      expiryDate.year,
      expiryDate.month,
      expiryDate.day,
    );
    final remainingDays = normalizedExpiry.difference(today).inDays;

    if (remainingDays > licenseDueSoonWindowDays) {
      return null;
    }

    return ReminderCandidate(
      vehicleId: vehicle.id,
      type: ReminderType.license,
      urgency: remainingDays < 0
          ? ReminderUrgency.overdue
          : ReminderUrgency.upcoming,
      remainingDays: remainingDays,
      dueDate: normalizedExpiry,
    );
  }

  VehicleReminderSnapshot vehicleReminders({
    required Vehicle vehicle,
    required List<Expense> expenses,
    required AppPreferences preferences,
  }) {
    return VehicleReminderSnapshot(
      service: upcomingServiceReminderCandidate(
        vehicle: vehicle,
        expenses: expenses,
        preferences: preferences,
      ),
      license: upcomingLicenseReminderCandidate(
        vehicle: vehicle,
        preferences: preferences,
      ),
    );
  }

  ReminderSummary summarize({
    required List<Vehicle> vehicles,
    required Map<int, List<Expense>> expensesByVehicle,
    required AppPreferences preferences,
  }) {
    var serviceUpcoming = 0;
    var serviceOverdue = 0;
    var licenseUpcoming = 0;
    var licenseOverdue = 0;

    for (final vehicle in vehicles) {
      final snapshot = vehicleReminders(
        vehicle: vehicle,
        expenses: expensesByVehicle[vehicle.id] ?? const [],
        preferences: preferences,
      );

      final service = snapshot.service;
      if (service != null) {
        if (service.urgency == ReminderUrgency.overdue) {
          serviceOverdue += 1;
        } else {
          serviceUpcoming += 1;
        }
      }

      final license = snapshot.license;
      if (license != null) {
        if (license.urgency == ReminderUrgency.overdue) {
          licenseOverdue += 1;
        } else {
          licenseUpcoming += 1;
        }
      }
    }

    return ReminderSummary(
      totalUpcoming: serviceUpcoming + licenseUpcoming,
      totalOverdue: serviceOverdue + licenseOverdue,
      serviceUpcoming: serviceUpcoming,
      serviceOverdue: serviceOverdue,
      licenseUpcoming: licenseUpcoming,
      licenseOverdue: licenseOverdue,
    );
  }

  int _currentMileage(Vehicle vehicle, List<Expense> expenses) {
    var maxMileage = vehicle.initialMileage;

    final serviceMileage = vehicle.lastServiceMileage;
    if (serviceMileage != null && serviceMileage > maxMileage) {
      maxMileage = serviceMileage;
    }

    for (final expense in expenses) {
      final odometer = expense.odometer;
      if (odometer != null && odometer > maxMileage) {
        maxMileage = odometer;
      }
    }

    return maxMileage;
  }
}
