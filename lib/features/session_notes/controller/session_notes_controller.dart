import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/dependency_locator.dart';
import '../../../utils/networks/toast_services/toast_services.dart';
import '../../appointment/controller/appointment_controller.dart';
import '../model/session_note_model.dart';
import '../repo/session_notes_repo.dart';

class SessionNotesController extends GetxController {
  final TextEditingController noteController = TextEditingController();
  final RxList<SessionNote> notes = <SessionNote>[].obs;
  final RxBool isLoading = false.obs;

  final ISessionNotesRepo _sessionNotesRepo = getIt();

  String get _appointmentId => Get.find<AppointmentController>().appointment.value!.id;

  @override
  void onInit() {
    super.onInit();
    loadNotes();
  }

  Future<void> loadNotes() async {
    isLoading.value = true;
    try {
      notes.value = await _sessionNotesRepo.getNotes(_appointmentId);
    } catch (e) {
      ToastServices.error('Error', 'Unable to load session notes.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addNote() async {
    final text = noteController.text.trim();
    if (text.isEmpty) {
      ToastServices.warning('Empty Note', 'Please write something before saving.');
      return;
    }

    try {
      await _sessionNotesRepo.addNote(_appointmentId, text);
      noteController.clear();
      await loadNotes();
      ToastServices.success('Saved', 'Session note added.');
    } catch (e) {
      ToastServices.error('Error', 'Could not save the session note.');
    }
  }

  @override
  void onClose() {
    noteController.dispose();
    super.onClose();
  }
}
