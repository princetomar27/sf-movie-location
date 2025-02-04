import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../cubit/movie_location_cubit.dart';

class MovieMapScreen extends StatelessWidget {
  final LatLng _sfCenter = const LatLng(37.7749, -122.4194);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SF Movie Locations')),
      body: Column(
        children: [
          // Search bar to filter locations
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<MovieLocationCubit, MovieLocationState>(
              builder: (context, state) {
                final movieLocationCubit = context.read<MovieLocationCubit>();
                return TextFormField(
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
                );
              },
            ),
          ),

          // Google Map to display locations and markers
          Expanded(
            child: BlocBuilder<MovieLocationCubit, MovieLocationState>(
              builder: (context, state) {
                final movieLocationCubit = context.read<MovieLocationCubit>();
                switch (state.runtimeType) {
                  case MovieLocationLoading:
                    return const Center(child: CircularProgressIndicator());
                  case MovieLocationError:
                    final errorState = state as MovieLocationError;
                    return Center(
                      child: Text(
                        errorState.message,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    );
                  case MovieLocationLoaded:
                    final loadedState = state as MovieLocationLoaded;
                    return GoogleMap(
                      initialCameraPosition:
                          CameraPosition(target: _sfCenter, zoom: 12),
                      onMapCreated: movieLocationCubit.onMapCreated,
                      markers: loadedState.markers, // Display filtered markers
                      onCameraMove: (position) {
                        // Optional: Handle camera movement if needed.
                      },
                    );
                  default:
                    return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
