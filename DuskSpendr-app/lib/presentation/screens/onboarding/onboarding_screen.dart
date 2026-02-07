import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../common/widgets/gradient_button.dart';
import '../../navigation/app_router.dart';
import '../../../providers/onboarding_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  final _pages = const [
    _OnboardingData(
      title: 'Take Control of Your Money',
      subtitle: 'Track every rupee without lifting a finger',
      icon: Icons.stars_rounded,
    ),
    _OnboardingData(
      title: 'Automatic Expense Tracking',
      subtitle: 'Link your bank, UPI, and wallets. We\'ll handle the rest.',
      icon: Icons.auto_awesome,
    ),
    _OnboardingData(
      title: 'Your Data Stays Private',
      subtitle: 'All SMS processing happens on your phone.',
      icon: Icons.shield_rounded,
    ),
    _OnboardingData(
      title: 'AI-Powered Insights',
      subtitle: 'Smart categorization, tips, and a Finance Score.',
      icon: Icons.insights_rounded,
    ),
    _OnboardingData(
      title: 'Ready to Start?',
      subtitle: 'Join 1M+ students who\'ve mastered their finances.',
      icon: Icons.celebration_rounded,
    ),
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_completed_onboarding', true);
    ref.read(onboardingStatusProvider.notifier).state = true;
    if (!mounted) return;
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradientNight),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (value) => setState(() => _index = value),
                  itemCount: _pages.length,
                  itemBuilder: (context, i) {
                    return _OnboardingPage(data: _pages[i]);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    _PageDots(count: _pages.length, index: _index),
                    const SizedBox(height: AppSpacing.lg),
                    GradientButton(
                      label: _index == _pages.length - 1
                          ? 'Create Account'
                          : 'Continue',
                      onPressed: () {
                        if (_index == _pages.length - 1) {
                          _completeOnboarding();
                          return;
                        }
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (_index == _pages.length - 1)
                      TextButton(
                        onPressed: () => _completeOnboarding(),
                        child: const Text('I already have an account'),
                      )
                    else
                      TextButton(
                        onPressed: () => _completeOnboarding(),
                        child: const Text('Skip'),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data});

  final _OnboardingData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: AppSpacing.screenVertical,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.gradientDusk,
              boxShadow: [
                BoxShadow(
                  color: AppColors.dusk500.withValues(alpha: 0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Icon(data.icon, size: 90, color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            data.title,
            style: AppTypography.h1.copyWith(color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            data.subtitle,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? AppColors.gold400 : AppColors.dusk700,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }
}

class _OnboardingData {
  const _OnboardingData({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
}
