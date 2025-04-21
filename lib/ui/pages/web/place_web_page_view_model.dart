import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceWebPageViewModel extends AutoDisposeNotifier<bool> {
  @override
  bool build() => true;

  void setLoading(bool value) {
    state = value;
  }
}

final placeWebPageViewModelProvider =
    NotifierProvider.autoDispose<PlaceWebPageViewModel, bool>(
      PlaceWebPageViewModel.new,
    );
