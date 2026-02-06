import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// SS-097: Credit Score Tracking
/// CIBIL/Experian integration, manual entry, improvement tips
class CreditScoreTracker {
  static const _storage = FlutterSecureStorage();
  static const _scoreKey = 'credit_score';
  static const _providerKey = 'credit_score_provider';
  static const _lastUpdatedKey = 'credit_score_last_updated';

  /// Get current credit score
  Future<CreditScore?> getCurrentScore() async {
    final scoreStr = await _storage.read(key: _scoreKey);
    final providerStr = await _storage.read(key: _providerKey);
    final updatedStr = await _storage.read(key: _lastUpdatedKey);

    if (scoreStr == null) return null;

    return CreditScore(
      score: int.parse(scoreStr),
      provider: providerStr != null
          ? CreditScoreProvider.values.byName(providerStr)
          : CreditScoreProvider.manual,
      lastUpdated: updatedStr != null ? DateTime.parse(updatedStr) : DateTime.now(),
    );
  }

  /// Set credit score manually
  Future<void> setManualScore(int score) async {
    await _storage.write(key: _scoreKey, value: score.toString());
    await _storage.write(
      key: _providerKey,
      value: CreditScoreProvider.manual.name,
    );
    await _storage.write(
      key: _lastUpdatedKey,
      value: DateTime.now().toIso8601String(),
    );
  }

  /// Sync from CIBIL (requires API integration)
  Future<bool> syncFromCibil({
    required String userId,
    required String password,
  }) async {
    // Integrate with CIBIL API when credentials are available
    // For now, return false (not implemented)
    return false;
  }

  /// Sync from Experian (requires API integration)
  Future<bool> syncFromExperian({
    required String apiKey,
  }) async {
    // Integrate with Experian API when credentials are available
    // For now, return false (not implemented)
    return false;
  }

  /// Get improvement tips based on score
  List<String> getImprovementTips(int score) {
    if (score >= 750) {
      return [
        'Excellent score! Maintain your good credit habits.',
        'Keep paying bills on time.',
        'Avoid opening too many new credit accounts.',
      ];
    } else if (score >= 700) {
      return [
        'Good score! You\'re on the right track.',
        'Pay all bills on time to improve further.',
        'Keep credit utilization below 30%.',
        'Don\'t close old credit accounts.',
      ];
    } else if (score >= 650) {
      return [
        'Fair score. There\'s room for improvement.',
        'Focus on paying bills on time.',
        'Reduce credit card balances.',
        'Check for errors in your credit report.',
      ];
    } else {
      return [
        'Your score needs improvement.',
        'Start by paying all bills on time.',
        'Reduce outstanding debt.',
        'Avoid applying for new credit.',
        'Consider a secured credit card to rebuild credit.',
      ];
    }
  }

  /// Get score range description
  String getScoreRange(int score) {
    if (score >= 750) return 'Excellent (750-900)';
    if (score >= 700) return 'Good (700-749)';
    if (score >= 650) return 'Fair (650-699)';
    if (score >= 600) return 'Poor (600-649)';
    return 'Very Poor (300-599)';
  }
}

enum CreditScoreProvider {
  cibil,
  experian,
  manual,
}

class CreditScore {
  final int score;
  final CreditScoreProvider provider;
  final DateTime lastUpdated;

  const CreditScore({
    required this.score,
    required this.provider,
    required this.lastUpdated,
  });

  String get range => CreditScoreTracker().getScoreRange(score);
  List<String> get tips => CreditScoreTracker().getImprovementTips(score);
}
