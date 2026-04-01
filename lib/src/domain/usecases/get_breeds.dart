import '../entities/breed.dart';
import '../repositories/breed_repository.dart';

class GetBreeds {
  final BreedRepository repository;

  GetBreeds(this.repository);

  Future<List<Breed>> call({int page = 1}) async {
    return await repository.getBreeds(page: page);
  }
}
