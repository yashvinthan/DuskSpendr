import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/security/auth_service.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../../../providers/auth_providers.dart';
import '../home/home_screen.dart';

class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  String _pin = '';
  bool _isBiometricAvailable = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    final authService = ref.read(localAuthServiceProvider);
    final available = await authService.isBiometricAvailable();
    if (mounted) {
      setState(() {
        _isBiometricAvailable = available;
      });
      if (available) {
        _authenticateBiometric();
      }
    }
  }

  Future<void> _authenticateBiometric() async {
    final authService = ref.read(localAuthServiceProvider);
    final result = await authService.authenticateWithBiometrics();
    if (result == AuthResult.success) {
      _unlock();
    }
  }

  Future<void> _authenticatePin() async {
    if (_pin.length != 4) return;

    final authService = ref.read(localAuthServiceProvider);
    final result = await authService.authenticateWithPin(_pin);
    if (result == AuthResult.success) {
      _unlock();
    } else {
      setState(() {
        _error = 'Incorrect PIN';
        _pin = '';
      });
      HapticFeedback.vibrate();
    }
  }

  void _unlock() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  void _onKeyTap(String key) {
    if (_pin.length < 4) {
      setState(() {
        _pin += key;
        _error = '';
      });
      if (_pin.length == 4) {
        _authenticatePin();
      }
    }
  }

  void _onBackspace() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
        _error = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dusk900,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Icon(
              Icons.lock_outline,
              size: 64,
              color: AppColors.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Enter PIN',
              style: AppTypography.displaySmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            if (_error.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                _error,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.error,
                ),
              ),
            ],
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index < _pin.length
                        ? AppColors.primary
                        : AppColors.dusk700,
                  ),
                );
              }),
            ),
            const Spacer(),
            _buildKeypad(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          _buildKeyRow(['1', '2', '3']),
          const SizedBox(height: 24),
          _buildKeyRow(['4', '5', '6']),
          const SizedBox(height: 24),
          _buildKeyRow(['7', '8', '9']),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _isBiometricAvailable
                  ? IconButton(
                      onPressed: _authenticateBiometric,
                      icon: const Icon(
                        Icons.fingerprint,
                        size: 32,
                        color: AppColors.primary,
                      ),
                    )
                  : const SizedBox(width: 48),
              _buildKey('0'),
              IconButton(
                onPressed: _onBackspace,
                icon: const Icon(
                  Icons.backspace_outlined,
                  size: 28,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeyRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((k) => _buildKey(k)).toList(),
    );
  }

  Widget _buildKey(String key) {
    return Material(
      color: AppColors.dusk800,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: () => _onKeyTap(key),
        customBorder: const CircleBorder(),
        child: Container(
          width: 80,
          height: 80,
          alignment: Alignment.center,
          child: Text(
            key,
            style: AppTypography.displaySmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
