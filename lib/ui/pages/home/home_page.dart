import 'package:flutter/material.dart';
import 'package:flutter_place_finder/app/constants/app_constants.dart';

import '../../../data/model/location_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // iOS-style
      appBar: AppBar(title: const Text('장소 목록')),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: AppConstants.sampleLocations.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final LocationModel location = AppConstants.sampleLocations[index];
          return _buildListItem(location);
        },
      ),
    );
  }

  Container _buildListItem(LocationModel location) {
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
            location.title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            location.category,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 6),
          _buildAddressRow(location),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _actionButton(
                icon: Icons.map_outlined,
                label: '지도 보기',
                onTap: () => {}, // MapLauncherService.openLocationInMaps(location.roadAddress),
              ),
              const SizedBox(width: 8),
              _actionButton(
                icon: Icons.directions_outlined,
                label: '길찾기',
                onTap: () => print('길찾기: ${location.roadAddress}'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Row _buildAddressRow(LocationModel location) {
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
                location.roadAddress,
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
  }) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18, color: Colors.blueAccent),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.blueAccent,
          fontWeight: FontWeight.w500,
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
