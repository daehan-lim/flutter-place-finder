import 'package:flutter_place_finder/app/app_providers.dart';
import 'package:flutter_place_finder/core/exceptions/data_exceptions.dart';
import 'package:flutter_place_finder/data/model/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeState {
  final List<Place> places;
  final double? lat;
  final double? lon;

  HomeState({required this.places, this.lat, this.lon});

  HomeState copyWith({List<Place>? places, double? lat, double? lon}) {
    return HomeState(
      places: places ?? this.places,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
    );
  }
}

class HomeViewModel extends Notifier<AsyncValue<HomeState>> {
  @override
  AsyncValue<HomeState> build() {
    return AsyncData(HomeState(places: []));
  }

  Future<void> fetchPlaces(String query) async {
    if (query.isEmpty) return;

    final locationRepository = ref.read(locationRepositoryProvider);
    // Safely extract current data without directly accessing .value
    HomeState currentData;
    if (state is AsyncData<HomeState>) {
      currentData = (state as AsyncData<HomeState>).value;
    } else {
      // Default empty state if we don't have data
      currentData = HomeState(places: []);
    }
    // Set to loading but preserve the previous data
    state = AsyncLoading<HomeState>().copyWithPrevious(state);
    try {
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
    } catch (e) {
      print(e);
      state = AsyncError('문제가 발생했습니다. 다시 시도해주세요.', StackTrace.current);
    }
  }
}

final homeViewModelProvider =
    NotifierProvider<HomeViewModel, AsyncValue<HomeState>>(HomeViewModel.new);
