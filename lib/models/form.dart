class Forms {
  final String label;
  final String id;
  final DateTime date;

  Forms({required this.label, required this.id, required this.date});

  factory Forms.fromJson(Map<String, dynamic> json) {
    return Forms(
      label: json["label"],
      id: json["id"],
      date: json["date"].toDate(),
    );
  }
}
