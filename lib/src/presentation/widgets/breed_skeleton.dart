import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';

class BreedSkeleton extends StatelessWidget {
  const BreedSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(height: 120, color: Colors.white),
        ),
      ),
    );
  }
}
