# 📱 DuskSpendr Mobile App - Premium UI/UX Development Prompt

## Application Overview

**DuskSpendr** is a privacy-first AI-powered personal finance application designed specifically for **Indian college students**. Build a mobile application that automatically tracks expenses through secure bank/UPI account linking, SMS parsing, and intelligent categorization — all while ensuring maximum privacy with on-device processing.

---

## 🎯 Target Platform & Stack

### Technology Stack
- **Framework**: Flutter 3.x (Dart)
- **State Management**: Riverpod 2.x
- **Architecture**: Clean Architecture with MVVM
- **Local Database**: Drift with SQLCipher encryption
- **Backend Sync**: Serverpod (Dart) + Go (API Gateway)
- **ML/AI**: TensorFlow Lite (on-device categorization)
- **Charts**: fl_chart package
- **Animations**: 
  - Flutter built-in animations
  - Rive for complex micro-animations
  - Lottie for icon/illustration animations

### Platforms
- Primary: Android (minimum SDK 24)
- Secondary: iOS (minimum iOS 14)

---

## 🎨 Design System & Visual Identity

### Design Philosophy

1. **Dusk/Twilight Theme** - Brand-inspired aesthetic
   - Deep purples transitioning to warm sunset oranges
   - Starlit accent details
   - "Golden hour" glow effects

2. **Youth-Forward, Not Childish**
   - Modern, Instagram-worthy UI
   - Tech-forward aesthetic
   - Trustworthy (handling finances)
   - Clean with personality

3. **Premium Mobile Experience**
   - Buttery smooth 60fps animations
   - Haptic feedback on interactions
   - Gesture-driven navigation
   - Satisfying micro-interactions

---

## 🌅 Color Palette

```dart
// Primary - Twilight Purple
static const dusk900 = Color(0xFF1A0A2E);
static const dusk800 = Color(0xFF2D1B4E);
static const dusk700 = Color(0xFF432874);
static const dusk600 = Color(0xFF5C3D9A);
static const dusk500 = Color(0xFF7C3AED); // Primary accent

// Secondary - Sunset Orange/Gold
static const sunset500 = Color(0xFFF97316);
static const sunset400 = Color(0xFFFB923C);
static const sunset300 = Color(0xFFFDBA74);
static const gold500 = Color(0xFFEAB308);
static const gold400 = Color(0xFFFACC15);

// Gradients
static const gradientDusk = LinearGradient(
  colors: [Color(0xFF7C3AED), Color(0xFFF97316), Color(0xFFFACC15)],
);
static const gradientNight = LinearGradient(
  colors: [Color(0xFF1A0A2E), Color(0xFF432874), Color(0xFF5C3D9A)],
);

// Backgrounds
static const darkBackground = Color(0xFF0A0A0F);
static const darkSurface = Color(0xFF121218);
static const darkCard = Color(0xFF1A1A24);

// Text Colors
static const textPrimary = Color(0xFFFAFAFA);
static const textSecondary = Color(0xFFA1A1AA);
static const textMuted = Color(0xFF71717A);

// Semantic Colors
static const success = Color(0xFF22C55E);
static const warning = Color(0xFFEAB308);
static const error = Color(0xFFEF4444);
static const info = Color(0xFF3B82F6);

// Category Colors (for expense visualization)
static const categoryFood = Color(0xFFFF6B6B);
static const categoryTransport = Color(0xFF4ECDC4);
static const categoryEntertainment = Color(0xFFFFE66D);
static const categoryEducation = Color(0xFF95E1D3);
static const categoryShopping = Color(0xFFF38181);
static const categoryBills = Color(0xFF7C3AED);
static const categorySavings = Color(0xFF22C55E);
```

---

## 🔤 Typography

```dart
// Font Families
// Primary: Plus Jakarta Sans (headings, UI elements)
// Secondary: Inter (body text, data)
// Numeric: Space Mono or JetBrains Mono (amounts, stats)

class AppTypography {
  // Display - Hero numbers, big stats
  static const displayLarge = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 48,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.5,
  );
  
  // Headings
  static const h1 = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );
  
  static const h2 = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );
  
  static const h3 = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );
  
  // Body
  static const bodyLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );
  
  static const bodyMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );
  
  // Amounts/Numbers
  static const amount = TextStyle(
    fontFamily: 'SpaceMono',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );
  
  static const amountSmall = TextStyle(
    fontFamily: 'SpaceMono',
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
}
```

---

## 📐 Spacing & Layout

```dart
class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
  
  // Screen padding
  static const screenHorizontal = 20.0;
  static const screenVertical = 24.0;
}

class AppRadius {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const full = 999.0;
}
```

---

## 📱 Screen Specifications

### 1. Splash Screen
**Duration**: 2-3 seconds with animated logo

**Design Elements**:
- Dark gradient background (dusk900 → dusk700)
- Animated DuskSpendr logo:
  - Stylized "D" that transforms/morphs
  - Sunrise effect revealing the logo
  - Subtle particle effects
- "Your AI Finance Buddy" tagline fading in
- Progress indicator (subtle ring or dots)

**Animation Sequence**:
1. Background gradient animation (0-0.5s)
2. Logo reveal with glow effect (0.5-1.5s)
3. Tagline fade in (1.5-2s)
4. Transition to onboarding/home (2-3s)

---

### 2. Onboarding Flow (4-5 screens)

**Design Style**: Full-screen illustrations with parallax elements

**Screen 1 - Welcome**
```
Illustration: Student with floating financial icons around
Headline: "Take Control of Your Money"
Subtext: "Track every rupee without lifting a finger"
[Continue] button with gradient
Skip link (subtle)
Page indicator dots
```

**Screen 2 - Auto Tracking**
```
Illustration: Phone with transactions flying into it from bank/UPI icons
Headline: "Automatic Expense Tracking"
Subtext: "Link your bank, UPI, and wallets. We'll handle the rest."
Animated connection lines between icons
```

**Screen 3 - Privacy First**
```
Illustration: Shield with lock, phone with local processing visual
Headline: "Your Data Stays Private"
Subtext: "All SMS processing happens on your phone. We never see your messages."
Animated shield pulse effect
```

**Screen 4 - Smart Insights**
```
Illustration: Brain/AI icon with expense categories around it
Headline: "AI-Powered Insights"
Subtext: "Smart categorization, spending tips, and a Finance Score to gamify your savings."
Animated category icons sorting themselves
```

**Screen 5 - Get Started**
```
Illustration: Celebration confetti, happy student
Headline: "Ready to Start?"
Subtext: "Join 1M+ students who've mastered their finances"
[Create Account] - Primary CTA
[I already have an account] - Secondary link
```

**Animation Requirements**:
- Swipe/drag gesture between screens
- Parallax layers in illustrations
- Smooth page indicator transitions
- Background gradient shifts between screens
- Illustrations respond subtly to device tilt (accelerometer)

---

### 3. Authentication Screens

#### Login Screen
```
├── App logo (subtle, top)
├── Welcome back heading
├── Phone number input with +91 prefix
│   └── Gradient border on focus
├── OR divider with lines
├── Social login buttons (Google, Apple)
│   └── Outlined style with icons
├── [Send OTP] Primary button
│   └── Gradient background, loading state
└── "New here? Create account" link
```

#### OTP Verification
```
├── Phone number display (editable link)
├── 6-digit OTP input
│   └── Individual rounded boxes
│   └── Auto-focus next on input
│   └── Shake animation on error
├── Countdown timer for resend
├── [Verify] button (activates when 6 digits)
└── "Didn't receive? Resend OTP" link
```

#### Biometric Setup (after first login)
```
├── Fingerprint/Face icon (animated)
├── "Secure Your App"
├── Explanation text
├── [Enable Biometric] Primary
└── [Maybe Later] Secondary
```

---

### 4. Main Dashboard (Home Screen)

**Layout**: Scrollable with sticky header

```
┌─────────────────────────────────────────┐
│ [≡] Good evening, Priya! 👋    [🔔] [⚙️] │ ← Sticky header
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────────────────────────┐   │
│  │    Total Balance                │   │   ← Glassmorphism card
│  │    ₹24,560.00                   │   │      Gradient border
│  │                                 │   │
│  │  📈 +₹2,340 this month          │   │   ← Trend indicator
│  │                                 │   │
│  │  [SBI ₹15.2K] [HDFC ₹9.3K]     │   │   ← Account chips (scrollable)
│  └─────────────────────────────────┘   │
│                                         │
│  This Month's Spending                  │
│  ┌─────────────────────────────────┐   │
│  │  ₹12,450 spent of ₹20,000      │   │   ← Animated progress bar
│  │  ████████████░░░░░░░░░░ 62%    │   │      Color changes near limit
│  │                                 │   │
│  │  🍔 Food      ₹4,200  ████     │   │   ← Mini category bars
│  │  🚗 Transport ₹2,100  ██       │   │      Tap expands
│  │  🎮 Fun       ₹3,150  ███      │   │
│  └─────────────────────────────────┘   │
│                                         │
│  Recent Transactions                    │
│  ┌─────────────────────────────────┐   │
│  │ 🍕 Swiggy          -₹245       │   │
│  │    Food • Today 2:30 PM         │   │
│  ├─────────────────────────────────┤   │
│  │ 🚕 Uber            -₹180       │   │
│  │    Transport • Today 10:15 AM   │   │
│  ├─────────────────────────────────┤   │
│  │ 📚 Mom (Pocket)    +₹5,000     │   │   ← Green for income
│  │    Income • Yesterday           │   │
│  └─────────────────────────────────┘   │
│  [See All Transactions →]              │
│                                         │
│  Quick Actions                          │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐          │
│  │ ➕ │ │ 📊 │ │ 👥 │ │ 💡 │          │
│  │Add │ │Stats│ │Split│ │Tips│          │
│  └────┘ └────┘ └────┘ └────┘          │
│                                         │
│  Your Finance Score                     │
│  ┌─────────────────────────────────┐   │
│  │  ⭐ 78 / 100                    │   │   ← Animated gauge
│  │       "Doing Great!"            │   │      Gamification element
│  │  [See How to Improve →]         │   │
│  └─────────────────────────────────┘   │
│                                         │
└─────────────────────────────────────────┘
│ 🏠  │  📝  │  ➕  │  📊  │  👤  │       ← Bottom nav bar
│Home │Trans │ Add │Stats │Profile│           FAB for Add
```

**Interactive Features**:
- Pull-to-refresh with custom animation
- Balance card: Long press to hide amounts (privacy mode)
- Budget progress: Tap to expand category details
- Transaction items: Swipe right to edit, left to categorize
- Quick actions: Subtle bounce on tap
- Finance score gauge: Animated on scroll into view

---

### 5. All Transactions Screen

**Layout**: List with smart filtering

```
┌─────────────────────────────────────────┐
│  [←]  Transactions            [🔍] [⫶]  │
├─────────────────────────────────────────┤
│  ┌─────────────────────────────────┐   │
│  │ 🔍 Search transactions...       │   │
│  └─────────────────────────────────┘   │
│                                         │
│  Filter chips (horizontal scroll)       │
│  [All] [Food] [Transport] [UPI] [Card]  │
│                                         │
│  ── February 2026 ──────────────────    │
│                                         │
│  Today                     -₹2,450      │
│  ┌─────────────────────────────────┐   │
│  │ 🍕 Swiggy           -₹245      │   │
│  │    Food via PhonePe • 2:30 PM   │   │
│  │    [AI: 94% confident]          │   │   ← Category confidence
│  ├─────────────────────────────────┤   │
│  │ 🎬 PVR Cinemas      -₹450      │   │
│  │    Entertainment • 7:00 PM      │   │
│  └─────────────────────────────────┘   │
│                                         │
│  Yesterday                 +₹4,820      │
│  ┌─────────────────────────────────┐   │
│  │ 📚 Pocket Money     +₹5,000    │   │
│  │    Income • 9:00 AM             │   │
│  ├─────────────────────────────────┤   │
│  │ ☕ Starbucks         -₹180      │   │
│  │    Food • 3:45 PM               │   │
│  └─────────────────────────────────┘   │
│                                         │
│  [Load More...]                         │
└─────────────────────────────────────────┘
```

**Interaction Patterns**:
- Sticky date headers while scrolling
- Pull down to filter by date range
- Long press for multi-select (bulk categorize)
- Swipe actions:
  - Left: Quick categorize
  - Right: Edit details
- Floating month/year picker on fast scroll

---

### 6. Transaction Detail Screen

**Design**: Bottom sheet style (70% height) with full-screen option

```
┌─────────────────────────────────────────┐
│  ─────  (Drag handle)                   │
├─────────────────────────────────────────┤
│                                         │
│         🍕                              │   ← Large category icon
│      Swiggy                             │      (animated on open)
│                                         │
│     ─₹245.00                            │   ← Large amount
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ Category     │ 🍔 Food          →│   │
│  ├──────────────┼──────────────────┤   │
│  │ Date         │ Feb 5, 2:30 PM    │   │
│  ├──────────────┼──────────────────┤   │
│  │ Payment      │ PhonePe UPI       │   │
│  ├──────────────┼──────────────────┤   │
│  │ Account      │ HDFC ****4521     │   │
│  ├──────────────┼──────────────────┤   │
│  │ Status       │ ✓ Confirmed       │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ 📝 Add Note                      │   │
│  │    "Dinner with roommates"       │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ 🏷️ Tags: #friends #dinner        │   │
│  │    [+ Add tag]                   │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌────────────┐  ┌────────────────┐   │
│  │ 👥 Split   │  │ 🗑️ Delete      │   │
│  └────────────┘  └────────────────┘   │
│                                         │
└─────────────────────────────────────────┘
```

---

### 7. Add Transaction Screen (Manual Entry)

**Design**: Full screen with step-by-step feel

```
┌─────────────────────────────────────────┐
│  [×]      Add Expense           [✓]     │
├─────────────────────────────────────────┤
│                                         │
│           ₹ 0                           │   ← Large editable amount
│                                         │      Number pad below
│  ┌─────────────────────────────────┐   │
│  │  7   8   9                      │   │
│  │  4   5   6                      │   │
│  │  1   2   3                      │   │
│  │  .   0   ⌫                      │   │
│  └─────────────────────────────────┘   │
│                                         │
│  Select Category                        │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐ ┌────┐   │
│  │ 🍔 │ │ 🚗 │ │ 🎮 │ │ 📚 │ │ 🛒 │   │
│  │Food│ │Move│ │Fun │ │Edu │ │Shop│   │
│  └────┘ └────┘ └────┘ └────┘ └────┘   │
│  [See all categories →]                 │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ 📅 Today, Feb 5              →  │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ 📝 Description (optional)       │   │
│  │    e.g., "Coffee at CCD"        │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ 💳 Cash                       → │   │   ← Payment method
│  └─────────────────────────────────┘   │
│                                         │
│  [ Make it recurring? 🔄 ]              │   ← Toggle
│                                         │
│  ┌─────────────────────────────────┐   │
│  │        Save Transaction          │   │   ← Gradient button
│  └─────────────────────────────────┘   │
│                                         │
└─────────────────────────────────────────┘
```

---

### 8. Budget Management Screen

```
┌─────────────────────────────────────────┐
│  [←]      Budgets              [＋]     │
├─────────────────────────────────────────┤
│                                         │
│  February 2026                          │
│  Overall Budget                         │
│  ┌─────────────────────────────────┐   │
│  │  ₹12,450 / ₹20,000             │   │
│  │  ████████████████░░░░░░░ 62%    │   │   ← Gradient progress
│  │                                 │   │
│  │  ₹7,550 left • 23 days remain   │   │
│  │  ₹328/day recommended           │   │   ← Smart daily limit
│  └─────────────────────────────────┘   │
│                                         │
│  Category Budgets                       │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ 🍔 Food                         │   │
│  │  ₹4,200 / ₹6,000    70%         │   │
│  │  ████████████████░░░░░░         │   │
│  │  ⚠️ On track to exceed!         │   │   ← Warning state
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ 🚗 Transportation               │   │
│  │  ₹2,100 / ₹4,000    52%         │   │
│  │  ████████████░░░░░░░░           │   │
│  │  ✓ Looking good!                │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ 🎮 Entertainment                │   │
│  │  ₹3,150 / ₹3,000    105%        │   │
│  │  ████████████████████ EXCEEDED  │   │   ← Red state
│  │  ❌ Over by ₹150                │   │
│  └─────────────────────────────────┘   │
│                                         │
│  [＋ Add Category Budget]               │
│                                         │
└─────────────────────────────────────────┘
```

---

### 9. Split Bills / Shared Expenses Screen

```
┌─────────────────────────────────────────┐
│  [←]    Split Bills           [👥＋]    │
├─────────────────────────────────────────┤
│                                         │
│  Your Balance                           │
│  ┌─────────────────────────────────┐   │
│  │  You're owed                    │   │
│  │  ₹1,245                         │   │   ← Green when positive
│  │                                 │   │
│  │  [Settle Up] [Remind All]       │   │
│  └─────────────────────────────────┘   │
│                                         │
│  Friends                                │
│  ┌─────────────────────────────────┐   │
│  │ 👤 Rahul                        │   │
│  │    Owes you ₹450            [→] │   │
│  ├─────────────────────────────────┤   │
│  │ 👤 Sneha                        │   │
│  │    You owe ₹125             [→] │   │   ← Red when you owe
│  ├─────────────────────────────────┤   │
│  │ 👤 Arjun                        │   │
│  │    Settled up ✓             [→] │   │
│  └─────────────────────────────────┘   │
│                                         │
│  Recent Splits                          │
│  ┌─────────────────────────────────┐   │
│  │ 🍕 Pizza Night                  │   │
│  │    ₹1,200 • 4 people            │   │
│  │    You paid • Feb 4             │   │
│  ├─────────────────────────────────┤   │
│  │ 🎬 Movie Outing                 │   │
│  │    ₹800 • 2 people              │   │
│  │    Rahul paid • Feb 2           │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │   ＋  Create New Split           │   │
│  └─────────────────────────────────┘   │
│                                         │
└─────────────────────────────────────────┘
```

---

### 10. Statistics / Analytics Screen

```
┌─────────────────────────────────────────┐
│  [←]      Analytics           [📅]      │
├─────────────────────────────────────────┤
│                                         │
│  [Week] [Month] [Year] [Custom]         │   ← Period tabs
│                                         │
│  February 2026 ▼                        │
│                                         │
│  Total Spent                            │
│  ┌─────────────────────────────────┐   │
│  │                                 │   │
│  │     ₹12,450                     │   │   ← Large animated number
│  │     ▼ 8% vs last month          │   │   ← Comparison chip
│  │                                 │   │
│  └─────────────────────────────────┘   │
│                                         │
│  Spending by Category                   │
│  ┌─────────────────────────────────┐   │
│  │         🥧                       │   │   ← Interactive pie/donut
│  │        Tap to                   │   │      chart with animations
│  │       see details               │   │
│  │                                 │   │
│  │  🍔 34% 🚗 17% 🎮 25% 📚 12%    │   │   ← Legend
│  └─────────────────────────────────┘   │
│                                         │
│  Spending Trend                         │
│  ┌─────────────────────────────────┐   │
│  │  ₹                              │   │   ← Line/bar chart
│  │  │    ╭─╮                       │   │      Animated drawing
│  │  │   ╱   ╲   ╭╮                 │   │
│  │  │  ╱     ╲ ╱  ╲╭╮             │   │
│  │  │ ╱       ╲    ╲╱             │   │
│  │  └─────────────────── Days      │   │
│  └─────────────────────────────────┘   │
│                                         │
│  Top Merchants                          │
│  ┌─────────────────────────────────┐   │
│  │ 1. Swiggy           ₹2,450     │   │
│  │ 2. Uber             ₹1,890     │   │
│  │ 3. Amazon           ₹1,200     │   │
│  └─────────────────────────────────┘   │
│                                         │
│  AI Insights                            │
│  ┌─────────────────────────────────┐   │
│  │ 💡 "You spent 40% more on food  │   │
│  │    this week. Consider cooking  │   │
│  │    2 meals at home to save ₹500"│   │
│  └─────────────────────────────────┘   │
│                                         │
└─────────────────────────────────────────┘
```

---

### 11. Account Linking Screen (Zerodha-style)

```
┌─────────────────────────────────────────┐
│  [←]    Link Accounts                   │
├─────────────────────────────────────────┤
│                                         │
│  Your Linked Accounts                   │
│  ┌─────────────────────────────────┐   │
│  │ 🏦 SBI Savings                  │   │
│  │    ****4521 • ₹15,230           │   │
│  │    ✓ Connected • Synced 2m ago  │   │   ← Green status
│  │                            [⋮]  │   │
│  ├─────────────────────────────────┤   │
│  │ 🏦 HDFC Savings                 │   │
│  │    ****7823 • ₹9,330            │   │
│  │    ✓ Connected • Synced 5m ago  │   │
│  │                            [⋮]  │   │
│  ├─────────────────────────────────┤   │
│  │ 📱 PhonePe UPI                  │   │
│  │    username@ybl                 │   │
│  │    ✓ Connected • Live sync      │   │
│  │                            [⋮]  │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ─────── Add New Account ───────        │
│                                         │
│  Banks                                  │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐          │
│  │SBI │ │HDFC│ │ICICI││Axis│          │
│  └────┘ └────┘ └────┘ └────┘          │
│                                         │
│  UPI Apps                               │
│  ┌────┐ ┌────┐ ┌────┐                  │
│  │GPay│ │PhPe│ │Paytm│                 │
│  └────┘ └────┘ └────┘                  │
│                                         │
│  Wallets                                │
│  ┌────┐ ┌────┐                         │
│  │Amzn│ │Pytm│                         │
│  └────┘ └────┘                         │
│                                         │
│  BNPL Services                          │
│  ┌────┐ ┌────┐ ┌────┐                  │
│  │Lazy│ │Smpl│ │Amzn│                  │
│  │Pay │ │    │ │Later│                 │
│  └────┘ └────┘ └────┘                  │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ 🔒 Your data is secure          │   │
│  │    We use bank-level encryption │   │
│  │    and never store passwords    │   │
│  └─────────────────────────────────┘   │
│                                         │
└─────────────────────────────────────────┘
```

---

### 12. Profile & Settings Screen

```
┌─────────────────────────────────────────┐
│  [←]      Profile                       │
├─────────────────────────────────────────┤
│                                         │
│         ┌─────┐                         │
│         │ 👤 │                         │   ← Profile photo
│         └─────┘                         │      with edit option
│       Priya Sharma                      │
│    priya@college.edu                    │
│       [Edit Profile]                    │
│                                         │
│  ─────────────────────────────────      │
│                                         │
│  Finance Score                          │
│  ┌─────────────────────────────────┐   │
│  │  ⭐ 78 / 100  "Doing Great!"    │   │
│  │  [View Details →]               │   │
│  └─────────────────────────────────┘   │
│                                         │
│  Preferences                            │
│  ┌─────────────────────────────────┐   │
│  │ 🔔 Notifications            [→] │   │
│  │ 🔒 Privacy & Security       [→] │   │
│  │ 🌙 Appearance               [→] │   │
│  │ 💳 Linked Accounts          [→] │   │
│  │ 🗓️ Budget Settings          [→] │   │
│  │ 📤 Export Data              [→] │   │
│  │ ☁️ Backup & Restore         [→] │   │
│  └─────────────────────────────────┘   │
│                                         │
│  Support                                │
│  ┌─────────────────────────────────┐   │
│  │ ❓ Help Center              [→] │   │
│  │ 💬 Contact Support          [→] │   │
│  │ ⭐ Rate Us                  [→] │   │
│  │ 📜 Terms & Privacy          [→] │   │
│  └─────────────────────────────────┘   │
│                                         │
│  [🚪 Log Out]                           │
│                                         │
│  DuskSpendr v1.0.0                      │
│  Made with ❤️ for students              │
│                                         │
└─────────────────────────────────────────┘
```

---

### 13. Financial Education / Tips Screen

```
┌─────────────────────────────────────────┐
│  [←]    Money Tips              [🔖]    │
├─────────────────────────────────────────┤
│                                         │
│  Personalized for You                   │
│  ┌─────────────────────────────────┐   │
│  │ 💡                               │   │
│  │ "You spent ₹4,200 on food this  │   │
│  │  month. Try the ₹200 Challenge: │   │
│  │  Cook 3 meals at home this week │   │
│  │  and save ₹600!"                │   │
│  │                                 │   │
│  │  [Accept Challenge 🎯]          │   │
│  └─────────────────────────────────┘   │
│                                         │
│  Learn Money Basics                     │
│  ┌─────────────────────────────────┐   │
│  │ 📚 Budgeting 101          5 min │   │
│  │    Learn the 50/30/20 rule      │   │
│  ├─────────────────────────────────┤   │
│  │ 💳 Credit Cards Explained  7 min│   │
│  │    Should you get one?          │   │
│  ├─────────────────────────────────┤   │
│  │ 📈 Start Investing Early   8 min│   │
│  │    Compound interest magic      │   │
│  ├─────────────────────────────────┤   │
│  │ 🏦 Emergency Fund         10 min│   │
│  │    Why every student needs one  │   │
│  └─────────────────────────────────┘   │
│                                         │
│  Achievements Unlocked 🏆               │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐ ┌────┐   │
│  │ 🌱 │ │ 📊 │ │ 💪 │ │ 🔒 │ │ ❓ │   │
│  │Got │ │1st │ │Week│ │Priv│ │    │   │
│  └────┘ └────┘ └────┘ └────┘ └────┘   │
│  12 of 25 unlocked                      │
│                                         │
└─────────────────────────────────────────┘
```

---

## 💰 Investing & Wealth Management Module

### Overview

A comprehensive investment tracking and wealth management hub designed specifically for students beginning their investing journey. One unified place to track all portfolios, metrics, savings goals, and build wealth systematically.

---

### 14. Portfolio Dashboard Screen

**Purpose:** Central hub for all investments — stocks, mutual funds, FDs, gold, and more in one unified view.

**Key Features:**
- **Total Portfolio Value** with daily/weekly/monthly change
- **Asset Allocation** pie chart (Equity, Debt, Gold, FD, Cash)
- **Portfolio Performance** comparison with benchmark (Nifty 50)
- **Holdings breakdown** by asset class
- **Investment calendar** for upcoming maturities and SIP dates

**Wireframe:**

```
┌─────────────────────────────────────────┐
│ ←                Portfolio           🔔 │
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────────────────────────────┐│
│  │     Total Portfolio Value           ││
│  │     ₹2,45,680     ▲ +₹12,450        ││
│  │                   (+5.33% all time) ││
│  │  ┌─────────────────────────────┐    ││
│  │  │  📈 ↗ Performance Graph     │    ││
│  │  │     (Interactive sparkline) │    ││
│  │  └─────────────────────────────┘    ││
│  │  [1D] [1W] [1M] [3M] [1Y] [All]     ││
│  └─────────────────────────────────────┘│
│                                         │
│  Asset Allocation                       │
│  ┌─────────────────────────────────────┐│
│  │    ╭────────╮                       ││
│  │   ╱  Equity  ╲   🟣 Equity    45%   ││
│  │  │   45%     │   🔵 Mutual F  30%   ││
│  │   ╲  MF     ╱    🟡 FDs       15%   ││
│  │    ╰────────╯    🟢 Gold      8%    ││
│  │                  ⚪ Cash      2%    ││
│  └─────────────────────────────────────┘│
│                                         │
│  Holdings by Type                       │
│  ┌─────────────────────────────────────┐│
│  │📊 Stocks (Direct)      ₹1,10,556    ││
│  │   ▲ +8.2% │ 4 holdings              ││
│  ├─────────────────────────────────────┤│
│  │📈 Mutual Funds          ₹73,704     ││
│  │   ▲ +12.1% │ 3 SIPs active          ││
│  ├─────────────────────────────────────┤│
│  │🏦 Fixed Deposits        ₹36,852     ││
│  │   7.5% avg │ 2 FDs active           ││
│  ├─────────────────────────────────────┤│
│  │🥇 Digital Gold          ₹19,654     ││
│  │   ▲ +14.3% │ 0.25g                  ││
│  ├─────────────────────────────────────┤│
│  │💵 Emergency Fund        ₹4,914      ││
│  │   Goal: ₹50,000 │ 9.8% achieved     ││
│  └─────────────────────────────────────┘│
│                                         │
│  Upcoming                               │
│  ┌─────────────────────────────────────┐│
│  │ 📅 Feb 5   SIP - Axis Small Cap     ││
│  │ 📅 Feb 10  FD Maturity - ₹15,000    ││
│  │ 📅 Feb 15  SIP - Nifty 50 Index     ││
│  └─────────────────────────────────────┘│
│                                         │
└─────────────────────────────────────────┘
│  🏠  │  📊  │  ➕  │  💰  │  👤  │
└──────┴──────┴──────┴──────┴──────┘
```

**Animations:**
- Portfolio value counts up from 0 on screen load
- Pie chart segments animate in clockwise with stagger
- Holdings cards slide in from bottom with stagger delay
- Tapping on asset class shows expansion animation

---

### 15. Stocks Portfolio Screen

**Purpose:** Track direct equity investments with real-time updates

**Key Features:**
- **Current holdings** with live price updates
- **P&L tracking** (realized + unrealized)
- **Watchlist** for stocks you're monitoring
- **Stock search** with company details
- **Portfolio insights** (sector allocation, concentration risk)

**Wireframe:**

```
┌─────────────────────────────────────────┐
│ ←         Stocks Portfolio        ⚙️ 🔔 │
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────────────────────────────┐│
│  │  Investment   ₹95,000               ││
│  │  Current      ₹1,10,556  ▲ +16.4%   ││
│  │  P&L          +₹15,556              ││
│  └─────────────────────────────────────┘│
│                                         │
│  [Holdings]  [Watchlist]  [Orders]      │
│                                         │
│  ┌─────────────────────────────────────┐│
│  │ 🔴 RELIANCE                         ││
│  │    5 shares @ ₹2,450 = ₹12,250      ││
│  │    LTP: ₹2,520   ▲ +2.86%           ││
│  │    P&L: +₹350    ▲                  ││
│  ├─────────────────────────────────────┤│
│  │ 🟢 INFY                             ││
│  │    10 shares @ ₹1,420 = ₹14,200     ││
│  │    LTP: ₹1,510   ▲ +6.34%           ││
│  │    P&L: +₹900    ▲                  ││
│  ├─────────────────────────────────────┤│
│  │ 🟡 TATA MOTORS                      ││
│  │    20 shares @ ₹650 = ₹13,000       ││
│  │    LTP: ₹712     ▲ +9.54%           ││
│  │    P&L: +₹1,240  ▲                  ││
│  ├─────────────────────────────────────┤│
│  │ 🔵 HDFC BANK                        ││
│  │    8 shares @ ₹1,580 = ₹12,640      ││
│  │    LTP: ₹1,605   ▲ +1.58%           ││
│  │    P&L: +₹200    ▲                  ││
│  └─────────────────────────────────────┘│
│                                         │
│  Sector Allocation                      │
│  [███████░░] IT 35%                     │
│  [█████░░░░] Banking 28%                │
│  [████░░░░░] Auto 22%                   │
│  [███░░░░░░] Oil & Gas 15%              │
│                                         │
└─────────────────────────────────────────┘
│  + Add Stock |  Link Broker Account    │
└─────────────────────────────────────────┘
```

---

### 16. Mutual Funds Screen

**Purpose:** Track mutual fund investments and SIPs

**Key Features:**
- **SIP tracker** with next payment dates
- **Fund performance** comparison
- **NAV history** with charts
- **XIRR calculation** for true returns
- **Fund categories** (Large Cap, Small Cap, Debt, etc.)

**Wireframe:**

```
┌─────────────────────────────────────────┐
│ ←          Mutual Funds            + 🔔 │
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────────────────────────────┐│
│  │  Invested       ₹62,000             ││
│  │  Current        ₹73,704  ▲ +18.9%   ││
│  │  XIRR            24.5% p.a.         ││
│  └─────────────────────────────────────┘│
│                                         │
│  Active SIPs                            │
│  ┌─────────────────────────────────────┐│
│  │ 📈 Axis Small Cap Fund - Direct    ││
│  │    SIP: ₹1,000/month (5th)          ││
│  │    Invested: ₹24,000 → ₹32,150      ││
│  │    Units: 420.5 @ NAV ₹76.45        ││
│  │    ▲ +33.96%                        ││
│  │    Next SIP: Feb 5                  ││
│  │    ┌────────────────────────────┐   ││
│  │    │   📊 NAV Performance       │   ││
│  │    │      (12M chart)           │   ││
│  │    └────────────────────────────┘   ││
│  ├─────────────────────────────────────┤│
│  │ 📈 UTI Nifty 50 Index Fund         ││
│  │    SIP: ₹2,000/month (15th)         ││
│  │    Invested: ₹28,000 → ₹31,920      ││
│  │    ▲ +14.0%                         ││
│  ├─────────────────────────────────────┤│
│  │ 📈 ICICI Pru Short Term Debt       ││
│  │    Lumpsum: ₹10,000                 ││
│  │    Current: ₹9,634 (📉 -3.66%)     ││
│  └─────────────────────────────────────┘│
│                                         │
│  📊 Category Distribution               │
│  ┌─────────────────────────────────────┐│
│  │ 🟣 Small Cap     50%                ││
│  │ 🔵 Index Fund    35%                ││
│  │ 🟢 Debt          15%                ││
│  └─────────────────────────────────────┘│
│                                         │
│  [📖 Explore Funds]  [🔗 Link Demat]   │
│                                         │
└─────────────────────────────────────────┘
```

---

### 17. Fixed Deposits (FDs) Screen

**Purpose:** Track and manage Fixed Deposits from multiple banks

**Key Features:**
- **FD ladder visualization** (maturity timeline)
- **Interest earned** tracker
- **Maturity alerts** with reminders
- **Compare FD rates** across banks
- **Tax implications** (TDS tracking)
- **Auto-renewal management**

**Wireframe:**

```
┌─────────────────────────────────────────┐
│ ←        Fixed Deposits         + Add 🔔│
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────────────────────────────┐│
│  │  Total FD Value      ₹36,852        ││
│  │  │▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░│            ││
│  │  Principal: ₹35,000                 ││
│  │  Interest Earned: ₹1,852            ││
│  │  Avg Rate: 7.5% p.a.                ││
│  └─────────────────────────────────────┘│
│                                         │
│  FD Ladder (Maturity Timeline)          │
│  ┌─────────────────────────────────────┐│
│  │  Feb'25  ─────────○ ₹15,000         ││
│  │  May'25  ──────────────○ ₹20,000    ││
│  │               ↑                      ││
│  │           Upcoming                   ││
│  └─────────────────────────────────────┘│
│                                         │
│  Your FDs                               │
│  ┌─────────────────────────────────────┐│
│  │ 🏦 SBI Fixed Deposit                ││
│  │    Principal:   ₹15,000             ││
│  │    Interest:    7.25% p.a.          ││
│  │    Tenure:      12 months           ││
│  │    Maturity:    Feb 10, 2025        ││
│  │    ⏰ Matures in 5 days!            ││
│  │    Maturity Amt: ₹16,087            ││
│  │    [Auto-renew: OFF]  [Edit]        ││
│  ├─────────────────────────────────────┤│
│  │ 🏦 HDFC Fixed Deposit               ││
│  │    Principal:   ₹20,000             ││
│  │    Interest:    7.75% p.a.          ││
│  │    Tenure:      18 months           ││
│  │    Maturity:    May 15, 2025        ││
│  │    Days left:   99 days             ││
│  │    Maturity Amt: ₹22,325            ││
│  │    [Auto-renew: ON]   [Edit]        ││
│  └─────────────────────────────────────┘│
│                                         │
│  💡 Compare FD Rates                    │
│  ┌─────────────────────────────────────┐│
│  │ Bank          1 Year    2 Year      ││
│  │ SBI           7.25%     7.50%       ││
│  │ HDFC          7.50%     7.75%       ││
│  │ ICICI         7.40%     7.60%       ││
│  │ Axis          7.35%     7.55%       ││
│  │ [View All Banks →]                  ││
│  └─────────────────────────────────────┘│
│                                         │
│  📊 TDS This Year: ₹185                 │
│                                         │
└─────────────────────────────────────────┘
```

**Animations:**
- FD ladder animates drawing connections on load
- Interest meter fills up progressively
- Maturity countdown pulses when < 7 days

---

### 18. Emergency Fund Screen

**Purpose:** Build and track your emergency fund with a goal-based approach

**Key Features:**
- **Goal setting** (typically 3-6 months of expenses)
- **Visual progress** towards goal
- **Quick deposit** into emergency fund
- **Liquid fund allocation** (for better returns than savings)
- **"Break the glass"** metaphor for withdrawals
- **Emergency scenarios** education

**Wireframe:**

```
┌─────────────────────────────────────────┐
│ ←        Emergency Fund          ⚙️ 🔔 │
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────────────────────────────┐│
│  │     🛡️ YOUR SAFETY NET              ││
│  │                                      ││
│  │          ₹4,914                     ││
│  │        ─────────────                ││
│  │       of ₹50,000 goal               ││
│  │                                      ││
│  │     ╭────────────────────╮          ││
│  │    ╱                      ╲         ││
│  │   │     🌊                 │         ││
│  │   │  ~~~~~~~~~~            │  9.8%   ││
│  │   │  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ │  funded ││
│  │   ╰──────────────────────╯          ││
│  │                                      ││
│  │   3 months of expenses = ₹50,000    ││
│  │   Based on your avg spending        ││
│  │                                      ││
│  │   [ 🎯 Adjust Goal ]                 ││
│  └─────────────────────────────────────┘│
│                                         │
│  Quick Actions                          │
│  ┌────────────┐  ┌────────────────────┐│
│  │ + ADD ₹500 │  │ + ADD CUSTOM       ││
│  └────────────┘  └────────────────────┘│
│                                         │
│  Where's Your Fund?                     │
│  ┌─────────────────────────────────────┐│
│  │ 💳 Savings Account     ₹2,000       ││
│  │    SBI *4521                        ││
│  │    Interest: ~3.5% p.a.             ││
│  ├─────────────────────────────────────┤│
│  │ 📈 Liquid Mutual Fund  ₹2,914       ││
│  │    Nippon Liquid Fund               ││
│  │    Interest: ~6.2% p.a.             ││
│  │    Withdrawal: T+1 day              ││
│  └─────────────────────────────────────┘│
│                                         │
│  🚨 Need to Withdraw?                   │
│  ┌─────────────────────────────────────┐│
│  │  ⚠️ This is for TRUE emergencies    ││
│  │                                      ││
│  │     [ Break the Glass 🔨 ]          ││
│  │                                      ││
│  │  What counts as emergency?           ││
│  │  ✓ Medical emergency                 ││
│  │  ✓ Job loss                          ││
│  │  ✓ Urgent home repairs               ││
│  │  ✗ Concert tickets                   ││
│  │  ✗ New phone                         ││
│  └─────────────────────────────────────┘│
│                                         │
│  📚 Why Emergency Fund Matters          │
│  ┌─────────────────────────────────────┐│
│  │ "76% of students face at least one  ││
│  │  unexpected expense every year..."   ││
│  │  [Read More →]                       ││
│  └─────────────────────────────────────┘│
│                                         │
└─────────────────────────────────────────┘
```

**Animations:**
- Water level rises on deposit
- "Break the glass" has dramatic shatter animation
- Goal celebration with confetti when reached

---

### 19. Savings Goals Screen

**Purpose:** Set and track multiple savings goals (beyond emergency fund)

**Key Features:**
- **Multiple goals** with individual targets and deadlines
- **Priority ranking** of goals
- **Automated allocation** suggestions
- **Visual progress** (jars, piggy banks, or goal images)
- **Celebrate milestones**

**Wireframe:**

```
┌─────────────────────────────────────────┐
│ ←         Savings Goals          + 🔔   │
├─────────────────────────────────────────┤
│                                         │
│  Total Saved for Goals: ₹24,500        │
│                                         │
│  ┌─────────────────────────────────────┐│
│  │ 🎓 Higher Studies Fund              ││
│  │    ₹15,000 of ₹2,00,000             ││
│  │    ███░░░░░░░░░░░░░░░░░░ 7.5%       ││
│  │    Deadline: Dec 2026               ││
│  │    Monthly: ₹8,000 req'd            ││
│  ├─────────────────────────────────────┤│
│  │ 💻 New Laptop                       ││
│  │    ₹35,000 of ₹70,000               ││
│  │    ██████████░░░░░░░░░░░ 50%        ││
│  │    Deadline: Sep 2025               ││
│  │    Monthly: ₹5,000 req'd            ││
│  │    🎉 Halfway there!                 ││
│  ├─────────────────────────────────────┤│
│  │ ✈️ Goa Trip with Friends            ││
│  │    ₹8,500 of ₹15,000                ││
│  │    ████████████░░░░░░░░░ 57%        ││
│  │    Deadline: Mar 2025               ││
│  │    Monthly: ₹3,250 req'd            ││
│  ├─────────────────────────────────────┤│
│  │ 🚗 Bike Down-payment                ││
│  │    ₹0 of ₹40,000                    ││
│  │    ░░░░░░░░░░░░░░░░░░░░░ 0%         ││
│  │    [ Start saving ]                 ││
│  └─────────────────────────────────────┘│
│                                         │
│  💡 Smart Suggestions                   │
│  ┌─────────────────────────────────────┐│
│  │ "You have ₹3,200 unallocated.       ││
│  │  Split between your goals?"         ││
│  │  [ Auto-allocate ]  [ Manual ]      ││
│  └─────────────────────────────────────┘│
│                                         │
└─────────────────────────────────────────┘
```

---

### 20. Investment Metrics Dashboard

**Purpose:** Deep dive into portfolio analytics and metrics

**Key Features:**
- **Portfolio health score** (diversification, risk)
- **Risk analysis** (beta, volatility)
- **Tax harvesting** opportunities
- **Rebalancing alerts**
- **Benchmark comparison**
- **Fee analysis** (expense ratios)

**Wireframe:**

```
┌─────────────────────────────────────────┐
│ ←       Investment Metrics        📊 🔔 │
├─────────────────────────────────────────┤
│                                         │
│  Portfolio Health Score                 │
│  ┌─────────────────────────────────────┐│
│  │          ╭─────╮                    ││
│  │      ╭───┤     ├───╮                ││
│  │     ╱    │ 78  │    ╲               ││
│  │    │ 🟢  │/100 │  🟢 │              ││
│  │     ╲    │Good │   ╱                ││
│  │      ╰───┴─────┴───╯                ││
│  │                                      ││
│  │  ✓ Diversified     ⚠ Sector risk    ││
│  │  ✓ Low expense     ⚠ No debt funds  ││
│  └─────────────────────────────────────┘│
│                                         │
│  Key Metrics                            │
│  ┌─────────────────────────────────────┐│
│  │ XIRR           │ 18.5% p.a.   ▲     ││
│  │ CAGR           │ 15.2% p.a.   ▲     ││
│  │ vs Nifty 50    │ +3.2%  🏆          ││
│  │ Portfolio Beta │ 1.12  (Moderate)   ││
│  │ Volatility     │ Medium             ││
│  │ Sharpe Ratio   │ 1.45               ││
│  └─────────────────────────────────────┘│
│                                         │
│  Expense Analysis                       │
│  ┌─────────────────────────────────────┐│
│  │ Total Annual Fees: ₹1,247           ││
│  │                                      ││
│  │ Mutual Fund Expense Ratios:         ││
│  │ • Axis Small Cap: 0.49%    ₹750     ││
│  │ • UTI Nifty 50:   0.10%    ₹280     ││
│  │ • ICICI Debt:     0.25%    ₹217     ││
│  │                                      ││
│  │ 💡 Switch to direct plans to save   ││
│  │    ₹420/year                        ││
│  └─────────────────────────────────────┘│
│                                         │
│  Tax Harvesting                         │
│  ┌─────────────────────────────────────┐│
│  │ 💰 Tax saving opportunity!          ││
│  │                                      ││
│  │ ICICI Debt Fund is at -3.66%        ││
│  │ Book loss now: ₹366                 ││
│  │ Tax saved: ~₹100 (30% slab)         ││
│  │                                      ││
│  │ [Learn About Tax Harvesting]        ││
│  └─────────────────────────────────────┘│
│                                         │
│  Rebalancing                            │
│  ┌─────────────────────────────────────┐│
│  │ ⚠️ Portfolio slightly overweight    ││
│  │    in equity (85% vs target 70%)    ││
│  │                                      ││
│  │ [View Rebalancing Plan]             ││
│  └─────────────────────────────────────┘│
│                                         │
└─────────────────────────────────────────┘
```

---

### 21. Add Investment Flow

**Purpose:** Seamless flow to add new investments of any type

**Flow Steps:**

```
1. Select Investment Type
   ┌─────────────────────────────────────────┐
   │ What are you investing in?              │
   │                                         │
   │  ┌──────────┐  ┌──────────┐            │
   │  │ 📈       │  │ 📊       │            │
   │  │ Stocks   │  │ Mutual   │            │
   │  │          │  │ Funds    │            │
   │  └──────────┘  └──────────┘            │
   │                                         │
   │  ┌──────────┐  ┌──────────┐            │
   │  │ 🏦       │  │ 🥇       │            │
   │  │ Fixed    │  │ Digital  │            │
   │  │ Deposit  │  │ Gold     │            │
   │  └──────────┘  └──────────┘            │
   │                                         │
   │  ┌──────────┐  ┌──────────┐            │
   │  │ 💰       │  │ 🏠       │            │
   │  │ Savings  │  │ Other    │            │
   │  │ Goal     │  │ Assets   │            │
   │  └──────────┘  └──────────┘            │
   └─────────────────────────────────────────┘

2. Enter Details (Example: Stock)
   ┌─────────────────────────────────────────┐
   │ Add Stock Purchase                      │
   │                                         │
   │  🔍 Search stock or enter symbol        │
   │  ┌─────────────────────────────────┐   │
   │  │ RELIANCE                        │   │
   │  └─────────────────────────────────┘   │
   │                                         │
   │  Reliance Industries Ltd               │
   │  NSE: RELIANCE | Current: ₹2,520       │
   │                                         │
   │  Quantity                               │
   │  ┌─────────────────────────────────┐   │
   │  │ 5                               │   │
   │  └─────────────────────────────────┘   │
   │                                         │
   │  Buy Price                              │
   │  ┌─────────────────────────────────┐   │
   │  │ ₹ 2,450                         │   │
   │  └─────────────────────────────────┘   │
   │                                         │
   │  Purchase Date                          │
   │  ┌─────────────────────────────────┐   │
   │  │ 📅 Jan 15, 2025                 │   │
   │  └─────────────────────────────────┘   │
   │                                         │
   │  Total Investment: ₹12,250              │
   │                                         │
   │  [ Add to Portfolio ]                   │
   └─────────────────────────────────────────┘

3. Success
   ┌─────────────────────────────────────────┐
   │                                         │
   │           ✓ Added!                      │
   │                                         │
   │   RELIANCE added to your portfolio      │
   │   5 shares @ ₹2,450                     │
   │                                         │
   │   Current Value: ₹12,600                │
   │   P&L: +₹350 (▲ 2.86%)                  │
   │                                         │
   │   [ View Portfolio ]  [ Add Another ]   │
   │                                         │
   └─────────────────────────────────────────┘
```

---

### 22. Link Broker/Demat Account

**Purpose:** One-click import of existing investments from brokers

**Supported Integrations:**
- **Zerodha** (via Kite Connect)
- **Groww** (via API)
- **Upstox** (via API)
- **Angel One** (via SmartAPI)
- **MF Central** (for all mutual funds)
- **CAMS/KFintech** (for MF holdings)

**Wireframe:**

```
┌─────────────────────────────────────────┐
│ ←       Link Accounts                   │
├─────────────────────────────────────────┤
│                                         │
│  Import your investments automatically  │
│  from your broker accounts              │
│                                         │
│  Broker Accounts                        │
│  ┌─────────────────────────────────────┐│
│  │ 🟢 Zerodha                          ││
│  │    Stocks & MF | Most popular       ││
│  │    [ Connect → ]                    ││
│  ├─────────────────────────────────────┤│
│  │ 🟢 Groww                            ││
│  │    Stocks, MF & Gold                ││
│  │    [ Connect → ]                    ││
│  ├─────────────────────────────────────┤│
│  │ 🟡 Upstox                           ││
│  │    Stocks & F&O                     ││
│  │    [ Connect → ]                    ││
│  ├─────────────────────────────────────┤│
│  │ 🟡 Angel One                        ││
│  │    Full service broker              ││
│  │    [ Connect → ]                    ││
│  └─────────────────────────────────────┘│
│                                         │
│  Mutual Fund Central                    │
│  ┌─────────────────────────────────────┐│
│  │ 📊 MF Central / CAMS / KFintech     ││
│  │    Import ALL your mutual funds     ││
│  │    from any platform                ││
│  │    [ Connect with PAN → ]           ││
│  └─────────────────────────────────────┘│
│                                         │
│  Already Connected                      │
│  ┌─────────────────────────────────────┐│
│  │ ✅ Zerodha          Last sync: 2h   ││
│  │    4 stocks | 2 MFs | ₹1,10,556     ││
│  │    [ Sync Now ]      [ Unlink ]     ││
│  └─────────────────────────────────────┘│
│                                         │
│  🔒 Your data is encrypted and secure  │
│     We only read holdings, never trade │
│                                         │
└─────────────────────────────────────────┘
```

---

### Investing Module - State Management

```dart
// Investment Providers

// Portfolio overview
final portfolioSummaryProvider = StreamProvider<PortfolioSummary>

// Individual asset classes
final stockHoldingsProvider = StreamProvider<List<StockHolding>>
final mutualFundHoldingsProvider = StreamProvider<List<MFHolding>>
final fixedDepositsProvider = StreamProvider<List<FixedDeposit>>
final goldHoldingsProvider = StreamProvider<List<GoldHolding>>

// Emergency fund
final emergencyFundProvider = StreamProvider<EmergencyFund>
final emergencyFundGoalProvider = StateNotifierProvider<EmergencyFundNotifier, Money>

// Savings goals
final savingsGoalsProvider = StreamProvider<List<SavingsGoal>>
final savingsGoalByIdProvider = Provider.family<SavingsGoal?, String>

// Metrics
final portfolioMetricsProvider = FutureProvider<PortfolioMetrics>
final xirrCalculatorProvider = Provider<XIRRCalculator>

// Broker connections
final linkedBrokersProvider = StreamProvider<List<LinkedBroker>>
final brokerSyncStatusProvider = StreamProvider.family<SyncStatus, String>

// Market data (if live prices needed - consider caching)
final stockPriceProvider = FutureProvider.family<StockPrice, String>
final navHistoryProvider = FutureProvider.family<List<NAVData>, String>
```

---

### Investing Module - Data Models

```dart
// Core investment entities

class PortfolioSummary {
  final Money totalValue;
  final Money invested;
  final Money returns;
  final double returnsPercentage;
  final Map<AssetClass, Money> allocation;
  final List<UpcomingEvent> upcomingEvents;
}

enum AssetClass {
  equity, mutualFund, fixedDeposit, gold, savings, other
}

class StockHolding {
  final String symbol;
  final String name;
  final int quantity;
  final Money buyPrice;
  final Money currentPrice;
  final DateTime purchaseDate;
  final String? broker;
}

class MFHolding {
  final String schemeCode;
  final String schemeName;
  final double units;
  final Money nav;
  final Money invested;
  final MFCategory category;
  final bool isSIP;
  final SIPDetails? sipDetails;
}

class FixedDeposit {
  final String bankName;
  final Money principal;
  final double interestRate;
  final DateTime startDate;
  final DateTime maturityDate;
  final Money maturityAmount;
  final bool autoRenew;
}

class EmergencyFund {
  final Money currentAmount;
  final Money goalAmount;
  final double percentageFunded;
  final List<EmergencyFundSource> sources;
}

class SavingsGoal {
  final String id;
  final String name;
  final String icon;
  final Money targetAmount;
  final Money savedAmount;
  final DateTime? deadline;
  final GoalPriority priority;
}
```

---

### Investing Module - Project Structure Additions

```
lib/
├── presentation/
│   └── screens/
│       └── investing/
│           ├── portfolio_dashboard_screen.dart
│           ├── stocks_portfolio_screen.dart
│           ├── mutual_funds_screen.dart
│           ├── fixed_deposits_screen.dart
│           ├── emergency_fund_screen.dart
│           ├── savings_goals_screen.dart
│           ├── investment_metrics_screen.dart
│           ├── add_investment_flow/
│           │   ├── select_type_screen.dart
│           │   ├── add_stock_screen.dart
│           │   ├── add_mutual_fund_screen.dart
│           │   ├── add_fd_screen.dart
│           │   └── add_goal_screen.dart
│           └── link_broker_screen.dart
├── domain/
│   ├── entities/
│   │   ├── portfolio_summary.dart
│   │   ├── stock_holding.dart
│   │   ├── mf_holding.dart
│   │   ├── fixed_deposit.dart
│   │   ├── emergency_fund.dart
│   │   └── savings_goal.dart
│   └── usecases/
│       ├── get_portfolio_summary.dart
│       ├── calculate_xirr.dart
│       ├── sync_broker_data.dart
│       └── manage_savings_goal.dart
└── data/
    ├── datasources/
    │   ├── local/
    │   │   └── investment_database.dart
    │   └── remote/
    │       ├── broker_api/
    │       │   ├── zerodha_api.dart
    │       │   ├── groww_api.dart
    │       │   └── mf_central_api.dart
    │       └── market_data_api.dart
    └── repositories/
        ├── investment_repository_impl.dart
        └── broker_repository_impl.dart
```

---

### Investing Module - Implementation Checklist

#### Phase 7: Investing Foundation
- [ ] Portfolio dashboard UI
- [ ] Asset allocation chart
- [ ] Manual stock entry
- [ ] Manual MF entry
- [ ] Basic holdings display

#### Phase 8: Advanced Investing
- [ ] FD management screen
- [ ] Emergency fund with goal
- [ ] Savings goals feature
- [ ] Investment calendar/reminders
- [ ] P&L tracking with XIRR

#### Phase 9: Broker Integration
- [ ] Zerodha integration (Kite Connect)
- [ ] Groww integration
- [ ] MF Central / CAMS integration
- [ ] Auto-sync of holdings
- [ ] Real-time price updates

#### 0: Analytics & Insights
- [ ] Portfolio health score
- [ ] Benchmark comparison
- [ ] Fee analysis
- [ ] Tax harvesting suggestions
- [ ] Rebalancing recommendations

---

## 🐷 Smart Savings Module

### Overview

A comprehensive savings module designed to help students build wealth systematically through automated savings, challenges, and gamified incentives. Goes beyond just tracking to actively help students save more.

---

### 23. Smart Savings Dashboard

**Purpose:** Central hub for all savings activities — recurring deposits, challenges, round-ups, and piggy banks.

**Key Features:**
- **Total savings overview** across all methods
- **Active savings streaks** with gamification
- **Quick save** buttons for impulse saving
- **Savings rate** (% of income saved)
- **Monthly savings trend** chart

**Wireframe:**

```
┌─────────────────────────────────────────┐
│ ←           Smart Savings          🔔 ⚙ │
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────────────────────────────┐│
│  │   🐷 You've saved                   ││
│  │                                      ││
│  │      ₹28,450                        ││
│  │      this month                     ││
│  │                                      ││
│  │   ███████████████████░░░░░ 78%     ││
│  │   of ₹36,500 goal                   ││
│  │                                      ││
│  │   🔥 12-day saving streak!          ││
│  └─────────────────────────────────────┘│
│                                         │
│  Quick Save                             │
│  ┌────────┐ ┌────────┐ ┌────────┐      │
│  │ ₹100   │ │ ₹500   │ │ ₹1000  │      │
│  │ Coffee │ │ Lunch  │ │ Outing │      │
│  └────────┘ └────────┘ └────────┘      │
│  [ Custom Amount ]                      │
│                                         │
│  Savings Methods                        │
│  ┌─────────────────────────────────────┐│
│  │ 🔄 Recurring Deposits               ││
│  │    3 active | ₹8,500/month          ││
│  │    Next: Feb 5 - ₹3,000             ││
│  ├─────────────────────────────────────┤│
│  │ 🎯 Savings Challenges               ││
│  │    2 active challenges              ││
│  │    52-Week Challenge: Week 6        ││
│  ├─────────────────────────────────────┤│
│  │ 🔼 Round-Up Savings                 ││
│  │    ON | Saved ₹847 this month       ││
│  │    From 156 transactions            ││
│  ├─────────────────────────────────────┤│
│  │ 🏦 Piggy Banks                      ││
│  │    4 active | ₹24,500 total         ││
│  │    [View All →]                     ││
│  └─────────────────────────────────────┘│
│                                         │
│  Monthly Savings Trend                  │
│  ┌─────────────────────────────────────┐│
│  │     ₹                               ││
│  │  30k ┤           ╭─╮                ││
│  │  20k ┤     ╭─╮   │ │  ╭─            ││
│  │  10k ┤ ╭─╮ │ │ ╭─╯ │  │             ││
│  │   0  └─┴─┴─┴─┴─┴───┴──┴─────        ││
│  │      Oct Nov Dec Jan Feb            ││
│  └─────────────────────────────────────┘│
│                                         │
└─────────────────────────────────────────┘
```

**Animations:**
- Piggy bank jiggles on deposit
- Coins fly into piggy bank on save
- Streak flame animates continuously
- Progress bar fills with celebratory particles

---

### 24. Recurring Deposits Screen

**Purpose:** Set up and manage automated recurring savings

**Key Features:**
- **Multiple RDs** with different frequencies
- **Smart scheduling** based on salary dates
- **Pause/resume** flexibility
- **Interest calculator** for bank RDs
- **History tracking**

**Wireframe:**

```
┌─────────────────────────────────────────┐
│ ←      Recurring Deposits         + Add │
├─────────────────────────────────────────┤
│                                         │
│  Total Monthly RDs: ₹8,500              │
│  Next Deposit: Feb 5 (in 3 days)        │
│                                         │
│  Active RDs                             │
│  ┌─────────────────────────────────────┐│
│  │ 🎓 Education Fund                   ││
│  │    ₹5,000/month on 5th              ││
│  │    To: SBI RD Account               ││
│  │    Interest: 6.8% p.a.              ││
│  │    Tenure: 24 months                ││
│  │    ┌────────────────────────────┐   ││
│  │    │ Deposited   │ ₹30,000      │   ││
│  │    │ Interest    │ ₹1,890       │   ││
│  │    │ Maturity    │ ₹65,420      │   ││
│  │    └────────────────────────────┘   ││
│  │    [Pause]  [Edit]                  ││
│  ├─────────────────────────────────────┤│
│  │ 🛡️ Emergency Buffer                 ││
│  │    ₹2,000/month on 10th             ││
│  │    To: Liquid Fund                  ││
│  │    Since: Oct 2024 (5 months)       ││
│  │    Total Saved: ₹10,280             ││
│  │    [Pause]  [Edit]                  ││
│  ├─────────────────────────────────────┤│
│  │ 🎮 Fun Money                        ││
│  │    ₹1,500/month on 15th             ││
│  │    To: Savings Goal                 ││
│  │    For: Gaming Console              ││
│  │    Progress: ₹4,500/₹45,000         ││
│  │    [Pause]  [Edit]                  ││
│  └─────────────────────────────────────┘│
│                                         │
│  Paused RDs                             │
│  ┌─────────────────────────────────────┐│
│  │ ⏸️ Travel Fund - ₹2,000/month       ││
│  │    Paused since Jan 15              ││
│  │    [Resume]                         ││
│  └─────────────────────────────────────┘│
│                                         │
│  💡 Tip: Set RD dates 2-3 days after   │
│     your salary date for best results   │
│                                         │
└─────────────────────────────────────────┘
```

---

### 25. Savings Challenges Screen

**Purpose:** Gamified savings challenges to make saving fun and consistent

**Key Features:**
- **Pre-built challenges** (52-Week, No-Spend, Round-Up)
- **Custom challenges** creation
- **Leaderboard** with friends
- **Achievement badges** for completion
- **Challenge reminders**

**Wireframe:**

```
┌─────────────────────────────────────────┐
│ ←       Savings Challenges        + New │
├─────────────────────────────────────────┤
│                                         │
│  Your Active Challenges                 │
│  ┌─────────────────────────────────────┐│
│  │ 📅 52-Week Money Challenge          ││
│  │    Save ₹100 in Week 1, ₹200 in     ││
│  │    Week 2... ₹5,200 in Week 52!     ││
│  │                                      ││
│  │    Week 6/52                        ││
│  │    ███░░░░░░░░░░░░░░░░░░░ 11.5%     ││
│  │                                      ││
│  │    This week: Save ₹600             ││
│  │    Total saved: ₹2,100              ││
│  │    Goal: ₹1,37,800                  ││
│  │                                      ││
│  │    [✓ Mark Week 6 Complete]         ││
│  ├─────────────────────────────────────┤│
│  │ 🚫 No-Spend Weekend Challenge       ││
│  │    No discretionary spending on     ││
│  │    weekends for 1 month             ││
│  │                                      ││
│  │    🔥 2 weekends completed!         ││
│  │    ████████░░░░░░░░░░░░░░ 40%       ││
│  │                                      ││
│  │    Est. savings: ₹3,200             ││
│  │    Actual saved: ₹2,850             ││
│  └─────────────────────────────────────┘│
│                                         │
│  Explore Challenges                     │
│  ┌─────────────────────────────────────┐│
│  │ 🎯 365-Day Penny Challenge          ││
│  │    Save ₹1 on Day 1, ₹2 on Day 2... ││
│  │    Total: ₹66,795 in a year!        ││
│  │    [Start →]                        ││
│  ├─────────────────────────────────────┤│
│  │ ☕ Skip-a-Latte Challenge           ││
│  │    Save every time you skip coffee  ││
│  │    outside. Log each skip!          ││
│  │    [Start →]                        ││
│  ├─────────────────────────────────────┤│
│  │ 🍱 Meal Prep Mondays                ││
│  │    Cook at home every Monday for    ││
│  │    3 months. Save ₹400/week avg!    ││
│  │    [Start →]                        ││
│  └─────────────────────────────────────┘│
│                                         │
│  Completed Challenges 🏆                │
│  ┌─────────────────────────────────────┐│
│  │ ✅ January No-Spend Week            ││
│  │    Saved ₹4,200 • Completed Jan 7   ││
│  └─────────────────────────────────────┘│
│                                         │
└─────────────────────────────────────────┘
```

**Animations:**
- Confetti burst on challenge completion
- Progress fills with celebration particles
- Badge unlock animation on milestones
- Leaderboard updates with slide animation

---

### 26. Round-Up Savings Screen

**Purpose:** Automatically save spare change from transactions

**Key Features:**
- **Auto round-up** to nearest ₹10/₹50/₹100
- **Multiplier option** (2x, 3x round-up)
- **Category filters** (only round-up food transactions)
- **Monthly summary** of round-up savings
- **Destination selection** (goal, emergency fund, investment)

**Wireframe:**

```
┌─────────────────────────────────────────┐
│ ←         Round-Up Savings         ⚙️   │
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────────────────────────────┐│
│  │     🔼 Round-Up Active              ││
│  │                                      ││
│  │     ₹847 saved this month           ││
│  │     from 156 transactions           ││
│  │                                      ││
│  │     ████████████████████░░░ 85%     ││
│  │     of ₹1,000 monthly goal          ││
│  └─────────────────────────────────────┘│
│                                         │
│  How It Works                           │
│  ┌─────────────────────────────────────┐│
│  │  ₹127 purchase → ₹130 rounded       ││
│  │                   ₹3 saved! 🐷      ││
│  │                                      ││
│  │  ₹89 purchase  → ₹100 rounded       ││
│  │                   ₹11 saved! 🐷     ││
│  └─────────────────────────────────────┘│
│                                         │
│  Settings                               │
│  ┌─────────────────────────────────────┐│
│  │ Round to nearest                    ││
│  │ [ ₹10 ]  [● ₹50 ]  [ ₹100 ]         ││
│  ├─────────────────────────────────────┤│
│  │ Multiplier                          ││
│  │ [● 1x ]  [ 2x ]  [ 3x ]             ││
│  │ Save 2x or 3x the round-up amount   ││
│  ├─────────────────────────────────────┤│
│  │ Apply to categories      [Edit →]   ││
│  │ ✓ Food & Dining                     ││
│  │ ✓ Shopping                          ││
│  │ ✓ Entertainment                     ││
│  │ ✗ Bills (excluded)                  ││
│  ├─────────────────────────────────────┤│
│  │ Save round-ups to       [Change]    ││
│  │ 🎯 Emergency Fund                   ││
│  └─────────────────────────────────────┘│
│                                         │
│  Recent Round-ups                       │
│  ┌─────────────────────────────────────┐│
│  │ Today                               ││
│  │ ☕ Starbucks ₹245 → ₹5 saved        ││
│  │ 🍕 Dominos ₹489 → ₹11 saved         ││
│  │ 🛒 BigBasket ₹1,234 → ₹16 saved     ││
│  │                                      ││
│  │ Yesterday                           ││
│  │ 🚕 Uber ₹187 → ₹13 saved            ││
│  │ [View All →]                        ││
│  └─────────────────────────────────────┘│
│                                         │
│  📊 Total Round-up: ₹4,290 (all time)   │
│                                         │
└─────────────────────────────────────────┘
```

---

### 27. Piggy Banks (Virtual Jars) Screen

**Purpose:** Visual savings containers for different purposes

**Key Features:**
- **Multiple piggy banks** with custom names/icons
- **Visual fill level** showing progress
- **Quick deposit** from any source
- **Break piggy bank** to use funds
- **Automated contributions**

**Wireframe:**

```
┌─────────────────────────────────────────┐
│ ←          Piggy Banks           + New  │
├─────────────────────────────────────────┤
│                                         │
│  Total in Piggy Banks: ₹24,500          │
│                                         │
│  ┌─────────────────────────────────────┐│
│  │    🐷        🎮        ✈️        📱  ││
│  │   ████     ████      ████     ░░░░  ││
│  │   ████     ███░      ██░░     ░░░░  ││
│  │   ████     ██░░      █░░░     ░░░░  ││
│  │   ▓▓▓▓     █░░░      ░░░░     ░░░░  ││
│  │   100%      65%       45%       0%  ││
│  │                                      ││
│  │ General  Gaming    Travel   iPhone  ││
│  │ ₹10,000  ₹6,500   ₹6,750    ₹0     ││
│  └─────────────────────────────────────┘│
│                                         │
│  ┌─────────────────────────────────────┐│
│  │ 🐷 General Savings                  ││
│  │    ₹10,000 of ₹10,000 (100%! 🎉)   ││
│  │    █████████████████████████        ││
│  │    [ Break Piggy Bank 🔨 ]          ││
│  ├─────────────────────────────────────┤│
│  │ 🎮 Gaming Console                   ││
│  │    ₹6,500 of ₹10,000 (65%)          ││
│  │    █████████████████░░░░░░░░        ││
│  │    Auto: ₹1,500/month               ││
│  │    ETA: Mar 2025                    ││
│  │    [ + Add ]  [ Edit ]              ││
│  ├─────────────────────────────────────┤│
│  │ ✈️ Goa Trip                         ││
│  │    ₹6,750 of ₹15,000 (45%)          ││
│  │    ███████████░░░░░░░░░░░░░░        ││
│  │    [ + Add ]  [ Edit ]              ││
│  ├─────────────────────────────────────┤│
│  │ 📱 New iPhone                       ││
│  │    ₹0 of ₹80,000 (0%)               ││
│  │    ░░░░░░░░░░░░░░░░░░░░░░░░░        ││
│  │    [ Get Started ]                  ││
│  └─────────────────────────────────────┘│
│                                         │
│  💡 Tip: Give your piggy banks fun     │
│     names to stay motivated!            │
│                                         │
└─────────────────────────────────────────┘
```

**Animations:**
- Piggy bank shakes when receiving deposit
- Coins animate falling into the bank
- Breaking animation with confetti when goal reached
- Fill level animates smoothly

---

## 🛡️ Insurance Hub Module

### Overview

A student-friendly insurance tracking and education module. Most students don't think about insurance, but this module helps them understand its importance, track family policies they're covered under, and prepare for their own insurance needs.

---

### 28. Insurance Dashboard

**Purpose:** Central hub for all insurance policies and coverage awareness

**Key Features:**
- **Coverage overview** (what you're protected against)
- **Active policies** list
- **Premium reminders** for family policies
- **Insurance score** (coverage adequacy)
- **Education content** on insurance basics

**Wireframe:**

```
┌─────────────────────────────────────────┐
│ ←         Insurance Hub          ⚙️ 🔔  │
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────────────────────────────┐│
│  │   🛡️ Your Protection Status        ││
│  │                                      ││
│  │     ╭─────────────────╮             ││
│  │    │   Coverage: 65%  │             ││
│  │    │   ████████░░░░░  │             ││
│  │     ╰─────────────────╯             ││
│  │                                      ││
│  │   ✓ Health: Covered                 ││
│  │   ✓ Accident: Covered               ││
│  │   ⚠ Term Life: Not covered         ││
│  │   ⚠ Critical Illness: Not covered  ││
│  └─────────────────────────────────────┘│
│                                         │
│  Your Policies                          │
│  ┌─────────────────────────────────────┐│
│  │ 🏥 Family Health Insurance          ││
│  │    Star Health - Family Floater     ││
│  │    Sum Insured: ₹10,00,000          ││
│  │    You're covered as dependent      ││
│  │    Premium: ₹24,500/year (Parent)   ││
│  │    Renewal: Aug 15, 2025            ││
│  │    [ View Details → ]               ││
│  ├─────────────────────────────────────┤│
│  │ 🚗 Two-Wheeler Insurance            ││
│  │    ICICI Lombard                    ││
│  │    Vehicle: Honda Activa            ││
│  │    IDV: ₹45,000                     ││
│  │    Premium: ₹1,850/year             ││
│  │    ⚠️ Expires in 23 days!           ││
│  │    [ Renew Now ]  [ Details ]       ││
│  ├─────────────────────────────────────┤│
│  │ 📱 Mobile Insurance                 ││
│  │    Samsung Care+                    ││
│  │    Device: Galaxy S23               ││
│  │    Coverage: Screen + Accidental    ││
│  │    Valid till: Dec 2025             ││
│  └─────────────────────────────────────┘│
│                                         │
│  Recommended for You                    │
│  ┌─────────────────────────────────────┐│
│  │ 💡 As a student, consider:          ││
│  │                                      ││
│  │ ⭐ Personal Accident Cover          ││
│  │    ~₹500/year for ₹5L coverage      ││
│  │    [ Learn More ]                   ││
│  │                                      ││
│  │ ⭐ Student Travel Insurance         ││
│  │    If you're studying abroad        ││
│  │    [ Learn More ]                   ││
│  └─────────────────────────────────────┘│
│                                         │
└─────────────────────────────────────────┘
```

---

### 29. Health Insurance Screen

**Purpose:** Track health insurance policies (family + personal)

**Key Features:**
- **Policy details** and coverage limits
- **Claim history**
- **Network hospitals** finder
- **Cashless vs reimbursement** info
- **Sub-limits** awareness (room rent, specific treatments)

**Wireframe:**

```
┌─────────────────────────────────────────┐
│ ←       Health Insurance                │
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────────────────────────────┐│
│  │ 🏥 Star Health Family Floater       ││
│  │                                      ││
│  │ Sum Insured: ₹10,00,000             ││
│  │ ████████████████████░░░░ 80% left   ││
│  │ (₹2,00,000 claimed this year)       ││
│  │                                      ││
│  │ Policy No: SH/2024/FAM/123456       ││
│  │ Members: 4 (You + Parents + Sibling)││
│  └─────────────────────────────────────┘│
│                                         │
│  Coverage Details                       │
│  ┌─────────────────────────────────────┐│
│  │ Hospitalization      ₹10,00,000     ││
│  │ Room Rent Limit      ₹8,000/day     ││
│  │ ICU Charges          ₹16,000/day    ││
│  │ Pre-hospitalization  60 days        ││
│  │ Post-hospitalization 90 days        ││
│  │ Ambulance Cover      ₹3,000         ││
│  │ Day Care Procedures  ✓ Covered      ││
│  │ Maternity            ✗ Not Covered  ││
│  └─────────────────────────────────────┘│
│                                         │
│  Claim History                          │
│  ┌─────────────────────────────────────┐│
│  │ 📋 Dec 2024 - Dad's Surgery         ││
│  │    Claimed: ₹1,85,000               ││
│  │    Status: ✅ Settled               ││
│  │    Type: Cashless                   ││
│  ├─────────────────────────────────────┤│
│  │ 📋 Aug 2024 - Mom's Checkup         ││
│  │    Claimed: ₹15,000                 ││
│  │    Status: ✅ Reimbursed            ││
│  └─────────────────────────────────────┘│
│                                         │
│  🏥 Find Network Hospitals              │
│  ┌─────────────────────────────────────┐│
│  │ 🔍 Search by location or name       ││
│  │ 234 cashless hospitals near you     ││
│  │ [ Open Hospital Finder → ]          ││
│  └─────────────────────────────────────┘│
│                                         │
│  📞 Emergency: 1800-XXX-XXXX           │
│                                         │
└─────────────────────────────────────────┘
```

---

### 30. Vehicle Insurance Screen

**Purpose:** Track two-wheeler/car insurance

**Key Features:**
- **Policy status** (active, expiring soon, expired)
- **IDV** (Insured Declared Value) tracking
- **Renewal reminders** with countdown
- **Add-on covers** (zero depreciation, roadside assistance)
- **NCB** (No Claim Bonus) tracker

**Wireframe:**

```
┌─────────────────────────────────────────┐
│ ←       Vehicle Insurance               │
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────────────────────────────┐│
│  │ 🛵 Honda Activa 6G                  ││
│  │    MH-02-XX-1234                    ││
│  │                                      ││
│  │    ⚠️ EXPIRES IN 23 DAYS            ││
│  │    ━━━━━━━━━━━░░░░░░░               ││
│  │    Valid till: Feb 28, 2025         ││
│  │                                      ││
│  │    [ 🔄 Renew Now ]                 ││
│  └─────────────────────────────────────┘│
│                                         │
│  Policy Details                         │
│  ┌─────────────────────────────────────┐│
│  │ Insurer         ICICI Lombard       ││
│  │ Policy Type     Comprehensive       ││
│  │ Policy No.      IL/2024/TWO/789     ││
│  │ IDV             ₹45,000             ││
│  │ Premium Paid    ₹1,850              ││
│  │ NCB             25% (2nd year)      ││
│  └─────────────────────────────────────┘│
│                                         │
│  Your Coverage                          │
│  ┌─────────────────────────────────────┐│
│  │ ✓ Own Damage Cover                  ││
│  │ ✓ Third Party Liability             ││
│  │ ✓ Personal Accident (₹15L)          ││
│  │ ✗ Zero Depreciation                 ││
│  │ ✗ Roadside Assistance               ││
│  │ ✗ Engine Protection                 ││
│  │                                      ││
│  │ 💡 Add Zero Dep for ₹350 extra      ││
│  └─────────────────────────────────────┘│
│                                         │
│  NCB Tracker (No Claim Bonus)           │
│  ┌─────────────────────────────────────┐│
│  │ Current NCB: 25%                    ││
│  │ Next Year (if no claim): 35%        ││
│  │                                      ││
│  │ Year 1: 20% → Year 2: 25% →         ││
│  │ Year 3: 35% → Year 4: 45% → 50%     ││
│  │                                      ││
│  │ 💰 You're saving ₹462 with NCB!     ││
│  └─────────────────────────────────────┘│
│                                         │
│  📞 Claim Helpline: 1800-XXX-XXXX      │
│                                         │
└─────────────────────────────────────────┘
```

**Animations:**
- Warning pulse on expiring policies
- NCB progress shows buildup over years
- Countdown timer animates daily

---

### 31. Term Life Insurance Screen (Future Planning)

**Purpose:** Educate students about term insurance for when they start earning

**Key Features:**
- **Why term insurance** education
- **Premium calculator** based on age
- **"When to buy"** guidance
- **Set reminder** for first job
- **Compare plans** (if ready to buy)

**Wireframe:**

```
┌─────────────────────────────────────────┐
│ ←       Term Life Insurance        ℹ️   │
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────────────────────────────┐│
│  │   📚 For Future You                 ││
│  │                                      ││
│  │   Term insurance is the most        ││
│  │   affordable way to protect your    ││
│  │   family's future.                  ││
│  │                                      ││
│  │   🎓 As a student, you don't need   ││
│  │   it yet. But here's why learning   ││
│  │   about it NOW matters...           ││
│  └─────────────────────────────────────┘│
│                                         │
│  Why Term Insurance?                    │
│  ┌─────────────────────────────────────┐│
│  │ ✓ Pure protection, no savings       ││
│  │ ✓ Highest cover at lowest cost      ││
│  │ ✓ Cheaper when you're young         ││
│  │ ✓ Tax benefits under 80C            ││
│  │                                      ││
│  │ [ Watch 2-min Explainer 🎬 ]        ││
│  └─────────────────────────────────────┘│
│                                         │
│  Premium Calculator                     │
│  ┌─────────────────────────────────────┐│
│  │ If you buy at age...                ││
│  │                                      ││
│  │ Age 25: ₹8,000/year for ₹1 Cr       ││
│  │ Age 30: ₹10,500/year for ₹1 Cr      ││
│  │ Age 35: ₹14,200/year for ₹1 Cr      ││
│  │                                      ││
│  │ 💡 Earlier = Cheaper forever!       ││
│  │                                      ││
│  │ [ Calculate Your Premium ]          ││
│  └─────────────────────────────────────┘│
│                                         │
│  When Should You Buy?                   │
│  ┌─────────────────────────────────────┐│
│  │ 📅 When you:                        ││
│  │ • Start earning a regular income    ││
│  │ • Get married                       ││
│  │ • Have dependents (parents/kids)    ││
│  │ • Take a loan (home/education)      ││
│  │                                      ││
│  │ [ 🔔 Remind Me After 1st Job ]      ││
│  └─────────────────────────────────────┘│
│                                         │
│  How Much Cover Do You Need?            │
│  ┌─────────────────────────────────────┐│
│  │ Rule of thumb:                      ││
│  │ 10-15x your annual income           ││
│  │                                      ││
│  │ [ Use Cover Calculator → ]          ││
│  └─────────────────────────────────────┘│
│                                         │
└─────────────────────────────────────────┘
```

---

### 32. Add Insurance Policy Screen

**Purpose:** Manually add policies you're covered under

**Wireframe:**

```
┌─────────────────────────────────────────┐
│ ←        Add Insurance Policy           │
├─────────────────────────────────────────┤
│                                         │
│  What type of insurance?                │
│  ┌──────────┐ ┌──────────┐             │
│  │ 🏥       │ │ 🚗       │             │
│  │ Health   │ │ Vehicle  │             │
│  └──────────┘ └──────────┘             │
│  ┌──────────┐ ┌──────────┐             │
│  │ 🛡️       │ │ 📱       │             │
│  │ Life     │ │ Gadget   │             │
│  └──────────┘ └──────────┘             │
│  ┌──────────┐ ┌──────────┐             │
│  │ ✈️       │ │ 📦       │             │
│  │ Travel   │ │ Other    │             │
│  └──────────┘ └──────────┘             │
├─────────────────────────────────────────┤
│                                         │
│  Policy Details                         │
│                                         │
│  Insurance Company                      │
│  ┌─────────────────────────────────┐   │
│  │ 🔍 Search insurer...            │   │
│  └─────────────────────────────────┘   │
│                                         │
│  Policy Number                          │
│  ┌─────────────────────────────────┐   │
│  │                                 │   │
│  └─────────────────────────────────┘   │
│                                         │
│  Sum Insured / Cover Amount             │
│  ┌─────────────────────────────────┐   │
│  │ ₹                               │   │
│  └─────────────────────────────────┘   │
│                                         │
│  Premium Amount                         │
│  ┌─────────────────────────────────┐   │
│  │ ₹              /year ▼          │   │
│  └─────────────────────────────────┘   │
│                                         │
│  Policy Validity                        │
│  ┌──────────────┐  ┌──────────────┐   │
│  │ Start Date   │  │ End Date     │   │
│  │ 📅 Select    │  │ 📅 Select    │   │
│  └──────────────┘  └──────────────┘   │
│                                         │
│  Who's covered?                         │
│  [ ] Me only                            │
│  [ ] Family (specify members)           │
│                                         │
│  📎 Upload Policy Document (optional)   │
│                                         │
│  [ Save Policy ]                        │
│                                         │
└─────────────────────────────────────────┘
```

---

### 33. Insurance Education Center

**Purpose:** Teach students about insurance fundamentals

**Content Topics:**
- What is insurance and how it works
- Types of insurance explained
- Premium vs Coverage trade-offs
- Claim process walkthrough
- Common insurance terms glossary
- Mistakes to avoid
- Insurance for students (what you actually need)

**Wireframe:**

```
┌─────────────────────────────────────────┐
│ ←       Insurance 101          🔖 Saved │
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────────────────────────────┐│
│  │ 🎓 Learn Insurance Basics           ││
│  │    Understand how insurance works   ││
│  │    before you need it!              ││
│  └─────────────────────────────────────┘│
│                                         │
│  Start Here                             │
│  ┌─────────────────────────────────────┐│
│  │ 📖 What is Insurance?         5 min ││
│  │    The concept of risk pooling      ││
│  ├─────────────────────────────────────┤│
│  │ 📖 Types of Insurance         8 min ││
│  │    Life, Health, Motor, & more      ││
│  ├─────────────────────────────────────┤│
│  │ 📖 Premium vs Coverage        4 min ││
│  │    Finding the right balance        ││
│  └─────────────────────────────────────┘│
│                                         │
│  For Students                           │
│  ┌─────────────────────────────────────┐│
│  │ 🎯 Do Students Need Insurance?      ││
│  │    What coverage is actually useful ││
│  ├─────────────────────────────────────┤│
│  │ 🎯 Covered Under Parents' Policy?   ││
│  │    Understanding family floaters    ││
│  ├─────────────────────────────────────┤│
│  │ 🎯 First Job Insurance Checklist    ││
│  │    What to buy when you start work  ││
│  └─────────────────────────────────────┘│
│                                         │
│  Deep Dives                             │
│  ┌─────────────────────────────────────┐│
│  │ 🔍 How to File a Claim        10min ││
│  │ 🔍 Cashless vs Reimbursement   6min ││
│  │ 🔍 Understanding Policy Exclusions  ││
│  │ 🔍 Insurance Jargon Glossary        ││
│  │ 🔍 5 Insurance Mistakes to Avoid    ││
│  └─────────────────────────────────────┘│
│                                         │
│  📊 Your Progress                       │
│  ██████████░░░░░░░░░░░ 45%              │
│  5 of 11 articles completed             │
│                                         │
└─────────────────────────────────────────┘
```

---

### Savings & Insurance Module - State Management

```dart
// Savings Providers
final smartSavingsSummaryProvider = StreamProvider<SavingsSummary>
final recurringDepositsProvider = StreamProvider<List<RecurringDeposit>>
final savingsChallengesProvider = StreamProvider<List<SavingsChallenge>>
final roundUpSettingsProvider = StateNotifierProvider<RoundUpNotifier, RoundUpSettings>
final piggyBanksProvider = StreamProvider<List<PiggyBank>>
final savingsStreakProvider = Provider<int>

// Insurance Providers  
final insuranceDashboardProvider = StreamProvider<InsuranceDashboard>
final healthPoliciesProvider = StreamProvider<List<HealthInsurance>>
final vehiclePoliciesProvider = StreamProvider<List<VehicleInsurance>>
final lifePoliciesProvider = StreamProvider<List<LifeInsurance>>
final gadgetPoliciesProvider = StreamProvider<List<GadgetInsurance>>
final insuranceRemindersProvider = StreamProvider<List<InsuranceReminder>>
final insuranceCoverageScoreProvider = Provider<int>
```

---

### Savings & Insurance - Data Models

```dart
// Savings entities
class SavingsSummary {
  final Money totalSaved;
  final Money monthlyGoal;
  final int savingStreak;
  final double savingsRate;
  final Money roundUpTotal;
}

class RecurringDeposit {
  final String id;
  final String name;
  final Money amount;
  final int dayOfMonth;
  final String destination;
  final bool isPaused;
  final DateTime startDate;
}

class SavingsChallenge {
  final String id;
  final String name;
  final ChallengeType type;
  final int currentProgress;
  final int totalSteps;
  final Money savedAmount;
  final Money targetAmount;
  final DateTime? deadline;
}

class PiggyBank {
  final String id;
  final String name;
  final String icon;
  final Money currentAmount;
  final Money goalAmount;
  final bool hasAutoContribution;
}

// Insurance entities
class InsurancePolicy {
  final String id;
  final InsuranceType type;
  final String insurer;
  final String policyNumber;
  final Money sumInsured;
  final Money premiumAmount;
  final PremiumFrequency frequency;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> coveredMembers;
  final String? documentPath;
}

enum InsuranceType {
  health, vehicle, life, gadget, travel, other
}

class InsuranceDashboard {
  final int coverageScore;
  final List<InsurancePolicy> policies;
  final List<CoverageGap> gaps;
  final List<InsuranceReminder> upcomingRenewals;
}
```

---

### Savings & Insurance - Project Structure Additions

```
lib/
├── presentation/
│   └── screens/
│       ├── savings/
│       │   ├── smart_savings_dashboard.dart
│       │   ├── recurring_deposits_screen.dart
│       │   ├── savings_challenges_screen.dart
│       │   ├── round_up_savings_screen.dart
│       │   └── piggy_banks_screen.dart
│       └── insurance/
│           ├── insurance_dashboard.dart
│           ├── health_insurance_screen.dart
│           ├── vehicle_insurance_screen.dart
│           ├── term_life_screen.dart
│           ├── add_insurance_screen.dart
│           └── insurance_education_screen.dart
├── domain/
│   ├── entities/
│   │   ├── savings_summary.dart
│   │   ├── recurring_deposit.dart
│   │   ├── savings_challenge.dart
│   │   ├── piggy_bank.dart
│   │   ├── insurance_policy.dart
│   │   └── insurance_dashboard.dart
│   └── usecases/
│       ├── manage_recurring_deposit.dart
│       ├── process_round_up.dart
│       ├── track_challenge_progress.dart
│       └── calculate_coverage_score.dart
└── data/
    ├── datasources/
    │   └── local/
    │       ├── savings_database.dart
    │       └── insurance_database.dart
    └── repositories/
        ├── savings_repository_impl.dart
        └── insurance_repository_impl.dart
```

---

### Savings & Insurance - Implementation Checklist

#### 1: Smart Savings
- [ ] Smart savings dashboard
- [ ] Recurring deposits management
- [ ] Piggy banks feature
- [ ] Round-up savings automation
- [ ] Savings challenges system

#### 2: Insurance Hub
- [ ] Insurance dashboard
- [ ] Health insurance tracking
- [ ] Vehicle insurance with NCB
- [ ] Add policy flow
- [ ] Renewal reminders

#### 3: Education & Gamification
- [ ] Insurance education center
- [ ] Savings streaks & achievements
- [ ] Challenge leaderboards
- [ ] Coverage score calculation
- [ ] Financial health integration

---

## 📊 Smart Budgeting Module

### Overview

A flexible, intelligent budgeting system designed for the variable income patterns of students. Supports multiple budgeting philosophies (50/30/20, zero-based, envelope method) while providing smart recommendations based on spending patterns.

---

### 34. Budget Overview Dashboard

**Purpose:** Central budgeting hub showing all active budgets, spending status, and quick insights

**Key Features:**
- **Monthly budget summary** with visual progress
- **Category breakdown** with quick glance status
- **Days remaining** in budget period
- **Daily spending allowance** (remaining ÷ days left)
- **Quick comparisons** to previous months

**Wireframe:**

```
┌─────────────────────────────────────────┐
│ ←           My Budget            ⚙️  📅 │
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────────────────────────────┐│
│  │   February 2025                     ││
│  │                                      ││
│  │   ₹18,450 of ₹25,000 spent          ││
│  │   ███████████████████░░░░░░ 74%     ││
│  │                                      ││
│  │   ₹6,550 remaining                  ││
│  │   23 days left                      ││
│  │                                      ││
│  │   💡 Safe to spend ₹284/day         ││
│  └─────────────────────────────────────┘│
│                                         │
│  Budget Health                          │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐│
│  │ On Track │ │ Warning  │ │ Over     ││
│  │    5     │ │    2     │ │    1     ││
│  │    🟢    │ │    🟡    │ │    🔴    ││
│  └──────────┘ └──────────┘ └──────────┘│
│                                         │
│  Category Budgets                       │
│  ┌─────────────────────────────────────┐│
│  │ 🍔 Food & Dining          ₹4,200    ││
│  │    ██████████████░░░ 70%  /₹6,000   ││
│  │    ✓ On track • ₹75/day left        ││
│  ├─────────────────────────────────────┤│
│  │ 🚌 Transport              ₹1,800    ││
│  │    ████████████░░░░░ 60%  /₹3,000   ││
│  │    ✓ On track                       ││
│  ├─────────────────────────────────────┤│
│  │ 🎮 Entertainment          ₹1,950    ││
│  │    █████████████████ 97%  /₹2,000   ││
│  │    ⚠ Only ₹50 left!                 ││
│  ├─────────────────────────────────────┤│
│  │ 🛒 Shopping               ₹3,500    ││
│  │    ███████████████████ 116% /₹3,000 ││
│  │    🔴 Over by ₹500                  ││
│  ├─────────────────────────────────────┤│
│  │ 📚 Education              ₹2,000    ││
│  │    ███████████░░░░░░ 50%  /₹4,000   ││
│  │    ✓ Excellent                      ││
│  └─────────────────────────────────────┘│
│                                         │
│  [ + Add Budget ]  [ 📊 See Insights ]  │
│                                         │
│  vs Last Month                          │
│  ┌─────────────────────────────────────┐│
│  │ You're spending 12% less this month ││
│  │ 📉 Food: -₹800 • 📉 Transport: -₹400││
│  │ 📈 Shopping: +₹500                  ││
│  └─────────────────────────────────────┘│
│                                         │
└─────────────────────────────────────────┘
```

**Animations:**
- Progress bars fill on load
- Category cards expand on tap
- Warning badges pulse gently
- Over-budget indicators shake

---

### 35. Category Budget Detail Screen

**Purpose:** Deep dive into single category budget performance

**Key Features:**
- **Spending timeline** within the month
- **Transaction list** for this category
- **Budget adjustment** options
- **Historical comparison** chart
- **Spending pattern** insights

**Wireframe:**

```
┌─────────────────────────────────────────┐
│ ←        🍔 Food & Dining         ✏️    │
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────────────────────────────┐│
│  │   Budget: ₹6,000/month              ││
│  │   Spent: ₹4,200 (70%)               ││
│  │   ███████████████░░░░░░░░░░         ││
│  │                                      ││
│  │   Remaining: ₹1,800                 ││
│  │   Daily pace: ₹140 → ₹78/day safe   ││
│  └─────────────────────────────────────┘│
│                                         │
│  Spending Timeline                      │
│  ┌─────────────────────────────────────┐│
│  │      Week 1   Week 2   Week 3   W4  ││
│  │  ₹2k ┤                              ││
│  │  ₹1k ┤ ████    ████    ███░         ││
│  │   0  └──────────────────────────    ││
│  │      ₹1,400  ₹1,600  ₹1,200  --     ││
│  │                                      ││
│  │  — Budget pace   •• Your spending   ││
│  └─────────────────────────────────────┘│
│                                         │
│  Recent Transactions                    │
│  ┌─────────────────────────────────────┐│
│  │ Today                               ││
│  │ 🍕 Dominos Pizza         -₹489      ││
│  │ ☕ Chai Point             -₹85      ││
│  ├─────────────────────────────────────┤│
│  │ Yesterday                           ││
│  │ 🍔 McDonald's            -₹320      ││
│  │ 🛒 Zepto Groceries       -₹750      ││
│  │ [View All →]                        ││
│  └─────────────────────────────────────┘│
│                                         │
│  Spending Insights                      │
│  ┌─────────────────────────────────────┐│
│  │ 📊 You spend most on weekends       ││
│  │    Fri-Sun averages ₹400 vs ₹180    ││
│  │                                      ││
│  │ 📍 Top merchant: Swiggy (₹1,200)    ││
│  │                                      ││
│  │ 💡 Cooking 2 meals/week could save  ││
│  │    ~₹800/month                      ││
│  └─────────────────────────────────────┘│
│                                         │
│  [ Adjust Budget ]                      │
│                                         │
└─────────────────────────────────────────┘
```

---

### 36. 50/30/20 Smart Budget

**Purpose:** Set up and track the popular 50/30/20 budgeting rule

**Key Features:**
- **Auto-categorize** expenses into Needs/Wants/Savings
- **Visual breakdown** of current split
- **Recommendations** to improve allocation
- **One-tap setup** based on income
- **Real-time tracking** of each bucket

**Wireframe:**

```
┌─────────────────────────────────────────┐
│ ←        50/30/20 Budget           ℹ️   │
├─────────────────────────────────────────┤
│                                         │
│  Your Monthly Income: ₹25,000           │
│  ┌─────────────────────────────────────┐│
│  │  [ Edit Income ]                    ││
│  └─────────────────────────────────────┘│
│                                         │
│  Target Allocation                      │
│  ┌─────────────────────────────────────┐│
│  │                                      ││
│  │  ┌─────────────────────────────┐    ││
│  │  │  NEEDS   │ WANTS  │ SAVINGS │    ││
│  │  │   50%    │  30%   │   20%   │    ││
│  │  │ ₹12,500  │ ₹7,500 │ ₹5,000  │    ││
│  │  └─────────────────────────────┘    ││
│  │                                      ││
│  └─────────────────────────────────────┘│
│                                         │
│  February Status                        │
│  ┌─────────────────────────────────────┐│
│  │ 🏠 NEEDS (50% target)               ││
│  │    ₹11,200 of ₹12,500               ││
│  │    ██████████████████░░░ 90%        ││
│  │    ✓ On track                       ││
│  │    ├─ Rent: ₹8,000                  ││
│  │    ├─ Bills: ₹1,200                 ││
│  │    ├─ Transport: ₹1,400             ││
│  │    └─ Groceries: ₹600               ││
│  ├─────────────────────────────────────┤│
│  │ 🎉 WANTS (30% target)               ││
│  │    ₹8,200 of ₹7,500                 ││
│  │    ████████████████████ 109%        ││
│  │    🔴 Over by ₹700                  ││
│  │    ├─ Dining out: ₹3,500            ││
│  │    ├─ Entertainment: ₹2,200         ││
│  │    ├─ Shopping: ₹1,800              ││
│  │    └─ Subscriptions: ₹700           ││
│  ├─────────────────────────────────────┤│
│  │ 💰 SAVINGS (20% target)             ││
│  │    ₹3,500 of ₹5,000                 ││
│  │    ██████████████░░░░░░░ 70%        ││
│  │    ⚠ Add ₹1,500 more                ││
│  │    ├─ Emergency fund: ₹2,000        ││
│  │    ├─ Investments: ₹1,000           ││
│  │    └─ Goal savings: ₹500            ││
│  └─────────────────────────────────────┘│
│                                         │
│  AI Recommendation                      │
│  ┌─────────────────────────────────────┐│
│  │ 💡 To hit your savings goal:        ││
│  │                                      ││
│  │ • Skip 3 dining-out meals → ₹900    ││
│  │ • Pause Netflix for Feb → ₹199      ││
│  │ • Cook weekends at home → ₹400      ││
│  │                                      ││
│  │ [ Apply Suggestions ]               ││
│  └─────────────────────────────────────┘│
│                                         │
└─────────────────────────────────────────┘
```

---

### 37. Create/Edit Budget Flow

**Purpose:** Step-by-step budget creation wizard

**Key Features:**
- **Smart suggestions** based on past spending
- **Flexible periods** (monthly, weekly, custom)
- **Rollover options** (carry unused budget)
- **Alert thresholds** (50%, 80%, 90%)
- **Category selection** with icons

**Wireframe:**

```
┌─────────────────────────────────────────┐
│ ×          Create Budget          Next →│
├─────────────────────────────────────────┤
│                                         │
│  Step 1 of 4: Choose Category           │
│  ━━━━━━━━━░░░░░░░░░░░░░░░░░░░░         │
│                                         │
│  ┌─────────────────────────────────────┐│
│  │ Quick Start (based on your spending)││
│  │                                      ││
│  │   🍔 Food        🚌 Transport       ││
│  │   ₹5,500 avg     ₹2,800 avg        ││
│  │                                      ││
│  │   🎮 Fun         🛒 Shopping        ││
│  │   ₹2,100 avg     ₹3,200 avg        ││
│  └─────────────────────────────────────┘│
│                                         │
│  Or pick a category                     │
│  ┌─────────────────────────────────────┐│
│  │ ● 🍔 Food & Dining                  ││
│  │ ○ 🚌 Transport                      ││
│  │ ○ 🎮 Entertainment                  ││
│  │ ○ 🛒 Shopping                       ││
│  │ ○ 📚 Education                      ││
│  │ ○ 💊 Health                         ││
│  │ ○ 🎁 Gifts                          ││
│  │ ○ ➕ Create Custom Category         ││
│  └─────────────────────────────────────┘│
│                                         │
├─────────────────────────────────────────┤
│  Step 2: Set Amount                     │
│                                         │
│  How much do you want to budget?        │
│  ┌─────────────────────────────────────┐│
│  │         ₹ 6,000                     ││
│  │           /month                    ││
│  └─────────────────────────────────────┘│
│                                         │
│  💡 You spent ₹5,480 on Food last month│
│     Suggested: ₹5,500 - ₹6,000         │
│                                         │
│  Budget Period                          │
│  [ Monthly ▼ ]  starts 1st of month    │
│                                         │
├─────────────────────────────────────────┤
│  Step 3: Alert Settings                 │
│                                         │
│  Notify me when I reach:                │
│  ┌─────────────────────────────────────┐│
│  │ ☑ 50% (₹3,000) - Gentle reminder    ││
│  │ ☑ 80% (₹4,800) - Warning            ││
│  │ ☑ 100% (₹6,000) - Budget reached    ││
│  │ ☐ Custom threshold...               ││
│  └─────────────────────────────────────┘│
│                                         │
├─────────────────────────────────────────┤
│  Step 4: Rollover Settings              │
│                                         │
│  What happens to unused budget?         │
│  ┌─────────────────────────────────────┐│
│  │ ○ Reset to ₹6,000 each month        ││
│  │ ● Carry forward unused amount       ││
│  │   (e.g., ₹500 left → ₹6,500 next)   ││
│  │ ○ Transfer to savings goal          ││
│  └─────────────────────────────────────┘│
│                                         │
│  [ Create Budget ]                      │
│                                         │
└─────────────────────────────────────────┘
```

---

### 38. Budget Alerts & Notifications

**Purpose:** Real-time spending alerts and smart notifications

**Key Features:**
- **Threshold alerts** (50%, 80%, 100%)
- **Predictive warnings** ("at this pace, you'll run out by...")
- **Daily summaries** (optional)
- **Smart timing** (don't alert during sleep hours)
- **Actionable notifications** with quick actions

**Wireframe:**

```
┌─────────────────────────────────────────┐
│ ←        Budget Alerts           ⚙️     │
├─────────────────────────────────────────┤
│                                         │
│  Active Alerts                          │
│  ┌─────────────────────────────────────┐│
│  │ 🔴 Shopping Budget Exceeded         ││
│  │    Feb 5, 2:30 PM                   ││
│  │                                      ││
│  │    You've spent ₹3,500 of your      ││
│  │    ₹3,000 Shopping budget.          ││
│  │                                      ││
│  │    [ View Budget ]  [ Adjust ]      ││
│  ├─────────────────────────────────────┤│
│  │ 🟡 Entertainment at 97%             ││
│  │    Feb 4, 6:15 PM                   ││
│  │                                      ││
│  │    Only ₹50 remaining in your       ││
│  │    Entertainment budget this month. ││
│  │                                      ││
│  │    [ View Budget ]                  ││
│  ├─────────────────────────────────────┤│
│  │ 💡 Pace Alert: Food Budget          ││
│  │    Feb 3, 9:00 AM                   ││
│  │                                      ││
│  │    At your current pace, you'll     ││
│  │    exhaust Food budget by Feb 20.   ││
│  │    Consider reducing daily to ₹180. ││
│  │                                      ││
│  │    [ Got it ]  [ See Tips ]         ││
│  └─────────────────────────────────────┘│
│                                         │
│  Notification Settings                  │
│  ┌─────────────────────────────────────┐│
│  │ Budget Alerts                   🔔  ││
│  │ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━○   ││
│  │                                      ││
│  │ Alert thresholds                    ││
│  │ ☑ 50% - Gentle reminder             ││
│  │ ☑ 80% - Warning                     ││
│  │ ☑ 100% - Over budget                ││
│  │                                      ││
│  │ Predictive alerts               ON  ││
│  │ "You'll run out by..."              ││
│  │                                      ││
│  │ Daily spending summary          OFF ││
│  │                                      ││
│  │ Quiet hours                         ││
│  │ 10 PM - 8 AM (no notifications)     ││
│  └─────────────────────────────────────┘│
│                                         │
└─────────────────────────────────────────┘
```

---

### 39. Weekly Allowance Mode

**Purpose:** Break monthly budget into weekly chunks for better control

**Key Features:**
- **Weekly breakdown** of monthly budget
- **Leftover handling** (save or splurge on weekend)
- **Week-by-week comparison**
- **Spending velocity** tracking
- **Great for students** with variable weekly expenses

**Wireframe:**

```
┌─────────────────────────────────────────┐
│ ←       Weekly Allowance          ⚙️    │
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────────────────────────────┐│
│  │   This Week (Feb 3 - Feb 9)         ││
│  │                                      ││
│  │   ₹3,200 of ₹4,500 spent            ││
│  │   ██████████████░░░░░ 71%           ││
│  │                                      ││
│  │   ₹1,300 remaining                  ││
│  │   4 days left                       ││
│  │                                      ││
│  │   💰 Daily allowance: ₹325          ││
│  └─────────────────────────────────────┘│
│                                         │
│  Weekly Breakdown                       │
│  ┌─────────────────────────────────────┐│
│  │ Week 1 (Feb 1-2)    ✓               ││
│  │ ₹1,200 of ₹1,286 • Saved ₹86!       ││
│  │ ████████████████████░               ││
│  ├─────────────────────────────────────┤│
│  │ Week 2 (Feb 3-9)    ← Current       ││
│  │ ₹3,200 of ₹4,500                    ││
│  │ ██████████████░░░░░░                ││
│  ├─────────────────────────────────────┤│
│  │ Week 3 (Feb 10-16)  Upcoming        ││
│  │ Budget: ₹4,500                      ││
│  │ ░░░░░░░░░░░░░░░░░░░░                ││
│  ├─────────────────────────────────────┤│
│  │ Week 4 (Feb 17-23)  Upcoming        ││
│  │ Budget: ₹4,500                      ││
│  │ ░░░░░░░░░░░░░░░░░░░░                ││
│  └─────────────────────────────────────┘│
│                                         │
│  Leftover Options                       │
│  ┌─────────────────────────────────────┐│
│  │ When you have money left over:      ││
│  │                                      ││
│  │ ● Roll over to next week            ││
│  │ ○ Transfer to savings               ││
│  │ ○ Add to fun money                  ││
│  │ ○ Reset each week (strict)          ││
│  └─────────────────────────────────────┘│
│                                         │
│  This Month Summary                     │
│  ┌─────────────────────────────────────┐│
│  │ Total Budget: ₹18,000               ││
│  │ Spent so far: ₹4,400                ││
│  │ Saved so far: ₹86                   ││
│  └─────────────────────────────────────┘│
│                                         │
└─────────────────────────────────────────┘
```

---

### 40. Spending Limits (Per-Merchant/Category)

**Purpose:** Set hard or soft limits on specific merchants or subcategories

**Key Features:**
- **Merchant-level limits** (e.g., Swiggy ₹2,000/month)
- **Subcategory limits** (e.g., Coffee ₹500/month)
- **Hard vs soft limits** (block or warn)
- **Cool-down periods** after hitting limit
- **Exceptions** for special occasions

**Wireframe:**

```
┌─────────────────────────────────────────┐
│ ←       Spending Limits          + Add  │
├─────────────────────────────────────────┤
│                                         │
│  Active Limits                          │
│  ┌─────────────────────────────────────┐│
│  │ 🍕 Swiggy/Zomato                    ││
│  │    Monthly limit: ₹2,000            ││
│  │    ██████████████████░░░ 85%        ││
│  │    ₹1,700 spent • ₹300 left         ││
│  │                                      ││
│  │    Type: Soft (warns only)          ││
│  │    [ Edit ]  [ Pause ]              ││
│  ├─────────────────────────────────────┤│
│  │ ☕ Coffee Shops                      ││
│  │    Weekly limit: ₹300               ││
│  │    ██████░░░░░░░░░░░░ 40%           ││
│  │    ₹120 spent • ₹180 left           ││
│  │                                      ││
│  │    Type: Hard (blocks)              ││
│  │    [ Edit ]  [ Pause ]              ││
│  ├─────────────────────────────────────┤│
│  │ 🎮 Gaming In-App Purchases          ││
│  │    Monthly limit: ₹500              ││
│  │    ████████████████████ 100% 🔒     ││
│  │    ₹500 spent • LIMIT REACHED       ││
│  │                                      ││
│  │    Resets in: 23 days               ││
│  │    [ Request Exception ]            ││
│  └─────────────────────────────────────┘│
│                                         │
│  Suggested Limits                       │
│  ┌─────────────────────────────────────┐│
│  │ Based on your spending patterns:    ││
│  │                                      ││
│  │ 🛵 Quick Commerce                   ││
│  │    You spent ₹3,200 last month      ││
│  │    Suggested limit: ₹2,500          ││
│  │    [ Set Limit ]                    ││
│  │                                      ││
│  │ 📺 Streaming Subscriptions          ││
│  │    You have 4 active subs: ₹897     ││
│  │    [ Review & Limit ]               ││
│  └─────────────────────────────────────┘│
│                                         │
│  [ + Create New Limit ]                 │
│                                         │
└─────────────────────────────────────────┘
```

---

### 41. Budget Insights & AI Recommendations

**Purpose:** AI-powered budget analysis and optimization suggestions

**Key Features:**
- **Spending pattern analysis** with visualizations
- **Budget optimization** suggestions
- **Anomaly detection** (unusual spending)
- **Peer comparison** (optional, anonymized)
- **Forecast** for month-end status

**Wireframe:**

```
┌─────────────────────────────────────────┐
│ ←       Budget Insights           🤖    │
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────────────────────────────┐│
│  │ 🧠 AI Analysis for February         ││
│  │                                      ││
│  │ Overall Budget Health: Good 👍      ││
│  │ ██████████████████░░░░ 78%          ││
│  │                                      ││
│  │ You're ₹1,200 ahead of typical      ││
│  │ mid-month spending.                 ││
│  └─────────────────────────────────────┘│
│                                         │
│  Month-End Forecast                     │
│  ┌─────────────────────────────────────┐│
│  │ At current pace, by Feb 28:         ││
│  │                                      ││
│  │ Expected spend: ₹23,400             ││
│  │ Budget: ₹25,000                     ││
│  │ Likely to save: ₹1,600 ✨           ││
│  │                                      ││
│  │ 🎯 You're on track to meet your     ││
│  │    savings goal this month!         ││
│  └─────────────────────────────────────┘│
│                                         │
│  Key Insights                           │
│  ┌─────────────────────────────────────┐│
│  │ 📈 Weekend Spending Spike           ││
│  │    Fri-Sun: ₹890/day avg            ││
│  │    Mon-Thu: ₹420/day avg            ││
│  │    Consider weekend budget: ₹2,000  ││
│  ├─────────────────────────────────────┤│
│  │ 🔄 Recurring Subscriptions          ││
│  │    Netflix + Spotify + Prime = ₹897 ││
│  │    This is 3.6% of your income      ││
│  │    [ Review Subscriptions ]         ││
│  ├─────────────────────────────────────┤│
│  │ 🎯 Quick Win Opportunity            ││
│  │    Switching to meal prep 2x/week   ││
│  │    could save ₹1,600/month          ││
│  │    [ Tell Me More ]                 ││
│  └─────────────────────────────────────┘│
│                                         │
│  Unusual Activity                       │
│  ┌─────────────────────────────────────┐│
│  │ ⚠️ Higher than usual spending at:   ││
│  │                                      ││
│  │ Amazon: ₹4,200 (vs ₹1,800 avg)      ││
│  │ Is this expected? [Yes] [No, Flag]  ││
│  └─────────────────────────────────────┘│
│                                         │
│  Compare (Anonymous)                    │
│  ┌─────────────────────────────────────┐│
│  │ Students with similar income:       ││
│  │ • Spend 22% less on dining out      ││
│  │ • Spend 15% more on transport       ││
│  │ • Save 18% more monthly             ││
│  │                                      ││
│  │ [ See How to Improve ]              ││
│  └─────────────────────────────────────┘│
│                                         │
└─────────────────────────────────────────┘
```

---

### Budgeting Module - State Management

```dart
// Budget Providers
final budgetOverviewProvider = StreamProvider<BudgetOverview>
final categoryBudgetsProvider = StreamProvider<List<CategoryBudget>>
final activeBudgetProvider = StateProvider<BudgetPeriod>
final budget5030Provider = StreamProvider<Budget5030Status>
final weeklyAllowanceProvider = StreamProvider<WeeklyAllowance>
final spendingLimitsProvider = StreamProvider<List<SpendingLimit>>
final budgetAlertsProvider = StreamProvider<List<BudgetAlert>>
final budgetInsightsProvider = FutureProvider<BudgetInsights>

// Budget Notifiers
final createBudgetNotifier = StateNotifierProvider<CreateBudgetNotifier, CreateBudgetState>
final budgetAlertSettingsProvider = StateNotifierProvider<AlertSettingsNotifier, AlertSettings>
```

---

### Budgeting Module - Data Models

```dart
class BudgetOverview {
  final Money totalBudget;
  final Money totalSpent;
  final Money remaining;
  final int daysRemaining;
  final Money dailyAllowance;
  final List<CategoryBudget> categoryBudgets;
  final BudgetHealth health;
}

class CategoryBudget {
  final String id;
  final Category category;
  final Money budgetAmount;
  final Money spentAmount;
  final BudgetPeriod period;
  final List<AlertThreshold> thresholds;
  final RolloverOption rolloverOption;
  final BudgetStatus status;
}

enum BudgetStatus {
  onTrack,    // < 80%
  warning,    // 80-100%
  exceeded    // > 100%
}

class Budget5030Status {
  final Money income;
  final BucketStatus needs;   // 50%
  final BucketStatus wants;   // 30%
  final BucketStatus savings; // 20%
}

class WeeklyAllowance {
  final Money weeklyBudget;
  final Money spent;
  final int daysRemaining;
  final List<WeekSummary> weeks;
  final RolloverOption leftoverOption;
}

class SpendingLimit {
  final String id;
  final LimitType type; // merchant, subcategory
  final String targetName;
  final Money limitAmount;
  final Money spentAmount;
  final LimitPeriod period;
  final bool isHardLimit;
  final bool isPaused;
}

class BudgetInsights {
  final int healthScore;
  final MonthEndForecast forecast;
  final List<Insight> insights;
  final List<AnomalyAlert> anomalies;
  final PeerComparison? comparison;
}
```

---

### Budgeting Module - Project Structure Additions

```
lib/
├── presentation/
│   └── screens/
│       └── budgeting/
│           ├── budget_overview_screen.dart
│           ├── category_budget_detail_screen.dart
│           ├── budget_5030_screen.dart
│           ├── create_budget_flow.dart
│           ├── budget_alerts_screen.dart
│           ├── weekly_allowance_screen.dart
│           ├── spending_limits_screen.dart
│           └── budget_insights_screen.dart
├── domain/
│   ├── entities/
│   │   ├── budget_overview.dart
│   │   ├── category_budget.dart
│   │   ├── spending_limit.dart
│   │   ├── weekly_allowance.dart
│   │   └── budget_insights.dart
│   └── usecases/
│       ├── calculate_daily_allowance.dart
│       ├── check_budget_thresholds.dart
│       ├── generate_budget_insights.dart
│       ├── forecast_month_end.dart
│       └── apply_spending_limit.dart
└── data/
    └── repositories/
        └── budget_repository_impl.dart
```

---

### Budgeting Module - Implementation Checklist

#### 4: Core Budgeting
- [ ] Budget overview dashboard
- [ ] Category budget creation & editing
- [ ] Budget progress tracking
- [ ] Alert threshold system
- [ ] Rollover handling

#### 5: Advanced Budgets
- [ ] 50/30/20 rule implementation
- [ ] Weekly allowance mode
- [ ] Spending limits (merchant/category)
- [ ] Hard vs soft limit enforcement
- [ ] Budget templates

#### 6: Intelligence & Insights
- [ ] AI budget recommendations
- [ ] Month-end forecasting
- [ ] Anomaly detection
- [ ] Peer comparison (opt-in)
- [ ] Spending pattern analysis

---

## ✨ Animation & Micro-interaction Specifications

### Global Animations

| Interaction | Animation | Duration | Easing |
|-------------|-----------|----------|--------|
| Screen transitions | Shared element + fade | 300ms | easeInOutCubic |
| Pull to refresh | Custom logo animation | 500ms | bounceOut |
| Card tap | Scale 0.98 → 1.0 | 100ms | easeOut |
| Button tap | Ripple + slight scale | 150ms | easeOut |
| Bottom sheet open | Slide up with fade | 250ms | easeOutQuart |
| List item appear | Staggered fade up | 50ms delay each | easeOutQuart |
| Number changes | Count up animation | 800ms | easeOutExpo |
| Progress bars | Animated fill | 500ms | easeInOutQuint |

### Specific Animations

1. **Balance Card**
   - Parallax tilt on drag
   - Shimmer effect on balance (optional reveal)
   - Gradient animation on refresh

2. **Pie/Donut Charts**
   - Segments animate in clockwise
   - Tap segment: expand + show tooltip
   - Category colors pulse subtly

3. **Transaction Items**
   - Slide in from right on new transaction
   - Swipe reveals action buttons
   - Category icon has micro-animation

4. **Finance Score Gauge**
   - Needle animates to score
   - Glow effect on high scores
   - Particle burst on score increase

5. **Budget Progress Bars**
   - Fill animation from left
   - Color transitions as approaching limit
   - Pulse animation when exceeded

6. **Success States**
   - Confetti on achievements
   - Checkmark draw animation
   - Haptic feedback (light)

### Haptic Feedback Pattern

```dart
// Light: Button taps, selections
HapticFeedback.lightImpact();

// Medium: Important actions (save, delete)
HapticFeedback.mediumImpact();

// Heavy: Success, achievements
HapticFeedback.heavyImpact();

// Selection: Toggle, checkbox
HapticFeedback.selectionClick();
```

---

## 🎭 Icon Design Guidelines

**DO NOT USE:**
- Generic material icons
- Typical AI-generated flat icons
- Inconsistent icon sets
- System default icons

**USE INSTEAD:**
- Custom-designed icons with brand personality
- Animated icons (Rive, Lottie) for categories
- Consistent 2px stroke weight
- Rounded corners matching brand
- Dual-tone or gradient fills where appropriate

**Icon Categories Needed:**
- Category icons (Food, Transport, Entertainment, etc.)
- Navigation icons (Home, Transactions, Add, Stats, Profile)
- Action icons (Edit, Delete, Share, Split, Filter)
- Status icons (Success, Warning, Error, Sync, Connected)
- Financial icons (Rupee, Bank, Card, UPI, Wallet)

---

## 📱 Component Library

### Core Components to Build

```
├── Buttons/
│   ├── PrimaryButton (gradient fill)
│   ├── SecondaryButton (outlined)
│   ├── GhostButton (text only)
│   ├── IconButton (circular)
│   └── FAB (floating action button)
├── Cards/
│   ├── GlassCard (glassmorphism)
│   ├── TransactionCard
│   ├── BudgetCard
│   ├── AccountCard
│   └── InsightCard
├── Inputs/
│   ├── AmountInput (with numpad)
│   ├── SearchInput
│   ├── DatePicker
│   ├── CategorySelector
│   └── OTPInput
├── Charts/
│   ├── DonutChart (animated)
│   ├── LineChart (trends)
│   ├── BarChart (comparisons)
│   └── ProgressBar (budgets)
├── Navigation/
│   ├── BottomNavBar
│   ├── TopAppBar
│   └── TabBar
├── Feedback/
│   ├── Toast notifications
│   ├── Loading states
│   ├── Empty states
│   └── Error states
└── Gamification/
    ├── ScoreGauge
    ├── AchievementBadge
    └── ProgressRing
```

---

## 🔐 Security UI Patterns

### Sensitive Data Display
- Balance amounts: Tap to reveal, auto-hide after 5s
- Account numbers: Always masked (****4521)
- Transaction details: Blur when app backgrounded

### Authentication Flows
- Biometric prompt on app resume
- PIN fallback option
- Session timeout (5 min inactive)
- Secure keyboard for OTP

### Privacy Indicators
- "On-device" badge on SMS processing
- Sync status indicators
- Encryption status in settings
- Data transparency dashboard

---

## 📊 State Management with Riverpod

### Key Providers Structure

```dart
// Auth state
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>

// User profile
final userProfileProvider = FutureProvider<UserProfile>

// Transactions
final transactionsProvider = StreamProvider<List<Transaction>>
final filteredTransactionsProvider = Provider<List<Transaction>>

// Budgets
final budgetsProvider = StreamProvider<List<Budget>>
final currentMonthBudgetProvider = Provider<Budget?>

// Accounts
final linkedAccountsProvider = StreamProvider<List<LinkedAccount>>
final totalBalanceProvider = Provider<Money>

// Analytics
final spendingStatsProvider = FutureProvider.family<SpendingStats, DateRange>

// Settings
final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>
```

---

## 📁 Project Structure

```
lib/
├── main.dart
├── app/
│   ├── app.dart
│   ├── router/
│   │   ├── app_router.dart
│   │   └── routes.dart
│   └── themes/
│       ├── app_theme.dart
│       ├── colors.dart
│       └── typography.dart
├── core/
│   ├── constants/
│   ├── errors/
│   ├── utils/
│   └── extensions/
├── data/
│   ├── datasources/
│   │   ├── local/
│   │   │   ├── database/
│   │   │   └── sms/
│   │   └── remote/
│   ├── models/
│   ├── repositories/
│   └── providers/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── common/
    │   ├── widgets/
    │   └── animations/
    ├── screens/
    │   ├── splash/
    │   ├── onboarding/
    │   ├── auth/
    │   ├── home/
    │   ├── transactions/
    │   ├── budgets/
    │   ├── analytics/
    │   ├── accounts/
    │   ├── split_bills/
    │   ├── education/
    │   └── settings/
    └── providers/
```

---

## 🤖 AI vs Non-AI Feature Matrix

### Overview

This section clearly identifies which features **require AI/ML** for core functionality vs features that work perfectly with **traditional logic**. AI should add real value, not complexity where simple rules suffice.

---

### 🧠 Features That NEED AI/ML

| Feature | AI Capability | Why AI is Essential |
|---------|---------------|---------------------|
| **SMS Transaction Parsing** | NLP/Named Entity Recognition | Bank SMS formats vary wildly; regex alone can't handle variations, typos, and new formats |
| **Auto-Categorization** | TensorFlow Lite Classifier | "Swiggy" → Food, "Ola" → Transport requires learning from context, merchant names, and user behavior |
| **Spending Predictions** | Time-series Forecasting | Predict month-end spend based on patterns, seasonality, and velocity |
| **Anomaly Detection** | Outlier Detection ML | Identify unusual transactions (₹5,000 at new merchant vs typical ₹200) |
| **Budget Recommendations** | Recommendation Engine | "Skip 3 dining-out meals to save ₹900" requires understanding spending patterns |
| **Finance Score Calculation** | Multi-factor ML Model | Weighing 10+ factors (savings rate, bill timing, budget adherence) into one score |
| **Smart Insights Generation** | NLG + Pattern Analysis | "You spend 40% more on weekends" - finding non-obvious patterns |
| **Merchant Name Normalization** | NLP/Fuzzy Matching | "SWIGGY*ORDER123" "Swiggy Indiranagar" "SWIGGYINDIA" → "Swiggy" |
| **Duplicate Transaction Detection** | ML Clustering | Same amount ± timing = duplicate? Needs learning from user confirmations |
| **Bill Due Date Prediction** | Pattern Recognition | Learning when recurring bills actually hit based on history |
| **Personalized Tips** | Content Recommendation | Show relevant tips based on user's actual spending behavior |
| **Peer Comparison Benchmarks** | Statistical ML | Anonymized comparison with similar income/age cohorts |
| **Savings Challenge Suggestions** | Personalization ML | Suggest achievable challenges based on past behavior |
| **Investment Recommendations** | Risk-profile ML | Match user behavior to suitable investment products |

---

### ⚙️ Features That DON'T Need AI

| Feature | Implementation | Why AI is Overkill |
|---------|----------------|-------------------|
| **Budget Progress Tracking** | Simple math (spent ÷ budget) | Just percentage calculation |
| **Daily Allowance Calculation** | (Remaining budget ÷ days left) | Pure arithmetic |
| **Transaction Display/List** | Database query + UI | Standard CRUD operations |
| **Account Balance Aggregation** | Sum of linked accounts | Simple addition |
| **Manual Transaction Entry** | Form input + validation | User provides all data |
| **Category Selection (manual)** | Dropdown/picker | User selects |
| **Recurring Deposit Tracking** | Date-based reminders | Calendar math |
| **Bill Reminder Notifications** | Scheduled notifications | Fixed date logic |
| **Spending Limits Enforcement** | Threshold comparison | If (spent > limit) alert |
| **50/30/20 Bucket Allocation** | Percentage splits | Fixed formula |
| **Weekly Allowance Division** | Monthly ÷ 4.33 | Simple division |
| **Savings Goal Progress** | (Saved ÷ goal × 100) | Percentage |
| **Transaction Filtering/Search** | SQL WHERE clauses | Database filtering |
| **Export to CSV/PDF** | Data formatting | Template-based export |
| **Settings/Preferences** | Key-value storage | Simple persistence |
| **Rollover Budget Calculation** | Previous unused + new budget | Addition |
| **NCB Tracker (Insurance)** | Years without claim counter | Increment logic |
| **Coverage Gap Detection** | Checklist of policy types | Boolean checks |
| **Streak Tracking (Savings)** | Consecutive days counter | Date comparison |
| **Achievement Unlocking** | Condition checking | If-then rules |
| **Dark Mode Toggle** | Theme switching | UI state |
| **Biometric Authentication** | Platform APIs | OS-level services |
| **QR Code Generation (Split)** | Data encoding | Standard library |
| **Chart Rendering** | fl_chart package | Visualization library |
| **Haptic Feedback** | Platform vibration API | System call |

---

### 🔀 Hybrid Features (AI-Enhanced but Works Without)

| Feature | Base Logic | AI Enhancement |
|---------|------------|----------------|
| **Categorization** | Manual selection works | AI auto-suggests, user confirms |
| **Bill Reminders** | Fixed date reminders work | AI predicts actual debit date ±2 days |
| **Budget Suggestions** | User sets manually | AI suggests based on past spending |
| **Subscription Detection** | User adds manually | AI detects from transaction patterns |
| **Merchant Icons** | Default category icons | AI matches merchant logos |
| **Transaction Descriptions** | Raw bank narrative | AI cleans up readability |
| **Savings Goals** | User creates with target | AI suggests realistic amounts |
| **Challenge Difficulty** | Fixed challenge templates | AI adjusts based on user capacity |

---

### 🛠️ AI Implementation Strategy

#### On-Device AI (TensorFlow Lite) - Privacy First
```
Used for:
├── Transaction categorization model
├── SMS parsing model
├── Merchant normalization
└── Basic pattern detection

Benefits:
• Zero data leaves device
• Works offline
• Fast inference (~50ms)
• Smaller model size (< 10MB)
```

#### Server-Side AI (Optional, Opt-in)
```
Used for:
├── Complex insights generation
├── Peer comparison benchmarks
├── Investment recommendations
└── Model updates & improvements

Benefits:
• More powerful models
• Continuous learning
• Cross-user patterns
• Requires explicit consent
```

---

### 📊 AI Model Inventory

| Model | Type | Size | Location | Update Frequency |
|-------|------|------|----------|------------------|
| SMS Parser | BERT-tiny NER | ~5MB | On-device | Quarterly |
| Categorizer | Multi-class Classifier | ~3MB | On-device | Monthly |
| Merchant Normalizer | Embedding + Fuzzy | ~2MB | On-device | Monthly |
| Anomaly Detector | Isolation Forest | ~1MB | On-device | Monthly |
| Spending Predictor | LSTM Time-series | ~4MB | On-device | Weekly (personalized) |
| Insights Generator | Template + Rule-based | N/A | On-device | Static |
| Finance Score | Gradient Boosting | ~2MB | On-device | Bi-weekly |

---

### ⚠️ AI Fallback Behavior

When AI fails or confidence is low:

| Scenario | Fallback Behavior |
|----------|-------------------|
| Can't parse SMS | Show raw message, ask user to categorize |
| Low categorization confidence (<70%) | Show top 3 suggestions, user picks |
| Merchant not recognized | Use category default icon |
| Prediction unavailable | Show "Not enough data yet" message |
| Insights can't be generated | Show basic stats (totals, averages) |
| Anomaly uncertain | Queue for user review, don't auto-flag |

---

### 🎯 AI ROI Per Feature

**High ROI (Must Have):**
- SMS Parsing → Core functionality, saves 100% manual entry
- Auto-categorization → 95% accuracy saves 10+ taps per transaction
- Merchant normalization → Clean, searchable transaction history

**Medium ROI (Nice to Have):**
- Spending predictions → Helps planning but not critical
- Smart insights → Engagement driver, not core
- Personalized tips → Value-add, works without

**Low ROI (Skip for MVP):**
- Peer comparison → Complex infra, privacy concerns
- Investment recommendations → Regulatory complexity
- Voice transaction entry → Edge case usage

---

### 🚫 Where NOT to Use AI

| Feature | Why Skip AI |
|---------|-------------|
| Settings screens | No learning needed |
| Profile management | User provides info |
| Help/FAQ | Static content |
| Privacy controls | Must be predictable |
| Data export | Template-based |
| Theme/appearance | User preference |
| Notification preferences | User controls |
| Account linking flow | API-driven |
| Onboarding screens | Sequential flow |
| Authentication | Security standards |

---

### Implementation Priority

#### : Core AI (Launch Critical)
- [ ] SMS transaction parser
- [ ] Basic auto-categorizer (80% accuracy)
- [ ] Merchant name normalization

#### : Enhanced AI (Post-Launch)
- [ ] Improved categorizer (95% accuracy)
- [ ] Anomaly detection
- [ ] Basic spending predictions

#### : Smart AI (Growth Phase)
- [ ] Personalized insights engine
- [ ] Finance score model
- [ ] Budget recommendations

#### : Advanced AI (Scale Phase)
- [ ] Peer comparison system
- [ ] Investment suggestions
- [ ] Continuous model improvement

---

## ✅ Implementation Checklist

### : Foundation
- [ ] Project setup with Flutter 3.x
- [ ] Theme system implementation
- [ ] Core components library
- [ ] Navigation/routing setup
- [ ] State management setup (Riverpod)

### : Authentication
- [ ] Splash screen with animation
- [ ] Onboarding flow (4-5 screens)
- [ ] Phone OTP authentication
- [ ] Biometric setup

### : Core Features
- [ ] Dashboard home screen
- [ ] Transaction list & detail
- [ ] Manual transaction entry
- [ ] Basic categorization

### : Financial Features
- [ ] Budget management
- [ ] Spending analytics
- [ ] Account linking UI
- [ ] Split bills feature

### : AI & Education
- [ ] AI insights integration
- [ ] Financial tips screen
- [ ] Gamification (Finance Score)
- [ ] Achievements system

### : Polish
- [ ] All animations refined
- [ ] Haptic feedback
- [ ] Dark/light mode
- [ ] Performance optimization
- [ ] Accessibility

---

## 🎯 Success Criteria

The mobile app is successful if:

1. **First Open**: User feels "this is a premium app" within 5 seconds
2. **Usability**: Common tasks (check balance, add expense) take < 3 taps
3. **Engagement**: Daily active use for expense tracking
4. **Trust**: Users feel safe linking their bank accounts
5. **Delight**: Micro-animations create moments of joy
6. **Performance**: 60fps at all times, < 2s cold start

---

*Build an app that students will actually WANT to use, not just need to use.* 📱✨
