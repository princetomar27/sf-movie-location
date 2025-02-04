import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/movie_location_cubit.dart';

class MovieMapScreen extends StatefulWidget {
  @override
  _MovieMapScreenState createState() => _MovieMapScreenState();
}

class _MovieMapScreenState extends State<MovieMapScreen> {
  late GoogleMapController _mapController;
  final LatLng _sfCenter = LatLng(37.7749, -122.4194);

  @override
  void initState() {
    super.initState();
    context.read<MovieLocationCubit>().fetchMovieLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SF Movie Locations')),
      body: BlocBuilder<MovieLocationCubit, MovieLocationState>(
        builder: (context, state) {
          if (state is MovieLocationLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is MovieLocationError) {
            return Center(child: Text(state.message));
          } else if (state is MovieLocationLoaded) {
            Set<Marker> markers = state.locations
                .map((movie) => Marker(
                      markerId: MarkerId(movie.title),
                      position: LatLng(movie.latitude, movie.longitude),
                      infoWindow: InfoWindow(
                          title: movie.title, snippet: movie.location),
                    ))
                .toSet();

            return GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: _sfCenter, zoom: 12),
              onMapCreated: (controller) => _mapController = controller,
              markers: markers,
            );
          }
          return Container();
        },
      ),
    );
  }
}
