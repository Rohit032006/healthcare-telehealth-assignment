import 'dart:convert';

import 'package:get_storage/get_storage.dart';

import '../../../utils/constants/local_storage_key_strings.dart';
import '../model/session_note_model.dart';

abstract class ISessionNotesRepo {
  Future<List<SessionNote>> getNotes(String appointmentId);
  Future<void> addNote(String appointmentId, String note);
}

/// Session notes are stored locally per appointment (no backend for this
/// assignment) using the same GetStorage instance the rest of the app uses.
class SessionNotesRepo implements ISessionNotesRepo {
  String _keyFor(String appointmentId) =>
      '${LocalStorageKeyStrings.sessionNotesKeyPrefix}$appointmentId';

  @override
  Future<List<SessionNote>> getNotes(String appointmentId) async {
    final raw = GetStorage().read<String>(_keyFor(appointmentId));
    if (raw == null || raw.isEmpty) return [];

    final decoded = jsonDecode(raw) as List;
    return decoded
        .map((e) => SessionNote.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  @override
  Future<void> addNote(String appointmentId, String note) async {
    final notes = await getNotes(appointmentId);
    final updated = [
      SessionNote(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        note: note,
        createdAt: DateTime.now(),
      ),
      ...notes,
    ];

    await GetStorage().write(
      _keyFor(appointmentId),
      jsonEncode(updated.map((e) => e.toJson()).toList()),
    );
  }
}
