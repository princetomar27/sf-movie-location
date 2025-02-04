import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

import '../../features/movies/data/datasource/movie_remote_data_source.dart';
import '../../features/movies/data/repositories/movie_repository_impl.dart';
import '../../features/movies/domain/repositories/movie_repository.dart';
import '../../features/movies/domain/usecases/get_movie_locations.dart';
import '../../features/movies/presentation/cubit/movie_location_cubit.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  // Load environment variables
  await dotenv.load();

  // Register Dio (HTTP Client)
  sl.registerLazySingleton<Dio>(() => Dio());

  // Register Data Source
  registerDataSources();

  // Register Repository
  registerRepositories();

  // Register Use Case
  registerUseCases();

  // Register Cubit
  registerCubits();
}

void registerDataSources() {
  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSource(
      sl<Dio>(),
    ),
  );
}

void registerRepositories() {
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      sl<MovieRemoteDataSource>(),
    ),
  );
}

void registerUseCases() {
  sl.registerLazySingleton<GetMovieLocationsUsecase>(
    () => GetMovieLocationsUsecase(
      repository: sl<MovieRepository>(),
    ),
  );
}

void registerCubits() {
  sl.registerFactory(
    () => MovieLocationCubit(
      sl(),
    ),
  );
}
