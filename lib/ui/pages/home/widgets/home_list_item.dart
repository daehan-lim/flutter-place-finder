import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_place_finder/core/utils/snackbar_util.dart';
import 'package:flutter_place_finder/ui/pages/web/place_web_page.dart';

import '../../../../app/constants/app_colors.dart';
import '../../../../core/services/map_launcher_service.dart';
import '../../../../data/model/place.dart';

class HomeListItem extends StatelessWidget {
  final Place place;

  const HomeListItem(this.place, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: AppColors.lightGrey,
      onTap: () {
        if (place.link.isEmpty) {
          SnackbarUtil.showSnackBar(context, '링크가 제공되지 않는 장소입니다');
          return;
        }
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => PlaceWebPage(place)));
      },
      child: Ink(
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
          child: Tooltip(
            preferBelow: true,
            message: location.address,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              location.address,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15.5,
                color: Colors.black.withValues(alpha: 0.85),
              ),
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
