class SessionNote {
  final String id;
  final String note;
  final DateTime createdAt;

  const SessionNote({
    required this.id,
    required this.note,
    required this.createdAt,
  });

  factory SessionNote.fromJson(Map<String, dynamic> json) {
    return SessionNote(
      id: json['id'] as String,
      note: json['note'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
