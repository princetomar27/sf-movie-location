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
