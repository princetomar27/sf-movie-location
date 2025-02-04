import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sfmovie/src/features/movies/presentation/screens/movie_map_screen.dart';

import 'src/core/injector/service_locator.dart';
import 'src/features/movies/presentation/cubit/movie_location_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator(); // Initialize service locator

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MovieLocationCubit>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SF Movie Locations',
        home: MovieMapScreen(),
      ),
    );
  }
}
