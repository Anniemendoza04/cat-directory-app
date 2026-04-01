abstract class BreedEvent {}

// carga inicial y refresh de breeds
class GetBreedsStarted extends BreedEvent {}

// para paginación: cargar la siguiente página de breeds
class GetBreedsNextPageRetrieved extends BreedEvent {}

//para filtrar breeds por nombre
class BreedListFiltered extends BreedEvent {
  final String query;
  BreedListFiltered(this.query);
}
