class Speciality {
  final String id;
  final String name;
  final String description;

  Speciality({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Speciality.fromJson(Map<String, dynamic> json) {
    return Speciality(
      id: json['id'],
      name: json['name'],
      description: (json['description']),
    );
  }

  String getName() {
    return name;
  }

  String getDes() {
    return description;
  }

  String getId() {
    return id;
  }
}
