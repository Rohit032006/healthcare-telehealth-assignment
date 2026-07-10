class DebugProperties {
  final String purpose;
  final List<String> trackedProperties;
  final String? notes;

  const DebugProperties({
    required this.purpose,
    required this.trackedProperties,
    this.notes,
  });
}
