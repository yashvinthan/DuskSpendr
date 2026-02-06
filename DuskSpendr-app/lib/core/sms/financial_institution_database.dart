/// SS-034: Enhanced Financial Institution Database
/// Comprehensive sender ID database for Indian banks, UPI apps, and fintech
library;

/// Financial Institution enumeration with full Indian bank coverage
enum FinancialInstitution {
  // Public Sector Banks
  sbi,
  pnb,
  bob, // Bank of Baroda
  boi, // Bank of India
  canara,
  unionBank,
  indianBank,
  centralBank,
  indianOverseasBank,
  uco,
  bankOfMaharashtra,
  punjabSindBank,

  // Private Sector Banks
  hdfc,
  icici,
  axis,
  kotak,
  yesBank,
  idfcFirst,
  idbi,
  indusind,
  federalBank,
  rbl,
  bandhan,
  southIndianBank,
  karnatakaBank,
  cityUnionBank,
  lakshmiVilas,
  dcb,
  dhanlaxmi,
  jammuKashmir,
  nainital,
  tamilnad,

  // Small Finance Banks
  auSmallFinance,
  equitas,
  ujjivan,
  jana,
  suryoday,
  fincare,
  esaf,
  northEast,
  capital,
  shivalik,

  // Payments Banks
  paytmPaymentsBank,
  airtelPaymentsBank,
  jioPay,
  finoPaymentsBank,
  indiaPosts,
  napb, // NSDL Payments Bank

  // UPI Apps
  gpay,
  phonepe,
  paytm,
  amazonPay,
  bharatPe,
  whatsappPay,
  cred,
  mobikwik,
  freecharge,

  // BNPL & Credit
  lazypay,
  simpl,
  zestMoney,
  slice,
  uni,
  moneyTap,
  kreditBee,
  cashE,
  earlyCredit,
  paysense,
  stashfin,
  kissht,
  flexmoney,
  earlySalary,

  // Fintech & Neobanks
  niyo,
  jupiter,
  fi,
  oneCard,

  // Credit Cards
  amex,
  dinersClub,
  rupay,

  // Other
  other,
}

/// Sender ID patterns mapped to financial institutions
/// Includes short codes, alphanumeric IDs, and variations
class FinancialInstitutionDatabase {
  /// Comprehensive sender ID mapping
  static const senderPatterns = <String, FinancialInstitution>{
    // ====== PUBLIC SECTOR BANKS ======

    // State Bank of India
    'SBIINB': FinancialInstitution.sbi,
    'SBIPSG': FinancialInstitution.sbi,
    'SBIOTP': FinancialInstitution.sbi,
    'SBIUPI': FinancialInstitution.sbi,
    'SBIBNK': FinancialInstitution.sbi,
    'SBIATM': FinancialInstitution.sbi,
    'SBICRD': FinancialInstitution.sbi,
    'SBICARD': FinancialInstitution.sbi,
    'SBIYONO': FinancialInstitution.sbi,

    // Punjab National Bank
    'PNBSMS': FinancialInstitution.pnb,
    'PNBINB': FinancialInstitution.pnb,
    'PNBANK': FinancialInstitution.pnb,
    'PNBOTP': FinancialInstitution.pnb,
    'PNBUPI': FinancialInstitution.pnb,

    // Bank of Baroda
    'BOBSMS': FinancialInstitution.bob,
    'BOBANK': FinancialInstitution.bob,
    'BARODB': FinancialInstitution.bob,
    'BOBINB': FinancialInstitution.bob,

    // Bank of India
    'BOISMS': FinancialInstitution.boi,
    'BOIBNK': FinancialInstitution.boi,
    'BOIACC': FinancialInstitution.boi,

    // Canara Bank
    'CANBNK': FinancialInstitution.canara,
    'CANARA': FinancialInstitution.canara,
    'CANAAB': FinancialInstitution.canara,
    'CANSMS': FinancialInstitution.canara,

    // Union Bank of India
    'UBISMS': FinancialInstitution.unionBank,
    'UBIBNK': FinancialInstitution.unionBank,
    'UNIONB': FinancialInstitution.unionBank,

    // Indian Bank
    'INDBNK': FinancialInstitution.indianBank,
    'INDIANB': FinancialInstitution.indianBank,

    // Central Bank of India
    'CENTRL': FinancialInstitution.centralBank,
    'CBISMS': FinancialInstitution.centralBank,

    // Indian Overseas Bank
    'IOBSMS': FinancialInstitution.indianOverseasBank,
    'IOBBNK': FinancialInstitution.indianOverseasBank,

    // UCO Bank
    'UCOSMS': FinancialInstitution.uco,
    'UCOBNK': FinancialInstitution.uco,

    // Bank of Maharashtra
    'BOMSMS': FinancialInstitution.bankOfMaharashtra,
    'MAHBNK': FinancialInstitution.bankOfMaharashtra,

    // Punjab & Sind Bank
    'PSBSMS': FinancialInstitution.punjabSindBank,
    'PUNJSB': FinancialInstitution.punjabSindBank,

    // ====== PRIVATE SECTOR BANKS ======

    // HDFC Bank
    'HDFCBK': FinancialInstitution.hdfc,
    'HDFCBN': FinancialInstitution.hdfc,
    'HDBANK': FinancialInstitution.hdfc,
    'HDFCCC': FinancialInstitution.hdfc,
    'HDFATM': FinancialInstitution.hdfc,
    'HDFCDC': FinancialInstitution.hdfc,
    'HDFCOTP': FinancialInstitution.hdfc,

    // ICICI Bank
    'ICICIB': FinancialInstitution.icici,
    'ICICIP': FinancialInstitution.icici,
    'ICICIN': FinancialInstitution.icici,
    'ICIBNK': FinancialInstitution.icici,
    'ICICRD': FinancialInstitution.icici,
    'ICIATM': FinancialInstitution.icici,

    // Axis Bank
    'AXISBK': FinancialInstitution.axis,
    'AXISBB': FinancialInstitution.axis,
    'AXISCR': FinancialInstitution.axis,
    'AXSOTP': FinancialInstitution.axis,
    'AXISCC': FinancialInstitution.axis,

    // Kotak Mahindra Bank
    'KOTAKB': FinancialInstitution.kotak,
    'KOTAKM': FinancialInstitution.kotak,
    'KOTAK': FinancialInstitution.kotak,
    'KOTMHB': FinancialInstitution.kotak,
    'KOTAKC': FinancialInstitution.kotak,

    // Yes Bank
    'YESBNK': FinancialInstitution.yesBank,
    'YESBKN': FinancialInstitution.yesBank,

    // IDFC First Bank
    'IDFCFB': FinancialInstitution.idfcFirst,
    'IDFCBK': FinancialInstitution.idfcFirst,
    'IDFC': FinancialInstitution.idfcFirst,

    // IDBI Bank
    'IDBIBN': FinancialInstitution.idbi,
    'IDBIBK': FinancialInstitution.idbi,

    // IndusInd Bank
    'INDUSB': FinancialInstitution.indusind,
    'INDUSL': FinancialInstitution.indusind,
    'INDUSN': FinancialInstitution.indusind,

    // Federal Bank
    'FEDBNK': FinancialInstitution.federalBank,
    'FEDRLB': FinancialInstitution.federalBank,

    // RBL Bank
    'RBLBNK': FinancialInstitution.rbl,
    'RBLBKN': FinancialInstitution.rbl,

    // Bandhan Bank
    'BANDHN': FinancialInstitution.bandhan,
    'BNDHBK': FinancialInstitution.bandhan,

    // South Indian Bank
    'SIBANK': FinancialInstitution.southIndianBank,
    'SIBNK': FinancialInstitution.southIndianBank,

    // Karnataka Bank
    'KTKBNK': FinancialInstitution.karnatakaBank,
    'KARNTK': FinancialInstitution.karnatakaBank,

    // City Union Bank
    'CITYUB': FinancialInstitution.cityUnionBank,
    'CUBSMS': FinancialInstitution.cityUnionBank,

    // DCB Bank
    'DCBBNK': FinancialInstitution.dcb,

    // ====== SMALL FINANCE BANKS ======

    // AU Small Finance Bank
    'AUSFIN': FinancialInstitution.auSmallFinance,
    'AUBANK': FinancialInstitution.auSmallFinance,

    // Equitas Small Finance Bank
    'EQTSFB': FinancialInstitution.equitas,
    'EQITAS': FinancialInstitution.equitas,

    // Ujjivan Small Finance Bank
    'UJJVAN': FinancialInstitution.ujjivan,
    'UJJSFB': FinancialInstitution.ujjivan,

    // Jana Small Finance Bank
    'JANASFB': FinancialInstitution.jana,
    'JANASF': FinancialInstitution.jana,

    // Suryoday Small Finance Bank
    'SURYDY': FinancialInstitution.suryoday,
    'SURYAB': FinancialInstitution.suryoday,

    // Fincare Small Finance Bank
    'FINCRE': FinancialInstitution.fincare,

    // ESAF Small Finance Bank
    'ESAFBK': FinancialInstitution.esaf,

    // ====== PAYMENTS BANKS ======

    // Paytm Payments Bank
    'PYTMPB': FinancialInstitution.paytmPaymentsBank,
    'PPBLTD': FinancialInstitution.paytmPaymentsBank,

    // Airtel Payments Bank
    'AIRTEL': FinancialInstitution.airtelPaymentsBank,
    'ARTLPB': FinancialInstitution.airtelPaymentsBank,

    // Jio Payments Bank
    'JIOPAY': FinancialInstitution.jioPay,
    'JIOPB': FinancialInstitution.jioPay,

    // Fino Payments Bank
    'FINOPB': FinancialInstitution.finoPaymentsBank,

    // India Post Payments Bank
    'IPPB': FinancialInstitution.indiaPosts,
    'INDPST': FinancialInstitution.indiaPosts,

    // ====== UPI APPS ======

    // Google Pay
    'GPAY': FinancialInstitution.gpay,
    'GOOGLY': FinancialInstitution.gpay,
    'GOOGLP': FinancialInstitution.gpay,
    'GPAYIN': FinancialInstitution.gpay,

    // PhonePe
    'PHONPE': FinancialInstitution.phonepe,
    'PHNPEI': FinancialInstitution.phonepe,
    'PPINDIA': FinancialInstitution.phonepe,

    // Paytm
    'PAYTM': FinancialInstitution.paytm,
    'PAYTMB': FinancialInstitution.paytm,
    'PYTMUPI': FinancialInstitution.paytm,
    'PTMBIZ': FinancialInstitution.paytm,

    // Amazon Pay
    'AMZPAY': FinancialInstitution.amazonPay,
    'AMAZON': FinancialInstitution.amazonPay,
    'AMZNPY': FinancialInstitution.amazonPay,

    // BharatPe
    'BHRTPE': FinancialInstitution.bharatPe,
    'BHARTP': FinancialInstitution.bharatPe,

    // WhatsApp Pay
    'WAPAY': FinancialInstitution.whatsappPay,
    'WATSPY': FinancialInstitution.whatsappPay,

    // CRED
    'CRED': FinancialInstitution.cred,
    'CREDAP': FinancialInstitution.cred,

    // MobiKwik
    'MOBKWK': FinancialInstitution.mobikwik,
    'MOBIKW': FinancialInstitution.mobikwik,

    // Freecharge
    'FRCHRG': FinancialInstitution.freecharge,
    'FREECH': FinancialInstitution.freecharge,

    // ====== BNPL & CREDIT ======

    // LazyPay
    'LAZYPY': FinancialInstitution.lazypay,
    'LAZYPA': FinancialInstitution.lazypay,

    // Simpl
    'SIMPL': FinancialInstitution.simpl,
    'SIMPLP': FinancialInstitution.simpl,

    // ZestMoney
    'ZESTMN': FinancialInstitution.zestMoney,
    'ZESTMY': FinancialInstitution.zestMoney,

    // Slice
    'SLICE': FinancialInstitution.slice,
    'SLICEP': FinancialInstitution.slice,

    // Uni Cards
    'UNICRD': FinancialInstitution.uni,
    'UNICAR': FinancialInstitution.uni,

    // KreditBee
    'KRDTBE': FinancialInstitution.kreditBee,
    'KREDTB': FinancialInstitution.kreditBee,

    // MoneyTap
    'MNYTAP': FinancialInstitution.moneyTap,

    // EarlySalary
    'ERLSAL': FinancialInstitution.earlySalary,

    // ====== NEOBANKS ======

    // Niyo
    'NIYOBN': FinancialInstitution.niyo,

    // Jupiter
    'JUPTER': FinancialInstitution.jupiter,
    'JUPITER': FinancialInstitution.jupiter,

    // Fi Money
    'FIMONY': FinancialInstitution.fi,

    // OneCard
    'ONECARD': FinancialInstitution.oneCard,
    'ONECRD': FinancialInstitution.oneCard,

    // ====== CREDIT CARDS ======

    // American Express
    'AMEX': FinancialInstitution.amex,
    'AMEXIN': FinancialInstitution.amex,

    // Diners Club
    'DINERS': FinancialInstitution.dinersClub,
  };

  /// Regex patterns for flexible matching
  static final regexPatterns = <RegExp, FinancialInstitution>{
    RegExp(r'^[A-Z]{2}-?SBI', caseSensitive: false): FinancialInstitution.sbi,
    RegExp(r'^[A-Z]{2}-?HDFC', caseSensitive: false): FinancialInstitution.hdfc,
    RegExp(r'^[A-Z]{2}-?ICICI', caseSensitive: false): FinancialInstitution.icici,
    RegExp(r'^[A-Z]{2}-?AXIS', caseSensitive: false): FinancialInstitution.axis,
    RegExp(r'^[A-Z]{2}-?KOTAK', caseSensitive: false): FinancialInstitution.kotak,
    RegExp(r'^[A-Z]{2}-?PNB', caseSensitive: false): FinancialInstitution.pnb,
    RegExp(r'^[A-Z]{2}-?CANARA', caseSensitive: false): FinancialInstitution.canara,
    RegExp(r'^[A-Z]{2}-?UNION', caseSensitive: false): FinancialInstitution.unionBank,
    RegExp(r'^[A-Z]{2}-?BOB', caseSensitive: false): FinancialInstitution.bob,
    RegExp(r'^[A-Z]{2}-?BOI', caseSensitive: false): FinancialInstitution.boi,
    RegExp(r'^[A-Z]{2}-?IDFC', caseSensitive: false): FinancialInstitution.idfcFirst,
    RegExp(r'^[A-Z]{2}-?YES', caseSensitive: false): FinancialInstitution.yesBank,
    RegExp(r'^[A-Z]{2}-?INDUS', caseSensitive: false): FinancialInstitution.indusind,
    RegExp(r'^[A-Z]{2}-?FEDERAL', caseSensitive: false): FinancialInstitution.federalBank,
    RegExp(r'^[A-Z]{2}-?AU\s?BANK', caseSensitive: false): FinancialInstitution.auSmallFinance,
    RegExp(r'^[A-Z]{2}-?PAYTM', caseSensitive: false): FinancialInstitution.paytm,
    RegExp(r'^[A-Z]{2}-?PHONEPE', caseSensitive: false): FinancialInstitution.phonepe,
    RegExp(r'^[A-Z]{2}-?AMAZON', caseSensitive: false): FinancialInstitution.amazonPay,
  };

  /// Get institution display name
  static String getDisplayName(FinancialInstitution institution) {
    switch (institution) {
      case FinancialInstitution.sbi:
        return 'State Bank of India';
      case FinancialInstitution.pnb:
        return 'Punjab National Bank';
      case FinancialInstitution.bob:
        return 'Bank of Baroda';
      case FinancialInstitution.boi:
        return 'Bank of India';
      case FinancialInstitution.canara:
        return 'Canara Bank';
      case FinancialInstitution.unionBank:
        return 'Union Bank of India';
      case FinancialInstitution.indianBank:
        return 'Indian Bank';
      case FinancialInstitution.centralBank:
        return 'Central Bank of India';
      case FinancialInstitution.indianOverseasBank:
        return 'Indian Overseas Bank';
      case FinancialInstitution.uco:
        return 'UCO Bank';
      case FinancialInstitution.bankOfMaharashtra:
        return 'Bank of Maharashtra';
      case FinancialInstitution.punjabSindBank:
        return 'Punjab & Sind Bank';
      case FinancialInstitution.hdfc:
        return 'HDFC Bank';
      case FinancialInstitution.icici:
        return 'ICICI Bank';
      case FinancialInstitution.axis:
        return 'Axis Bank';
      case FinancialInstitution.kotak:
        return 'Kotak Mahindra Bank';
      case FinancialInstitution.yesBank:
        return 'Yes Bank';
      case FinancialInstitution.idfcFirst:
        return 'IDFC First Bank';
      case FinancialInstitution.idbi:
        return 'IDBI Bank';
      case FinancialInstitution.indusind:
        return 'IndusInd Bank';
      case FinancialInstitution.federalBank:
        return 'Federal Bank';
      case FinancialInstitution.rbl:
        return 'RBL Bank';
      case FinancialInstitution.bandhan:
        return 'Bandhan Bank';
      case FinancialInstitution.southIndianBank:
        return 'South Indian Bank';
      case FinancialInstitution.karnatakaBank:
        return 'Karnataka Bank';
      case FinancialInstitution.cityUnionBank:
        return 'City Union Bank';
      case FinancialInstitution.lakshmiVilas:
        return 'Lakshmi Vilas Bank';
      case FinancialInstitution.dcb:
        return 'DCB Bank';
      case FinancialInstitution.dhanlaxmi:
        return 'Dhanlaxmi Bank';
      case FinancialInstitution.jammuKashmir:
        return 'J&K Bank';
      case FinancialInstitution.nainital:
        return 'Nainital Bank';
      case FinancialInstitution.tamilnad:
        return 'Tamilnad Mercantile Bank';
      case FinancialInstitution.auSmallFinance:
        return 'AU Small Finance Bank';
      case FinancialInstitution.equitas:
        return 'Equitas Small Finance Bank';
      case FinancialInstitution.ujjivan:
        return 'Ujjivan Small Finance Bank';
      case FinancialInstitution.jana:
        return 'Jana Small Finance Bank';
      case FinancialInstitution.suryoday:
        return 'Suryoday Small Finance Bank';
      case FinancialInstitution.fincare:
        return 'Fincare Small Finance Bank';
      case FinancialInstitution.esaf:
        return 'ESAF Small Finance Bank';
      case FinancialInstitution.northEast:
        return 'North East Small Finance Bank';
      case FinancialInstitution.capital:
        return 'Capital Small Finance Bank';
      case FinancialInstitution.shivalik:
        return 'Shivalik Small Finance Bank';
      case FinancialInstitution.paytmPaymentsBank:
        return 'Paytm Payments Bank';
      case FinancialInstitution.airtelPaymentsBank:
        return 'Airtel Payments Bank';
      case FinancialInstitution.jioPay:
        return 'Jio Payments Bank';
      case FinancialInstitution.finoPaymentsBank:
        return 'Fino Payments Bank';
      case FinancialInstitution.indiaPosts:
        return 'India Post Payments Bank';
      case FinancialInstitution.napb:
        return 'NSDL Payments Bank';
      case FinancialInstitution.gpay:
        return 'Google Pay';
      case FinancialInstitution.phonepe:
        return 'PhonePe';
      case FinancialInstitution.paytm:
        return 'Paytm';
      case FinancialInstitution.amazonPay:
        return 'Amazon Pay';
      case FinancialInstitution.bharatPe:
        return 'BharatPe';
      case FinancialInstitution.whatsappPay:
        return 'WhatsApp Pay';
      case FinancialInstitution.cred:
        return 'CRED';
      case FinancialInstitution.mobikwik:
        return 'MobiKwik';
      case FinancialInstitution.freecharge:
        return 'Freecharge';
      case FinancialInstitution.lazypay:
        return 'LazyPay';
      case FinancialInstitution.simpl:
        return 'Simpl';
      case FinancialInstitution.zestMoney:
        return 'ZestMoney';
      case FinancialInstitution.slice:
        return 'Slice';
      case FinancialInstitution.uni:
        return 'Uni Cards';
      case FinancialInstitution.moneyTap:
        return 'MoneyTap';
      case FinancialInstitution.kreditBee:
        return 'KreditBee';
      case FinancialInstitution.cashE:
        return 'CashE';
      case FinancialInstitution.earlyCredit:
        return 'Early Credit';
      case FinancialInstitution.paysense:
        return 'PaySense';
      case FinancialInstitution.stashfin:
        return 'Stashfin';
      case FinancialInstitution.kissht:
        return 'Kissht';
      case FinancialInstitution.flexmoney:
        return 'FlexMoney';
      case FinancialInstitution.earlySalary:
        return 'EarlySalary';
      case FinancialInstitution.niyo:
        return 'Niyo';
      case FinancialInstitution.jupiter:
        return 'Jupiter';
      case FinancialInstitution.fi:
        return 'Fi Money';
      case FinancialInstitution.oneCard:
        return 'OneCard';
      case FinancialInstitution.amex:
        return 'American Express';
      case FinancialInstitution.dinersClub:
        return 'Diners Club';
      case FinancialInstitution.rupay:
        return 'RuPay';
      case FinancialInstitution.other:
        return 'Other';
    }
  }

  /// Check if institution is a bank (vs UPI app, BNPL, etc.)
  static bool isBank(FinancialInstitution institution) {
    return institution.index <= FinancialInstitution.shivalik.index;
  }

  /// Check if institution is a UPI app
  static bool isUpiApp(FinancialInstitution institution) {
    return institution.index >= FinancialInstitution.gpay.index &&
        institution.index <= FinancialInstitution.freecharge.index;
  }

  /// Check if institution is a BNPL service
  static bool isBnpl(FinancialInstitution institution) {
    return institution.index >= FinancialInstitution.lazypay.index &&
        institution.index <= FinancialInstitution.earlySalary.index;
  }
}

/// OTP message patterns to filter out
class OtpMessageFilter {
  /// Patterns that indicate an OTP message (should be skipped)
  static final otpPatterns = [
    RegExp(r'\b(?:OTP|otp)\b.*\d{4,8}', caseSensitive: false),
    RegExp(r'\d{4,8}.*\b(?:OTP|otp)\b', caseSensitive: false),
    RegExp(r'(?:one\s*time\s*password|verification\s*code)', caseSensitive: false),
    RegExp(r'(?:use|enter|type)\s*(?:this\s*)?(?:code|OTP)', caseSensitive: false),
    RegExp(r'(?:code|otp)\s*(?:is|:)?\s*\d{4,8}', caseSensitive: false),
    RegExp(r'\d{4,8}\s*(?:is\s*(?:your|the)|valid\s*for)', caseSensitive: false),
    RegExp(r'(?:do\s*not\s*share|never\s*share).*(?:OTP|code)', caseSensitive: false),
    RegExp(r'(?:expires?\s*in|valid\s*(?:for|till))\s*\d+\s*(?:min|sec|minute)', caseSensitive: false),
  ];

  /// Check if message is an OTP message
  static bool isOtp(String message) {
    return otpPatterns.any((pattern) => pattern.hasMatch(message));
  }

  /// Non-transactional message patterns
  static final nonTransactionalPatterns = [
    RegExp(r'(?:dear\s*customer|valued\s*customer)', caseSensitive: false),
    RegExp(r'(?:your\s*(?:request|application))', caseSensitive: false),
    RegExp(r'(?:grievance|complaint|feedback)', caseSensitive: false),
    RegExp(r'(?:survey|rate\s*us|review)', caseSensitive: false),
    RegExp(r'(?:offer|discount|cashback)\s*(?:of|upto|up\s*to)\s*\d+%', caseSensitive: false),
    RegExp(r'(?:pre-?approved|instant\s*loan)', caseSensitive: false),
    RegExp(r'(?:update\s*(?:your|kyc|pan))', caseSensitive: false),
  ];

  /// Check if message is non-transactional (promotional, service, etc.)
  static bool isNonTransactional(String message) {
    // Skip if it's clearly a transaction
    if (message.contains(RegExp(r'(?:debited|credited)', caseSensitive: false))) {
      return false;
    }
    return nonTransactionalPatterns.any((pattern) => pattern.hasMatch(message));
  }
}
