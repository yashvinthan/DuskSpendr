import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../common/widgets/navigation/top_app_bar.dart';

/// Settings screen
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: const AppTopBar(title: 'Settings'),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Account section
          _SettingsSection(
            title: 'Account',
            children: [
              _SettingsTile(
                icon: Icons.person_outline,
                title: 'Edit Profile',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.lock_outline,
                title: 'Security & Privacy',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.account_balance_outlined,
                title: 'Linked Accounts',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          // Preferences
          _SettingsSection(
            title: 'Preferences',
            children: [
              _SettingsToggle(
                icon: Icons.notifications_outlined,
                title: 'Push Notifications',
                value: true,
                onChanged: (value) {},
              ),
              _SettingsToggle(
                icon: Icons.dark_mode_outlined,
                title: 'Dark Mode',
                value: true,
                onChanged: (value) {},
              ),
              _SettingsTile(
                icon: Icons.language,
                title: 'Language',
                trailing: 'English',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.currency_rupee,
                title: 'Currency',
                trailing: 'INR (₹)',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          // Privacy
          _SettingsSection(
            title: 'Privacy',
            children: [
              _SettingsToggle(
                icon: Icons.fingerprint,
                title: 'Biometric Lock',
                value: true,
                onChanged: (value) {},
              ),
              _SettingsToggle(
                icon: Icons.visibility_off_outlined,
                title: 'Hide Balances',
                value: false,
                onChanged: (value) {},
              ),
              _SettingsTile(
                icon: Icons.download_outlined,
                title: 'Export Data',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.delete_outline,
                title: 'Delete Account',
                textColor: AppColors.error,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          // Support
          _SettingsSection(
            title: 'Support',
            children: [
              _SettingsTile(
                icon: Icons.help_outline,
                title: 'Help Center',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.feedback_outlined,
                title: 'Send Feedback',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.star_outline,
                title: 'Rate App',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.description_outlined,
                title: 'Terms & Conditions',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          // Sign out
          _SignOutButton(),
          const SizedBox(height: AppSpacing.lg),
          // Version
          Center(
            child: Text(
              'DuskSpendr v1.0.0',
              style: AppTypography.caption.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.sm,
            bottom: AppSpacing.sm,
          ),
          child: Text(
            title,
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailing;
  final Color? textColor;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: textColor ?? AppColors.textSecondary,
              size: 22,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                title,
                style: AppTypography.bodyMedium.copyWith(
                  color: textColor ?? AppColors.textPrimary,
                ),
              ),
            ),
            if (trailing != null)
              Text(
                trailing!,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            const SizedBox(width: AppSpacing.xs),
            Icon(
              Icons.chevron_right,
              color: textColor ?? AppColors.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsToggle extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsToggle({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.textSecondary,
            size: 22,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              title,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: (newValue) {
              HapticFeedback.lightImpact();
              onChanged(newValue);
            },
            activeThumbColor: AppColors.dusk500,
          ),
        ],
      ),
    );
  }
}

class _SignOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.darkSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            title: Text(
              'Sign Out',
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            content: Text(
              'Are you sure you want to sign out?',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Sign out logic
                },
                child: Text(
                  'Sign Out',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, color: AppColors.error),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Sign Out',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

