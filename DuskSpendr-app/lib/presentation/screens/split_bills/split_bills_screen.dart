import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/shared/shared_expense_service.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../domain/entities/entities.dart';
import '../../../providers/shared_expense_provider.dart';
import '../../common/widgets/navigation/top_app_bar.dart';
import '../../common/widgets/cards/glass_card.dart';
import 'friend_detail_screen.dart';

/// Split Bills main screen - SS-106
class SplitBillsScreen extends ConsumerStatefulWidget {
  const SplitBillsScreen({super.key});

  @override
  ConsumerState<SplitBillsScreen> createState() => _SplitBillsScreenState();
}

class _SplitBillsScreenState extends ConsumerState<SplitBillsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final balanceSummary = ref.watch(balanceSummaryProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppTopBar(
        title: 'Split Bills',
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: AppColors.textPrimary),
            onPressed: () => _showSettlementHistory(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateSplitSheet(context),
        backgroundColor: AppColors.dusk500,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search groups or expenses...',
                hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
                prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.darkCard,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: BorderSide.none,
                ),
              ),
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          // Tab bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.dusk500,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: AppTypography.caption,
              tabs: const [
                Tab(text: 'Active'),
                Tab(text: 'Settled'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Summary card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: balanceSummary.when(
              data: (summary) => _BalanceSummaryCard(summary: summary),
              loading: () => const _LoadingCard(),
              error: (_, __) => const _ErrorCard(),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Groups list
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _ActiveSplitsTab(searchQuery: _searchQuery),
                _SettledSplitsTab(searchQuery: _searchQuery),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateSplitSheet(BuildContext context) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _CreateSplitSheet(),
    );
  }

  void _showSettlementHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettlementHistoryScreen()),
    );
  }
}

class _BalanceSummaryCard extends StatelessWidget {
  final BalanceSummary summary;

  const _BalanceSummaryCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final youOwePaisa = summary.totalOwing.paisa;
    final youAreOwedPaisa = summary.totalOwed.paisa;
    
    return GlassCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You owe',
                  style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${(youOwePaisa / 100).toStringAsFixed(0)}',
                  style: AppTypography.h2.copyWith(
                    color: youOwePaisa > 0 ? AppColors.error : AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 48, color: AppColors.darkSurface),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'You\'re owed',
                  style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${(youAreOwedPaisa / 100).toStringAsFixed(0)}',
                  style: AppTypography.h2.copyWith(
                    color: youAreOwedPaisa > 0 ? AppColors.success : AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('You owe', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Container(height: 28, width: 80, decoration: BoxDecoration(color: AppColors.darkSurface, borderRadius: BorderRadius.circular(4))),
              ],
            ),
          ),
          Container(width: 1, height: 48, color: AppColors.darkSurface),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('You\'re owed', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Container(height: 28, width: 80, decoration: BoxDecoration(color: AppColors.darkSurface, borderRadius: BorderRadius.circular(4))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Center(
        child: Text('Error loading balances', style: AppTypography.caption.copyWith(color: AppColors.error)),
      ),
    );
  }
}

class _ActiveSplitsTab extends ConsumerWidget {
  final String searchQuery;

  const _ActiveSplitsTab({required this.searchQuery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsWithBalances = ref.watch(friendsWithBalancesProvider);

    return friendsWithBalances.when(
      data: (balances) {
        final filtered = searchQuery.isEmpty
            ? balances
            : balances.where((b) => b.friend.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();

        if (filtered.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.people_outline, size: 64, color: AppColors.textMuted),
                const SizedBox(height: AppSpacing.md),
                Text('No active splits', style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: AppSpacing.sm),
                Text('Add a friend or create a group', style: AppTypography.caption.copyWith(color: AppColors.textMuted)),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) => _FriendBalanceCard(balance: filtered[index]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _FriendBalanceCard extends StatelessWidget {
  final FriendBalance balance;

  const _FriendBalanceCard({required this.balance});

  @override
  Widget build(BuildContext context) {
    final netBalancePaisa = balance.friend.netBalance.paisa;
    final youOwe = netBalancePaisa < 0 ? (-netBalancePaisa / 100) : null;
    final youAreOwed = netBalancePaisa > 0 ? (netBalancePaisa / 100) : null;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => FriendDetailScreen(friendId: balance.friend.id)),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.md),
                gradient: const LinearGradient(colors: [AppColors.dusk500, AppColors.sunset500]),
              ),
              child: Center(
                child: Text(
                  balance.friend.name.isNotEmpty ? balance.friend.name[0].toUpperCase() : '?',
                  style: AppTypography.h2.copyWith(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(balance.friend.name, style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                  if (balance.friend.phone != null)
                    Text(balance.friend.phone!, style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            if (youOwe != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('₹${youOwe.toStringAsFixed(0)}', style: AppTypography.bodyLarge.copyWith(color: AppColors.error, fontWeight: FontWeight.bold)),
                  Text('you owe', style: AppTypography.caption.copyWith(color: AppColors.error)),
                ],
              ),
            if (youAreOwed != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('₹${youAreOwed.toStringAsFixed(0)}', style: AppTypography.bodyLarge.copyWith(color: AppColors.success, fontWeight: FontWeight.bold)),
                  Text('you\'re owed', style: AppTypography.caption.copyWith(color: AppColors.success)),
                ],
              ),
            if (youOwe == null && youAreOwed == null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('₹0', style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary)),
                  Text('settled', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _SettledSplitsTab extends ConsumerWidget {
  final String searchQuery;

  const _SettledSplitsTab({required this.searchQuery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settlements = ref.watch(settlementsProvider);

    return settlements.when(
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle_outline, size: 64, color: AppColors.textMuted),
                const SizedBox(height: AppSpacing.md),
                Text('No settled expenses yet', style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) => _SettledCard(settlement: list[index]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _SettledCard extends StatelessWidget {
  final Settlement settlement;

  const _SettledCard({required this.settlement});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.success),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('₹${(settlement.amount.paisa / 100).toStringAsFixed(0)}', style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                Text('Settled', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          if (settlement.notes != null && settlement.notes!.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Text(settlement.notes!, style: AppTypography.caption.copyWith(color: AppColors.success)),
            ),
        ],
      ),
    );
  }
}

class _CreateSplitSheet extends ConsumerStatefulWidget {
  const _CreateSplitSheet();

  @override
  ConsumerState<_CreateSplitSheet> createState() => _CreateSplitSheetState();
}

class _CreateSplitSheetState extends ConsumerState<_CreateSplitSheet> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: AppColors.textMuted, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Add Friend', style: AppTypography.h2.copyWith(color: AppColors.textPrimary)),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _nameController,
            style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Friend\'s name',
              hintStyle: AppTypography.bodyLarge.copyWith(color: AppColors.textMuted),
              filled: true,
              fillColor: AppColors.darkCard,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _addFriend,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.dusk500,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
              ),
              child: Text('Add Friend', style: AppTypography.button.copyWith(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  void _addFriend() async {
    if (_nameController.text.isEmpty) return;
    await ref.read(sharedExpenseNotifierProvider.notifier).addFriend(name: _nameController.text);
    if (mounted) Navigator.pop(context);
  }
}
