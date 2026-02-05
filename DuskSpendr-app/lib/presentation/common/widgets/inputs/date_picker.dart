import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';

/// Custom date picker field that opens a styled date picker.
class DatePickerField extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final String? label;
  final String? hintText;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool enabled;

  const DatePickerField({
    super.key,
    this.selectedDate,
    required this.onDateSelected,
    this.label,
    this.hintText,
    this.firstDate,
    this.lastDate,
    this.enabled = true,
  });

  String get _displayText {
    if (selectedDate == null) {
      return hintText ?? 'Select date';
    }
    final now = DateTime.now();
    final isToday = selectedDate!.day == now.day &&
        selectedDate!.month == now.month &&
        selectedDate!.year == now.year;
    final isYesterday = selectedDate!.day == now.day - 1 &&
        selectedDate!.month == now.month &&
        selectedDate!.year == now.year;

    if (isToday) return 'Today, ${_formatMonthDay(selectedDate!)}';
    if (isYesterday) return 'Yesterday';
    return _formatFullDate(selectedDate!);
  }

  String _formatMonthDay(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  String _formatFullDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Future<void> _showDatePicker(BuildContext context) async {
    HapticFeedback.lightImpact();
    
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2020),
      lastDate: lastDate ?? DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.dusk500,
              onPrimary: AppColors.textPrimary,
              surface: AppColors.darkCard,
              onSurface: AppColors.textPrimary,
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: AppColors.darkBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        GestureDetector(
          onTap: enabled ? () => _showDatePicker(context) : null,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: AppColors.dusk700.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: enabled
                      ? AppColors.textSecondary
                      : AppColors.textMuted,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    _displayText,
                    style: AppTypography.bodyLarge.copyWith(
                      color: selectedDate != null && enabled
                          ? AppColors.textPrimary
                          : AppColors.textMuted,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: enabled
                      ? AppColors.textSecondary
                      : AppColors.textMuted,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Date range selector for analytics
class DateRangeSelector extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<DateTimeRange> onRangeSelected;
  final List<DateRangePreset> presets;
  final DateRangePreset? selectedPreset;
  final ValueChanged<DateRangePreset>? onPresetSelected;

  const DateRangeSelector({
    super.key,
    this.startDate,
    this.endDate,
    required this.onRangeSelected,
    this.presets = const [],
    this.selectedPreset,
    this.onPresetSelected,
  });

  @override
  Widget build(BuildContext context) {
    final displayPresets = presets.isEmpty ? DateRangePreset.defaults : presets;

    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: displayPresets.map((preset) {
          final isSelected = selectedPreset == preset;
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                onPresetSelected?.call(preset);
                onRangeSelected(preset.getRange());
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
                      : Border.all(
                          color: AppColors.dusk700.withValues(alpha: 0.5),
                        ),
                ),
                child: Text(
                  preset.label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Preset date ranges
enum DateRangePreset {
  week('Week'),
  month('Month'),
  year('Year'),
  custom('Custom');

  final String label;
  const DateRangePreset(this.label);

  static const List<DateRangePreset> defaults = [week, month, year, custom];

  DateTimeRange getRange() {
    final now = DateTime.now();
    switch (this) {
      case DateRangePreset.week:
        return DateTimeRange(
          start: now.subtract(const Duration(days: 7)),
          end: now,
        );
      case DateRangePreset.month:
        return DateTimeRange(
          start: DateTime(now.year, now.month, 1),
          end: now,
        );
      case DateRangePreset.year:
        return DateTimeRange(
          start: DateTime(now.year, 1, 1),
          end: now,
        );
      case DateRangePreset.custom:
        return DateTimeRange(
          start: now.subtract(const Duration(days: 30)),
          end: now,
        );
    }
  }
}
