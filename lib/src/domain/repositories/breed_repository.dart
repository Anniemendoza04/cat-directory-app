import '../entities/breed.dart';

abstract class BreedRepository {
  // para obtener la lista de razas de gatos y soporte de paginación
  Future<List<Breed>> getBreeds();
}
