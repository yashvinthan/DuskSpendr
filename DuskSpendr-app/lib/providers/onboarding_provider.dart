import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Simple provider for onboarding status
final onboardingStatusProvider = StateProvider<bool>((ref) => false);
