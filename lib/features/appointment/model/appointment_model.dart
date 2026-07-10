import '../../../utils/constants/enum_constant.dart';

class Appointment {
  final String id;
  final String patientName;
  final String patientId;
  final int age;
  final String phoneNumber;
  final DateTime dateTime;
  final AppointmentStatus status;

  const Appointment({
    required this.id,
    required this.patientName,
    required this.patientId,
    required this.age,
    required this.phoneNumber,
    required this.dateTime,
    required this.status,
  });

  Appointment copyWith({AppointmentStatus? status}) {
    return Appointment(
      id: id,
      patientName: patientName,
      patientId: patientId,
      age: age,
      phoneNumber: phoneNumber,
      dateTime: dateTime,
      status: status ?? this.status,
    );
  }
}
