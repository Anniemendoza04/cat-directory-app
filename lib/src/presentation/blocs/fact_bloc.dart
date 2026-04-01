import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/breed_repository.dart';

// Eventos
abstract class FactEvent {}

class GetRandomFactStarted extends FactEvent {}

// Estados
abstract class FactState {}

class FactInitial extends FactState {}

class FactLoading
    extends
        FactState {} // Estado de carga, se puede usar para mostrar un indicador de progreso (se uso shimmer)

class FactSuccess extends FactState {
  final String fact;
  FactSuccess(this.fact);
}

class FactFailure extends FactState {}

class FactBloc extends Bloc<FactEvent, FactState> {
  final BreedRepository repository;
  FactBloc({required this.repository}) : super(FactInitial()) {
    on<GetRandomFactStarted>((event, emit) async {
      emit(FactLoading());
      try {
        final catFact = await repository.getRandomCatFact();
        emit(FactSuccess(catFact.fact));
      } catch (_) {
        emit(FactFailure());
      }
    });
  }
}
