import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../common/widgets/gradient_button.dart';
import '../home/home_screen.dart';

/// SS-087: First-time user onboarding tutorial flow
/// Steps:
/// 1. Welcome to DuskSpendr
/// 2. SMS permission request
/// 3. Notification permission request
/// 4. Quick budget setup
/// 5. Completion celebration

class OnboardingTutorialScreen extends ConsumerStatefulWidget {
  const OnboardingTutorialScreen({super.key});

  @override
  ConsumerState<OnboardingTutorialScreen> createState() =>
      _OnboardingTutorialScreenState();
}

class _OnboardingTutorialScreenState
    extends ConsumerState<OnboardingTutorialScreen> {
  final PageController _controller = PageController();
  int _currentStep = 0;
  bool _smsPermissionGranted = false;
  bool _notificationPermissionGranted = false;
  int _dailyBudget = 500; // Default daily budget in rupees

  final int _totalSteps = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradientNight),
        child: SafeArea(
          child: Column(
            children: [
              // Progress indicator
              _ProgressBar(current: _currentStep, total: _totalSteps),
              const SizedBox(height: AppSpacing.md),

              // Skip button (except for final step)
              if (_currentStep < _totalSteps - 1)
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.md),
                    child: TextButton(
                      onPressed: _skipToHome,
                      child: Text('Skip',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          )),
                    ),
                  ),
                ),

              // Main content
              Expanded(
                child: PageView(
                  controller: _controller,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _WelcomeStep(onContinue: _nextStep),
                    _SmsPermissionStep(
                      onGranted: (granted) {
                        setState(() => _smsPermissionGranted = granted);
                        _nextStep();
                      },
                      onSkip: _nextStep,
                    ),
                    _NotificationPermissionStep(
                      onGranted: (granted) {
                        setState(
                            () => _notificationPermissionGranted = granted);
                        _nextStep();
                      },
                      onSkip: _nextStep,
                    ),
                    _BudgetSetupStep(
                      initialBudget: _dailyBudget,
                      onBudgetSet: (budget) {
                        setState(() => _dailyBudget = budget);
                        _nextStep();
                      },
                      onSkip: _nextStep,
                    ),
                    _CompletionStep(
                      smsEnabled: _smsPermissionGranted,
                      notificationsEnabled: _notificationPermissionGranted,
                      dailyBudget: _dailyBudget,
                      onComplete: _completeOnboarding,
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

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      _controller.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipToHome() {
    _completeOnboarding();
  }

  void _completeOnboarding() {
    // Save onboarding completion + initial budget can be wired to persistent prefs.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }
}

// ====== Progress Bar ======

class _ProgressBar extends StatelessWidget {
  final int current;
  final int total;

  const _ProgressBar({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: List.generate(total, (index) {
          final isActive = index <= current;
          final isCurrent = index == current;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: isCurrent ? 6 : 4,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.accent
                    : AppColors.dusk700.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ====== Step 1: Welcome ======

class _WelcomeStep extends StatelessWidget {
  final VoidCallback onContinue;

  const _WelcomeStep({required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🎉', style: TextStyle(fontSize: 80)),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Welcome to DuskSpendr!',
            style: AppTypography.h1.copyWith(color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Your personal finance buddy designed for students. '
            'Let\'s set things up in less than a minute!',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxl),
          GradientButton(
            label: 'Let\'s Go!',
            onPressed: onContinue,
          ),
        ],
      ),
    );
  }
}

// ====== Step 2: SMS Permission ======

class _SmsPermissionStep extends StatelessWidget {
  final Function(bool) onGranted;
  final VoidCallback onSkip;

  const _SmsPermissionStep({
    required this.onGranted,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.sms_rounded,
              size: 60,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Track Expenses Automatically',
            style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Allow SMS access to automatically detect bank transactions. '
            'Your messages never leave your phone!',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          _PrivacyBadge(),
          const SizedBox(height: AppSpacing.xxl),
          GradientButton(
            label: 'Allow SMS Access',
            onPressed: () async {
              final status = await Permission.sms.request();
              onGranted(status.isGranted);
            },
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: onSkip,
            child: Text('I\'ll add expenses manually',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                )),
          ),
        ],
      ),
    );
  }
}

class _PrivacyBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.accent, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '100% on-device processing',
            style: AppTypography.caption.copyWith(color: AppColors.accent),
          ),
        ],
      ),
    );
  }
}

// ====== Step 3: Notification Permission ======

class _NotificationPermissionStep extends StatelessWidget {
  final Function(bool) onGranted;
  final VoidCallback onSkip;

  const _NotificationPermissionStep({
    required this.onGranted,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
              size: 60,
              color: AppColors.warning,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Stay on Track',
            style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Get alerts when you\'re close to budget limits and reminders for bill payments.',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          _NotificationExamples(),
          const SizedBox(height: AppSpacing.xxl),
          GradientButton(
            label: 'Enable Notifications',
            onPressed: () async {
              final status = await Permission.notification.request();
              onGranted(status.isGranted);
            },
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: onSkip,
            child: Text('Maybe later',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                )),
          ),
        ],
      ),
    );
  }
}

class _NotificationExamples extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _NotificationExample(
          icon: '⚠️',
          text: 'Budget 80% used - ₹200 remaining',
        ),
        SizedBox(height: AppSpacing.sm),
        _NotificationExample(
          icon: '📅',
          text: 'Electricity bill due tomorrow',
        ),
      ],
    );
  }
}

class _NotificationExample extends StatelessWidget {
  final String icon;
  final String text;

  const _NotificationExample({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(text,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                )),
          ),
        ],
      ),
    );
  }
}

// ====== Step 4: Budget Setup ======

class _BudgetSetupStep extends StatefulWidget {
  final int initialBudget;
  final Function(int) onBudgetSet;
  final VoidCallback onSkip;

  const _BudgetSetupStep({
    required this.initialBudget,
    required this.onBudgetSet,
    required this.onSkip,
  });

  @override
  State<_BudgetSetupStep> createState() => _BudgetSetupStepState();
}

class _BudgetSetupStepState extends State<_BudgetSetupStep> {
  late int _selectedBudget;

  final _budgetOptions = [300, 500, 750, 1000, 1500, 2000];

  @override
  void initState() {
    super.initState();
    _selectedBudget = widget.initialBudget;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              size: 60,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Set Your Daily Budget',
            style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'How much do you want to spend per day? Don\'t worry, you can change this later.',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: _budgetOptions.map((budget) {
              final isSelected = budget == _selectedBudget;
              return GestureDetector(
                onTap: () => setState(() => _selectedBudget = budget),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.darkCard,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.dusk700,
                    ),
                  ),
                  child: Text(
                    '₹$budget',
                    style: AppTypography.bodyLarge.copyWith(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            '₹${_selectedBudget * 30}/month',
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          GradientButton(
            label: 'Set Budget',
            onPressed: () => widget.onBudgetSet(_selectedBudget),
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: widget.onSkip,
            child: Text('Skip for now',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                )),
          ),
        ],
      ),
    );
  }
}

// ====== Step 5: Completion ======

class _CompletionStep extends StatefulWidget {
  final bool smsEnabled;
  final bool notificationsEnabled;
  final int dailyBudget;
  final VoidCallback onComplete;

  const _CompletionStep({
    required this.smsEnabled,
    required this.notificationsEnabled,
    required this.dailyBudget,
    required this.onComplete,
  });

  @override
  State<_CompletionStep> createState() => _CompletionStepState();
}

class _CompletionStepState extends State<_CompletionStep>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: const Text('🎊', style: TextStyle(fontSize: 100)),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'You\'re All Set!',
            style: AppTypography.h1.copyWith(color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'DuskSpendr is ready to help you master your finances.',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          _SetupSummary(
            smsEnabled: widget.smsEnabled,
            notificationsEnabled: widget.notificationsEnabled,
            dailyBudget: widget.dailyBudget,
          ),
          const SizedBox(height: AppSpacing.xxl),
          GradientButton(
            label: 'Start Tracking! 🚀',
            onPressed: widget.onComplete,
          ),
        ],
      ),
    );
  }
}

class _SetupSummary extends StatelessWidget {
  final bool smsEnabled;
  final bool notificationsEnabled;
  final int dailyBudget;

  const _SetupSummary({
    required this.smsEnabled,
    required this.notificationsEnabled,
    required this.dailyBudget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          _SummaryRow(
            icon: Icons.sms,
            label: 'SMS Tracking',
            value: smsEnabled ? 'Enabled' : 'Disabled',
            isEnabled: smsEnabled,
          ),
          const Divider(color: AppColors.dusk700),
          _SummaryRow(
            icon: Icons.notifications,
            label: 'Notifications',
            value: notificationsEnabled ? 'Enabled' : 'Disabled',
            isEnabled: notificationsEnabled,
          ),
          const Divider(color: AppColors.dusk700),
          _SummaryRow(
            icon: Icons.account_balance_wallet,
            label: 'Daily Budget',
            value: '₹$dailyBudget',
            isEnabled: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isEnabled;

  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon,
              color: isEnabled ? AppColors.accent : AppColors.textMuted,
              size: 20),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(label,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                )),
          ),
          Text(value,
              style: AppTypography.bodyMedium.copyWith(
                color: isEnabled ? AppColors.accent : AppColors.textMuted,
                fontWeight: FontWeight.w600,
              )),
        ],
      ),
    );
  }
}
