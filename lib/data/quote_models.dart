class Quote {
  Quote({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.quoteName,
    required this.quoteDate,
    required this.serviceType,
    required this.frequency,
    required this.lastProClean,
    required this.status,
    required this.total,
    this.address = '',
    this.totalSqFt = '',
    this.useTotalSqFt = true,
    this.estimatedSqFt = '',
    this.petsPresent = false,
    this.homeOccupied = true,
    this.entryCode = '',
    this.paymentMethod = '',
    this.feedbackDiscussed = false,
    this.laborRate = 40.0,
    this.taxEnabled = false,
    this.ccEnabled = false,
    this.taxRate = 0.07,
    this.ccRate = 0.03,
    this.defaultRoomType = '',
    this.defaultLevel = '',
    this.defaultSize = '',
    this.defaultComplexity = '',
    this.subItemType = '',
    this.specialNotes = '',
    this.items = const [],
  });

  final String id;
  final String clientId;
  final String clientName;
  final String quoteName;
  final String quoteDate;
  final String serviceType;
  final String frequency;
  final String lastProClean;
  final String status;
  final double total;
  final String address;
  final String totalSqFt;
  final bool useTotalSqFt;
  final String estimatedSqFt;
  final bool petsPresent;
  final bool homeOccupied;
  final String entryCode;
  final String paymentMethod;
  final bool feedbackDiscussed;
  final double laborRate;
  final bool taxEnabled;
  final bool ccEnabled;
  final double taxRate;
  final double ccRate;
  final String defaultRoomType;
  final String defaultLevel;
  final String defaultSize;
  final String defaultComplexity;
  final String subItemType;
  final String specialNotes;
  final List<Map<String, dynamic>> items;
}

class QuoteDraft {
  QuoteDraft({
    required this.clientId,
    required this.clientName,
    required this.quoteName,
    required this.quoteDate,
    required this.serviceType,
    required this.frequency,
    required this.lastProClean,
    required this.status,
    required this.total,
    this.address = '',
    this.totalSqFt = '',
    this.useTotalSqFt = true,
    this.estimatedSqFt = '',
    this.petsPresent = false,
    this.homeOccupied = true,
    this.entryCode = '',
    this.paymentMethod = '',
    this.feedbackDiscussed = false,
    this.laborRate = 40.0,
    this.taxEnabled = false,
    this.ccEnabled = false,
    this.taxRate = 0.07,
    this.ccRate = 0.03,
    this.defaultRoomType = '',
    this.defaultLevel = '',
    this.defaultSize = '',
    this.defaultComplexity = '',
    this.subItemType = '',
    this.specialNotes = '',
    this.items = const [],
  });

  final String clientId;
  final String clientName;
  final String quoteName;
  final String quoteDate;
  final String serviceType;
  final String frequency;
  final String lastProClean;
  final String status;
  final double total;
  final String address;
  final String totalSqFt;
  final bool useTotalSqFt;
  final String estimatedSqFt;
  final bool petsPresent;
  final bool homeOccupied;
  final String entryCode;
  final String paymentMethod;
  final bool feedbackDiscussed;
  final double laborRate;
  final bool taxEnabled;
  final bool ccEnabled;
  final double taxRate;
  final double ccRate;
  final String defaultRoomType;
  final String defaultLevel;
  final String defaultSize;
  final String defaultComplexity;
  final String subItemType;
  final String specialNotes;
  final List<Map<String, dynamic>> items;

  Map<String, dynamic> toMap() => {
        'clientId': clientId.trim(),
        'clientName': clientName.trim(),
        'quoteName': quoteName.trim(),
        'quoteDate': quoteDate.trim(),
        'serviceType': serviceType.trim(),
        'frequency': frequency.trim(),
        'lastProClean': lastProClean.trim(),
        'status': status.trim(),
        'total': total,
        'address': address.trim(),
        'totalSqFt': totalSqFt.trim(),
        'useTotalSqFt': useTotalSqFt,
        'estimatedSqFt': estimatedSqFt.trim(),
        'petsPresent': petsPresent,
        'homeOccupied': homeOccupied,
        'entryCode': entryCode.trim(),
        'paymentMethod': paymentMethod.trim(),
        'feedbackDiscussed': feedbackDiscussed,
        'laborRate': laborRate,
        'taxEnabled': taxEnabled,
        'ccEnabled': ccEnabled,
        'taxRate': taxRate,
        'ccRate': ccRate,
        'defaultRoomType': defaultRoomType.trim(),
        'defaultLevel': defaultLevel.trim(),
        'defaultSize': defaultSize.trim(),
        'defaultComplexity': defaultComplexity.trim(),
        'subItemType': subItemType.trim(),
        'specialNotes': specialNotes.trim(),
        'items': items,
      };
}
