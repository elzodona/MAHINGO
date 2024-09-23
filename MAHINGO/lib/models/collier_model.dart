class Collier {
  final int id;
  final String timestamp;
  final String batterie;
  final String position;
  final Temperature temperature;
  final Frequence frequence;
  final Localisation localisation;
  final String etat;

  Collier({
    required this.id,
    required this.timestamp,
    required this.batterie,
    required this.position,
    required this.temperature,
    required this.frequence,
    required this.localisation,
    required this.etat,
  });

  factory Collier.fromJson(Map<String, dynamic> json) {
    return Collier(
      id: json['id'],
      timestamp: json['timestamp'],
      batterie: json['batterie'],
      position: json['position'],
      temperature: Temperature.fromJson(json['température']),
      frequence: Frequence.fromJson(json['frequence']),
      localisation: Localisation.fromJson(json['localisation']),
      etat: json['etat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp,
      'batterie': batterie,
      'position': position,
      'température': temperature.toJson(),
      'frequence': frequence.toJson(),
      'localisation': localisation.toJson(),
      'etat': etat,
    };
  }
}

class Temperature {
  final String value;
  final String etat;

  Temperature({required this.value, required this.etat});

  factory Temperature.fromJson(Map<String, dynamic> json) {
    return Temperature(
      value: json['value'],
      etat: json['etat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'etat': etat,
    };
  }
}

class Frequence {
  final String value;
  final String etat;

  Frequence({required this.value, required this.etat});

  factory Frequence.fromJson(Map<String, dynamic> json) {
    return Frequence(
      value: json['value'],
      etat: json['etat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'etat': etat,
    };
  }
}

class Localisation {
  final String altitude;
  final String longitude;

  Localisation({required this.altitude, required this.longitude});

  factory Localisation.fromJson(Map<String, dynamic> json) {
    return Localisation(
      altitude: json['altitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'altitude': altitude,
      'longitude': longitude,
    };
  }
}

