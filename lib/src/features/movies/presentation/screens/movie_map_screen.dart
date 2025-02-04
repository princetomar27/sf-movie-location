import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../cubit/movie_location_cubit.dart';

class MovieMapScreen extends StatefulWidget {
  @override
  _MovieMapScreenState createState() => _MovieMapScreenState();
}

class _MovieMapScreenState extends State<MovieMapScreen> {
  final LatLng _sfCenter = const LatLng(37.7749, -122.4194);

  @override
  void initState() {
    super.initState();
    context.read<MovieLocationCubit>().fetchMovieLocations();
  }

  @override
  Widget build(BuildContext context) {
    final movieCubit = context.read<MovieLocationCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('SF Movie Locations')),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: movieCubit.searchController,
              decoration: InputDecoration(
                hintText: "Search movie locations...",
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (movie) {
                movieCubit.filterMovies();
              },
            ),
          ),
          // Display the map and results
          Expanded(
            child: BlocBuilder<MovieLocationCubit, MovieLocationState>(
              builder: (context, state) {
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
                      onMapCreated: movieCubit.onMapCreated,
                      markers: loadedState.markers,
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
