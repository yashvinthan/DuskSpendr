# Spec 6: Student Dashboard UI

## Overview

This specification covers the main user interface design, including the student-friendly dashboard, visualizations, gamification elements, and overall user experience.

**Priority:** P0 (Core Feature)  
**Estimated Effort:** 3 sprints  
**Dependencies:** Spec 1, Spec 4, Spec 5

---

## Goals

1. Create a youth-friendly, engaging interface
2. Build intuitive spending visualizations
3. Implement gamification with Student Finance Score
4. Provide weekly/monthly spending summaries
5. Design smooth onboarding experience

---

## Design Principles

### Student-Focused UX
- **Simplicity**: Clean, uncluttered interface
- **Visual**: Charts and icons over walls of text
- **Engaging**: Animations, gamification, achievements
- **Fast**: Quick actions, minimal taps
- **Fun**: Celebratory feedback, playful language

### Color Palette

| Purpose | Color | Usage |
|---------|-------|-------|
| Primary | #6C5CE7 | Actions, focus elements |
| Accent | #00B894 | Success, positive amounts |
| Warning | #FDCB6E | Alerts, approaching limits |
| Danger | #E17055 | Over budget, debits |
| Background | #F5F6FA | Light mode background |
| Dark BG | #1E272E | Dark mode background |

---

## Tickets

### SS-080: Design student-friendly UI theme
**Priority:** P0 | **Points:** 8

**Description:**
Create the overall design system and theme for the DuskSpendr app.

**Acceptance Criteria:**
- [ ] Define color palette (light and dark mode)
- [ ] Create typography scale
- [ ] Design component library
  - Buttons (primary, secondary, ghost)
  - Cards (transaction, summary, dashboard)
  - Input fields
  - Navigation elements
- [ ] Create icon set or select icon library
- [ ] Design loading states and skeletons
- [ ] Define spacing and sizing system
- [ ] Create Compose theme implementation
- [ ] Document design tokens

**Typography:**
```
Heading 1: 28sp, Bold
Heading 2: 24sp, SemiBold
Heading 3: 20sp, Medium
Body Large: 16sp, Regular
Body: 14sp, Regular
Caption: 12sp, Regular
```

**Dependencies:** None

---

### SS-081: Create main dashboard with spending overview
**Priority:** P0 | **Points:** 8

**Description:**
Build the main home screen dashboard with key financial metrics.

**Acceptance Criteria:**
- [ ] Total balance card (large, prominent)
- [ ] Today's spending summary
- [ ] Budget progress indicator
- [ ] Quick action buttons (Add expense, Scan, Accounts)
- [ ] Recent transactions preview (last 5)
- [ ] Finance Score badge preview
- [ ] Bottom navigation bar
- [ ] Pull-to-refresh functionality
- [ ] Smooth scroll behavior

**Dashboard Layout:**
```
┌─────────────────────────┐
│  Total Balance: ₹5,000  │
│  ▲₹200 Today            │
├─────────────────────────┤
│  Budget: ████████░░ 80% │
│  ₹800/₹1000 remaining   │
├─────────────────────────┤
│  [+ Add] [📷] [🔗]      │
├─────────────────────────┤
│  Recent Transactions    │
│  • Swiggy      -₹250    │
│  • Uber        -₹120    │
│  • Mom         +₹2000   │
│          See All →      │
└─────────────────────────┘
```

**Dependencies:** SS-080

---

### SS-082: Build expense visualization charts
**Priority:** P0 | **Points:** 8

**Description:**
Create interactive charts for visualizing spending patterns.

**Acceptance Criteria:**
- [ ] Pie/Donut chart for category breakdown
- [ ] Bar chart for daily spending trend
- [ ] Line chart for weekly/monthly trend
- [ ] Interactive chart tooltips
- [ ] Category legend with percentages
- [ ] Time period selector (7d/30d/90d)
- [ ] Smooth animations on data change
- [ ] Empty state when no data
- [ ] Accessibility for charts

**Chart Library**: MPAndroidChart or Compose Charts

**Dependencies:** SS-080

---

### SS-083: Implement Student Finance Score (gamification)
**Priority:** P1 | **Points:** 13

**Description:**
Create the Student Finance Score system with levels and achievements.

**Acceptance Criteria:**
- [ ] Calculate Finance Score (0-100)
- [ ] Score breakdown (budgeting, saving, discipline)
- [ ] Display score with visual gauge
- [ ] Score level tiers:
  - Beginner (0-20)
  - Saver (21-40)
  - Smart Spender (41-60)
  - Money Master (61-80)
  - Finance Wizard (81-100)
- [ ] Weekly score change indicator
- [ ] Tips to improve score
- [ ] Achievements system
  - First budget created
  - Week under budget
  - Saved 20% of pocket money
  - Categorized 100 transactions
- [ ] Achievement badges display
- [ ] Score sharing capability (optional)

**Score Calculation:**
```
Budget Score (30%): How often under budget
Savings Score (25%): Percentage saved vs spent
Consistency Score (20%): Regular tracking habits  
Categorization Score (15%): Accuracy of categories
Goal Score (10%): Progress toward goals
```

**Dependencies:** SS-081

---

### SS-084: Create weekly/monthly summary views
**Priority:** P0 | **Points:** 8

**Description:**
Build summary screens for weekly and monthly spending analysis.

**Acceptance Criteria:**
- [ ] Weekly summary card
  - Total spent this week
  - Category breakdown
  - Comparison to last week
  - Top spending day
- [ ] Monthly summary
  - Total spent this month
  - Budget vs actual
  - Category trends
  - Comparison to last month
- [ ] Swipe between weeks/months
- [ ] Export summary as image
- [ ] Share summary capability
- [ ] Insights and recommendations

**Summary Components:**
- Spending total with trend arrow
- Category bars ranked by amount
- Day-by-day mini chart
- Key highlights (biggest expense, saved amount)

**Dependencies:** SS-082

---

### SS-085: Build spending trend analysis UI
**Priority:** P1 | **Points:** 5

**Description:**
Create detailed trend analysis view for deep spending insights.

**Acceptance Criteria:**
- [ ] Long-term trend chart (3-6 months)
- [ ] Category trend comparison
- [ ] Spending velocity indicator
- [ ] Seasonal pattern detection
- [ ] Year-over-year comparison (when available)
- [ ] Drill-down by category
- [ ] Export trend data

**Dependencies:** SS-082

---

### SS-086: Implement quick action shortcuts
**Priority:** P1 | **Points:** 3

**Description:**
Create shortcut widgets and quick actions for common tasks.

**Acceptance Criteria:**
- [ ] Floating action button for quick add
- [ ] Speed dial options (Expense, Income, Transfer)
- [ ] Android app shortcuts (long press icon)
- [ ] Home screen widget for balance
- [ ] Quick expense entry widget
- [ ] Notification actions for transactions

**Quick Actions:**
- Add cash expense (1 tap)
- View today's spending
- Check budget status
- Scan receipt (future)

**Dependencies:** SS-081

---

### SS-087: Create onboarding tutorial flow
**Priority:** P0 | **Points:** 8

**Description:**
Design and implement first-time user onboarding experience.

**Acceptance Criteria:**
- [ ] Welcome screen with app intro
- [ ] Permission requests with explanations
  - SMS permission (for tracking)
  - Notification permission (for alerts)
- [ ] Account linking prompt
- [ ] Budget setup wizard
- [ ] Feature highlights tour
- [ ] Profile creation (name, avatar)
- [ ] Skip option at each step
- [ ] Progress indicator
- [ ] Celebratory completion animation

**Onboarding Steps:**
1. Welcome to DuskSpendr 🎉
2. Let's track your expenses automatically (SMS permission)
3. Connect your accounts (Bank/UPI linking)
4. Set your first budget (Quick budget setup)
5. You're all set! (Dashboard tour)

**Dependencies:** SS-080, SS-081

---

### SS-088: Build settings and preferences screen
**Priority:** P0 | **Points:** 5

**Description:**
Create comprehensive settings screen for app configuration.

**Acceptance Criteria:**
- [ ] Profile section
- [ ] Linked accounts management link
- [ ] Notification settings
  - Budget alerts on/off
  - Daily summary on/off
  - Bill reminders on/off
- [ ] Privacy settings
  - SMS processing toggle
  - Data export
  - Privacy report view
- [ ] Appearance settings
  - Theme (light/dark/system)
  - Currency format
  - Language (English/Hindi)
- [ ] Security settings
  - Change PIN
  - Biometric toggle
  - Auto-lock timeout
- [ ] About section
- [ ] Help and support
- [ ] Logout/delete account

**Dependencies:** SS-080

---

### SS-089: Implement dark mode support
**Priority:** P2 | **Points:** 3

**Description:**
Add dark mode theme with automatic system detection.

**Acceptance Criteria:**
- [ ] Dark mode color palette
- [ ] System theme detection
- [ ] Manual theme toggle
- [ ] Smooth theme transition
- [ ] OLED-friendly true black option
- [ ] All screens support dark mode
- [ ] Chart colors adapted for dark mode

**Dependencies:** SS-080

---

## Verification Plan

### UI Tests
- Dashboard rendering tests
- Chart interaction tests
- Onboarding flow completion
- Theme switching
- Navigation flow

### Usability Testing
- User testing with 5-10 students
- Task completion time metrics
- Engagement analysis
- Feedback collection

### Accessibility Testing
- Screen reader compatibility
- Color contrast verification
- Touch target sizes
- Text scaling support

### Performance Testing
- Dashboard load time (<2s)
- Chart rendering performance
- Smooth scrolling (60 FPS)
- Memory usage optimization

---

## Definition of Done

- [ ] All screens designed and implemented
- [ ] Dark mode fully functional
- [ ] Charts interactive and accurate
- [ ] Onboarding complete and tested
- [ ] Gamification system working
- [ ] Accessibility verified
- [ ] User testing feedback incorporated
