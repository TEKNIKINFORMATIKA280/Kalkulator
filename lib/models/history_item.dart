import 'dart:convert';

class HistoryItem {
  final String equation;
  final String result;
  final DateTime timestamp;

  HistoryItem({
    required this.equation,
    required this.result,
    required this.timestamp,
  });

  // Convert a HistoryItem into a Map.
  Map<String, dynamic> toMap() {
    return {
      'equation': equation,
      'result': result,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Convert a Map into a HistoryItem.
  factory HistoryItem.fromMap(Map<String, dynamic> map) {
    return HistoryItem(
      equation: map['equation'] ?? '',
      result: map['result'] ?? '',
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }

  // To JSON string for SharedPreferences
  String toJson() => json.encode(toMap());

  // From JSON string
  factory HistoryItem.fromJson(String source) => HistoryItem.fromMap(json.decode(source));

  // Helper for displaying in list if needed
  String get displayString => "$equation = $result";
}
