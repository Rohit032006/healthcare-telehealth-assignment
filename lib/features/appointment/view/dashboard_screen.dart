import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/constants/mock_data.dart';
import '../../../utils/extension/appointment_status_extension.dart';
import '../../../utils/extension/sized_box_extension.dart';
import '../../../utils/themes/app_text_style.dart';
import '../controller/appointment_controller.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppointmentController controller = Get.find<AppointmentController>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Doctor Dashboard'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, ${MockData.doctorName}',
                style: AppTextStyle.largeHeader
                    .copyWith(color: colorScheme.onSurface, fontSize: 22),
              ),
              6.height,
              Text(
                'Here is your upcoming appointment',
                style: AppTextStyle.mediumNormalText
                    .copyWith(color: Theme.of(context).textTheme.bodySmall?.color),
              ),
              24.height,
              Obx(() {
                final appointment = controller.appointment.value;
                if (controller.isLoading.value || appointment == null) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => controller.goToAppointmentDetail(context),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                appointment.patientName,
                                style: AppTextStyle.largeHeader
                                    .copyWith(color: colorScheme.onSurface),
                              ),
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
                        8.height,
                        Row(
                          children: [
                            Icon(Icons.calendar_today_outlined,
                                size: 16, color: Theme.of(context).textTheme.bodySmall?.color),
                            6.width,
                            Text(
                              DateFormat('MMM d, y • h:mm a').format(appointment.dateTime),
                              style: AppTextStyle.mediumNormalText
                                  .copyWith(color: Theme.of(context).textTheme.bodySmall?.color),
                            ),
                          ],
                        ),
                        16.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'View Details',
                              style: AppTextStyle.mediumHeader.copyWith(color: colorScheme.primary),
                            ),
                            4.width,
                            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: colorScheme.primary),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
