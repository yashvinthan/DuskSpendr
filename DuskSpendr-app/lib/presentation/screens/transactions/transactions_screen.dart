import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../data/models/transaction_model.dart';
import '../../../providers/auth_providers.dart';
import '../../../providers/data_providers.dart';
import '../../../providers/search_history_provider.dart';
import 'edit_transaction_screen.dart';
import 'transaction_detail_sheet.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  String _filter = 'all';
  final Set<String> _selectedIds = {};

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _confirmDeleteSelected(BuildContext context) async {
    if (_selectedIds.isEmpty) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete transactions?'),
        content: Text('Delete ${_selectedIds.length} selected items?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    final token = await ref.read(sessionStoreProvider).readToken();
    if (token == null) return;

    final pageItems = ref.read(transactionPageProvider).items;
    final toDelete =
        pageItems.where((tx) => _selectedIds.contains(tx.id)).toList();

    await ref.read(transactionsApiProvider).bulkDelete(
          token: token,
          ids: toDelete.map((e) => e.id).toList(),
        );

    setState(() => _selectedIds.clear());
    ref.invalidate(transactionPageProvider);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted ${toDelete.length} transactions'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            for (final tx in toDelete) {
              await ref.read(transactionsApiProvider).create(
                    token: token,
                    amountPaisa: tx.amountPaisa,
                    type: tx.type,
                    category: tx.category,
                    source: tx.source,
                    timestamp: tx.timestamp,
                    merchantName: tx.merchantName,
                    description: tx.description,
                  );
            }
            ref.invalidate(transactionPageProvider);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pageState = ref.watch(transactionPageProvider);
    final query = ref.watch(transactionQueryProvider).toLowerCase();

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.gradientNight),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontal,
            vertical: AppSpacing.screenVertical,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('Transactions',
                        style: AppTypography.h2.copyWith(
                          color: AppColors.textPrimary,
                        )),
                  ),
                  if (_selectedIds.isNotEmpty)
                    IconButton(
                      onPressed: () {
                        final items = ref.read(transactionPageProvider).items;
                        final allSelected = _selectedIds.length == items.length;
                        setState(() {
                          if (allSelected) {
                            _selectedIds.clear();
                          } else {
                            _selectedIds
                              ..clear()
                              ..addAll(items.map((e) => e.id));
                          }
                        });
                      },
                      icon: const Icon(Icons.select_all,
                          color: AppColors.textSecondary),
                    ),
                  if (_selectedIds.isNotEmpty)
                    IconButton(
                      onPressed: () => _confirmDeleteSelected(context),
                      icon: const Icon(Icons.delete, color: AppColors.error),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _searchController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Search transactions...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  _debounce?.cancel();
                  _debounce = Timer(const Duration(milliseconds: 350), () {
                    ref.read(transactionQueryProvider.notifier).state = value;
                  });
                },
                onSubmitted: (value) {
                  ref.read(searchHistoryProvider.notifier).add(value);
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              _RecentSearches(
                controller: _searchController,
                onSelected: (value) {
                  _searchController.text = value;
                  ref.read(transactionQueryProvider.notifier).state = value;
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              _FilterChips(
                value: _filter,
                onChanged: (value) {
                  setState(() => _filter = value);
                  ref.read(transactionCategoryProvider.notifier).state = value;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(transactionPageProvider.notifier).refresh();
                  },
                  child: pageState.error != null
                      ? ListView(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: AppSpacing.xl),
                              child: Center(
                                child: Text(
                                  pageState.error!,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.error,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : pageState.items.isEmpty && pageState.isLoading
                          ? ListView(
                              children: const [
                                SizedBox(height: 120),
                                Center(child: CircularProgressIndicator()),
                              ],
                            )
                          : pageState.items.isEmpty
                              ? ListView(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: AppSpacing.xl),
                                      child: Center(
                                        child: Text(
                                          'No transactions found',
                                          style:
                                              AppTypography.bodyMedium.copyWith(
                                            color: AppColors.textMuted,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : ListView.separated(
                                  itemCount: pageState.items.length + 1,
                                  separatorBuilder: (_, __) => const Divider(
                                    color: AppColors.dusk700,
                                  ),
                                  itemBuilder: (context, index) {
                                    if (index == pageState.items.length) {
                                      if (pageState.nextOffset == null) {
                                        return const SizedBox(height: 80);
                                      }
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: AppSpacing.md),
                                        child: Center(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              ref
                                                  .read(transactionPageProvider
                                                      .notifier)
                                                  .loadMore();
                                            },
                                            child: pageState.isLoading
                                                ? const SizedBox(
                                                    height: 16,
                                                    width: 16,
                                                    child:
                                                        CircularProgressIndicator(
                                                            strokeWidth: 2),
                                                  )
                                                : const Text('Load more'),
                                          ),
                                        ),
                                      );
                                    }
                                    final tx = pageState.items[index];
                                    final selected =
                                        _selectedIds.contains(tx.id);
                                    return Dismissible(
                                      key: ValueKey(tx.id),
                                      background: const _SwipeAction(
                                        label: 'Edit',
                                        icon: Icons.edit,
                                        color: AppColors.dusk600,
                                        alignment: Alignment.centerLeft,
                                      ),
                                      secondaryBackground: const _SwipeAction(
                                        label: 'Category',
                                        icon: Icons.category,
                                        color: AppColors.dusk700,
                                        alignment: Alignment.centerRight,
                                      ),
                                      confirmDismiss: (direction) async {
                                        if (direction ==
                                            DismissDirection.startToEnd) {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  EditTransactionScreen(tx: tx),
                                            ),
                                          );
                                          return false;
                                        }
                                        await _showCategoryPicker(
                                            context, ref, tx);
                                        return false;
                                      },
                                      child: GestureDetector(
                                        onLongPress: () {
                                          setState(() {
                                            if (_selectedIds.contains(tx.id)) {
                                              _selectedIds.remove(tx.id);
                                            } else {
                                              _selectedIds.add(tx.id);
                                            }
                                          });
                                        },
                                        child: ListTile(
                                          selected: selected,
                                          leading: selected
                                              ? const CircleAvatar(
                                                  backgroundColor:
                                                      AppColors.dusk600,
                                                  child: Icon(Icons.check,
                                                      color: AppColors
                                                          .textPrimary),
                                                )
                                              : const CircleAvatar(
                                                  backgroundColor:
                                                      AppColors.dusk700,
                                                  child: Icon(
                                                      Icons.receipt_long,
                                                      color: AppColors
                                                          .textPrimary),
                                                ),
                                          title: _HighlightedText(
                                            text: tx.merchantName ??
                                                'Transaction',
                                            lowerText: tx.lowerMerchantName ??
                                                'transaction',
                                            lowerQuery: query,
                                            baseStyle: AppTypography.bodyLarge
                                                .copyWith(
                                              color: AppColors.textPrimary,
                                            ),
                                            highlightColor: AppColors.gold400,
                                          ),
                                          subtitle: _HighlightedText(
                                            text: tx.category,
                                            lowerText: tx.lowerCategory,
                                            lowerQuery: query,
                                            baseStyle: AppTypography.bodyMedium
                                                .copyWith(
                                              color: AppColors.textSecondary,
                                            ),
                                            highlightColor: AppColors.gold400,
                                          ),
                                          trailing: Text(
                                            tx.amountLabel,
                                            style: AppTypography.bodyLarge
                                                .copyWith(
                                              color: tx.type == 'credit'
                                                  ? AppColors.success
                                                  : AppColors.textPrimary,
                                            ),
                                          ),
                                          onTap: () {
                                            if (_selectedIds.isNotEmpty) {
                                              setState(() {
                                                if (_selectedIds
                                                    .contains(tx.id)) {
                                                  _selectedIds.remove(tx.id);
                                                } else {
                                                  _selectedIds.add(tx.id);
                                                }
                                              });
                                              return;
                                            }
                                            showModalBottomSheet(
                                              context: context,
                                              backgroundColor:
                                                  Colors.transparent,
                                              builder: (_) =>
                                                  TransactionDetailSheet(
                                                      tx: tx),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _Chip(label: 'All', value: 'all', group: value, onChanged: onChanged),
          const SizedBox(width: 8),
          _Chip(
              label: 'Food', value: 'food', group: value, onChanged: onChanged),
          const SizedBox(width: 8),
          _Chip(
              label: 'Transport',
              value: 'transportation',
              group: value,
              onChanged: onChanged),
          const SizedBox(width: 8),
          _Chip(
              label: 'Shopping',
              value: 'shopping',
              group: value,
              onChanged: onChanged),
          const SizedBox(width: 8),
          _Chip(
              label: 'Entertainment',
              value: 'entertainment',
              group: value,
              onChanged: onChanged),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.value,
    required this.group,
    required this.onChanged,
  });

  final String label;
  final String value;
  final String group;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final active = value == group;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.dusk600 : AppColors.darkSurface,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(label,
            style: AppTypography.bodyMedium.copyWith(
              color: active ? AppColors.textPrimary : AppColors.textSecondary,
            )),
      ),
    );
  }
}

class _SwipeAction extends StatelessWidget {
  const _SwipeAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.alignment,
  });

  final String label;
  final IconData icon;
  final Color color;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: color,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.textPrimary),
          const SizedBox(width: 8),
          Text(label,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              )),
        ],
      ),
    );
  }
}

Future<void> _showCategoryPicker(
  BuildContext context,
  WidgetRef ref,
  TransactionModel tx,
) async {
  final selected = await showModalBottomSheet<String>(
    context: context,
    backgroundColor: AppColors.darkSurface,
    builder: (_) {
      const items = [
        'food',
        'transportation',
        'entertainment',
        'education',
        'shopping',
        'utilities',
        'other',
      ];
      return ListView(
        shrinkWrap: true,
        children: items
            .map(
              (value) => ListTile(
                title: Text(value,
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textPrimary,
                    )),
                onTap: () => Navigator.of(context).pop(value),
              ),
            )
            .toList(),
      );
    },
  );
  if (selected == null || selected == tx.category) return;
  final token = await ref.read(sessionStoreProvider).readToken();
  if (token == null) return;
  await ref.read(transactionsApiProvider).update(
        token: token,
        id: tx.id,
        amountPaisa: tx.amountPaisa,
        type: tx.type,
        category: selected,
        source: tx.source,
        timestamp: tx.timestamp,
        merchantName: tx.merchantName,
        description: tx.description,
      );
  ref.invalidate(transactionsProvider);
}

class _RecentSearches extends ConsumerWidget {
  const _RecentSearches({required this.controller, required this.onSelected});

  final TextEditingController controller;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(searchHistoryProvider);
    if (history.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: history.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final term = history[index];
          return GestureDetector(
            onTap: () {
              onSelected(term);
              ref.read(searchHistoryProvider.notifier).add(term);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(term,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  )),
            ),
          );
        },
      ),
    );
  }
}

class _HighlightedText extends StatelessWidget {
  const _HighlightedText({
    required this.text,
    this.lowerText,
    required this.lowerQuery,
    required this.baseStyle,
    required this.highlightColor,
  });

  final String text;
  final String? lowerText;
  final String lowerQuery;
  final TextStyle baseStyle;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    if (lowerQuery.isEmpty) {
      return Text(text, style: baseStyle);
    }
    final actualLowerText = lowerText ?? text.toLowerCase();
    final matchIndex = actualLowerText.indexOf(lowerQuery);
    if (matchIndex == -1) {
      return Text(text, style: baseStyle);
    }
    final before = text.substring(0, matchIndex);
    final match = text.substring(matchIndex, matchIndex + lowerQuery.length);
    final after = text.substring(matchIndex + lowerQuery.length);
    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: before),
          TextSpan(
            text: match,
            style: baseStyle.copyWith(color: highlightColor),
          ),
          TextSpan(text: after),
        ],
      ),
    );
  }
}
