import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/extension/sized_box_extension.dart';
import '../../../utils/themes/app_text_style.dart';
import '../../../utils/widgets/buttons/primary_elevated_button.dart';
import '../../../utils/widgets/text_form_fields/title_text_form_field.dart';
import '../controller/session_notes_controller.dart';

class SessionNotesScreen extends StatelessWidget {
  const SessionNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SessionNotesController controller = Get.find<SessionNotesController>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Session Notes')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleTextFormField(
                title: 'Add a note',
                hintText: 'Write your observations for this session...',
                controller: controller.noteController,
                maxLines: 3,
              ),
              12.height,
              SizedBox(
                width: double.infinity,
                child: PrimaryElevatedButton(
                  label: 'Add Note',
                  onPressed: controller.addNote,
                ),
              ),
              20.height,
              Text(
                'Previous Notes',
                style: AppTextStyle.mediumHeader.copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              10.height,
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.notes.isEmpty) {
                    return Center(
                      child: Text(
                        'No session notes yet.',
                        style: AppTextStyle.mediumNormalText
                            .copyWith(color: Theme.of(context).textTheme.bodySmall?.color),
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: controller.notes.length,
                    separatorBuilder: (context, index) => 10.height,
                    itemBuilder: (context, index) {
                      final note = controller.notes[index];
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              note.note,
                              style: AppTextStyle.mediumNormalText
                                  .copyWith(color: Theme.of(context).colorScheme.onSurface),
                            ),
                            8.height,
                            Text(
                              DateFormat('MMM d, y • h:mm a').format(note.createdAt),
                              style: AppTextStyle.smallNormalText
                                  .copyWith(color: Theme.of(context).textTheme.bodySmall?.color),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
