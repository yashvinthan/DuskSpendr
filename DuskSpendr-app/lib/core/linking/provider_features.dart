import 'account_linker.dart';

class ProviderFeatureFlags {
  static bool isEnabled(AccountProviderType type) {
    switch (type) {
      case AccountProviderType.sbi:
        return const bool.fromEnvironment('FEATURE_SBI', defaultValue: false);
      case AccountProviderType.hdfc:
        return const bool.fromEnvironment('FEATURE_HDFC', defaultValue: false);
      case AccountProviderType.icici:
        return const bool.fromEnvironment('FEATURE_ICICI', defaultValue: false);
      case AccountProviderType.axis:
        return const bool.fromEnvironment('FEATURE_AXIS', defaultValue: false);
      case AccountProviderType.gpay:
        return const bool.fromEnvironment('FEATURE_GPAY', defaultValue: false);
      case AccountProviderType.phonepe:
        return const bool.fromEnvironment('FEATURE_PHONEPE', defaultValue: false);
      case AccountProviderType.paytmUpi:
        return const bool.fromEnvironment('FEATURE_PAYTM_UPI', defaultValue: false);
      case AccountProviderType.amazonPay:
        return const bool.fromEnvironment('FEATURE_AMAZON_PAY', defaultValue: false);
      case AccountProviderType.paytmWallet:
        return const bool.fromEnvironment('FEATURE_PAYTM_WALLET', defaultValue: false);
      case AccountProviderType.lazypay:
        return const bool.fromEnvironment('FEATURE_LAZYPAY', defaultValue: false);
      case AccountProviderType.simpl:
        return const bool.fromEnvironment('FEATURE_SIMPL', defaultValue: false);
      case AccountProviderType.amazonPayLater:
        return const bool.fromEnvironment('FEATURE_AMAZON_PAY_LATER', defaultValue: false);
      case AccountProviderType.zerodha:
        return const bool.fromEnvironment('FEATURE_ZERODHA', defaultValue: false);
      case AccountProviderType.groww:
        return const bool.fromEnvironment('FEATURE_GROWW', defaultValue: false);
      case AccountProviderType.upstox:
        return const bool.fromEnvironment('FEATURE_UPSTOX', defaultValue: false);
      case AccountProviderType.angelOne:
        return const bool.fromEnvironment('FEATURE_ANGEL_ONE', defaultValue: false);
      case AccountProviderType.zerodhaCoins:
        return const bool.fromEnvironment('FEATURE_ZERODHA_COINS', defaultValue: false);
      case AccountProviderType.indmoney:
        return const bool.fromEnvironment('FEATURE_INDMONEY', defaultValue: false);
    }
  }
}
