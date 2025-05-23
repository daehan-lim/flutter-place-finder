import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_place_finder/app/constants/app_constants.dart';
import 'package:flutter_place_finder/ui/pages/home/home_view_model.dart';
import 'package:flutter_place_finder/ui/pages/home/widgets/home_list_item.dart';
import 'package:flutter_place_finder/ui/widgets/error_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_providers.dart';
import '../../../app/constants/app_colors.dart';
import '../../../data/model/place.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchBarController = TextEditingController();

  @override
  void dispose() {
    searchBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final homeState = ref.watch(homeViewModelProvider);
        final homeViewModel = ref.read(homeViewModelProvider.notifier);
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: Colors.white, // iOS-style
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: _buildSearchBar(),
              titleSpacing: 0,
              toolbarHeight: 80,
              actionsPadding: EdgeInsets.only(right: 2),
              actions: [
                IconButton(
                  icon: const Icon(Icons.gps_fixed),
                  onPressed: () {
                    ref.read(searchTextProvider.notifier).state = AppConstants.currentLocationKeyword;
                    homeViewModel.fetchPlaces(AppConstants.currentLocationKeyword);
                  },
                ),
              ],
            ),
            body: homeState.when(
              loading:
                  () => const Center(
                    child: CupertinoActivityIndicator(radius: 20),
                  ),
              error:
                  (error, StackTrace _) => MessageLayout(
                    message: error.toString(),
                    imageUrl: 'assets/images/connection_error.png',
                  ),
              data: (state) {
                if (state.places.isEmpty) {
                  return MessageLayout(
                    message: '검색 결과가 없습니다',
                    imageUrl: 'assets/images/no_results.png',
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 5,
                    bottom: 100,
                  ),
                  itemCount: state.places.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final Place place = state.places[index];
                    return HomeListItem(place);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 3, top: 12, bottom: 12),
      child: Consumer(
        builder: (context, ref, child) {
          final viewModel = ref.read(homeViewModelProvider.notifier);
          final text = ref.watch(searchTextProvider);

          if (searchBarController.text != text) {
            searchBarController.text = text;
          }

          return TextField(
            controller: searchBarController,
            onChanged: (value) {
              ref.read(searchTextProvider.notifier).state = value;
            },
            onSubmitted: viewModel.fetchPlaces,
            style: const TextStyle(color: Colors.black, fontSize: 16.5),
            decoration: InputDecoration(
              hintStyle: TextStyle(
                color: Colors.black.withValues(alpha: 0.65),
                fontSize: 16,
              ),
              hintText: '장소 이름, 또는 주소를 입력해 주세요',
              contentPadding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 16,
              ),
              filled: true,
              fillColor: AppColors.lightGrey,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 7, right: 6),
                child: Icon(Icons.search, size: 21),
              ),
              suffixIcon:
                  text.isNotEmpty
                      ? IconButton(
                        iconSize: 21,
                        icon: const Icon(Icons.cancel_outlined),
                        onPressed: () {
                          ref.read(searchTextProvider.notifier).state = '';
                        },
                      )
                      : null,
            ),
          );
        },
      ),
    );
  }
}
