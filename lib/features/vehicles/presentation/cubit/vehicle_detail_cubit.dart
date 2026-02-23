import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../expenses/domain/expense.dart';
import '../../../expenses/domain/expense_repository.dart';
import '../../../reminders/domain/reminder_candidate.dart';
import '../../domain/vehicle.dart';
import '../../domain/vehicle_repository.dart';
import 'vehicle_detail_state.dart';

class VehicleDetailCubit extends Cubit<VehicleDetailState> {
  VehicleDetailCubit(
    this._expenseRepository,
    this._vehicleRepository,
    Vehicle initialVehicle,
  ) : super(VehicleDetailState(vehicle: initialVehicle));

  final ExpenseRepository _expenseRepository;
  final VehicleRepository _vehicleRepository;

  Future<void> loadExpenses(int vehicleId) async {
    emit(
      state.copyWith(status: VehicleDetailStatus.loading, errorMessage: null),
    );
    try {
      final expenses = await _expenseRepository.getExpensesForVehicle(
        vehicleId,
      );
      emit(
        state.copyWith(
          status: VehicleDetailStatus.success,
          actionStatus: VehicleExpenseActionStatus.idle,
          reminderActionStatus: VehicleReminderActionStatus.idle,
          expenses: expenses,
          actionMessage: null,
          reminderActionMessage: null,
          errorMessage: null,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: VehicleDetailStatus.failure,
          errorMessage: 'Failed to load expenses for this vehicle.',
        ),
      );
    }
  }

  Future<void> updateExpense(Expense expense) async {
    emit(
      state.copyWith(
        actionStatus: VehicleExpenseActionStatus.processing,
        actionMessage: null,
      ),
    );
    try {
      await _expenseRepository.updateExpense(expense);
      final updatedExpenses = List<Expense>.from(state.expenses);
      final index = updatedExpenses.indexWhere((item) => item.id == expense.id);
      if (index >= 0) {
        updatedExpenses[index] = expense;
      }
      emit(
        state.copyWith(
          expenses: updatedExpenses,
          actionStatus: VehicleExpenseActionStatus.success,
          actionMessage: 'Expense updated.',
        ),
      );
      emit(state.copyWith(actionStatus: VehicleExpenseActionStatus.idle));
    } catch (_) {
      emit(
        state.copyWith(
          actionStatus: VehicleExpenseActionStatus.failure,
          actionMessage: 'Failed to update expense.',
        ),
      );
      emit(state.copyWith(actionStatus: VehicleExpenseActionStatus.idle));
    }
  }

  Future<void> deleteExpense(int expenseId) async {
    emit(
      state.copyWith(
        actionStatus: VehicleExpenseActionStatus.processing,
        actionMessage: null,
      ),
    );
    try {
      await _expenseRepository.deleteExpense(expenseId);
      final updatedExpenses = state.expenses
          .where((expense) => expense.id != expenseId)
          .toList(growable: false);
      emit(
        state.copyWith(
          expenses: updatedExpenses,
          actionStatus: VehicleExpenseActionStatus.success,
          actionMessage: 'Expense deleted.',
        ),
      );
      emit(state.copyWith(actionStatus: VehicleExpenseActionStatus.idle));
    } catch (_) {
      emit(
        state.copyWith(
          actionStatus: VehicleExpenseActionStatus.failure,
          actionMessage: 'Failed to delete expense.',
        ),
      );
      emit(state.copyWith(actionStatus: VehicleExpenseActionStatus.idle));
    }
  }

  Future<void> markReminderDone(ReminderType type) async {
    emit(
      state.copyWith(
        reminderActionStatus: VehicleReminderActionStatus.processing,
        reminderActionMessage: null,
      ),
    );
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      Vehicle updatedVehicle;
      String message;

      if (type == ReminderType.service) {
        final mileage = _currentMileage(state.vehicle, state.expenses);
        updatedVehicle = state.vehicle.copyWith(
          lastServiceMileage: mileage,
          lastServiceDate: today,
          serviceReminderLastDoneAt: now,
          clearServiceReminderSnoozedUntil: true,
          clearServiceReminderRescheduledMileage: true,
          clearServiceReminderRescheduledDate: true,
        );
        message = 'Service reminder marked done.';
      } else {
        final baseline =
            state.vehicle.licenseReminderRescheduledDate ??
            state.vehicle.licenseExpiryDate ??
            today;
        final nextDue = DateTime(
          baseline.year + 1,
          baseline.month,
          baseline.day,
        );
        updatedVehicle = state.vehicle.copyWith(
          licenseExpiryDate: nextDue,
          licenseReminderLastDoneAt: now,
          clearLicenseReminderSnoozedUntil: true,
          clearLicenseReminderRescheduledDate: true,
        );
        message = 'License reminder marked done.';
      }

      await _vehicleRepository.updateVehicle(updatedVehicle);
      emit(
        state.copyWith(
          vehicle: updatedVehicle,
          reminderActionStatus: VehicleReminderActionStatus.success,
          reminderActionMessage: message,
        ),
      );
      emit(
        state.copyWith(reminderActionStatus: VehicleReminderActionStatus.idle),
      );
    } catch (_) {
      emit(
        state.copyWith(
          reminderActionStatus: VehicleReminderActionStatus.failure,
          reminderActionMessage: 'Failed to update reminder action.',
        ),
      );
      emit(
        state.copyWith(reminderActionStatus: VehicleReminderActionStatus.idle),
      );
    }
  }

  Future<void> snoozeReminder(
    ReminderType type, {
    Duration duration = const Duration(days: 7),
  }) async {
    emit(
      state.copyWith(
        reminderActionStatus: VehicleReminderActionStatus.processing,
        reminderActionMessage: null,
      ),
    );
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final snoozeUntil = today.add(duration);
      final updatedVehicle = type == ReminderType.service
          ? state.vehicle.copyWith(serviceReminderSnoozedUntil: snoozeUntil)
          : state.vehicle.copyWith(licenseReminderSnoozedUntil: snoozeUntil);

      await _vehicleRepository.updateVehicle(updatedVehicle);
      emit(
        state.copyWith(
          vehicle: updatedVehicle,
          reminderActionStatus: VehicleReminderActionStatus.success,
          reminderActionMessage:
              '${_typeLabel(type)} reminder snoozed until ${_shortDate(snoozeUntil)}.',
        ),
      );
      emit(
        state.copyWith(reminderActionStatus: VehicleReminderActionStatus.idle),
      );
    } catch (_) {
      emit(
        state.copyWith(
          reminderActionStatus: VehicleReminderActionStatus.failure,
          reminderActionMessage: 'Failed to update reminder action.',
        ),
      );
      emit(
        state.copyWith(reminderActionStatus: VehicleReminderActionStatus.idle),
      );
    }
  }

  Future<void> rescheduleServiceReminder(int dueMileageKm) async {
    emit(
      state.copyWith(
        reminderActionStatus: VehicleReminderActionStatus.processing,
        reminderActionMessage: null,
      ),
    );
    try {
      final updatedVehicle = state.vehicle.copyWith(
        serviceReminderRescheduledMileage: dueMileageKm,
        clearServiceReminderSnoozedUntil: true,
        serviceReminderRescheduledDate: DateTime.now(),
      );
      await _vehicleRepository.updateVehicle(updatedVehicle);
      emit(
        state.copyWith(
          vehicle: updatedVehicle,
          reminderActionStatus: VehicleReminderActionStatus.success,
          reminderActionMessage: 'Service reminder rescheduled.',
        ),
      );
      emit(
        state.copyWith(reminderActionStatus: VehicleReminderActionStatus.idle),
      );
    } catch (_) {
      emit(
        state.copyWith(
          reminderActionStatus: VehicleReminderActionStatus.failure,
          reminderActionMessage: 'Failed to update reminder action.',
        ),
      );
      emit(
        state.copyWith(reminderActionStatus: VehicleReminderActionStatus.idle),
      );
    }
  }

  Future<void> rescheduleLicenseReminder(DateTime dueDate) async {
    emit(
      state.copyWith(
        reminderActionStatus: VehicleReminderActionStatus.processing,
        reminderActionMessage: null,
      ),
    );
    try {
      final normalized = DateTime(dueDate.year, dueDate.month, dueDate.day);
      final updatedVehicle = state.vehicle.copyWith(
        licenseReminderRescheduledDate: normalized,
        clearLicenseReminderSnoozedUntil: true,
      );
      await _vehicleRepository.updateVehicle(updatedVehicle);
      emit(
        state.copyWith(
          vehicle: updatedVehicle,
          reminderActionStatus: VehicleReminderActionStatus.success,
          reminderActionMessage: 'License reminder rescheduled.',
        ),
      );
      emit(
        state.copyWith(reminderActionStatus: VehicleReminderActionStatus.idle),
      );
    } catch (_) {
      emit(
        state.copyWith(
          reminderActionStatus: VehicleReminderActionStatus.failure,
          reminderActionMessage: 'Failed to update reminder action.',
        ),
      );
      emit(
        state.copyWith(reminderActionStatus: VehicleReminderActionStatus.idle),
      );
    }
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

  String _typeLabel(ReminderType type) =>
      type == ReminderType.service ? 'Service' : 'License';

  String _shortDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
