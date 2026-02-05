import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../common/widgets/navigation/top_app_bar.dart';
import '../../common/widgets/cards/glass_card.dart';
import '../../common/widgets/buttons/primary_button.dart';

/// Insurance Hub screen
class InsuranceScreen extends StatefulWidget {
  const InsuranceScreen({super.key});

  @override
  State<InsuranceScreen> createState() => _InsuranceScreenState();
}

class _InsuranceScreenState extends State<InsuranceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppTopBar(
        title: 'Insurance Hub',
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: AppColors.textPrimary),
            onPressed: _showInsuranceGuide,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Coverage summary
          _CoverageSummaryCard(),
          const SizedBox(height: AppSpacing.lg),
          // Active policies
          Text(
            'Your Policies',
            style: AppTypography.titleLarge.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _PolicyCard(
            type: InsuranceType.health,
            provider: 'Star Health',
            policyNumber: 'SH2024XXXXXX',
            coverAmount: 500000,
            premium: 8500,
            renewalDate: 'Mar 15, 2025',
            status: PolicyStatus.active,
          ),
          _PolicyCard(
            type: InsuranceType.term,
            provider: 'HDFC Life',
            policyNumber: 'HDF2023XXXXXX',
            coverAmount: 5000000,
            premium: 12000,
            renewalDate: 'Jun 20, 2025',
            status: PolicyStatus.active,
          ),
          const SizedBox(height: AppSpacing.lg),
          // Recommended
          Text(
            'Recommended for You',
            style: AppTypography.titleLarge.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _RecommendedInsuranceCard(
            type: InsuranceType.vehicle,
            reason: 'You mentioned buying a new bike',
            estimatedPremium: '₹2,500/year',
          ),
          _RecommendedInsuranceCard(
            type: InsuranceType.travel,
            reason: 'For your upcoming Goa trip',
            estimatedPremium: '₹500/trip',
          ),
          const SizedBox(height: AppSpacing.lg),
          // Insurance score
          _InsuranceScoreCard(),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  void _showInsuranceGuide() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _InsuranceGuideSheet(),
    );
  }
}

enum InsuranceType { health, term, vehicle, travel, home }

enum PolicyStatus { active, expired, pendingRenewal }

class _CoverageSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Coverage',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹55 Lakhs',
                    style: AppTypography.displaySmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.success.withValues(alpha: 0.3),
                      AppColors.success.withValues(alpha: 0.1),
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.shield,
                    color: AppColors.success,
                    size: 32,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _CoverageStat(
                label: 'Health',
                value: '₹5L',
                icon: Icons.favorite,
                color: AppColors.error,
              ),
              _CoverageStat(
                label: 'Term Life',
                value: '₹50L',
                icon: Icons.person,
                color: AppColors.dusk500,
              ),
              _CoverageStat(
                label: 'Annual Premium',
                value: '₹20.5K',
                icon: Icons.payments,
                color: AppColors.warning,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CoverageStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _CoverageStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.titleSmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _PolicyCard extends StatelessWidget {
  final InsuranceType type;
  final String provider;
  final String policyNumber;
  final double coverAmount;
  final double premium;
  final String renewalDate;
  final PolicyStatus status;

  const _PolicyCard({
    required this.type,
    required this.provider,
    required this.policyNumber,
    required this.coverAmount,
    required this.premium,
    required this.renewalDate,
    required this.status,
  });

  IconData get _icon {
    switch (type) {
      case InsuranceType.health:
        return Icons.favorite;
      case InsuranceType.term:
        return Icons.person;
      case InsuranceType.vehicle:
        return Icons.directions_car;
      case InsuranceType.travel:
        return Icons.flight;
      case InsuranceType.home:
        return Icons.home;
    }
  }

  Color get _color {
    switch (type) {
      case InsuranceType.health:
        return AppColors.error;
      case InsuranceType.term:
        return AppColors.dusk500;
      case InsuranceType.vehicle:
        return AppColors.info;
      case InsuranceType.travel:
        return AppColors.sunset500;
      case InsuranceType.home:
        return AppColors.success;
    }
  }

  String get _typeName {
    switch (type) {
      case InsuranceType.health:
        return 'Health Insurance';
      case InsuranceType.term:
        return 'Term Life Insurance';
      case InsuranceType.vehicle:
        return 'Vehicle Insurance';
      case InsuranceType.travel:
        return 'Travel Insurance';
      case InsuranceType.home:
        return 'Home Insurance';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: status == PolicyStatus.active
              ? _color.withValues(alpha: 0.3)
              : AppColors.warning.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(_icon, color: _color),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _typeName,
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        provider,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(
                    'Active',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.darkSurface.withValues(alpha: 0.5),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(AppRadius.lg),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _PolicyStat(
                    label: 'Cover',
                    value: '₹${_formatAmount(coverAmount)}',
                  ),
                ),
                Expanded(
                  child: _PolicyStat(
                    label: 'Premium',
                    value: '₹${premium.toStringAsFixed(0)}/yr',
                  ),
                ),
                Expanded(
                  child: _PolicyStat(
                    label: 'Renewal',
                    value: renewalDate,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 10000000) {
      return '${(amount / 10000000).toStringAsFixed(0)} Cr';
    } else if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(0)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    }
    return amount.toStringAsFixed(0);
  }
}

class _PolicyStat extends StatelessWidget {
  final String label;
  final String value;

  const _PolicyStat({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _RecommendedInsuranceCard extends StatelessWidget {
  final InsuranceType type;
  final String reason;
  final String estimatedPremium;

  const _RecommendedInsuranceCard({
    required this.type,
    required this.reason,
    required this.estimatedPremium,
  });

  IconData get _icon {
    switch (type) {
      case InsuranceType.health:
        return Icons.favorite;
      case InsuranceType.term:
        return Icons.person;
      case InsuranceType.vehicle:
        return Icons.two_wheeler;
      case InsuranceType.travel:
        return Icons.flight;
      case InsuranceType.home:
        return Icons.home;
    }
  }

  String get _typeName {
    switch (type) {
      case InsuranceType.health:
        return 'Health Insurance';
      case InsuranceType.term:
        return 'Term Life Insurance';
      case InsuranceType.vehicle:
        return 'Vehicle Insurance';
      case InsuranceType.travel:
        return 'Travel Insurance';
      case InsuranceType.home:
        return 'Home Insurance';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.dusk500.withValues(alpha: 0.3),
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.dusk500.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(_icon, color: AppColors.dusk500),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _typeName,
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  reason,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'From $estimatedPremium',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.dusk500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

class _InsuranceScoreCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.dusk500.withValues(alpha: 0.3),
            AppColors.sunset500.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Center(
              child: Text(
                '72',
                style: AppTypography.headlineMedium.copyWith(
                  color: AppColors.dusk600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Insurance Score',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Good coverage! Add vehicle insurance to improve.',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }
}

class _InsuranceGuideSheet extends StatelessWidget {
  const _InsuranceGuideSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textMuted,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Insurance 101',
                  style: AppTypography.headlineSmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Understanding insurance made simple',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              children: const [
                _GuideItem(
                  emoji: '🏥',
                  title: 'Health Insurance',
                  description:
                      'Covers medical expenses. Essential for everyone. Get at least ₹5L cover.',
                ),
                _GuideItem(
                  emoji: '👤',
                  title: 'Term Life Insurance',
                  description:
                      'Pays your family if something happens to you. Get 10-15x annual income.',
                ),
                _GuideItem(
                  emoji: '🚗',
                  title: 'Vehicle Insurance',
                  description:
                      'Mandatory for all vehicles. Third-party is minimum, comprehensive is better.',
                ),
                _GuideItem(
                  emoji: '✈️',
                  title: 'Travel Insurance',
                  description:
                      'Covers trip cancellations, medical emergencies abroad. Get for international trips.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GuideItem extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;

  const _GuideItem({
    required this.emoji,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
