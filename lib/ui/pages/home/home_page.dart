import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_place_finder/app/constants/app_constants.dart';
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
            return _buildListItem(place);
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

  Container _buildListItem(Place place) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            place.title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            place.category,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 6),
          _buildAddressRow(place),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _actionButton(
                icon: Icons.map_outlined,
                label: '지도 보기',
                onTap: () => MapLauncherService.openInMap(place.address),
              ),
              const SizedBox(width: 8),
              _actionButton(
                icon: Icons.directions_outlined,
                label: '길찾기',
                isLoading: false,
                onTap: () => print('길찾기: ${place.address}'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Row _buildAddressRow(Place location) {
    return Row(
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 16,
          color: Colors.black.withValues(alpha: 0.8),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            location.address,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black.withValues(alpha: 0.8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isLoading = false,
  }) {
    return TextButton.icon(
      onPressed: isLoading ? null : onTap,
      icon:
          isLoading
              ? const SizedBox(
                width: 16,
                height: 16,
                child: CupertinoActivityIndicator(color: Colors.blueAccent),
              )
              : Icon(icon, size: 18, color: Colors.blueAccent),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 14.5,
          color: Colors.blueAccent,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        backgroundColor: Colors.blue.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
