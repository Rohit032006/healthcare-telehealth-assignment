class Verified {
  final Developer? veriefiedBy;
  final Developer responsibility;
  final String impediments;
  final String? comments;
  final List<ChangeLog> changeLogs;

  const Verified(
      {required this.comments,
      required this.responsibility,
      this.veriefiedBy,
      this.changeLogs = const [],
      this.impediments = ''});
}

enum Developer {
  sparsh,
  yashika,
  shreyas,
}

class ChangeLog {
  final Developer madeBy;
  final String reason;
  final String? description;

  const ChangeLog({
    required this.madeBy,
    required this.reason,
    this.description,
  });
}
