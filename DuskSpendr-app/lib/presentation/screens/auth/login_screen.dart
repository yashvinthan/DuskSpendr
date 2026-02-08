import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../providers/auth_providers.dart';
import '../../common/widgets/gradient_button.dart';
import '../../common/widgets/phone_input.dart';
import '../../navigation/app_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
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
                const SizedBox(height: AppSpacing.lg),
                Text('Welcome back',
                    style: AppTypography.h1.copyWith(
                      color: AppColors.textPrimary,
                    )),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Sign in with your phone number',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                PhoneInput(controller: _phoneController),
                const SizedBox(height: AppSpacing.lg),
                GradientButton(
                  label: 'Send OTP',
                  isLoading: state.status == AuthStatus.loading,
                  onPressed: () async {
                    final phone = _phoneController.text.trim();
                    final res = await ref
                        .read(authControllerProvider.notifier)
                        .startOtp(phone);
                    if (res == null || !context.mounted) return;

                    // We only pass phone for now as AppRouter expects a String extra
                    context.pushNamed('otp', extra: phone);
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                if (state.status == AuthStatus.error)
                  Text(
                    state.message ?? 'Something went wrong',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                const Spacer(),
                Center(
                  child: Text(
                    'We never store your messages',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textMuted,
                    ),
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
