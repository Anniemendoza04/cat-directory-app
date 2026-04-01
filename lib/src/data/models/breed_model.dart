import '../../domain/entities/breed.dart';

class BreedModel extends Breed {
  BreedModel({
    required super.id,
    required super.breed,
    required super.country,
    required super.origin,
    required super.coat,
    required super.pattern,
  });

  factory BreedModel.fromJson(Map<String, dynamic> json) {
    final breedName = json['breed']?.toString() ?? 'Unknown';

    return BreedModel(
      // Generamos un ID único basado en el nombre para el Hero y la imagen
      id: breedName.toLowerCase().replaceAll(' ', '_'),
      breed: breedName,
      country: json['country']?.toString() ?? 'N/A',
      origin: json['origin']?.toString() ?? 'N/A',
      coat: json['coat']?.toString() ?? 'N/A',
      pattern: json['pattern']?.toString() ?? 'N/A',
    );
  }
}
