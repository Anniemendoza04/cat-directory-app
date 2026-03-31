import '../entities/breed.dart';
import '../entities/cat_fact.dart';

abstract class BreedRepository {
  // para obtener la lista de razas de gatos y soporte de paginación
  Future<List<Breed>> getBreeds();

  // para obtener facts de gatos
  Future<CatFact> getRandomCatFact();
}
