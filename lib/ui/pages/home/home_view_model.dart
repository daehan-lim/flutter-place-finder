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
    final locationRepository = ref.read(locationRepositoryProvider);
    final previousState = state;
    state = AsyncLoading();
    try {
      final places = await locationRepository.searchPlaces(query);
      final currentData = previousState.value ?? HomeState(places: []);
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
    } /*catch (_) {
      state = AsyncError('문제가 발생했습니다. 다시 시도해주세요.', StackTrace.current);
    }*/
  }
}

final homeViewModelProvider =
    NotifierProvider<HomeViewModel, AsyncValue<HomeState>>(HomeViewModel.new);
