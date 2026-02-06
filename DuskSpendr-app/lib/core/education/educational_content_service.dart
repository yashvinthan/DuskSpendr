import '../../domain/entities/entities.dart';

/// SS-094: Educational Content Repository
/// Provides structured financial lessons for students

class EducationalContentService {
  /// Get all available topics
  List<FinancialTopic> getAllTopics() => FinancialTopic.values;

  /// Get lessons for a specific topic
  List<EducationalLesson> getLessonsForTopic(FinancialTopic topic) {
    switch (topic) {
      case FinancialTopic.spending:
        return _spendingLessons;
      case FinancialTopic.saving:
        return _savingLessons;
      case FinancialTopic.budgeting:
        return _budgetingLessons;
      case FinancialTopic.credit:
        return _creditLessons;
      case FinancialTopic.investing:
        return _investingLessons;
      case FinancialTopic.banking:
        return _bankingLessons;
      case FinancialTopic.goals:
        return _goalsLessons;
    }
  }

  /// Get a specific lesson by ID
  EducationalLesson? getLesson(String id) {
    for (final topic in FinancialTopic.values) {
      final lessons = getLessonsForTopic(topic);
      final lesson = lessons.where((l) => l.id == id).firstOrNull;
      if (lesson != null) return lesson;
    }
    return null;
  }

  /// Get next recommended lesson based on completed ones
  EducationalLesson? getNextRecommendedLesson(Set<String> completedIds) {
    // Recommend in order of importance
    const topicOrder = [
      FinancialTopic.budgeting,
      FinancialTopic.spending,
      FinancialTopic.saving,
      FinancialTopic.banking,
      FinancialTopic.credit,
      FinancialTopic.investing,
      FinancialTopic.goals,
    ];

    for (final topic in topicOrder) {
      final lessons = getLessonsForTopic(topic);
      for (final lesson in lessons) {
        if (!completedIds.contains(lesson.id)) {
          return lesson;
        }
      }
    }
    return null;
  }

  // ====== Spending Lessons ======
  static final _spendingLessons = [
    const EducationalLesson(
      id: 'spending_tracking',
      topic: FinancialTopic.spending,
      title: 'Track Every Rupee',
      subtitle: 'The foundation of financial awareness',
      durationMinutes: 5,
      sections: [
        LessonSection(
          type: LessonSectionType.hook,
          title: 'Where Does Your Money Go?',
          content:
              'Studies show that people underestimate their spending by 30-40%. '
              'The average student has no idea where ₹5000+ goes each month!',
        ),
        LessonSection(
          type: LessonSectionType.concept,
          title: 'Why Track?',
          content: 'Tracking spending helps you:\n'
              '• Identify unnecessary expenses\n'
              '• Spot patterns (weekend splurges, late-night shopping)\n'
              '• Make informed decisions about your money',
        ),
        LessonSection(
          type: LessonSectionType.example,
          title: 'Real Student Story',
          content:
              'Priya tracked her spending for a month and discovered she spent ₹3000 '
              'on "small" chai and snacks. That\'s ₹36,000 a year - enough for a laptop!',
        ),
        LessonSection(
          type: LessonSectionType.interactive,
          title: 'Quick Challenge',
          content:
              'Can you recall all your purchases from yesterday? '
              'Most people forget 40% of their transactions within a week.',
        ),
        LessonSection(
          type: LessonSectionType.takeaway,
          title: 'Key Takeaway',
          content:
              'Track every purchase for just 7 days. You\'ll be surprised what you discover!',
        ),
      ],
      quiz: [
        QuizQuestion(
          question: 'How much do people typically underestimate their spending?',
          options: ['10-15%', '20-25%', '30-40%', '50-60%'],
          correctIndex: 2,
          explanation:
              'Studies consistently show people underestimate spending by 30-40%.',
        ),
        QuizQuestion(
          question: 'What\'s the first step to financial control?',
          options: [
            'Invest in stocks',
            'Track every expense',
            'Get a credit card',
            'Open multiple bank accounts'
          ],
          correctIndex: 1,
          explanation:
              'You can\'t control what you don\'t measure. Tracking is step one.',
        ),
      ],
    ),
    const EducationalLesson(
      id: 'spending_wants_needs',
      topic: FinancialTopic.spending,
      title: 'Wants vs Needs',
      subtitle: 'Learn to tell the difference',
      durationMinutes: 4,
      sections: [
        LessonSection(
          type: LessonSectionType.hook,
          title: 'That "I Need It!" Feeling',
          content:
              'Our brains are wired to make wants feel like needs. '
              'Marketers spend billions exploiting this!',
        ),
        LessonSection(
          type: LessonSectionType.concept,
          title: 'The Difference',
          content: 'NEEDS: Essentials for survival and basic functioning\n'
              '- Food, shelter, transportation, basic clothing\n\n'
              'WANTS: Nice to have but not essential\n'
              '- Latest phone, eating out, entertainment',
        ),
        LessonSection(
          type: LessonSectionType.example,
          title: 'The "Need" Test',
          content: 'Ask yourself:\n'
              '"What happens if I don\'t buy this for a week?"\n\n'
              'If the answer is "nothing much," it\'s a want.',
        ),
        LessonSection(
          type: LessonSectionType.takeaway,
          title: 'Key Takeaway',
          content:
              'Before any purchase over ₹500, wait 24 hours and ask: "Is this a need or want?"',
        ),
      ],
    ),
  ];

  // ====== Saving Lessons ======
  static final _savingLessons = [
    const EducationalLesson(
      id: 'saving_basics',
      topic: FinancialTopic.saving,
      title: 'Saving Made Simple',
      subtitle: 'Start with just ₹100',
      durationMinutes: 5,
      sections: [
        LessonSection(
          type: LessonSectionType.hook,
          title: 'Small Amounts, Big Impact',
          content:
              '₹100 per week = ₹5,200 per year\n'
              '₹100 per day = ₹36,500 per year\n\n'
              'Small, consistent savings beat occasional large ones!',
        ),
        LessonSection(
          type: LessonSectionType.concept,
          title: 'Pay Yourself First',
          content:
              'The secret of wealthy people: save BEFORE you spend, not after.\n\n'
              'When you get money → Save first → Spend what\'s left',
        ),
        LessonSection(
          type: LessonSectionType.interactive,
          title: 'Find Your Saving Amount',
          content:
              'What could you give up to save ₹50/day?\n'
              '• Skip one coffee shop drink\n'
              '• Cook one meal at home\n'
              '• Avoid one impulse purchase',
        ),
        LessonSection(
          type: LessonSectionType.takeaway,
          title: 'Key Takeaway',
          content:
              'Start with any amount you can. Consistency matters more than amount!',
        ),
      ],
      quiz: [
        QuizQuestion(
          question: 'What does "Pay Yourself First" mean?',
          options: [
            'Buy things you want before bills',
            'Save before spending',
            'Invest everything you earn',
            'Spend on self-care first'
          ],
          correctIndex: 1,
          explanation:
              '"Pay Yourself First" means saving before spending on anything else.',
        ),
      ],
    ),
    const EducationalLesson(
      id: 'saving_emergency_fund',
      topic: FinancialTopic.saving,
      title: 'Emergency Fund',
      subtitle: 'Your financial safety net',
      durationMinutes: 5,
      sections: [
        LessonSection(
          type: LessonSectionType.hook,
          title: 'When Life Happens',
          content:
              'Phone breaks. Medical emergency. Unexpected travel. '
              'Without savings, you\'re one emergency away from debt.',
        ),
        LessonSection(
          type: LessonSectionType.concept,
          title: 'How Much to Save',
          content:
              'Goal: 3-6 months of essential expenses\n\n'
              'For students:\n'
              '• Start with ₹10,000 mini emergency fund\n'
              '• Build to ₹25,000-50,000 over time',
        ),
        LessonSection(
          type: LessonSectionType.example,
          title: 'Real Impact',
          content:
              'Raj had ₹15,000 saved when his laptop died before exams. '
              'He bought a used one and didn\'t miss any deadlines or take a loan.',
        ),
        LessonSection(
          type: LessonSectionType.takeaway,
          title: 'Key Takeaway',
          content:
              'Start building your emergency fund today. Even ₹500 is a great start!',
        ),
      ],
    ),
  ];

  // ====== Budgeting Lessons ======
  static final _budgetingLessons = [
    const EducationalLesson(
      id: 'budgeting_basics',
      topic: FinancialTopic.budgeting,
      title: 'Budgeting 101',
      subtitle: 'Take control of your money',
      durationMinutes: 6,
      sections: [
        LessonSection(
          type: LessonSectionType.hook,
          title: 'What\'s a Budget?',
          content:
              'A budget isn\'t a restriction - it\'s a plan for your money. '
              'It tells your money where to go instead of wondering where it went!',
        ),
        LessonSection(
          type: LessonSectionType.concept,
          title: 'The 50/30/20 Rule',
          content:
              '50% → Needs (rent, food, transport)\n'
              '30% → Wants (entertainment, dining out)\n'
              '20% → Savings & debt repayment\n\n'
              'This simple rule works for most students!',
        ),
        LessonSection(
          type: LessonSectionType.example,
          title: 'Monthly Budget Example',
          content:
              'Monthly allowance: ₹15,000\n\n'
              'Needs (50%): ₹7,500\n'
              '- Food: ₹4,000\n'
              '- Transport: ₹1,500\n'
              '- Phone/internet: ₹1,000\n'
              '- Essentials: ₹1,000\n\n'
              'Wants (30%): ₹4,500\n'
              '- Entertainment: ₹2,000\n'
              '- Dining out: ₹1,500\n'
              '- Shopping: ₹1,000\n\n'
              'Savings (20%): ₹3,000',
        ),
        LessonSection(
          type: LessonSectionType.interactive,
          title: 'Try It',
          content:
              'What\'s your monthly income/allowance?\n'
              'Calculate: 50% + 30% + 20%\n'
              'Does your current spending match?',
        ),
        LessonSection(
          type: LessonSectionType.takeaway,
          title: 'Key Takeaway',
          content:
              'Start with the 50/30/20 rule and adjust based on your needs.',
        ),
      ],
      quiz: [
        QuizQuestion(
          question: 'In the 50/30/20 rule, what percentage goes to savings?',
          options: ['50%', '30%', '20%', '10%'],
          correctIndex: 2,
          explanation: 'The 50/30/20 rule allocates 20% to savings and debt payments.',
        ),
        QuizQuestion(
          question: 'Which category falls under "Needs"?',
          options: [
            'Movie tickets',
            'Restaurant dinner',
            'Phone recharge',
            'New shoes for fashion'
          ],
          correctIndex: 2,
          explanation:
              'Phone recharge is a need. Others are wants (unless for specific needs).',
        ),
      ],
    ),
    const EducationalLesson(
      id: 'budgeting_envelope',
      topic: FinancialTopic.budgeting,
      title: 'Envelope Method',
      subtitle: 'Digital envelopes for spending control',
      durationMinutes: 4,
      sections: [
        LessonSection(
          type: LessonSectionType.hook,
          title: 'The Cash Envelope Trick',
          content:
              'Before UPI, people put cash in labeled envelopes. '
              'When the envelope was empty, spending stopped. Simple but effective!',
        ),
        LessonSection(
          type: LessonSectionType.concept,
          title: 'Digital Envelopes',
          content:
              'Create virtual "envelopes" (budgets) for each category:\n'
              '• Food: ₹4,000\n'
              '• Entertainment: ₹2,000\n'
              '• Shopping: ₹1,500\n\n'
              'Track spending against each envelope.',
        ),
        LessonSection(
          type: LessonSectionType.takeaway,
          title: 'Key Takeaway',
          content: 'Set up category budgets in the app. When one runs out, you stop or transfer!',
        ),
      ],
    ),
  ];

  // ====== Credit Lessons ======
  static final _creditLessons = [
    const EducationalLesson(
      id: 'credit_basics',
      topic: FinancialTopic.credit,
      title: 'Credit Score Basics',
      subtitle: 'Why your score matters',
      durationMinutes: 6,
      sections: [
        LessonSection(
          type: LessonSectionType.hook,
          title: 'Your Financial Reputation',
          content:
              'Your credit score is like a report card for your finances. '
              'It affects loan approvals, interest rates, and even job applications!',
        ),
        LessonSection(
          type: LessonSectionType.concept,
          title: 'Score Ranges (CIBIL)',
          content:
              '750-900: Excellent - Best rates, instant approval\n'
              '650-749: Good - Most loans approved\n'
              '550-649: Fair - Higher rates, more scrutiny\n'
              'Below 550: Poor - Difficulty getting credit',
        ),
        LessonSection(
          type: LessonSectionType.concept,
          title: 'What Affects Your Score',
          content:
              '35% - Payment History (pay on time!)\n'
              '30% - Credit Utilization (use less than 30%)\n'
              '15% - Length of credit history\n'
              '10% - Types of credit\n'
              '10% - New credit inquiries',
        ),
        LessonSection(
          type: LessonSectionType.example,
          title: 'Real Impact',
          content:
              'Good score (750): Home loan at 8.5%\n'
              'Poor score (600): Home loan at 11%\n\n'
              'On a ₹50 lakh loan, that\'s ₹20+ lakhs extra over 20 years!',
        ),
        LessonSection(
          type: LessonSectionType.takeaway,
          title: 'Key Takeaway',
          content:
              'Always pay bills on time and keep credit card usage under 30%.',
        ),
      ],
      quiz: [
        QuizQuestion(
          question: 'What\'s the biggest factor affecting your credit score?',
          options: [
            'Income level',
            'Payment history',
            'Number of credit cards',
            'Bank balance'
          ],
          correctIndex: 1,
          explanation:
              'Payment history accounts for 35% of your credit score - always pay on time!',
        ),
      ],
    ),
  ];

  // ====== Investing Lessons ======
  static final _investingLessons = [
    const EducationalLesson(
      id: 'investing_compound',
      topic: FinancialTopic.investing,
      title: 'Compound Interest Magic',
      subtitle: 'How money grows money',
      durationMinutes: 5,
      sections: [
        LessonSection(
          type: LessonSectionType.hook,
          title: 'The Eighth Wonder',
          content:
              'Einstein called compound interest "the eighth wonder of the world." '
              'Those who understand it earn it. Those who don\'t pay it!',
        ),
        LessonSection(
          type: LessonSectionType.concept,
          title: 'How It Works',
          content:
              'Year 1: ₹10,000 + 10% = ₹11,000\n'
              'Year 2: ₹11,000 + 10% = ₹12,100\n'
              'Year 3: ₹12,100 + 10% = ₹13,310\n\n'
              'You earn interest on your interest!',
        ),
        LessonSection(
          type: LessonSectionType.example,
          title: 'The Power of Time',
          content:
              'Starting at 20 vs 30 with ₹5,000/month:\n\n'
              'Start at 20: ₹2.35 Cr by age 60\n'
              'Start at 30: ₹95 Lakhs by age 60\n\n'
              '10 years delay = ₹1.4 Cr less!',
        ),
        LessonSection(
          type: LessonSectionType.takeaway,
          title: 'Key Takeaway',
          content:
              'Start investing early, even small amounts. Time is your biggest advantage!',
        ),
      ],
      quiz: [
        QuizQuestion(
          question: 'What makes compound interest special?',
          options: [
            'Higher interest rate',
            'You earn interest on interest',
            'Principal grows faster',
            'Banks pay more'
          ],
          correctIndex: 1,
          explanation:
              'Compound interest means you earn interest on both principal and previous interest.',
        ),
      ],
    ),
  ];

  // ====== Banking Lessons ======
  static final _bankingLessons = [
    const EducationalLesson(
      id: 'banking_account_types',
      topic: FinancialTopic.banking,
      title: 'Bank Account Basics',
      subtitle: 'Which account for what purpose',
      durationMinutes: 4,
      sections: [
        LessonSection(
          type: LessonSectionType.hook,
          title: 'Not All Accounts Are Equal',
          content:
              'Using a savings account for daily expenses? You might be losing money and control!',
        ),
        LessonSection(
          type: LessonSectionType.concept,
          title: 'Account Types',
          content:
              'Savings Account:\n'
              '• For keeping savings\n'
              '• Earns 2.5-4% interest\n'
              '• Limited transactions\n\n'
              'Current Account:\n'
              '• For businesses (not students)\n'
              '• No interest\n'
              '• Unlimited transactions',
        ),
        LessonSection(
          type: LessonSectionType.example,
          title: 'Smart Account Strategy',
          content:
              'Account 1: Daily Expenses\n'
              '- Keep only what you need for the week\n\n'
              'Account 2: Savings\n'
              '- Emergency fund & goals\n'
              '- Don\'t touch for daily spending!',
        ),
        LessonSection(
          type: LessonSectionType.takeaway,
          title: 'Key Takeaway',
          content: 'Separate spending and savings into different accounts for better control.',
        ),
      ],
    ),
  ];

  // ====== Goals Lessons ======
  static final _goalsLessons = [
    const EducationalLesson(
      id: 'goals_smart',
      topic: FinancialTopic.goals,
      title: 'Setting SMART Goals',
      subtitle: 'Turn dreams into achievable targets',
      durationMinutes: 5,
      sections: [
        LessonSection(
          type: LessonSectionType.hook,
          title: 'Goals Without Plans Are Dreams',
          content:
              '"I want to save money" is a wish.\n'
              '"I will save ₹10,000 by December for a laptop" is a goal!',
        ),
        LessonSection(
          type: LessonSectionType.concept,
          title: 'SMART Framework',
          content:
              'S - Specific: What exactly?\n'
              'M - Measurable: How much?\n'
              'A - Achievable: Realistic?\n'
              'R - Relevant: Why does it matter?\n'
              'T - Time-bound: By when?',
        ),
        LessonSection(
          type: LessonSectionType.example,
          title: 'Example Goal',
          content:
              'Vague: "Save for a trip"\n\n'
              'SMART: "Save ₹25,000 for a Goa trip in March by saving ₹2,500/month for 10 months"',
        ),
        LessonSection(
          type: LessonSectionType.takeaway,
          title: 'Key Takeaway',
          content: 'Make every financial goal SMART for better success rates!',
        ),
      ],
      quiz: [
        QuizQuestion(
          question: 'What does the "T" in SMART goals stand for?',
          options: ['Trackable', 'Time-bound', 'Tangible', 'Transparent'],
          correctIndex: 1,
          explanation:
              'T stands for Time-bound - goals need deadlines to be actionable.',
        ),
      ],
    ),
  ];
}
