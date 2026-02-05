# SS-070: Shared Expenses & Bill Splitting

## Ticket Metadata

| Field | Value |
|-------|-------|
| **Ticket ID** | SS-070 |
| **Epic** | Social Features |
| **Type** | Feature |
| **Priority** | P1 - High |
| **Story Points** | 13 |
| **Sprint** | Sprint 6-7 |
| **Assignee** | TBD |
| **Labels** | `social`, `bill-split`, `groups`, `flutter`, `postgresql` |

---

## User Story

**As a** student living with roommates/friends  
**I want** to easily split bills and track who owes whom  
**So that** I can manage group expenses without awkward money conversations

---

## Description

Build a shared expenses feature that enables students to create expense groups (roommates, trips, events), split bills evenly or by custom amounts, track individual balances, and settle up with friends. The feature should simplify the common student experience of managing group finances.

---

## Acceptance Criteria

### AC1: Group Creation
```gherkin
Given I want to track expenses with others
When I create a group
Then I can:
  | Field | Details |
  | Name | "Apartment", "Goa Trip", "Party Fund" |
  | Members | Add by phone, email, or in-app invite |
  | Type | Roommates, Trip, Event, Custom |
  | Icon/Image | Select or upload |
And non-DuskSpendr members get SMS invite link
And group syncs across all member devices
```

### AC2: Adding Shared Expense
```gherkin
Given I paid for something shared
When I add a shared expense
Then I specify:
  | Field | Options |
  | Amount | ₹100 - ₹100,000 |
  | Description | "Groceries", "Netflix", "Rent" |
  | Paid by | Me or select member |
  | Split Type | Equal, Percentage, Exact amounts |
  | Date | Default today, can change |
  | Receipt | Optional photo |
And all members see the expense
And individual balances update automatically
```

### AC3: Split Calculations
```gherkin
Given a ₹1000 expense among 4 people
When splitting equally
Then each person's share = ₹250
And payer's balance increases by ₹750 (what others owe them)
And each non-payer's balance decreases by ₹250 (what they owe)

Given a ₹1000 expense with custom split
When I set 60%/20%/20% split
Then shares are ₹600, ₹200, ₹200 respectively
```

### AC4: Balance Dashboard
```gherkin
Given I'm viewing a group
Then I see:
  - Overall balance ("You are owed ₹500" or "You owe ₹300")
  - Per-member breakdown:
    | Member | Balance |
    | Rahul | You owe ₹200 |
    | Priya | Owes you ₹400 |
    | Amit | Settled |
  - Recent group expenses
  - Settle up button
And balances are color-coded (red = owe, green = owed)
```

### AC5: Settlement
```gherkin
Given I owe Rahul ₹200
When I tap "Settle Up" with Rahul
Then I can:
  - Record cash payment
  - Send UPI payment request (deep link to UPI apps)
  - Partial settlement (pay ₹100, still owe ₹100)
And both accounts update
And settlement shows in activity log
```

### AC6: Activity Feed
```gherkin
Given group has activity
Then show chronological feed:
  - "You added 'Groceries' ₹500 (split 3 ways)"
  - "Rahul paid you ₹200"
  - "Priya joined the group"
And each entry shows timestamp
And can filter by type (expenses, settlements)
```

### AC7: Notifications
```gherkin
Given I'm in a group
Then receive notifications for:
  | Event | Notification |
  | New expense added | "Rahul added 'Pizza' ₹800 in 'Roommates'" |
  | Someone pays me | "Priya settled ₹500 with you" |
  | Reminder | "You owe ₹1000 to Apartment group" (weekly opt-in) |
And notifications are configurable per group
```

---

## Technical Implementation

### Flutter UI

```dart
// lib/features/shared_expenses/presentation/screens/group_detail_screen.dart
class GroupDetailScreen extends ConsumerWidget {
  final String groupId;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = ref.watch(groupDetailProvider(groupId));
    
    return Scaffold(
      body: group.when(
        data: (g) => CustomScrollView(
          slivers: [
            // Header with group info
            SliverAppBar(
              expandedHeight: 160,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(g.name),
                background: _GroupHeader(group: g),
              ),
            ),
            
            // Balance summary
            SliverToBoxAdapter(
              child: BalanceSummaryCard(
                balance: g.myBalance,
                memberBalances: g.memberBalances,
                onSettleUp: () => _showSettleSheet(context, g),
              ),
            ),
            
            // Member balances
            SliverToBoxAdapter(
              child: MemberBalancesList(
                members: g.members,
                balances: g.memberBalances,
              ),
            ),
            
            // Recent expenses
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Recent Expenses', style: context.textTheme.titleMedium),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => ExpenseListTile(
                  expense: g.expenses[i],
                  currentUserId: ref.read(currentUserProvider).id,
                ),
                childCount: g.expenses.length.clamp(0, 10),
              ),
            ),
          ],
        ),
        loading: () => const GroupDetailSkeleton(),
        error: (e, s) => ErrorView(error: e),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddExpense(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
    );
  }
  
  void _showSettleSheet(BuildContext context, Group group) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => SettleUpSheet(group: group),
    );
  }
}

// lib/features/shared_expenses/presentation/widgets/split_selector.dart
class SplitSelector extends StatefulWidget {
  final List<GroupMember> members;
  final double totalAmount;
  final Function(Map<String, double>) onSplitChanged;
  
  @override
  State<SplitSelector> createState() => _SplitSelectorState();
}

class _SplitSelectorState extends State<SplitSelector> {
  SplitType _type = SplitType.equal;
  final Map<String, double> _customSplits = {};
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Split type toggle
        SegmentedButton<SplitType>(
          selected: {_type},
          onSelectionChanged: (s) => setState(() => _type = s.first),
          segments: const [
            ButtonSegment(value: SplitType.equal, label: Text('Equal')),
            ButtonSegment(value: SplitType.percentage, label: Text('%')),
            ButtonSegment(value: SplitType.exact, label: Text('Exact')),
          ],
        ),
        const SizedBox(height: 16),
        
        // Member split list
        if (_type == SplitType.equal)
          _EqualSplitView(
            members: widget.members,
            amount: widget.totalAmount,
          )
        else if (_type == SplitType.percentage)
          _PercentageSplitView(
            members: widget.members,
            amount: widget.totalAmount,
            onChanged: _updateSplits,
          )
        else
          _ExactSplitView(
            members: widget.members,
            onChanged: _updateSplits,
          ),
      ],
    );
  }
}
```

### PostgreSQL Schema

```sql
-- Shared expense groups
CREATE TABLE expense_groups (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    type VARCHAR(30) CHECK (type IN ('roommates', 'trip', 'event', 'custom')),
    icon_url TEXT,
    created_by UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Group members
CREATE TABLE group_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id UUID NOT NULL REFERENCES expense_groups(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id),  -- NULL for non-app members
    name VARCHAR(100) NOT NULL,          -- Fallback if not in app
    phone VARCHAR(20),
    email VARCHAR(255),
    invite_status VARCHAR(20) DEFAULT 'pending' CHECK (invite_status IN ('pending', 'accepted', 'declined')),
    is_admin BOOLEAN DEFAULT false,
    joined_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(group_id, user_id),
    UNIQUE(group_id, phone) WHERE user_id IS NULL
);

-- Shared expenses
CREATE TABLE shared_expenses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id UUID NOT NULL REFERENCES expense_groups(id) ON DELETE CASCADE,
    description VARCHAR(255) NOT NULL,
    amount DECIMAL(12,2) NOT NULL CHECK (amount > 0),
    paid_by UUID NOT NULL REFERENCES group_members(id),
    split_type VARCHAR(20) NOT NULL CHECK (split_type IN ('equal', 'percentage', 'exact')),
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    receipt_url TEXT,
    created_by UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Expense splits (who owes what)
CREATE TABLE expense_splits (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    expense_id UUID NOT NULL REFERENCES shared_expenses(id) ON DELETE CASCADE,
    member_id UUID NOT NULL REFERENCES group_members(id),
    amount DECIMAL(12,2) NOT NULL,
    percentage DECIMAL(5,2),  -- For percentage splits
    is_settled BOOLEAN DEFAULT false,
    UNIQUE(expense_id, member_id)
);

-- Settlements between members
CREATE TABLE settlements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id UUID NOT NULL REFERENCES expense_groups(id) ON DELETE CASCADE,
    from_member UUID NOT NULL REFERENCES group_members(id),
    to_member UUID NOT NULL REFERENCES group_members(id),
    amount DECIMAL(12,2) NOT NULL CHECK (amount > 0),
    method VARCHAR(30) CHECK (method IN ('cash', 'upi', 'bank', 'other')),
    note TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_group_members_group ON group_members(group_id);
CREATE INDEX idx_group_members_user ON group_members(user_id);
CREATE INDEX idx_shared_expenses_group ON shared_expenses(group_id);
CREATE INDEX idx_expense_splits_expense ON expense_splits(expense_id);
CREATE INDEX idx_settlements_group ON settlements(group_id);

-- Function to calculate member balances
CREATE OR REPLACE FUNCTION get_member_balance(p_group_id UUID, p_member_id UUID)
RETURNS DECIMAL AS $$
DECLARE
    v_owed DECIMAL := 0;
    v_owes DECIMAL := 0;
BEGIN
    -- What this member is owed (they paid)
    SELECT COALESCE(SUM(es.amount), 0) INTO v_owed
    FROM shared_expenses se
    JOIN expense_splits es ON se.id = es.expense_id
    WHERE se.group_id = p_group_id
      AND se.paid_by = p_member_id
      AND es.member_id != p_member_id
      AND es.is_settled = false;
    
    -- What this member owes (others paid)
    SELECT COALESCE(SUM(es.amount), 0) INTO v_owes
    FROM shared_expenses se
    JOIN expense_splits es ON se.id = es.expense_id
    WHERE se.group_id = p_group_id
      AND es.member_id = p_member_id
      AND se.paid_by != p_member_id
      AND es.is_settled = false;
    
    -- Subtract settlements
    SELECT v_owed - COALESCE(SUM(amount), 0) INTO v_owed
    FROM settlements
    WHERE group_id = p_group_id AND to_member = p_member_id;
    
    SELECT v_owes - COALESCE(SUM(amount), 0) INTO v_owes
    FROM settlements
    WHERE group_id = p_group_id AND from_member = p_member_id;
    
    RETURN v_owed - v_owes;  -- Positive = owed to them, Negative = owes others
END;
$$ LANGUAGE plpgsql;
```

### Serverpod Endpoints

```dart
// lib/src/endpoints/shared_expense_endpoint.dart
class SharedExpenseEndpoint extends Endpoint {
  
  Future<Group> createGroup(Session session, GroupCreateInput input) async {
    final userId = await session.authenticated;
    
    // Create group
    final group = Group(
      name: input.name,
      type: input.type,
      createdBy: userId,
    );
    final groupId = await Group.db.insertRow(session, group);
    
    // Add creator as admin member
    await GroupMember.db.insertRow(session, GroupMember(
      groupId: groupId,
      userId: userId,
      name: input.creatorName,
      isAdmin: true,
      inviteStatus: 'accepted',
    ));
    
    // Invite other members
    for (final invite in input.invites) {
      await _inviteMember(session, groupId, invite);
    }
    
    return group.copyWith(id: groupId);
  }
  
  Future<Expense> addExpense(Session session, ExpenseInput input) async {
    final userId = await session.authenticated;
    
    // Validate membership
    final isMember = await _validateMembership(session, input.groupId, userId);
    if (!isMember) throw UnauthorizedException();
    
    // Create expense
    final expense = SharedExpense(
      groupId: input.groupId,
      description: input.description,
      amount: input.amount,
      paidBy: input.paidByMemberId,
      splitType: input.splitType,
      date: input.date ?? DateTime.now(),
      createdBy: userId,
    );
    final expenseId = await SharedExpense.db.insertRow(session, expense);
    
    // Create splits
    final splits = _calculateSplits(input);
    for (final split in splits) {
      await ExpenseSplit.db.insertRow(session, split.copyWith(expenseId: expenseId));
    }
    
    // Notify members
    await _notifyExpenseAdded(session, expense, input.groupId);
    
    return expense.copyWith(id: expenseId);
  }
  
  Future<void> settleUp(Session session, SettlementInput input) async {
    final userId = await session.authenticated;
    
    // Record settlement
    final settlement = Settlement(
      groupId: input.groupId,
      fromMember: input.fromMemberId,
      toMember: input.toMemberId,
      amount: input.amount,
      method: input.method,
    );
    await Settlement.db.insertRow(session, settlement);
    
    // Notify recipient
    await _notifySettlement(session, settlement);
  }
}
```

---

## Definition of Done

- [ ] Group CRUD (create, read, update, delete)
- [ ] Member invitation (app + SMS)
- [ ] Add expense with 3 split types
- [ ] Balance calculations correct
- [ ] Settlement recording
- [ ] Activity feed
- [ ] Push notifications
- [ ] PostgreSQL schema + migrations
- [ ] Widget tests
- [ ] Integration tests
- [ ] Code reviewed

---

## Dependencies

| Ticket | Type | Description |
|--------|------|-------------|
| SS-201 | Blocks | User service (member lookup) |
| SS-209 | Blocks | Notification service |

---

## Blocks

| Ticket | Description |
|--------|-------------|
| SS-060 | Dashboard (group balance widget) |

---

## Security Considerations

1. **Group Access Control**: Only members can view/edit group data
2. **Member Validation**: Verify membership before any operation
3. **No Amount Tampering**: Server-side split calculations
4. **Invite Security**: One-time invite links with expiry

---

## Estimation Breakdown

| Task | Hours |
|------|-------|
| Group CRUD | 4 |
| Member invitation flow | 4 |
| Add expense UI | 4 |
| Split calculator | 3 |
| Balance calculations | 4 |
| Settlement flow | 3 |
| Activity feed | 3 |
| PostgreSQL schema | 3 |
| Backend endpoints | 6 |
| Widget tests | 4 |
| Integration tests | 2 |
| **Total** | **40 hours** |

---

## Related Links

- [Splitwise UX Inspiration](https://www.splitwise.com/)
- [UPI Deep Links](https://www.npci.org.in/what-we-do/upi/product-overview)

---

*Created: 2026-02-04 | Last Updated: 2026-02-05*
