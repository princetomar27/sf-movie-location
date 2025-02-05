import 'package:flutter/material.dart';

import '../../../../core/colors/app_colors.dart';
import '../../domain/entities/movie_location.dart';

class MovieDescriptionWidget extends StatelessWidget {
  final MovieLocation movie;

  const MovieDescriptionWidget({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            movie.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text("Year: ${movie.releaseYear}"),
          Text("Location: ${movie.location}"),
        ],
      ),
    );
  }
}
