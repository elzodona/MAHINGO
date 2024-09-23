class Animal {
  final int id;
  final String libelle;

  Animal({
    required this.id,
    required this.libelle
  });

  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      id: json['id'],
      libelle: json['libelle']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'libelle': libelle
    };
  }
}
