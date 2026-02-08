import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../providers/auth_providers.dart';
import '../../common/widgets/gradient_button.dart';
import '../../navigation/app_router.dart';

class OTPScreen extends ConsumerStatefulWidget {
  const OTPScreen({super.key, required this.phone, this.devCode});

  final String phone;
  final String? devCode;

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                ),
                const SizedBox(height: AppSpacing.md),
                Text('Verify OTP',
                    style: AppTypography.h1.copyWith(
                      color: AppColors.textPrimary,
                    )),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Sent to ${widget.phone}',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    hintText: 'Enter 6-digit OTP',
                    counterText: '',
                  ),
                ),
                if (widget.devCode != null)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm),
                    child: Text(
                      'Dev code: ${widget.devCode}',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.lg),
                GradientButton(
                  label: 'Verify',
                  isLoading: state.status == AuthStatus.loading,
                  onPressed: () async {
                    final ok = await ref
                        .read(authControllerProvider.notifier)
                        .verifyOtp(
                          phone: widget.phone,
                          code: _controller.text.trim(),
                        );
                    if (!ok || !context.mounted) return;

                    context.go(AppRoutes.biometricSetup);
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                if (state.status == AuthStatus.error)
                  Text(
                    state.message ?? 'Invalid code',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.error,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
