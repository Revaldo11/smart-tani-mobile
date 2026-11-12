import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smart_tani_mobile/core/theme/app_colors.dart';
import 'package:smart_tani_mobile/core/theme/app_spacing.dart';
import 'package:smart_tani_mobile/widget/text_widget.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    required this.avatarUrl,
    required this.onNotificationTap,
    super.key,
  });

  final String? avatarUrl;
  final VoidCallback onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.eco,
          color: AppColors.primary,
          size: 40,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WidgetText(
                text: 'Smart Tani',
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
              WidgetText(
                text:
                    'Bersama Petani, Menuju Panen Lebih Baik',
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
                color: AppColors.textPrimary,
                fontSize: 10,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Material(
          color: AppColors.surface,
          shape: const CircleBorder(),
          child: IconButton(
            tooltip: 'Notifikasi',
            onPressed: onNotificationTap,
            icon: const Icon(Icons.notifications_none),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        _Avatar(url: avatarUrl),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    const fallback = Icon(
      Icons.person,
      color: AppColors.primary,
    );

    return CircleAvatar(
      radius: 22,
      backgroundColor: AppColors.primaryLight,
      child: url == null
          ? fallback
          : ClipOval(
              child: CachedNetworkImage(
                imageUrl: url!,
                width: 44,
                height: 44,
                fit: BoxFit.cover,
                placeholder: (_, _) => fallback,
                errorWidget: (_, _, _) => fallback,
              ),
            ),
    );
  }
}
