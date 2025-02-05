import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../cubit/movie_location_cubit.dart';

class MovieMapScreen extends StatelessWidget {
  const MovieMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SF Movie Locations')),
      body: BlocBuilder<MovieLocationCubit, MovieLocationState>(
        builder: (context, state) {
          final movieLocationCubit = context.read<MovieLocationCubit>();

          switch (state) {
            case MovieLocationLoading():
              return const Center(child: CircularProgressIndicator());

            case MovieLocationError():
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              );

            case MovieLocationLoaded():
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: movieLocationCubit.searchController,
                      focusNode: movieLocationCubit.focusNode,
                      decoration: InputDecoration(
                        hintText: "Search movie locations...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            movieLocationCubit.clearSearchField();
                          },
                          child: Icon(
                            Icons.close,
                            color: movieLocationCubit.suffixIconColor,
                          ),
                        ),
                      ),
                      onChanged: (movie) {
                        movieLocationCubit.filterMovies();
                      },
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        // Google Map Widget
                        GoogleMap(
                          initialCameraPosition: CameraPosition(
                              target: movieLocationCubit.sfCenter, zoom: 12),
                          onMapCreated: movieLocationCubit.onMapCreated,
                          markers: state.markers,
                          onTap: (_) => movieLocationCubit
                              .customInfoWindowController.hideInfoWindow!(),
                        ),

                        // Custom Info Window
                        CustomInfoWindow(
                          controller:
                              movieLocationCubit.customInfoWindowController,
                          offset: 30,
                          width: 250,
                          height: 200,
                        ),
                      ],
                    ),
                  ),
                ],
              );

            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
