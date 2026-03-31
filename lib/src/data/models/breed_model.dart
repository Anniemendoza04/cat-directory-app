import '../../domain/entities/breed.dart';

class BreedModel extends Breed {
  const BreedModel({
    required super.breed,
    required super.country,
    required super.origin,
    required super.coat,
    required super.pattern,
  });

  factory BreedModel.fromJson(Map<String, dynamic> json) {
    return BreedModel(
      breed: json['breed'] ?? 'Unknown',
      country: json['country'] ?? 'Unknown',
      origin: json['origin'] ?? 'Unknown',
      coat: json['coat'] ?? 'Unknown',
      pattern: json['pattern'] ?? 'Unknown',
    );
  }
}
