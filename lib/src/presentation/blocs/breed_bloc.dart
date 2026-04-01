import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import '../../domain/usecases/get_breeds.dart';
import 'breed_event.dart';
import 'breed_state.dart';

class BreedBloc extends Bloc<BreedEvent, BreedState> {
  final GetBreeds getBreedsUseCase;
  int _currentPage = 1;
  String _searchQuery = '';

  BreedBloc({required this.getBreedsUseCase}) : super(BreedState()) {
    // uso de droppable para ignorar scrolls rapidos mientras carga
    on<GetBreedsNextPageRetrieved>(
      _onNextPageRetrieved,
      transformer: droppable(),
    );

    on<GetBreedsStarted>(_onStarted);
    on<BreedListFiltered>(_onFiltered);
  }

  Future<void> _onStarted(
    GetBreedsStarted event,
    Emitter<BreedState> emit,
  ) async {
    _currentPage = 1;
    _searchQuery = '';
    emit(state.copyWith(status: BreedStatus.loading, errorInNextPage: false));
    try {
      final breeds = await getBreedsUseCase(page: _currentPage);
      emit(
        state.copyWith(
          status: BreedStatus.success,
          breeds: breeds,
          filteredBreeds: breeds,
          hasReachedMax: breeds.isEmpty,
          errorInNextPage: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: BreedStatus.failure,
          errorMessage: e.toString(),
          errorInNextPage: false,
        ),
      );
    }
  }

  Future<void> _onNextPageRetrieved(
    GetBreedsNextPageRetrieved event,
    Emitter<BreedState> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      _currentPage++;
      final newBreeds = await getBreedsUseCase(page: _currentPage);

      if (newBreeds.isEmpty) {
        emit(state.copyWith(hasReachedMax: true, errorInNextPage: false));
        return;
      }

      final updatedBreeds = List.of(state.breeds)..addAll(newBreeds);

      final updatedFiltered = _searchQuery.isEmpty
          ? updatedBreeds
          : updatedBreeds
                .where(
                  (b) => b.breed.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ),
                )
                .toList();

      emit(
        state.copyWith(
          status: BreedStatus.success,
          breeds: updatedBreeds,
          filteredBreeds: updatedFiltered,
          hasReachedMax: false,
          errorInNextPage: false,
        ),
      );
    } catch (e) {
      _currentPage--;
      emit(
        state.copyWith(
          status: BreedStatus.success,
          errorInNextPage: true,
          errorMessage: 'Error cargando más razas: ${e.toString()}',
        ),
      );
    }
  }

  void _onFiltered(BreedListFiltered event, Emitter<BreedState> emit) {
    _searchQuery = event.query.toLowerCase();
    final filtered = state.breeds
        .where((b) => b.breed.toLowerCase().contains(_searchQuery))
        .toList();
    emit(state.copyWith(filteredBreeds: filtered, errorInNextPage: false));
  }
}
