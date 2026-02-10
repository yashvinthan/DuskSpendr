import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';

/// Custom amount input with embedded numpad for transaction entry.
class AmountInput extends StatefulWidget {
  final double initialValue;
  final ValueChanged<double> onChanged;
  @Deprecated('Use system keyboard instead')
  final bool showNumpad;
  final bool autoFocus;
  final String currencySymbol;

  const AmountInput({
    super.key,
    this.initialValue = 0,
    required this.onChanged,
    @Deprecated('Use system keyboard instead') this.showNumpad = true,
    this.autoFocus = true,
    this.currencySymbol = '₹',
  });

  @override
  State<AmountInput> createState() => _AmountInputState();
}

class _AmountInputState extends State<AmountInput> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  double _inputWidth = 100;
  late TextStyle _currentStyle;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();

    if (widget.initialValue > 0) {
      String text = widget.initialValue.toString();
      if (text.endsWith('.0')) {
        text = text.substring(0, text.length - 2);
      }
      _controller.text = text;
    }

    _updateWidth(_controller.text);

    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _updateWidth(String text) {
    final fontSize = text.length > 7 ? 36.0 : 48.0;

    _currentStyle = AppTypography.displayLarge.copyWith(
      color: AppColors.textPrimary,
      fontSize: fontSize,
    );

    final textPainter = TextPainter(
      text: TextSpan(text: text.isEmpty ? '0' : text, style: _currentStyle),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    setState(() {
      _inputWidth = textPainter.width + 24;
    });
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
              SizedBox(
                width: _inputWidth,
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      final text = newValue.text;
                      if (text.isEmpty) return newValue;
                      if (RegExp(r'^\d*\.?\d{0,2}$').hasMatch(text)) {
                        return newValue;
                      }
                      return oldValue;
                    }),
                  ],
                  textAlign: TextAlign.center,
                  style: _currentStyle,
                  cursorColor: AppColors.textPrimary,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: '0',
                    hintStyle:
                        _currentStyle.copyWith(color: AppColors.textSecondary),
                  ),
                  onChanged: (value) {
                    _updateWidth(value);
                    final amount = double.tryParse(value) ?? 0;
                    widget.onChanged(amount);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
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
