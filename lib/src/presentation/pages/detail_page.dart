import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../domain/entities/breed.dart';
import '../blocs/fact_bloc.dart';
import '../../injection_container.dart';

class DetailPage extends StatelessWidget {
  final Breed breed;

  const DetailPage({super.key, required this.breed});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Creamos el bloc solo para esta pantalla y disparamos el evento
      create: (_) => sl<FactBloc>()..add(GetRandomFactStarted()),
      child: Scaffold(
        appBar: AppBar(title: Text(breed.breed)),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Hero(
                tag: breed.breed, // IMPORTANTE: El mismo tag que en la Card
                child: Material(
                  color: Colors.transparent,
                  child: _BreedHeader(
                    breed: breed,
                  ), // Tu widget con los datos grandes
                ),
              ),
              const Padding(padding: EdgeInsets.all(16.0), child: Divider()),
              const SizedBox(height: 10),
              // LOADING INDEPENDIENTE: Solo esta sección reacciona al FactBloc
              BlocBuilder<FactBloc, FactState>(
                builder: (context, state) {
                  if (state is FactLoading) {
                    return const _FactSkeleton(); // Shimmer específico para el dato
                  }
                  if (state is FactSuccess) {
                    return _FactCard(fact: state.fact);
                  }
                  return const Text('Could not load a cat fact right now.');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BreedHeader extends StatelessWidget {
  final Breed breed;
  const _BreedHeader({required this.breed});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Quitamos el alto fijo si lo tenías, o usamos uno más generoso
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1)),
      child: Column(
        mainAxisSize: MainAxisSize
            .min, // CLAVE: Que la columna solo ocupe lo que necesita
        children: [
          Text(
            breed.breed,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Usamos Wrap en lugar de Column para los detalles si quieres que se ajusten
          // O simplemente envolvemos la columna actual en un Flexible si fuera necesario
          _DetailText(label: 'Country', value: breed.country),
          _DetailText(label: 'Origin', value: breed.origin),
          _DetailText(label: 'Coat', value: breed.coat),
          _DetailText(label: 'Pattern', value: breed.pattern),
        ],
      ),
    );
  }
}

// Widget auxiliar para evitar repetición y manejar el overflow
class _DetailText extends StatelessWidget {
  final String label;
  final String value;
  const _DetailText({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        '$label: $value',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16),
        overflow: TextOverflow.ellipsis, // Si el texto es muy largo, pone "..."
        maxLines: 1,
      ),
    );
  }
}

class _FactSkeleton extends StatelessWidget {
  const _FactSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 100,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

// Define the missing _FactCard widget
class _FactCard extends StatelessWidget {
  final String fact;

  const _FactCard({required this.fact});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(padding: const EdgeInsets.all(16), child: Text(fact)),
    );
  }
}
