import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/colors/app_colors.dart';
import '../../data/models/movie_location_model.dart';
import '../../domain/repositories/movie_repository.dart';

part 'movie_location_state.dart';

class MovieLocationCubit extends Cubit<MovieLocationState> {
  final MovieRepository repository;
  late GoogleMapController _mapController;

  MovieLocationCubit(this.repository) : super(MovieLocationInitial()) {
    addSearchListener();
  }

  final TextEditingController searchController = TextEditingController();
  bool get isSearchEmpty => searchController.text.trim().isEmpty;
  Timer? debounce;
  final FocusNode focusNode = FocusNode();

  Color get suffixIconColor =>
      isSearchEmpty ? AppColors.greyColor : AppColors.errorColor;

  void addSearchListener() {
    searchController.addListener(autoSearchListener);
  }

  void autoSearchListener() {
    debounce?.cancel();
    debounce = Timer(
      const Duration(milliseconds: 500),
      () {
        if (!isSearchEmpty) {
          filterMovies(); // Trigger filterMovies after debounce
        }
      },
    );
  }

  void fetchMovieLocations() async {
    emit(MovieLocationLoading());
    final locations = await repository.fetchMovieLocations();
    locations.fold(
      (failure) {
        emit(MovieLocationError(message: failure.message));
      },
      (filmLocations) {
        _updateMarkers(
          filmLocations
              .map(
                  (filmLocation) => MovieLocationModel.fromEntity(filmLocation))
              .toList(),
        );
      },
    );
  }

  void filterMovies() {
    if (state is MovieLocationLoaded) {
      final loadedState = state as MovieLocationLoaded;

      // Perform the filtering if there's a search term
      final filtered = loadedState.locations
          .where((movie) => movie.title
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();

      final markers = filtered
          .map(
            (movie) => Marker(
              markerId: MarkerId(movie.title),
              position: LatLng(
                movie.latitude ?? 0.0,
                movie.longitude ?? 0.0,
              ),
              infoWindow:
                  InfoWindow(title: movie.title, snippet: movie.location),
              onTap: () => _moveToLocation(
                  movie.latitude ?? 0.0, movie.longitude ?? 0.0),
            ),
          )
          .toSet();

      // Update the state with filtered results
      emit(loadedState.copyWith(
        locations: filtered,
        markers: markers,
      ));

      // Move camera to the first result in the filtered list
      if (filtered.isNotEmpty) {
        _moveToLocation(
            filtered[0].latitude ?? 0.0, filtered[0].longitude ?? 0.0);
      }
    }
  }

  void _updateMarkers(List<MovieLocationModel> locations) {
    final markers = locations
        .map(
          (movie) => Marker(
            markerId: MarkerId(movie.title),
            position: LatLng(
              movie.latitude ?? 0.0,
              movie.longitude ?? 0.0,
            ),
            infoWindow: InfoWindow(title: movie.title, snippet: movie.location),
            onTap: () =>
                _moveToLocation(movie.latitude ?? 0.0, movie.longitude ?? 0.0),
          ),
        )
        .toSet();

    emit(MovieLocationLoaded(locations: locations, markers: markers));
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void clearSearchField() {
    searchController.clear();

    fetchMovieLocations();
  }

  void _moveToLocation(double lat, double lng) {
    _mapController.animateCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));
  }

  @override
  Future<void> close() {
    searchController.dispose();
    focusNode.dispose();
    return super.close();
  }
}
