enum ActionScope { global, local }

enum ActionType { voting, aiSummary, courtCase, announcement }

class ActionItem {
  final String id;
  final String title;
  final String description;
  final ActionScope scope;
  final ActionType type;
  final String? locationName; // np. "Katowice, Centrum"
  final String?
  aiOutcomePrediction; // np. "Grozi: do 20 lat pozbawienia wolności"
  final String? imageUrl;
  final DateTime createdAt;

  const ActionItem({
    required this.id,
    required this.title,
    required this.description,
    required this.scope,
    required this.type,
    this.locationName,
    this.aiOutcomePrediction,
    this.imageUrl,
    required this.createdAt,
  });
}
