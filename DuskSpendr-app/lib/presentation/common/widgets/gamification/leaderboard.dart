import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';

/// Leaderboard entry row
class LeaderboardEntry extends StatelessWidget {
  final int rank;
  final String name;
  final String? avatarUrl;
  final int score;
  final bool isCurrentUser;
  final VoidCallback? onTap;

  const LeaderboardEntry({
    super.key,
    required this.rank,
    required this.name,
    this.avatarUrl,
    required this.score,
    this.isCurrentUser = false,
    this.onTap,
  });

  Color? get _rankColor {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return null;
    }
  }

  IconData? get _rankIcon {
    switch (rank) {
      case 1:
        return Icons.emoji_events;
      case 2:
        return Icons.emoji_events;
      case 3:
        return Icons.emoji_events;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isCurrentUser
              ? AppColors.dusk500.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: isCurrentUser
              ? Border.all(color: AppColors.dusk500.withValues(alpha: 0.3))
              : null,
        ),
        child: Row(
          children: [
            // Rank
            SizedBox(
              width: 36,
              child: _rankIcon != null && _rankColor != null
                  ? Icon(_rankIcon, color: _rankColor, size: 24)
                  : Text(
                      '#$rank',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
            const SizedBox(width: AppSpacing.sm),
            // Avatar
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.darkCard,
                border: isCurrentUser
                    ? Border.all(color: AppColors.dusk500, width: 2)
                    : null,
              ),
              child: ClipOval(
                child: avatarUrl != null
                    ? Image.network(
                        avatarUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _defaultAvatar(),
                      )
                    : _defaultAvatar(),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // Name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: isCurrentUser
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  if (isCurrentUser)
                    Text(
                      'You',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.dusk500,
                      ),
                    ),
                ],
              ),
            ),
            // Score
            Text(
              score.toString(),
              style: AppTypography.titleMedium.copyWith(
                color: _rankColor ?? AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _defaultAvatar() {
    return Container(
      color: AppColors.dusk500.withValues(alpha: 0.3),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: AppTypography.titleMedium.copyWith(color: AppColors.dusk500),
        ),
      ),
    );
  }
}

/// Leaderboard widget with tabs
class Leaderboard extends StatelessWidget {
  final List<LeaderboardEntry> entries;
  final String title;
  final VoidCallback? onViewAll;

  const Leaderboard({
    super.key,
    required this.entries,
    this.title = 'Leaderboard',
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTypography.titleLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              if (onViewAll != null)
                GestureDetector(
                  onTap: onViewAll,
                  child: Text(
                    'View All',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.dusk500,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ...entries,
      ],
    );
  }
}
