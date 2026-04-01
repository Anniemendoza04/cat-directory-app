import 'package:cat_directory_app/src/domain/entities/breed.dart';

enum BreedStatus { initial, loading, success, failure }

class BreedState {
  final BreedStatus status;
  final List<Breed> breeds; // lista acumulada
  final List<Breed> filteredBreeds; // Para búsqueda local
  final bool hasReachedMax; // Para saber si se han cargado todas las paginas
  final bool errorInNextPage;
  final String errorMessage;

  BreedState({
    this.status = BreedStatus.initial,
    this.breeds = const [],
    this.filteredBreeds = const [],
    this.hasReachedMax = false,
    this.errorInNextPage = false,
    this.errorMessage = '',
  });

  // metodo copywith para crear nuevas instancias del estado con cambios específicos
  BreedState copyWith({
    BreedStatus? status,
    List<Breed>? breeds,
    List<Breed>? filteredBreeds,
    bool? hasReachedMax,
    bool? errorInNextPage,
    String? errorMessage,
  }) {
    return BreedState(
      status: status ?? this.status,
      breeds: breeds ?? this.breeds,
      filteredBreeds: filteredBreeds ?? this.filteredBreeds,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
