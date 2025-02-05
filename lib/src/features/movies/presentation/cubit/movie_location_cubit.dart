import 'dart:async';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:equatable/equatable.dart';
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
          filterMovies();
        }
      },
    );
  }

  /// Fetch movie locations from repository
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

  /// Filter movies based on search query
  void filterMovies() {
    if (state is MovieLocationLoaded) {
      final loadedState = state as MovieLocationLoaded;

      final filtered = loadedState.locations
          .where((movie) => movie.title
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();

      final markers = _generateMarkers(filtered);

      emit(loadedState.copyWith(
        locations: filtered,
        markers: markers,
      ));

      if (filtered.isNotEmpty) {
        _moveToLocation(filtered[0].latitude, filtered[0].longitude);
      }
    }
  }

  /// Generate Google Map markers for movie locations
  Set<Marker> _generateMarkers(List<MovieLocation> locations) {
    return locations.map((movie) {
      return Marker(
        markerId: MarkerId(movie.title),
        position: LatLng(movie.latitude, movie.longitude),
        onTap: () {
          _moveToLocation(movie.latitude, movie.longitude);
          customInfoWindowController.addInfoWindow!(
            MovieDescriptionWidget(movie: movie),
            LatLng(movie.latitude, movie.longitude),
          );
        },
      );
    }).toSet();
  }

  /// Update map markers
  void _updateMarkers(List<MovieLocation> locations) {
    final markers = _generateMarkers(locations);
    emit(MovieLocationLoaded(locations: locations, markers: markers));
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    customInfoWindowController.googleMapController = controller;
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
    customInfoWindowController.dispose();
    return super.close();
  }
}
