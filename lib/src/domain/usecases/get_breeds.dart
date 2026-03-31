import '../entities/breed.dart';
import '../repositories/breed_repository.dart';

class GetBreeds {
  final BreedRepository repository;

  GetBreeds(this.repository);

  Future<List<Breed>> call() async {
    return await repository.getBreeds();
  }
}
