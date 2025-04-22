import 'package:flutter_place_finder/app/app_providers.dart';
import 'package:flutter_place_finder/core/exceptions/data_exceptions.dart';
import 'package:flutter_place_finder/core/utils/geolocator_util.dart';
import 'package:flutter_place_finder/data/model/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../app/constants/app_constants.dart';

/// State class for the home screen.
///
/// Holds the list of places and in the future, additional attributes
class HomeState {
  final List<Place> places;

  HomeState({required this.places});

  /// Creates a copy of this state with optional new values.
  ///
  /// Parameters that are null will keep their current values.
  HomeState copyWith({List<Place>? places, double? lat, double? lon}) {
    return HomeState(places: places ?? this.places);
  }
}

/// ViewModel for the home screen that manages place data and search operations.
class HomeViewModel extends Notifier<AsyncValue<HomeState>> {
  @override
  AsyncValue<HomeState> build() {
    Future.microtask(() {
      fetchPlaces(AppConstants.currentLocationKeyword);
    });
    return AsyncData(HomeState(places: []));
  }

  /// Fetches places based on the provided query string.
  ///
  /// If the query starts with the current location keyword, it will get
  /// the user's current location and search for places in that district.
  /// Updates the state with loading, error, or success states during the process.
  ///
  /// [query] The search term to find places.
  Future<void> fetchPlaces(String query) async {
    if (query.isEmpty || state is AsyncLoading) return;

    // Safely extract current data without directly accessing .value
    HomeState currentData;
    if (state is AsyncData<HomeState>) {
      currentData = (state as AsyncData<HomeState>).value;
    } else {
      // Default empty state if we don't have data
      currentData = HomeState(places: []);
    }
    state = AsyncLoading();
    // await Future.delayed(Duration(seconds: 10));

    try {
      final locationRepository = ref.read(locationRepositoryProvider);
      if (query.startsWith(AppConstants.currentLocationKeyword)) {
        final String? district = await _getDistrictByLocation();
        if (district == null) {
          state = AsyncError(
            '위치를 불러올 수 없습니다. GPS나 위치 권한을 확인해 주세요',
            StackTrace.current,
          );
          return;
        }
        query = district;
        if (ref
            .read(searchTextProvider)
            .startsWith(AppConstants.currentLocationKeyword)) {
          ref.read(searchTextProvider.notifier).state =
              '${AppConstants.currentLocationKeyword} $district';
        }
      }

      final places = await locationRepository.searchPlaces(query);
      state = AsyncData(currentData.copyWith(places: places));
    } on ApiException catch (e) {
      print(e);
      state = AsyncError('서버에서 오류가 발생했습니다', StackTrace.current);
    } on NetworkException catch (e) {
      print(e.message);
      state = AsyncError(
        '네트워크에 연결할 수 없습니다.\n연결 상태를 확인하고 다시 시도해 주세요.',
        StackTrace.current,
      );
    } on EnvFileException catch (e) {
      print(e);
      state = AsyncError(AppConstants.envErrorMessage, StackTrace.current);
    } catch (e) {
      print(e);
      state = AsyncError('문제가 발생했습니다. 다시 시도해주세요.', StackTrace.current);
    }
  }

  /// Gets the district name for the current device location.
  ///
  /// Retrieves the current position using geolocation services,
  /// then uses the location repository to get the district name
  /// corresponding to those coordinates.
  ///
  /// Returns the district name as a string, or null if position not available.
  Future<String?> _getDistrictByLocation() async {
    final Position? position = await GeolocatorUtil.getPosition();
    if (position == null) {
      return null;
    }
    final locationRepository = ref.read(locationRepositoryProvider);
    return await locationRepository.getDistrictByLocation(
      position.longitude,
      position.latitude,
    );
  }
}

final homeViewModelProvider =
    NotifierProvider<HomeViewModel, AsyncValue<HomeState>>(HomeViewModel.new);
