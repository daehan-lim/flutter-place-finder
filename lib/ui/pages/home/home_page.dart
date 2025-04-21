import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_place_finder/app/constants/app_constants.dart';
import 'package:flutter_place_finder/ui/pages/home/widgets/home_list_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_providers.dart';
import '../../../core/services/map_launcher_service.dart';
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white, // iOS-style
        appBar: AppBar(
          title: _buildSearchBar(),
          titleSpacing: 0,
          actionsPadding: EdgeInsets.only(right: 2),
          actions: [
            IconButton(icon: const Icon(Icons.gps_fixed), onPressed: () {}),
          ],
        ),
        body: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          itemCount: AppConstants.samplePlaces.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final Place place = AppConstants.samplePlaces[index];
            return HomeListItem(place);
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 3),
      child: Consumer(
        builder: (context, ref, child) {
          final text = ref.watch(searchTextProvider);
          return TextField(
            controller: searchBarController,
            onChanged: (value) {
              ref.read(searchTextProvider.notifier).state = value;
            },
            decoration: InputDecoration(
              hintText: '장소 이름, 또는 주소를 입력해 주세요',
              contentPadding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 16,
              ),
              filled: true,
              fillColor: Color(0XFFF1F2F1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              suffixIcon:
                  text.isNotEmpty
                      ? IconButton(
                        iconSize: 21,
                        icon: const Icon(Icons.cancel_outlined),
                        onPressed: () {
                          searchBarController.clear();
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
