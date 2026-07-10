/// Annotation to provide metadata about widgets for better documentation
/// and maintainability.
class WidgetDescription {
  /// A brief description of where and why this widget is used.
  final String usage;

  final String? figmaUrl;

  /// A unique identifier for this widget (e.g., to track usage or debug).
  final String uniqueKey;

  const WidgetDescription({
    required this.usage,
    required this.uniqueKey,
    this.figmaUrl,
  });
}
