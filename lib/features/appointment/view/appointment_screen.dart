import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/constants/enum_constant.dart';
import '../../../utils/extension/appointment_status_extension.dart';
import '../../../utils/extension/sized_box_extension.dart';
import '../../../utils/themes/app_text_style.dart';
import '../../../utils/widgets/bottomSheet/common_bottom_sheet.dart';
import '../../../utils/widgets/buttons/primary_elevated_button.dart';
import '../../../utils/widgets/buttons/primary_outlined_button.dart';
import '../controller/appointment_controller.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppointmentController controller = Get.find<AppointmentController>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Appointment Details')),
      body: SafeArea(
        child: Obx(() {
          final appointment = controller.appointment.value;
          if (appointment == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            appointment.patientName,
                            style: AppTextStyle.largeHeader.copyWith(color: colorScheme.onSurface),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: appointment.status.color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              appointment.status.label,
                              style: AppTextStyle.smallNormalText
                                  .copyWith(color: appointment.status.color, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                      20.height,
                      _DetailRow(icon: Icons.badge_outlined, label: 'Patient ID', value: appointment.patientId),
                      _DetailRow(icon: Icons.cake_outlined, label: 'Age', value: '${appointment.age} years'),
                      _DetailRow(icon: Icons.phone_outlined, label: 'Phone Number', value: appointment.phoneNumber),
                      _DetailRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'Appointment',
                        value: DateFormat('MMM d, y • h:mm a').format(appointment.dateTime),
                      ),
                    ],
                  ),
                ),
                24.height,
                if (appointment.status == AppointmentStatus.unconfirmed)
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryElevatedButton(
                      label: 'Cancel Appointment',
                      buttonColor: Theme.of(context).colorScheme.error,
                      onPressed: () => _confirmCancel(context, controller),
                    ),
                  ),
                if (appointment.status == AppointmentStatus.confirmed)
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryElevatedButton(
                      label: 'Start Video Call',
                      onPressed: () => controller.goToVideoCall(context),
                    ),
                  ),
                if (appointment.status == AppointmentStatus.cancelled)
                  Text(
                    'This appointment was cancelled.',
                    style: AppTextStyle.mediumNormalText
                        .copyWith(color: Theme.of(context).textTheme.bodySmall?.color),
                  ),
                14.height,
                SizedBox(
                  width: double.infinity,
                  child: PrimaryOutlinedButton(
                    label: 'Session Notes',
                    height: 48,
                    onPressed: () => controller.goToSessionNotes(context),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  void _confirmCancel(BuildContext context, AppointmentController controller) {
    CommonBottomSheet.show(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cancel Appointment?',
              style: AppTextStyle.largeHeader.copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
            8.height,
            Text(
              'Are you sure you want to cancel this appointment? This action cannot be undone.',
              style: AppTextStyle.mediumNormalText
                  .copyWith(color: Theme.of(context).textTheme.bodySmall?.color),
            ),
            20.height,
            Row(
              children: [
                Expanded(
                  child: PrimaryOutlinedButton(
                    label: 'Back',
                    onPressed: () => CommonBottomSheet.hideBottomSheet(),
                  ),
                ),
                12.width,
                Expanded(
                  child: PrimaryElevatedButton(
                    label: 'Yes, Cancel',
                    buttonColor: Theme.of(context).colorScheme.error,
                    onPressed: () {
                      CommonBottomSheet.hideBottomSheet();
                      controller.cancelAppointment();
                    },
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

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).textTheme.bodySmall?.color),
          10.width,
          Text(
            '$label: ',
            style: AppTextStyle.mediumNormalText
                .copyWith(color: Theme.of(context).textTheme.bodySmall?.color),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyle.mediumHeader.copyWith(color: Theme.of(context).colorScheme.onSurface),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
