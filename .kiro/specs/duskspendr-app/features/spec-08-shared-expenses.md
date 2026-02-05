# Spec 8: Shared Expenses & Social Features

## Overview

This specification covers the shared expense tracking features that allow students to split costs with friends, track who owes money, and manage group expenses while maintaining individual privacy.

**Priority:** P1 (Enhanced Feature)  
**Estimated Effort:** 2 sprints  
**Dependencies:** Spec 1, Spec 4, Spec 6

---

## Goals

1. Enable marking expenses as shared with specific friends
2. Automatically calculate individual shares
3. Track who owes money and who is owed
4. Manage settlements between friends
5. Maintain privacy of individual spending data

---

## Use Cases

### Student Scenarios
- **Lunch splits**: Daily cafeteria meals with friends
- **Movie outings**: Ticket and snack splitting
- **Trip expenses**: Shared accommodation, transport, food
- **Subscription sharing**: Netflix, Spotify family plans
- **Rent splitting**: Hostel or PG room sharing
- **Group gifts**: Birthday presents, farewell gifts

---

## Tickets

### SS-100: Design shared expense data model
**Priority:** P1 | **Points:** 3

**Description:**
Design the data model for shared expenses, friends, and settlements.

**Acceptance Criteria:**
- [ ] Define SharedExpense entity
- [ ] Define Friend/Participant entity
- [ ] Define Settlement entity
- [ ] Define Group entity (for repeated splits)
- [ ] Design relationships between entities
- [ ] Plan privacy protection approach
- [ ] Document data flow diagrams

**Data Models:**
```kotlin
@Entity(tableName = "shared_expenses")
data class SharedExpense(
    @PrimaryKey val id: String,
    val transactionId: String?,
    val groupId: String?,
    val description: String,
    val totalAmount: Money,
    val paidBy: String,  // userId
    val splitType: SplitType,
    val participants: List<Participant>,
    val isSettled: Boolean,
    val createdAt: Instant
)

data class Participant(
    val id: String,
    val name: String,
    val phone: String?,  // Optional for matching
    val share: Money,
    val hasPaid: Boolean,
    val paidAmount: Money?
)

@Entity(tableName = "friends")
data class Friend(
    @PrimaryKey val id: String,
    val name: String,
    val phone: String?,
    val email: String?,
    val avatarUrl: String?,
    val totalOwed: Money,   // They owe you
    val totalOwing: Money,  // You owe them
    val netBalance: Money
)
```

**Dependencies:** Spec 1 complete

---

### SS-101: Implement expense splitting calculator
**Priority:** P1 | **Points:** 8

**Description:**
Build the calculation engine for different split types.

**Acceptance Criteria:**
- [ ] Equal split calculation
- [ ] Percentage-based split
- [ ] Exact amount split
- [ ] Unequal split with adjustment
- [ ] Handle rounding for equal splits
- [ ] Support different currency (future)
- [ ] Calculate individual shares
- [ ] Update share when participants change
- [ ] Validate total equals sum of shares

**Split Types:**
```kotlin
enum class SplitType {
    EQUAL,      // Divide equally
    PERCENTAGE, // Each pays X%
    EXACT,      // Each pays specific amount
    SHARES,     // Based on share units (1x, 2x)
    ADJUSTMENT  // Equal with adjustments
}
```

**Split Calculation:**
```
Equal: totalAmount / participantCount
Percentage: totalAmount * (percentage / 100)
Shares: totalAmount * (personShares / totalShares)
```

**Dependencies:** SS-100

---

### SS-102: Create group/friend management
**Priority:** P1 | **Points:** 8

**Description:**
Build friend list and group management functionality.

**Acceptance Criteria:**
- [ ] Add friend manually (name, phone)
- [ ] Import from contacts (optional)
- [ ] Create groups for repeated splits
- [ ] Edit friend details
- [ ] Delete friend (with settlement check)
- [ ] View friend's expense history (shared only)
- [ ] Group member management
- [ ] Friend suggestions based on shared expenses
- [ ] Merge duplicate friends

**Friend Management:**
- Friends are local-only (no account required)
- Phone number for future UPI integration
- Groups for college friends, roommates, etc.

**Dependencies:** SS-100

---

### SS-103: Build who-owes-whom tracker
**Priority:** P1 | **Points:** 8

**Description:**
Track balances between the user and each friend/group.

**Acceptance Criteria:**
- [ ] Calculate net balance per friend
- [ ] Show "You owe" vs "Owes you" clearly
- [ ] Aggregate across all shared expenses
- [ ] Handle partial payments
- [ ] Show balance history
- [ ] Group balance summary
- [ ] Total balance (all friends combined)
- [ ] Simplify debts (optional: A→B→C becomes A→C)

**Balance View:**
```
Friends
--------
Rahul       You owe ₹150
Priya       Owes you ₹80
Amit        Owes you ₹220
Sanjay      Settled ✓
--------
Net: You're owed ₹150
```

**Dependencies:** SS-101

---

### SS-104: Implement settlement tracking
**Priority:** P1 | **Points:** 5

**Description:**
Record when shared expenses are settled between friends.

**Acceptance Criteria:**
- [ ] Record full settlement
- [ ] Record partial payment
- [ ] Settlement with specific expense
- [ ] General settlement (reduce balance)
- [ ] Update net balance after settlement
- [ ] Settlement confirmation prompt
- [ ] Settlement history view
- [ ] Undo settlement option

**Settlement Flow:**
1. Select friend or expense
2. Enter settlement amount
3. Confirm settlement
4. Update balances
5. Show confirmation

**Dependencies:** SS-103

---

### SS-105: Create settlement reminders
**Priority:** P2 | **Points:** 5

**Description:**
Send reminders for pending settlements.

**Acceptance Criteria:**
- [ ] Configure reminder frequency
- [ ] Reminder for old unsettled expenses (>7 days)
- [ ] Push notification for reminders
- [ ] Quick settle action from notification
- [ ] WhatsApp share reminder message (optional)
- [ ] Gentle reminder tone
- [ ] Snooze reminder option

**Reminder Message:**
```
Hey! Just a friendly reminder that you owe me ₹150 
for our lunch last week. Settle up when you can! 🙂
```

**Dependencies:** SS-104

---

### SS-106: Build shared expense UI
**Priority:** P1 | **Points:** 8

**Description:**
Create the complete user interface for shared expenses.

**Acceptance Criteria:**
- [ ] Shared expenses tab/section
- [ ] Add shared expense screen
  - Amount input
  - Split type selector
  - Participant selector
  - Who paid selector
  - Notes field
- [ ] Shared expense list view
- [ ] Expense detail view
- [ ] Friend list screen
- [ ] Group management screen
- [ ] Balance summary card on dashboard
- [ ] Settlement recording screen
- [ ] Empty states and onboarding

**Add Expense Flow:**
1. Enter total amount
2. Select/add participants
3. Choose split type
4. Indicate who paid
5. Add description
6. Save

**Dependencies:** SS-102, SS-103

---

### SS-107: Implement privacy protection for individual spending
**Priority:** P1 | **Points:** 5

**Description:**
Ensure individual spending data is never shared with friends.

**Acceptance Criteria:**
- [ ] Shared expenses stored separately from personal
- [ ] Never expose personal transaction history
- [ ] Friends only see their shared expenses
- [ ] No total spending revealed
- [ ] Clear privacy indicators in UI
- [ ] Privacy settings for shared features
- [ ] Data isolation verification tests

**Privacy Principles:**
- Friends ONLY see shared expenses involving them
- No individual transaction data exposed
- No spending totals shared
- No category breakdowns shared
- Group is just for organization, not data access

**Dependencies:** SS-100

---

## Future Considerations

> [!TIP]
> These features can be added in future versions:
> - **UPI settle-up**: Direct payment through UPI
> - **QR code sharing**: Share balance via QR
> - **Friend sync**: Cross-device friend list sync
> - **Group chat**: Discuss expenses in-app
> - **Receipt scanning**: Split from receipt items
> - **Travel mode**: Trip expense management

---

## Verification Plan

### Unit Tests
- Split calculation accuracy tests
- Balance calculation tests
- Settlement logic tests

### Integration Tests
- Add expense → Balance update flow
- Settlement → Balance update flow
- Friend management operations

### Privacy Tests
- Verify data isolation
- Check no personal data leakage
- Friend data access restrictions

### UI Tests
- Add shared expense flow
- Friend management flow
- Settlement recording flow

---

## Definition of Done

- [ ] Expense splitting working (all types)
- [ ] Friend/group management complete
- [ ] Balance tracking accurate
- [ ] Settlement recording functional
- [ ] Privacy verification passed
- [ ] UI complete and polished
- [ ] All P1 tickets complete
