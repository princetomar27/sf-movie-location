import 'package:custom_info_window/custom_info_window.dart';
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
          BlocBuilder<MovieLocationCubit, MovieLocationState>(
            builder: (context, state) {
              final movieLocationCubit = context.read<MovieLocationCubit>();
              return Padding(
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
              );
            },
          ),
          Expanded(
            child: BlocBuilder<MovieLocationCubit, MovieLocationState>(
              builder: (context, state) {
                final movieLocationCubit = context.read<MovieLocationCubit>();

                if (state is MovieLocationLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MovieLocationError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else if (state is MovieLocationLoaded) {
                  return Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition:
                            CameraPosition(target: _sfCenter, zoom: 12),
                        onMapCreated: movieLocationCubit.onMapCreated,
                        markers: state.markers,
                        onTap: (_) => movieLocationCubit
                            .customInfoWindowController.hideInfoWindow!(),
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        margin: EdgeInsets.symmetric(vertical: 16),
                        child: CustomInfoWindow(
                          controller:
                              movieLocationCubit.customInfoWindowController,
                          offset: 80,
                          width: 200,
                          height: 150,
                        ),
                      ),
                    ],
                  );
                } else {
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
