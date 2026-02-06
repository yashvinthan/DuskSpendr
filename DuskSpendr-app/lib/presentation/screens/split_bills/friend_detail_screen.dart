import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../domain/entities/entities.dart';
import '../../../providers/shared_expense_provider.dart';
import '../../common/widgets/cards/glass_card.dart';
import '../../common/widgets/navigation/top_app_bar.dart';
import '../../common/widgets/buttons/primary_button.dart';

/// Friend detail screen showing expenses and balance with a specific friend
class FriendDetailScreen extends ConsumerWidget {
  final String friendId;

  const FriendDetailScreen({super.key, required this.friendId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendAsync = ref.watch(friendByIdProvider(friendId));
    final balanceAsync = ref.watch(friendBalanceSummaryProvider(friendId));
    final expensesAsync = ref.watch(friendExpensesProvider(friendId));

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppTopBar(
        title: 'Friend Details',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: friendAsync.when(
        data: (friend) {
          if (friend == null) {
            return const Center(child: Text('Friend not found'));
          }
          return _FriendDetailContent(
            friend: friend,
            balance: balanceAsync.valueOrNull,
            expenses: expensesAsync.valueOrNull ?? [],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddExpenseSheet(context, ref),
        backgroundColor: AppColors.dusk500,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Add Expense', style: AppTypography.button.copyWith(color: Colors.white)),
      ),
    );
  }

  void _showAddExpenseSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddExpenseSheet(friendId: friendId),
    );
  }
}

class _FriendDetailContent extends StatelessWidget {
  final Friend friend;
  final FriendBalance? balance;
  final List<SharedExpense> expenses;

  const _FriendDetailContent({
    required this.friend,
    this.balance,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        // Friend header
        _FriendHeader(friend: friend, balance: balance),
        const SizedBox(height: AppSpacing.lg),
        
        // Quick actions
        _QuickActions(friend: friend, balance: balance),
        const SizedBox(height: AppSpacing.lg),
        
        // Expenses list
        Text(
          'Shared Expenses',
          style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.sm),
        
        if (expenses.isEmpty)
          _EmptyExpensesCard()
        else
          ...expenses.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _ExpenseCard(expense: e),
          )),
      ],
    );
  }
}

class _FriendHeader extends StatelessWidget {
  final Friend friend;
  final FriendBalance? balance;

  const _FriendHeader({required this.friend, this.balance});

  @override
  Widget build(BuildContext context) {
    final balancePaisa = balance?.friend.netBalance.paisa ?? 0;
    final isPositive = balancePaisa >= 0;

    return GlassCard(
      child: Column(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.dusk500, AppColors.sunset500],
              ),
            ),
            child: Center(
              child: Text(
                friend.name.isNotEmpty ? friend.name[0].toUpperCase() : '?',
                style: AppTypography.displayMedium.copyWith(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Name
          Text(
            friend.name,
            style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
          ),
          
          // Phone/Email
          if (friend.phone != null)
            Text(friend.phone!, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
          if (friend.email != null)
            Text(friend.email!, style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted)),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Balance
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            decoration: BoxDecoration(
              color: (isPositive ? AppColors.success : AppColors.error).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Column(
              children: [
                Text(
                  isPositive ? 'They owe you' : 'You owe',
                  style: AppTypography.caption.copyWith(color: isPositive ? AppColors.success : AppColors.error),
                ),
                Text(
                  '₹${(balancePaisa.abs() / 100).toStringAsFixed(0)}',
                  style: AppTypography.amount.copyWith(
                    color: isPositive ? AppColors.success : AppColors.error,
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

class _QuickActions extends ConsumerWidget {
  final Friend friend;
  final FriendBalance? balance;

  const _QuickActions({required this.friend, this.balance});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: Icons.payment,
            label: 'Settle Up',
            color: AppColors.success,
            onTap: () => _showSettleSheet(context, ref),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _ActionButton(
            icon: Icons.notifications,
            label: 'Remind',
            color: AppColors.sunset500,
            onTap: () => _sendReminder(context),
          ),
        ),
      ],
    );
  }

  void _showSettleSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SettleUpSheet(friend: friend, balance: balance),
    );
  }

  void _sendReminder(BuildContext context) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reminder sent to ${friend.name}'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(label, style: AppTypography.caption.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}

class _EmptyExpensesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          const Icon(Icons.receipt_long, size: 48, color: AppColors.textMuted),
          const SizedBox(height: AppSpacing.md),
          Text('No expenses yet', style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.sm),
          Text('Tap + to add your first shared expense', style: AppTypography.caption.copyWith(color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

class _ExpenseCard extends StatelessWidget {
  final SharedExpense expense;

  const _ExpenseCard({required this.expense});

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('MMM d, yyyy');
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.dusk500.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(Icons.receipt_long, color: AppColors.dusk500, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(expense.description, style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                Text(formatter.format(expense.createdAt), style: AppTypography.caption.copyWith(color: AppColors.textMuted)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${(expense.totalAmount.paisa / 100).toStringAsFixed(0)}',
                style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
              ),
              Text(
                expense.isFullySettled ? 'Settled' : 'Pending',
                style: AppTypography.caption.copyWith(
                  color: expense.isFullySettled ? AppColors.success : AppColors.sunset500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Sheet for settling up with a friend
class SettleUpSheet extends ConsumerStatefulWidget {
  final Friend friend;
  final FriendBalance? balance;

  const SettleUpSheet({super.key, required this.friend, this.balance});

  @override
  ConsumerState<SettleUpSheet> createState() => _SettleUpSheetState();
}

class _SettleUpSheetState extends ConsumerState<SettleUpSheet> {
  final _amountController = TextEditingController();
  String _method = 'UPI';

  @override
  void initState() {
    super.initState();
    // Pre-fill with balance amount
    if (widget.balance != null) {
      final balancePaisa = widget.balance!.friend.netBalance.paisa.abs();
      _amountController.text = (balancePaisa / 100).toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final balancePaisa = widget.balance?.friend.netBalance.paisa ?? 0;
    final youOwe = balancePaisa < 0;
    
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
              decoration: BoxDecoration(
                color: AppColors.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          
          Text(
            youOwe ? 'Pay ${widget.friend.name}' : 'Record payment from ${widget.friend.name}',
            style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // Amount input
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            style: AppTypography.amount.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              prefixText: '₹ ',
              prefixStyle: AppTypography.amount.copyWith(color: AppColors.textSecondary),
              hintText: '0',
              hintStyle: AppTypography.amount.copyWith(color: AppColors.textMuted),
              border: InputBorder.none,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Payment method
          Text('Payment Method', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              _MethodChip(label: 'UPI', selected: _method == 'UPI', onTap: () => setState(() => _method = 'UPI')),
              const SizedBox(width: AppSpacing.sm),
              _MethodChip(label: 'Cash', selected: _method == 'Cash', onTap: () => setState(() => _method = 'Cash')),
              const SizedBox(width: AppSpacing.sm),
              _MethodChip(label: 'Bank Transfer', selected: _method == 'Bank Transfer', onTap: () => setState(() => _method = 'Bank Transfer')),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          
          // Record button
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              label: 'Record Settlement',
              onPressed: _recordSettlement,
            ),
          ),
        ],
      ),
    );
  }

  void _recordSettlement() async {
    final amount = int.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) return;

    final balancePaisa = widget.balance?.friend.netBalance.paisa ?? 0;
    final youOwe = balancePaisa < 0;

    await ref.read(sharedExpenseNotifierProvider.notifier).recordSettlement(
      friendId: widget.friend.id,
      amount: Money.fromPaisa(amount * 100),
      isIncoming: !youOwe, // If you owe, you're paying (not incoming)
      notes: _method,
    );

    if (mounted) Navigator.pop(context);
  }
}

class _MethodChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _MethodChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: selected ? AppColors.dusk500 : AppColors.darkCard,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(color: selected ? AppColors.dusk500 : AppColors.darkSurface),
        ),
        child: Text(label, style: AppTypography.caption.copyWith(color: selected ? Colors.white : AppColors.textSecondary)),
      ),
    );
  }
}

/// Sheet for adding a new expense
class AddExpenseSheet extends ConsumerStatefulWidget {
  final String? friendId;
  
  const AddExpenseSheet({super.key, this.friendId});

  @override
  ConsumerState<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends ConsumerState<AddExpenseSheet> {
  final _descController = TextEditingController();
  final _amountController = TextEditingController();
  SplitType _splitType = SplitType.equal;
  bool _iPaid = true;

  @override
  void dispose() {
    _descController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  String _getSplitTypeName(SplitType type) {
    switch (type) {
      case SplitType.equal: return 'Equal';
      case SplitType.percentage: return 'Percentage';
      case SplitType.exact: return 'Exact';
      case SplitType.shares: return 'Shares';
      case SplitType.adjustment: return 'Adjustment';
    }
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
              decoration: BoxDecoration(
                color: AppColors.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          
          Text(
            'Add Expense',
            style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // Description
          TextField(
            controller: _descController,
            style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'What was it for?',
              hintStyle: AppTypography.bodyLarge.copyWith(color: AppColors.textMuted),
              filled: true,
              fillColor: AppColors.darkCard,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Amount
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              prefixText: '₹ ',
              prefixStyle: AppTypography.h2.copyWith(color: AppColors.textSecondary),
              hintText: '0',
              hintStyle: AppTypography.h2.copyWith(color: AppColors.textMuted),
              filled: true,
              fillColor: AppColors.darkCard,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Who paid
          Text('Who paid?', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _RadioCard(
                  label: 'You paid',
                  selected: _iPaid,
                  onTap: () => setState(() => _iPaid = true),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _RadioCard(
                  label: 'They paid',
                  selected: !_iPaid,
                  onTap: () => setState(() => _iPaid = false),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Split type
          Text('Split Type', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            children: SplitType.values.map((type) {
              return _MethodChip(
                label: _getSplitTypeName(type),
                selected: _splitType == type,
                onTap: () => setState(() => _splitType = type),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.xl),
          
          // Add button
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              label: 'Add Expense',
              onPressed: _addExpense,
            ),
          ),
        ],
      ),
    );
  }

  void _addExpense() async {
    final amount = int.tryParse(_amountController.text) ?? 0;
    if (amount <= 0 || _descController.text.isEmpty) return;

    final amountPaisa = amount * 100;
    final halfShare = Money.fromPaisa(amountPaisa ~/ 2);

    // For now, simple 50/50 split with the friend
    final participants = [
      Participant(id: 'self', name: 'You', share: halfShare),
      if (widget.friendId != null)
        Participant(id: widget.friendId!, name: 'Friend', share: halfShare),
    ];

    await ref.read(sharedExpenseNotifierProvider.notifier).addExpense(
      description: _descController.text,
      totalAmount: Money.fromPaisa(amountPaisa),
      paidById: _iPaid ? 'self' : (widget.friendId ?? 'self'),
      splitType: _splitType,
      participants: participants,
    );

    if (mounted) Navigator.pop(context);
  }
}

class _RadioCard extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RadioCard({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: selected ? AppColors.dusk500.withValues(alpha: 0.2) : AppColors.darkCard,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: selected ? AppColors.dusk500 : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? AppColors.dusk500 : AppColors.textMuted,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(label, style: AppTypography.caption.copyWith(color: selected ? AppColors.dusk500 : AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

/// Settlement history screen
class SettlementHistoryScreen extends ConsumerWidget {
  const SettlementHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settlements = ref.watch(settlementsProvider);
    
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppTopBar(
        title: 'Settlement History',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: settlements.when(
        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.history, size: 64, color: AppColors.textMuted),
                  const SizedBox(height: AppSpacing.md),
                  Text('No settlements yet', style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            );
          }
          
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final settlement = list[index];
              return _SettlementHistoryCard(settlement: settlement);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _SettlementHistoryCard extends StatelessWidget {
  final Settlement settlement;

  const _SettlementHistoryCard({required this.settlement});

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('MMM d, yyyy');
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            settlement.isIncoming ? Icons.arrow_downward : Icons.arrow_upward, 
            color: settlement.isIncoming ? AppColors.success : AppColors.error,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '₹${(settlement.amount.paisa / 100).toStringAsFixed(0)}',
                  style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Settled on ${formatter.format(settlement.settledAt)}',
                  style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                ),
                if (settlement.notes != null && settlement.notes!.isNotEmpty)
                  Text(
                    'via ${settlement.notes}',
                    style: AppTypography.caption.copyWith(color: AppColors.textMuted),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              settlement.isIncoming ? 'Received' : 'Paid',
              style: AppTypography.caption.copyWith(color: AppColors.success),
            ),
          ),
        ],
      ),
    );
  }
}
