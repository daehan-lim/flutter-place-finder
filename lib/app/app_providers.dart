import 'package:flutter_place_finder/data/repository/location_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final locationRepositoryProvider = Provider<LocationRepository>(
  (ref) => LocationRepositoryImpl(),
);