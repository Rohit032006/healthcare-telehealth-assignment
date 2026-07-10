import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/constants/enum_constant.dart';
import '../../../utils/dependency_locator.dart';
import '../../../utils/navigation/app_routes.dart';
import '../../../utils/networks/toast_services/toast_services.dart';
import '../model/appointment_model.dart';
import '../repo/appointment_repo.dart';

class AppointmentController extends GetxController {
  final Rx<Appointment?> appointment = Rx<Appointment?>(null);
  final RxBool isLoading = false.obs;

  final IAppointmentRepo _appointmentRepo = getIt();

  @override
  void onInit() {
    super.onInit();
    fetchAppointment();
  }

  Future<void> fetchAppointment() async {
    isLoading.value = true;
    try {
      appointment.value = await _appointmentRepo.getTodaysAppointment();
    } catch (e) {
      ToastServices.error('Error', 'Unable to load appointment details.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelAppointment() async {
    try {
      appointment.value =
          await _appointmentRepo.updateStatus(AppointmentStatus.cancelled);
      ToastServices.success('Cancelled', 'Appointment has been cancelled.');
    } catch (e) {
      ToastServices.error('Error', 'Could not cancel the appointment.');
    }
  }

  void goToAppointmentDetail(BuildContext context) {
    // push (not go) so a back arrow/gesture can return to the dashboard.
    context.push(AppRoutes.appointment);
  }

  void goToVideoCall(BuildContext context) {
    // go (not push): the call screen has no back button by design — ending
    // a call must go through the explicit End Call button so cleanup runs.
    context.go(AppRoutes.videoCall);
  }

  void goToSessionNotes(BuildContext context) {
    // push (not go) so a back arrow/gesture can return to the appointment.
    context.push(AppRoutes.sessionNotes);
  }
}
