import 'package:flutter/material.dart';

import '../../../core/theme/colors.dart';

class PhoneInput extends StatelessWidget {
  const PhoneInput({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.phone,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        prefixIcon: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Text('+91', style: TextStyle(color: AppColors.textSecondary)),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        hintText: 'Phone number',
        hintStyle: const TextStyle(color: AppColors.textMuted),
      ),
    );
  }
}
