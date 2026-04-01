import 'package:dio/dio.dart';
import '../../domain/entities/breed.dart';
import '../../domain/repositories/breed_repository.dart';
import '../models/breed_model.dart';
import '../models/cat_fact_model.dart';
import '../../domain/entities/cat_fact.dart';

class BreedRepositoryImpl implements BreedRepository {
  final Dio dio;

  BreedRepositoryImpl(this.dio);

  @override
  Future<List<Breed>> getBreeds({int page = 1}) async {
    try {
      final response = await dio.get('https://catfact.ninja/breeds?page=$page');

      if (response.statusCode == 200) {
        // OJO: catfact.ninja devuelve un objeto con una lista dentro de 'data'
        final List data = response.data['data'];
        return data.map((json) => BreedModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load breeds');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<String?> getBreedImageUrl(String breedName) async {
    try {
      // Buscamos la raza en TheCatAPI
      final response = await dio.get(
        'https://api.thecatapi.com/v1/breeds/search',
        queryParameters: {'q': breedName},
      );

      if (response.statusCode == 200 && (response.data as List).isNotEmpty) {
        final breedData = response.data[0];
        final imageId = breedData['reference_image_id'];
        if (imageId != null) {
          return 'https://cdn2.thecatapi.com/images/$imageId.jpg';
        }
      }
      return null; // Si no hay imagen, devuelve null para activar el fallback
    } catch (_) {
      return null; // ante cualquier error, fallback
    }
  }

  @override
  Future<CatFact> getRandomCatFact() async {
    try {
      final response = await dio.get('https://catfact.ninja/fact');
      return CatFactModel.fromJson(response.data) as CatFact;
    } on DioException catch (e) {
      // se manejan fallos de red:
      throw Exception('Failed to load cat fact: ${e.message}');
    }
  }
}
