import 'package:flutter/material.dart';

enum SnackBarMode { success, failure, warning, info }

void showGlobalSnackbar(
  BuildContext context, {
  required String title,
  required SnackBarMode mode,
  String? subtitle,
  int duration = 3,
  Widget? actionWidget,
}) {
  final trimmedSubtitle = subtitle?.trim();
  final hasSubtitle =
      trimmedSubtitle != null && trimmedSubtitle.isNotEmpty;

  final messenger = ScaffoldMessenger.maybeOf(context);

  final palette = _palette(mode);
  final backgroundColor = _backgroundColor(mode);

  final theme = Theme.of(context);

  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
    elevation: 8,
    backgroundColor: backgroundColor,
    duration: Duration(seconds: duration),
    showCloseIcon: false,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
      side: BorderSide(
        color: palette.primary.withValues(alpha: 0.12),
      ),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 14,
    ),
    content: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: palette.iconBackground,
          ),
          child: Icon(
            _iconByMode(mode),
            size: 25,
            color: palette.icon,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: palette.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              if (hasSubtitle) ...[
                const SizedBox(height: 3),
                Text(
                  trimmedSubtitle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(
                        color: palette.secondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 8),
        actionWidget != null
            ? InkWell(
                borderRadius: BorderRadius.circular(99),
                onTap: () =>
                    messenger?.hideCurrentSnackBar(),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.close_rounded,
                    size: 40,
                    color: palette.primary,
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    ),
  );

  messenger
    ?..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

Color _backgroundColor(SnackBarMode mode) {
  switch (mode) {
    case SnackBarMode.success:
      return const Color(0xFF0E8F3A);
    case SnackBarMode.failure:
      return const Color(0xFFD9364D);
    case SnackBarMode.warning:
      return const Color(0xFFFFC247);
    case SnackBarMode.info:
      return const Color(0xFFB9DBFF);
  }
}

({
  Color primary,
  Color secondary,
  Color icon,
  Color iconBackground,
})
_palette(SnackBarMode mode) {
  switch (mode) {
    case SnackBarMode.success:
      return (
        primary: Colors.white,
        secondary: Colors.white.withValues(alpha: 0.95),
        icon: Colors.white,
        iconBackground: Colors.white.withValues(
          alpha: 0.20,
        ),
      );
    case SnackBarMode.failure:
      return (
        primary: Colors.white,
        secondary: Colors.white.withValues(alpha: 0.95),
        icon: Colors.white,
        iconBackground: Colors.white.withValues(
          alpha: 0.22,
        ),
      );
    case SnackBarMode.warning:
      return (
        primary: const Color(0xFF4F2A00),
        secondary: const Color(
          0xFF4F2A00,
        ).withValues(alpha: 0.95),
        icon: const Color(0xFF7A3E00),
        iconBackground: Colors.white.withValues(
          alpha: 0.35,
        ),
      );
    case SnackBarMode.info:
      return (
        primary: const Color(0xFF0E2D63),
        secondary: const Color(
          0xFF0E2D63,
        ).withValues(alpha: 0.92),
        icon: const Color(0xFF2F95FF),
        iconBackground: Colors.white.withValues(
          alpha: 0.35,
        ),
      );
  }
}

IconData _iconByMode(SnackBarMode mode) {
  switch (mode) {
    case SnackBarMode.success:
      return Icons.check_rounded;
    case SnackBarMode.failure:
      return Icons.error_rounded;
    case SnackBarMode.warning:
      return Icons.warning_rounded;
    case SnackBarMode.info:
      return Icons.info_rounded;
  }
}
