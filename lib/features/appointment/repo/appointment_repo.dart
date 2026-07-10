import '../../../utils/constants/enum_constant.dart';
import '../model/appointment_model.dart';

abstract class IAppointmentRepo {
  Future<Appointment> getTodaysAppointment();
  Future<Appointment> updateStatus(AppointmentStatus status);
}

/// Mocked appointment backend — the assignment only requires a single
/// patient appointment, so this repo holds one in-memory record.
///
/// Seeded as [AppointmentStatus.confirmed] so the mandatory video-call flow
/// is reachable immediately. To see the Unconfirmed -> Cancel flow, change
/// [_seedStatus] to [AppointmentStatus.unconfirmed] (documented in README).
class AppointmentRepo implements IAppointmentRepo {
  static const AppointmentStatus _seedStatus = AppointmentStatus.confirmed;

  Appointment _appointment = Appointment(
    id: 'APT-2001',
    patientName: 'Ramesh Kumar',
    patientId: 'PT-4521',
    age: 54,
    phoneNumber: '+91 98765 43210',
    dateTime: DateTime.now().add(const Duration(minutes: 15)),
    status: _seedStatus,
  );

  @override
  Future<Appointment> getTodaysAppointment() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _appointment;
  }

  @override
  Future<Appointment> updateStatus(AppointmentStatus status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _appointment = _appointment.copyWith(status: status);
    return _appointment;
  }
}
