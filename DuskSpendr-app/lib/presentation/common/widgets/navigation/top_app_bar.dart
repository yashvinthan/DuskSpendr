import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../buttons/icon_button.dart';

/// Custom app bar with gradient support and action buttons
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? titleWidget;
  final bool showBack;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final bool transparent;
  final bool centerTitle;
  final Widget? leading;

  const AppTopBar({
    super.key,
    this.title = '',
    this.titleWidget,
    this.showBack = true,
    this.onBack,
    this.actions,
    this.transparent = false,
    this.centerTitle = true,
    this.leading,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: transparent
          ? null
          : BoxDecoration(
              color: AppColors.darkBackground,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Row(
              children: [
                // Leading
                if (leading != null)
                  leading!
                else if (showBack)
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: AppColors.textPrimary,
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      if (onBack != null) {
                        onBack!();
                      } else {
                        Navigator.of(context).maybePop();
                      }
                    },
                  )
                else
                  const SizedBox(width: 48),

                // Title
                Expanded(
                  child: centerTitle
                      ? Center(
                          child: titleWidget ??
                              Text(
                                title,
                                style: AppTypography.h3.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                        )
                      : titleWidget ??
                          Text(
                            title,
                            style: AppTypography.h3.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                ),

                // Actions
                if (actions != null && actions!.isNotEmpty)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: actions!,
                  )
                else
                  const SizedBox(width: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom header with greeting and notification bell
class HomeHeader extends StatelessWidget {
  final String userName;
  final int notificationCount;
  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onSettingsTap;

  const HomeHeader({
    super.key,
    required this.userName,
    this.notificationCount = 0,
    this.onMenuTap,
    this.onNotificationTap,
    this.onSettingsTap,
  });

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenHorizontal,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            // Menu button
            AppIconButton(
              icon: Icons.menu,
              onPressed: onMenuTap,
              size: 44,
            ),
            const SizedBox(width: AppSpacing.sm),
            
            // Greeting
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$_greeting,',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        userName,
                        style: AppTypography.h3.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text('👋', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ],
              ),
            ),

            // Notification button
            AppIconButton(
              icon: Icons.notifications_outlined,
              onPressed: onNotificationTap,
              size: 44,
              badgeCount: notificationCount,
            ),
            const SizedBox(width: AppSpacing.sm),
            
            // Settings button
            AppIconButton(
              icon: Icons.settings_outlined,
              onPressed: onSettingsTap,
              size: 44,
            ),
          ],
        ),
      ),
    );
  }
}
