import 'package:flutter/material.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../common/widgets/gradient_button.dart';
import '../home/home_screen.dart';

class BiometricSetupScreen extends StatelessWidget {
  const BiometricSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradientNight),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal,
              vertical: AppSpacing.screenVertical,
            ),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.xl),
                const Icon(Icons.fingerprint, size: 96, color: AppColors.gold400),
                const SizedBox(height: AppSpacing.lg),
                Text('Secure Your App',
                    style: AppTypography.h1.copyWith(
                      color: AppColors.textPrimary,
                    )),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Use Face ID or fingerprint for quick access.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                GradientButton(
                  label: 'Enable Biometric',
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const HomeScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const HomeScreen(),
                      ),
                    );
                  },
                  child: const Text('Maybe Later'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
