class Breed {
  final String id; // Nuevo campo para almacenar el ID de la raza
  final String breed;
  final String country;
  final String origin;
  final String coat;
  final String pattern;

  Breed({
    required this.id,
    required this.breed,
    required this.country,
    required this.origin,
    required this.coat,
    required this.pattern,
  });

  factory Breed.fromJson(Map<String, dynamic> json) {
    return Breed(
      id: json['id'] ?? '', // Parse the ID from API
      breed: json['name'] ?? '',
      country: json['country'] ?? '',
      origin: json['origin'] ?? '',
      coat: json['coat'] ?? '',
      pattern: json['pattern'] ?? '',
    );
  }
}
