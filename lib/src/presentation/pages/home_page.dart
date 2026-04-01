import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../injection_container.dart' as di;
import '../blocs/breed_bloc.dart';
import '../blocs/breed_state.dart';
import '../blocs/breed_event.dart';
import '../widgets/breed_card.dart';
import '../widgets/breed_skeleton.dart';
import 'detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<BreedBloc>()..add(GetBreedsStarted()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cat Breeds')),
      body: Column(
        children: [
          // 🔍 Buscador
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search breeds...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onChanged: (query) =>
                  context.read<BreedBloc>().add(BreedListFiltered(query)),
            ),
          ),

          // 📋 Lista
          Expanded(
            child: BlocBuilder<BreedBloc, BreedState>(
              builder: (context, state) {
                if (state.status == BreedStatus.loading) {
                  return const BreedSkeleton();
                }

                if (state.status == BreedStatus.failure &&
                    state.breeds.isEmpty) {
                  return Center(child: Text(state.errorMessage));
                }

                final breeds = state.filteredBreeds;

                return RefreshIndicator(
                  onRefresh: () async =>
                      context.read<BreedBloc>().add(GetBreedsStarted()),
                  child: ListView.builder(
                    itemCount: state.hasReachedMax
                        ? breeds.length
                        : breeds.length + 1,
                    itemBuilder: (context, index) {
                      if (index >= breeds.length) {
                        if (state.errorInNextPage) {
                          return TextButton(
                            onPressed: () => context.read<BreedBloc>().add(
                              GetBreedsNextPageRetrieved(),
                            ),
                            child: const Text('Error. Retry?'),
                          );
                        }

                        context.read<BreedBloc>().add(
                          GetBreedsNextPageRetrieved(),
                        );

                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      return BreedCard(
                        breed: breeds[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailPage(breed: breeds[index]),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
