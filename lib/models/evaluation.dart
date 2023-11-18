class Evaluation {
  final String id;
  final String label;
  final DateTime date;
  final String specId;
  final String levelId;
  final String grpId;
  final String subjectId;
  final String formId;
  final int? A;
  final int? B;
  final int? C;
  final int? D;
  final int? E;

  Evaluation({
    required this.label,
    required this.id,
    required this.formId,
    required this.date,
    required this.specId,
    required this.levelId,
    required this.grpId,
    this.A,
    this.B,
    this.C,
    this.D,
    this.E,
    required this.subjectId,
  });

  factory Evaluation.fromJson(Map<String, dynamic> json) {
    return Evaluation(
      id: json['id'],
      label: json['label'],
      formId: json['formId'],
      date: json['date'].toDate(),
      specId: json['specId'],
      levelId: json['levelId'],
      grpId: json['grpId'],
      A: json['A'],
      B: json['B'],
      C: json['C'],
      D: json['D'],
      E: json['E'],
      subjectId: json['subjectId'],
    );
  }
}
