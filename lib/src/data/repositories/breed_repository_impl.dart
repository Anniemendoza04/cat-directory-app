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
  Future<List<Breed>> getBreeds() async {
    try {
      final response = await dio.get('https://catfact.ninja/breeds');

      // La API devuelve los datos dentro de una lista 'data'
      final List<dynamic> data = response.data['data'];

      return data.map((json) => BreedModel.fromJson(json)).toList();
    } on DioException catch (e) {
      // se manejan fallos de red:
      throw Exception('Error al cargar razas: ${e.message}');
    }
  }

  @override
  Future<CatFact> getRandomCatFact() async {
    try {
      final response = await dio.get('https://catfact.ninja/fact');
      return CatFactModel.fromJson(response.data) as CatFact;
    } on DioException catch (e) {
      // se manejan fallos de red:
      throw Exception('Error al cargar el dato curioso: ${e.message}');
    }
  }
}
