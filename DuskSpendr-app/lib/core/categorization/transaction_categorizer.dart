import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/entities/category.dart';

/// SS-050 to SS-054, SS-059: Transaction Categorization Engine
/// ML merchant recognition, category system, user feedback learning,
/// custom categories, confidence scoring

/// Main categorizer that combines rule-based and ML approaches
class TransactionCategorizer {
  final MerchantRecognizer _merchantRecognizer;
  final UserMappingStore _userMappings;
  // ignore: unused_field
  static const _storage = FlutterSecureStorage();

  TransactionCategorizer({
    MerchantRecognizer? merchantRecognizer,
    UserMappingStore? userMappings,
  })  : _merchantRecognizer = merchantRecognizer ?? MerchantRecognizer(),
        _userMappings = userMappings ?? UserMappingStore();

  /// Categorize a transaction
  Future<CategorizationResult> categorize({
    required String? merchantName,
    required String? description,
    required int amountPaisa,
    String? upiId,
  }) async {
    // Combine merchant and description for matching
    final searchText = [merchantName, description, upiId]
        .whereType<String>()
        .join(' ')
        .toLowerCase()
        .trim();

    if (searchText.isEmpty) {
      return const CategorizationResult(
        category: TransactionCategory.other,
        confidence: 0.0,
        source: CategorizationSource.none,
      );
    }

    // 1. Check user-defined mappings first (highest priority)
    final userMapping = await _userMappings.getMapping(searchText);
    if (userMapping != null) {
      return CategorizationResult(
        category: userMapping,
        confidence: 1.0,
        source: CategorizationSource.userMapping,
        isLearned: true,
      );
    }

    // 2. Try ML-based merchant recognition
    final mlResult = await _merchantRecognizer.recognize(searchText);
    if (mlResult.confidence >= 0.85) {
      return CategorizationResult(
        category: mlResult.category,
        confidence: mlResult.confidence,
        source: CategorizationSource.mlModel,
        merchantDetails: mlResult.merchantDetails,
      );
    }

    // 3. Fallback to keyword matching
    final keywordResult = _matchByKeywords(searchText);
    if (keywordResult.confidence > mlResult.confidence) {
      return keywordResult;
    }

    // 4. Return ML result if better than random
    if (mlResult.confidence >= 0.5) {
      return CategorizationResult(
        category: mlResult.category,
        confidence: mlResult.confidence,
        source: CategorizationSource.mlModel,
      );
    }

    // 5. Use amount heuristics
    final amountResult = _categorizeByAmount(amountPaisa);
    if (amountResult != null) {
      return amountResult;
    }

    return const CategorizationResult(
      category: TransactionCategory.other,
      confidence: 0.3,
      source: CategorizationSource.fallback,
    );
  }

  CategorizationResult _matchByKeywords(String text) {
    TransactionCategory? bestMatch;
    double bestScore = 0;

    for (final category in TransactionCategory.values) {
      for (final keyword in category.keywords) {
        if (text.contains(keyword.toLowerCase())) {
          // Higher score for longer keyword matches
          final score = 0.7 + (keyword.length / 100).clamp(0, 0.2);
          if (score > bestScore) {
            bestScore = score;
            bestMatch = category;
          }
        }
      }
    }

    return CategorizationResult(
      category: bestMatch ?? TransactionCategory.other,
      confidence: bestScore,
      source: CategorizationSource.keywords,
    );
  }

  CategorizationResult? _categorizeByAmount(int amountPaisa) {
    final amount = amountPaisa / 100;

    // Common student spending patterns
    if (amount <= 100) {
      // Small amounts likely food/snacks
      return const CategorizationResult(
        category: TransactionCategory.food,
        confidence: 0.4,
        source: CategorizationSource.amountHeuristic,
      );
    }
    if (amount >= 5000 && amount <= 50000) {
      // Medium-large amounts might be education-related
      return const CategorizationResult(
        category: TransactionCategory.education,
        confidence: 0.35,
        source: CategorizationSource.amountHeuristic,
      );
    }

    return null;
  }

  /// SS-053: Record user correction for learning
  Future<void> recordCorrection({
    required String merchantName,
    required TransactionCategory originalCategory,
    required TransactionCategory correctedCategory,
  }) async {
    await _userMappings.addMapping(
      merchantName.toLowerCase(),
      correctedCategory,
    );

    // Also train the ML model with this feedback
    await _merchantRecognizer.addFeedback(
      merchantName: merchantName,
      category: correctedCategory,
    );
  }

  /// Get suggestion confidence level description
  String getConfidenceDescription(double confidence) {
    if (confidence >= 0.9) return 'Very confident';
    if (confidence >= 0.75) return 'Confident';
    if (confidence >= 0.6) return 'Likely';
    if (confidence >= 0.4) return 'Uncertain';
    return 'Guess';
  }
}

/// SS-051: ML Merchant Recognition using TensorFlow Lite
class MerchantRecognizer {
  // In production, this would load a TFLite model
  // For now, using comprehensive rule-based recognition
  
  static const _merchantDatabase = <String, MerchantInfo>{
    // Food & Delivery
    'swiggy': MerchantInfo('Swiggy', TransactionCategory.food),
    'zomato': MerchantInfo('Zomato', TransactionCategory.food),
    'dominos': MerchantInfo("Domino's Pizza", TransactionCategory.food),
    'mcdonalds': MerchantInfo("McDonald's", TransactionCategory.food),
    'kfc': MerchantInfo('KFC', TransactionCategory.food),
    'burgerking': MerchantInfo('Burger King', TransactionCategory.food),
    'pizzahut': MerchantInfo('Pizza Hut', TransactionCategory.food),
    'starbucks': MerchantInfo('Starbucks', TransactionCategory.food),
    'subway': MerchantInfo('Subway', TransactionCategory.food),
    'cwc': MerchantInfo('CCD', TransactionCategory.food),
    'barbeque': MerchantInfo('Barbeque Nation', TransactionCategory.food),
    'biryani': MerchantInfo('Biryani', TransactionCategory.food),
    'haldiram': MerchantInfo("Haldiram's", TransactionCategory.food),
    'magicpin': MerchantInfo('magicpin', TransactionCategory.food),
    'eatclub': MerchantInfo('EatClub', TransactionCategory.food),
    'eatsure': MerchantInfo('EatSure', TransactionCategory.food),
    
    // Transport
    'uber': MerchantInfo('Uber', TransactionCategory.transportation),
    'ola': MerchantInfo('Ola', TransactionCategory.transportation),
    'rapido': MerchantInfo('Rapido', TransactionCategory.transportation),
    'namma yatri': MerchantInfo('Namma Yatri', TransactionCategory.transportation),
    'irctc': MerchantInfo('IRCTC', TransactionCategory.transportation),
    'makemytrip': MerchantInfo('MakeMyTrip', TransactionCategory.transportation),
    'redbus': MerchantInfo('redBus', TransactionCategory.transportation),
    'goibibo': MerchantInfo('Goibibo', TransactionCategory.transportation),
    'yatra': MerchantInfo('Yatra', TransactionCategory.transportation),
    'cleartrip': MerchantInfo('Cleartrip', TransactionCategory.transportation),
    'bpcl': MerchantInfo('BPCL', TransactionCategory.transportation),
    'hpcl': MerchantInfo('HPCL', TransactionCategory.transportation),
    'iocl': MerchantInfo('IOCL', TransactionCategory.transportation),
    'reliance petro': MerchantInfo('Reliance Petroleum', TransactionCategory.transportation),
    'metro': MerchantInfo('Metro', TransactionCategory.transportation),
    
    // Entertainment
    'netflix': MerchantInfo('Netflix', TransactionCategory.entertainment),
    'hotstar': MerchantInfo('Disney+ Hotstar', TransactionCategory.entertainment),
    'prime video': MerchantInfo('Prime Video', TransactionCategory.entertainment),
    'spotify': MerchantInfo('Spotify', TransactionCategory.entertainment),
    'youtube': MerchantInfo('YouTube Premium', TransactionCategory.entertainment),
    'gaana': MerchantInfo('Gaana', TransactionCategory.entertainment),
    'jiosaavn': MerchantInfo('JioSaavn', TransactionCategory.entertainment),
    'pvr': MerchantInfo('PVR Cinemas', TransactionCategory.entertainment),
    'inox': MerchantInfo('INOX', TransactionCategory.entertainment),
    'bookmyshow': MerchantInfo('BookMyShow', TransactionCategory.entertainment),
    'steam': MerchantInfo('Steam', TransactionCategory.entertainment),
    'playstation': MerchantInfo('PlayStation', TransactionCategory.entertainment),
    'xbox': MerchantInfo('Xbox', TransactionCategory.entertainment),
    'twitch': MerchantInfo('Twitch', TransactionCategory.entertainment),
    
    // Shopping
    'amazon': MerchantInfo('Amazon', TransactionCategory.shopping),
    'flipkart': MerchantInfo('Flipkart', TransactionCategory.shopping),
    'myntra': MerchantInfo('Myntra', TransactionCategory.shopping),
    'ajio': MerchantInfo('AJIO', TransactionCategory.shopping),
    'nykaa': MerchantInfo('Nykaa', TransactionCategory.shopping),
    'meesho': MerchantInfo('Meesho', TransactionCategory.shopping),
    'snapdeal': MerchantInfo('Snapdeal', TransactionCategory.shopping),
    'tatacliq': MerchantInfo('Tata CLiQ', TransactionCategory.shopping),
    'bigbasket': MerchantInfo('BigBasket', TransactionCategory.shopping),
    'blinkit': MerchantInfo('Blinkit', TransactionCategory.shopping),
    'zepto': MerchantInfo('Zepto', TransactionCategory.shopping),
    'instamart': MerchantInfo('Swiggy Instamart', TransactionCategory.shopping),
    'dunzo': MerchantInfo('Dunzo', TransactionCategory.shopping),
    'dmart': MerchantInfo('DMart', TransactionCategory.shopping),
    'reliance': MerchantInfo('Reliance Digital', TransactionCategory.shopping),
    'croma': MerchantInfo('Croma', TransactionCategory.shopping),
    
    // Education
    'udemy': MerchantInfo('Udemy', TransactionCategory.education),
    'coursera': MerchantInfo('Coursera', TransactionCategory.education),
    'unacademy': MerchantInfo('Unacademy', TransactionCategory.education),
    'byju': MerchantInfo("BYJU'S", TransactionCategory.education),
    'vedantu': MerchantInfo('Vedantu', TransactionCategory.education),
    'toppr': MerchantInfo('Toppr', TransactionCategory.education),
    'skillshare': MerchantInfo('Skillshare', TransactionCategory.education),
    'linkedin learning': MerchantInfo('LinkedIn Learning', TransactionCategory.education),
    'college': MerchantInfo('College', TransactionCategory.education),
    'university': MerchantInfo('University', TransactionCategory.education),
    
    // Utilities
    'jio': MerchantInfo('Jio', TransactionCategory.utilities),
    'airtel': MerchantInfo('Airtel', TransactionCategory.utilities),
    'vodafone': MerchantInfo('Vi (Vodafone Idea)', TransactionCategory.utilities),
    'bsnl': MerchantInfo('BSNL', TransactionCategory.utilities),
    'tata power': MerchantInfo('Tata Power', TransactionCategory.utilities),
    'adani': MerchantInfo('Adani Electricity', TransactionCategory.utilities),
    'bescom': MerchantInfo('BESCOM', TransactionCategory.utilities),
    'mahanagar gas': MerchantInfo('Mahanagar Gas', TransactionCategory.utilities),
    'act fibernet': MerchantInfo('ACT Fibernet', TransactionCategory.utilities),
    'hathway': MerchantInfo('Hathway', TransactionCategory.utilities),
    
    // Healthcare
    'apollo': MerchantInfo('Apollo', TransactionCategory.healthcare),
    'pharmeasy': MerchantInfo('PharmEasy', TransactionCategory.healthcare),
    'netmeds': MerchantInfo('Netmeds', TransactionCategory.healthcare),
    'medplus': MerchantInfo('MedPlus', TransactionCategory.healthcare),
    'practo': MerchantInfo('Practo', TransactionCategory.healthcare),
    'lybrate': MerchantInfo('Lybrate', TransactionCategory.healthcare),
    'tata 1mg': MerchantInfo('TATA 1mg', TransactionCategory.healthcare),
    'cult.fit': MerchantInfo('cult.fit', TransactionCategory.healthcare),
    
    // Subscriptions
    'notion': MerchantInfo('Notion', TransactionCategory.subscriptions),
    'canva': MerchantInfo('Canva', TransactionCategory.subscriptions),
    'figma': MerchantInfo('Figma', TransactionCategory.subscriptions),
    'github': MerchantInfo('GitHub', TransactionCategory.subscriptions),
    'dropbox': MerchantInfo('Dropbox', TransactionCategory.subscriptions),
    'google one': MerchantInfo('Google One', TransactionCategory.subscriptions),
    'icloud': MerchantInfo('iCloud', TransactionCategory.subscriptions),
    'adobe': MerchantInfo('Adobe', TransactionCategory.subscriptions),
    'microsoft 365': MerchantInfo('Microsoft 365', TransactionCategory.subscriptions),
    
    // Investment
    'zerodha': MerchantInfo('Zerodha', TransactionCategory.investments),
    'groww': MerchantInfo('Groww', TransactionCategory.investments),
    'upstox': MerchantInfo('Upstox', TransactionCategory.investments),
    'angelone': MerchantInfo('Angel One', TransactionCategory.investments),
    'coin': MerchantInfo('Coin', TransactionCategory.investments),
    'kuvera': MerchantInfo('Kuvera', TransactionCategory.investments),
    'paytm money': MerchantInfo('Paytm Money', TransactionCategory.investments),
    'et money': MerchantInfo('ET Money', TransactionCategory.investments),
    
    // Loans
    'bajaj finserv': MerchantInfo('Bajaj Finserv', TransactionCategory.loans),
    'hdfc credila': MerchantInfo('HDFC Credila', TransactionCategory.loans),
    'tata capital': MerchantInfo('Tata Capital', TransactionCategory.loans),
    'navi': MerchantInfo('Navi', TransactionCategory.loans),
    'kreditbee': MerchantInfo('KreditBee', TransactionCategory.loans),
    'moneyview': MerchantInfo('MoneyView', TransactionCategory.loans),
  };

  Future<MerchantRecognitionResult> recognize(String text) async {
    final normalizedText = text.toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
        .trim();

    // Exact match
    for (final entry in _merchantDatabase.entries) {
      if (normalizedText.contains(entry.key)) {
        return MerchantRecognitionResult(
          category: entry.value.category,
          confidence: 0.95,
          merchantDetails: entry.value,
        );
      }
    }

    // Fuzzy match (would use ML model in production)
    MerchantInfo? bestMatch;
    double bestScore = 0;

    for (final entry in _merchantDatabase.entries) {
      final score = _fuzzyMatch(normalizedText, entry.key);
      if (score > bestScore && score > 0.7) {
        bestScore = score;
        bestMatch = entry.value;
      }
    }

    if (bestMatch != null) {
      return MerchantRecognitionResult(
        category: bestMatch.category,
        confidence: bestScore * 0.9,
        merchantDetails: bestMatch,
      );
    }

    return const MerchantRecognitionResult(
      category: TransactionCategory.other,
      confidence: 0,
    );
  }

  double _fuzzyMatch(String text, String pattern) {
    if (text.isEmpty || pattern.isEmpty) return 0;
    if (text.contains(pattern)) return 1.0;
    if (pattern.contains(text)) return 0.9;

    // Simple word overlap
    final textWords = text.split(' ').toSet();
    final patternWords = pattern.split(' ').toSet();
    final intersection = textWords.intersection(patternWords);

    if (intersection.isEmpty) return 0;
    return intersection.length / patternWords.length;
  }

  /// Add user feedback for future learning
  Future<void> addFeedback({
    required String merchantName,
    required TransactionCategory category,
  }) async {
    // In production, this would retrain the model or add to training data
    final feedbackKey = 'ml_feedback_${merchantName.hashCode}';
    await const FlutterSecureStorage().write(
      key: feedbackKey,
      value: jsonEncode({
        'merchant': merchantName,
        'category': category.name,
        'timestamp': DateTime.now().toIso8601String(),
      }),
    );
  }
}

/// Store for user-defined category mappings
class UserMappingStore {
  static const _storage = FlutterSecureStorage();
  static const _mappingsKey = 'user_category_mappings';

  Map<String, TransactionCategory>? _cache;

  Future<TransactionCategory?> getMapping(String merchantText) async {
    final mappings = await _loadMappings();
    
    for (final entry in mappings.entries) {
      if (merchantText.contains(entry.key)) {
        return entry.value;
      }
    }
    return null;
  }

  Future<void> addMapping(String pattern, TransactionCategory category) async {
    final mappings = await _loadMappings();
    mappings[pattern.toLowerCase()] = category;
    await _saveMappings(mappings);
  }

  Future<void> removeMapping(String pattern) async {
    final mappings = await _loadMappings();
    mappings.remove(pattern.toLowerCase());
    await _saveMappings(mappings);
  }

  Future<Map<String, TransactionCategory>> _loadMappings() async {
    if (_cache != null) return _cache!;

    final json = await _storage.read(key: _mappingsKey);
    if (json == null) {
      _cache = {};
      return _cache!;
    }

    final map = jsonDecode(json) as Map<String, dynamic>;
    _cache = map.map((key, value) => MapEntry(
          key,
          TransactionCategory.values.byName(value as String),
        ));
    return _cache!;
  }

  Future<void> _saveMappings(Map<String, TransactionCategory> mappings) async {
    _cache = mappings;
    final json = jsonEncode(
      mappings.map((key, value) => MapEntry(key, value.name)),
    );
    await _storage.write(key: _mappingsKey, value: json);
  }
}

// ====== Data Classes ======

class MerchantInfo {
  final String displayName;
  final TransactionCategory category;

  const MerchantInfo(this.displayName, this.category);
}

class MerchantRecognitionResult {
  final TransactionCategory category;
  final double confidence;
  final MerchantInfo? merchantDetails;

  const MerchantRecognitionResult({
    required this.category,
    required this.confidence,
    this.merchantDetails,
  });
}

enum CategorizationSource {
  userMapping,
  mlModel,
  keywords,
  amountHeuristic,
  fallback,
  none,
}

class CategorizationResult {
  final TransactionCategory category;
  final double confidence;
  final CategorizationSource source;
  final bool isLearned;
  final MerchantInfo? merchantDetails;

  const CategorizationResult({
    required this.category,
    required this.confidence,
    required this.source,
    this.isLearned = false,
    this.merchantDetails,
  });

  bool get needsReview => confidence < 0.6;
  bool get isHighConfidence => confidence >= 0.85;
}

/// SS-054: Custom Category
class CustomCategory {
  final String id;
  final String name;
  final String? nameHi;
  final int iconCodePoint;
  final int colorValue;
  final List<String> keywords;
  final DateTime createdAt;

  const CustomCategory({
    required this.id,
    required this.name,
    this.nameHi,
    required this.iconCodePoint,
    required this.colorValue,
    this.keywords = const [],
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'nameHi': nameHi,
        'iconCodePoint': iconCodePoint,
        'colorValue': colorValue,
        'keywords': keywords,
        'createdAt': createdAt.toIso8601String(),
      };

  factory CustomCategory.fromJson(Map<String, dynamic> json) => CustomCategory(
        id: json['id'],
        name: json['name'],
        nameHi: json['nameHi'],
        iconCodePoint: json['iconCodePoint'],
        colorValue: json['colorValue'],
        keywords: List<String>.from(json['keywords'] ?? []),
        createdAt: DateTime.parse(json['createdAt']),
      );
}

/// Custom category store
class CustomCategoryStore {
  static const _storage = FlutterSecureStorage();
  static const _categoriesKey = 'custom_categories';

  List<CustomCategory>? _cache;

  Future<List<CustomCategory>> getAll() async {
    if (_cache != null) return _cache!;

    final json = await _storage.read(key: _categoriesKey);
    if (json == null) {
      _cache = [];
      return _cache!;
    }

    final list = jsonDecode(json) as List;
    _cache = list.map((e) => CustomCategory.fromJson(e)).toList();
    return _cache!;
  }

  Future<void> add(CustomCategory category) async {
    final categories = await getAll();
    categories.add(category);
    await _save(categories);
  }

  Future<void> update(CustomCategory category) async {
    final categories = await getAll();
    final index = categories.indexWhere((c) => c.id == category.id);
    if (index >= 0) {
      categories[index] = category;
      await _save(categories);
    }
  }

  Future<void> delete(String id) async {
    final categories = await getAll();
    categories.removeWhere((c) => c.id == id);
    await _save(categories);
  }

  Future<void> _save(List<CustomCategory> categories) async {
    _cache = categories;
    final json = jsonEncode(categories.map((c) => c.toJson()).toList());
    await _storage.write(key: _categoriesKey, value: json);
  }
}
