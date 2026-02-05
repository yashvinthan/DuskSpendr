import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../buttons/icon_button.dart';

/// Nav item for bottom navigation
class NavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;

  const NavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
  });
}

/// Custom bottom navigation bar with gradient FAB
class AppBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavItem> items;
  final VoidCallback? onFabTap;
  final bool showFab;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.onFabTap,
    this.showFab = true,
  });

  @override
  State<AppBottomNavBar> createState() => _AppBottomNavBarState();
}

class _AppBottomNavBarState extends State<AppBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    // Calculate FAB position (center if 4 items + FAB)
    final fabIndex = widget.items.length ~/ 2;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (int i = 0; i < widget.items.length; i++) ...[
                if (widget.showFab && i == fabIndex) _buildFab(),
                _buildNavItem(i),
              ],
              if (widget.showFab && widget.items.length == fabIndex) _buildFab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final item = widget.items[index];
    final isSelected = widget.currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onTap(index);
        },
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isSelected
                      ? (item.activeIcon ?? item.icon)
                      : item.icon,
                  key: ValueKey(isSelected),
                  color: isSelected
                      ? AppColors.dusk500
                      : AppColors.textMuted,
                  size: 24,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? AppColors.dusk500
                      : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Transform.translate(
        offset: const Offset(0, -16),
        child: AppFAB(
          icon: Icons.add,
          onPressed: widget.onFabTap,
        ),
      ),
    );
  }
}

/// Default nav items for main navigation
class DefaultNavItems {
  static const home = NavItem(
    icon: Icons.home_outlined,
    activeIcon: Icons.home,
    label: 'Home',
  );
  static const transactions = NavItem(
    icon: Icons.receipt_long_outlined,
    activeIcon: Icons.receipt_long,
    label: 'Trans',
  );
  static const stats = NavItem(
    icon: Icons.bar_chart_outlined,
    activeIcon: Icons.bar_chart,
    label: 'Stats',
  );
  static const profile = NavItem(
    icon: Icons.person_outline,
    activeIcon: Icons.person,
    label: 'Profile',
  );

  static const List<NavItem> all = [home, transactions, stats, profile];
}
