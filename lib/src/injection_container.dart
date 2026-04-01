import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'data/repositories/breed_repository_impl.dart';
import 'domain/repositories/breed_repository.dart';
import 'domain/usecases/get_breeds.dart';
import 'presentation/blocs/breed_bloc.dart';
import 'presentation/blocs/fact_bloc.dart';

final sl = GetIt.instance; // sl = service locator

Future<void> init() async {
  // 1. External (Librerías externas)
  sl.registerLazySingleton(() => Dio());

  // 2. Repositories (Implementación y Contrato)
  sl.registerLazySingleton<BreedRepository>(() => BreedRepositoryImpl(sl()));

  // 3. Use Cases
  sl.registerLazySingleton(() => GetBreeds(sl()));

  // 4. BLoCs
  sl.registerFactory(() => BreedBloc(getBreedsUseCase: sl()));

  // 5. Registro del FactBloc
  sl.registerFactory(() => FactBloc(repository: sl()));
}
