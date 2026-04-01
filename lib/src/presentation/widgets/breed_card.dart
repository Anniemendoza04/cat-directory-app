import 'package:flutter/material.dart';
import '../../domain/entities/breed.dart';
import '../../domain/repositories/breed_repository.dart';
import '../../injection_container.dart'; // Para el service locator sl

class BreedCard extends StatelessWidget {
  final Breed breed;
  final VoidCallback onTap;

  const BreedCard({super.key, required this.breed, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // HERO PARA LA IMAGEN
              Hero(
                tag: 'breed-img-${breed.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: FutureBuilder<String?>(
                    // Buscamos la imagen real en TheCatAPI usando el nombre del breed
                    future: sl<BreedRepository>().getBreedImageUrl(breed.breed),
                    builder: (context, snapshot) {
                      // FALLBACK: Si no hay datos aún o falla, usamos Cataas con el ID para las fotos
                      final fallbackUrl =
                          'https://cataas.com/cat?seed=${breed.id}';
                      final finalUrl =
                          (snapshot.hasData && snapshot.data != null)
                          ? snapshot.data!
                          : fallbackUrl;

                      return Image.network(
                        finalUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return _PlaceholderContainer(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                              strokeWidth: 2,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) =>
                            const _PlaceholderContainer(
                              child: Icon(
                                Icons.pets,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // INFORMACIÓN DE LA RAZA
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      breed.breed,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _BreedInfoText(label: 'Country', value: breed.country),
                    _BreedInfoText(label: 'Origin', value: breed.origin),
                    _BreedInfoText(label: 'Coat', value: breed.coat),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget para los textos de info pequeña
class _BreedInfoText extends StatelessWidget {
  final String label;
  final String value;
  const _BreedInfoText({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$label: ${value.isNotEmpty ? value : 'N/A'}',
      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _PlaceholderContainer extends StatelessWidget {
  final Widget child;
  const _PlaceholderContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      color: Colors.grey[300],
      child: Center(child: child),
    );
  }
}
