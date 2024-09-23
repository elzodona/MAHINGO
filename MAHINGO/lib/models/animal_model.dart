class Animal {
  final int id;
  final String name;
  final String sexe;
  final String date_birth;
  final String photo;
  final String race;
  final String poids;
  final String taille;
  final int categorie_id;
  final int collier_id;

  Animal({
    required this.id,
    required this.name,
    required this.sexe,
    required this.date_birth,
    required this.photo,
    required this.race,
    required this.poids,
    required this.taille,
    required this.categorie_id,
    required this.collier_id,
  });

  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      id: json['id'],
      name: json['name'],
      sexe: json['sexe'],
      date_birth: json['date_birth'],
      photo: json['photo'],
      race: json['race'],
      poids: json['poids'],
      taille: json['taille'],
      categorie_id: json['categorie_id'],
      collier_id: json['collier_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sexe': sexe,
      'date_birth': date_birth,
      'photo': photo,
      'race': race,
      'poids': poids,
      'taille': taille,
      'categorie_id': categorie_id,
      'collier_id': collier_id,
    };
  }
}
