import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';

/// Custom amount input with embedded numpad for transaction entry.
class AmountInput extends StatefulWidget {
  final double initialValue;
  final ValueChanged<double> onChanged;
  final bool showNumpad;
  final bool autoFocus;
  final String currencySymbol;

  const AmountInput({
    super.key,
    this.initialValue = 0,
    required this.onChanged,
    this.showNumpad = true,
    this.autoFocus = true,
    this.currencySymbol = '₹',
  });

  @override
  State<AmountInput> createState() => _AmountInputState();
}

class _AmountInputState extends State<AmountInput> {
  String _amountString = '';
  bool _hasDecimal = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue > 0) {
      _amountString = widget.initialValue.toString();
      _hasDecimal = _amountString.contains('.');
    }
  }

  double get _amount {
    if (_amountString.isEmpty) return 0;
    return double.tryParse(_amountString) ?? 0;
  }

  String get _displayAmount {
    if (_amountString.isEmpty) return '0';
    return _amountString;
  }

  void _onKeyPress(String key) {
    HapticFeedback.lightImpact();
    
    setState(() {
      if (key == '⌫') {
        if (_amountString.isNotEmpty) {
          final lastChar = _amountString[_amountString.length - 1];
          _amountString = _amountString.substring(0, _amountString.length - 1);
          if (lastChar == '.') {
            _hasDecimal = false;
          }
        }
      } else if (key == '.') {
        if (!_hasDecimal && _amountString.isNotEmpty) {
          _amountString += '.';
          _hasDecimal = true;
        }
      } else {
        // Limit decimal places to 2
        if (_hasDecimal) {
          final parts = _amountString.split('.');
          if (parts.length > 1 && parts[1].length >= 2) {
            return;
          }
        }
        // Limit total length
        if (_amountString.length < 10) {
          _amountString += key;
        }
      }
    });

    widget.onChanged(_amount);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Amount Display
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xl,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.currencySymbol,
                style: AppTypography.h1.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: child,
                ),
                child: Text(
                  _displayAmount,
                  key: ValueKey(_displayAmount),
                  style: AppTypography.displayLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: _displayAmount.length > 7 ? 36 : 48,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Numpad
        if (widget.showNumpad) _buildNumpad(),
      ],
    );
  }

  Widget _buildNumpad() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          _buildNumRow(['7', '8', '9']),
          const SizedBox(height: AppSpacing.sm),
          _buildNumRow(['4', '5', '6']),
          const SizedBox(height: AppSpacing.sm),
          _buildNumRow(['1', '2', '3']),
          const SizedBox(height: AppSpacing.sm),
          _buildNumRow(['.', '0', '⌫']),
        ],
      ),
    );
  }

  Widget _buildNumRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) => _buildNumKey(key)).toList(),
    );
  }

  Widget _buildNumKey(String key) {
    final isBackspace = key == '⌫';
    final isDecimal = key == '.';

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _onKeyPress(key),
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Center(
                child: isBackspace
                    ? const Icon(
                        Icons.backspace_outlined,
                        color: AppColors.textSecondary,
                        size: 24,
                      )
                    : Text(
                        key,
                        style: TextStyle(
                          fontFamily: 'SpaceMono',
                          fontSize: isDecimal ? 32 : 28,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Quick amount selector chips
class QuickAmountSelector extends StatelessWidget {
  final List<double> amounts;
  final double? selectedAmount;
  final ValueChanged<double> onSelected;

  const QuickAmountSelector({
    super.key,
    this.amounts = const [100, 500, 1000, 5000],
    this.selectedAmount,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: amounts.map((amount) {
        final isSelected = selectedAmount == amount;
        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            onSelected(amount);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              gradient: isSelected ? AppColors.gradientDusk : null,
              color: isSelected ? null : AppColors.darkSurface,
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: isSelected
                  ? null
                  : Border.all(color: AppColors.dusk700.withValues(alpha: 0.5)),
            ),
            child: Text(
              '₹${amount.toInt()}',
              style: AppTypography.amountSmall.copyWith(
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
