import 'dart:async';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/colors/app_colors.dart';
import '../../domain/entities/movie_location.dart';
import '../../domain/repositories/movie_repository.dart';
import '../widgets/movie_description_widget.dart';

part 'movie_location_state.dart';

class MovieLocationCubit extends Cubit<MovieLocationState> {
  final MovieRepository repository;
  late GoogleMapController _mapController;
  final CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();

  MovieLocationCubit(this.repository) : super(MovieLocationInitial()) {
    fetchMovieLocations();
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

  final LatLng sfCenter = const LatLng(37.7749, -122.4194);

  void autoSearchListener() {
    debounce?.cancel();
    debounce = Timer(
      const Duration(milliseconds: 500),
      () {
        filterMovies();
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
        _updateMarkers(filmLocations);
      },
    );
  }

  /// Filter movies from search query
  void filterMovies() {
    if (state is! MovieLocationLoaded) return;

    final loadedState = state as MovieLocationLoaded;
    final query = searchController.text.trim().toLowerCase();

    List<MovieLocation> filteredLocations;
    if (query.isEmpty) {
      filteredLocations = loadedState.allLocations;
    } else {
      filteredLocations = loadedState.allLocations
          .where((movie) => movie.title.toLowerCase().contains(query))
          .toList();
    }

    _updateMarkers(filteredLocations);
  }

  /// Show movie info. window for selected movie
  void _showMovieInfoWindows(MovieLocation tappedMovie) {
    if (state is! MovieLocationLoaded) return;

    final loadedState = state as MovieLocationLoaded;
    final sameMovieLocations = loadedState.allLocations
        .where((movie) => movie.title == tappedMovie.title)
        .toList();

    customInfoWindowController.hideInfoWindow!();

    final markersToShow = _generateMarkers(sameMovieLocations);

    emit(loadedState.copyWith(markers: markersToShow));
    _moveToLocation(
        sameMovieLocations.first.latitude, sameMovieLocations.first.longitude);
    if (!kIsWeb) {
      customInfoWindowController.addInfoWindow!(
        MovieDescriptionWidget(movie: tappedMovie),
        LatLng(tappedMovie.latitude, tappedMovie.longitude),
      );
    }
  }

  Set<Marker> _generateMarkers(List<MovieLocation> locations) {
    if (kIsWeb) {
      return locations.map((movie) {
        return Marker(
          markerId: MarkerId(movie.title +
              movie.latitude.toString() +
              movie.longitude.toString()),
          position: LatLng(movie.latitude, movie.longitude),
          onTap: () {
            _showMovieInfoWindows(movie);
          },
          infoWindow: InfoWindow(
            title: movie.title,
            snippet: "Year: ${movie.releaseYear}\nLocation: ${movie.location}",
          ),
        );
      }).toSet();
    } else {
      return locations.map((movie) {
        return Marker(
          markerId: MarkerId(movie.title +
              movie.latitude.toString() +
              movie.longitude.toString()),
          position: LatLng(movie.latitude, movie.longitude),
          onTap: () {
            _showMovieInfoWindows(movie);
          },
        );
      }).toSet();
    }
  }

  void _updateMarkers(List<MovieLocation> locations) {
    final markers = _generateMarkers(locations);
    if (state is MovieLocationLoaded) {
      final allLocations = (state as MovieLocationLoaded).allLocations;
      emit(MovieLocationLoaded(
          locations: locations, markers: markers, allLocations: allLocations));
    } else {
      emit(MovieLocationLoaded(
          locations: locations, markers: markers, allLocations: locations));
    }
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    customInfoWindowController.googleMapController = controller;
  }

  void clearSearchField() {
    if (isSearchEmpty) return;
    searchController.clear();
    customInfoWindowController.hideInfoWindow!();
    fetchMovieLocations();
  }

  void _moveToLocation(double lat, double lng, {double zoom = 12.0}) {
    final CameraPosition cameraPosition = CameraPosition(
      target: LatLng(lat, lng),
      zoom: zoom,
    );
    _mapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  Future<void> close() {
    debounce?.cancel();
    searchController.dispose();
    focusNode.dispose();
    customInfoWindowController.dispose();

    return super.close();
  }
}
