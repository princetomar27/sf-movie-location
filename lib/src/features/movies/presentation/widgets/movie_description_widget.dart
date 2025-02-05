import 'package:flutter/material.dart';

import '../../../../core/colors/app_colors.dart';
import '../../domain/entities/movie_location.dart';

class MovieDescriptionWidget extends StatelessWidget {
  final MovieLocation movie;

  const MovieDescriptionWidget({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            spreadRadius: 2,
          )
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              movie.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            if (movie.releaseYear.isNotEmpty)
              Text("Year: ${movie.releaseYear}", style: _infoStyle()),
            if (movie.location != null)
              Text("Location: ${movie.location}", style: _infoStyle()),
            const SizedBox(height: 8),
            if (movie.director != null)
              Text("Director: ${movie.director}", style: _infoStyle()),
            if (movie.writer != null)
              Text("Writer: ${movie.writer}", style: _infoStyle()),
            const SizedBox(height: 8),
            if (movie.actors != null && movie.actors!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Actors:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimaryColor,
                    ),
                  ),
                  if (movie.actors != null) ...[
                    ...movie.actors!.map(
                      (actor) => Text(
                        actor,
                        style: _infoStyle(),
                      ),
                    ),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }

  TextStyle _infoStyle() => const TextStyle(
        color: AppColors.textPrimaryColor,
        fontSize: 14,
      );
}
