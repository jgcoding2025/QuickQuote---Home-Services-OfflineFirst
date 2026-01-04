class OrgSettings {
  final double laborRate;
  final bool taxEnabled;
  final double taxRate;
  final bool ccEnabled;
  final double ccRate;
  final String defaultPricingProfileId;

  const OrgSettings({
    required this.laborRate,
    required this.taxEnabled,
    required this.taxRate,
    required this.ccEnabled,
    required this.ccRate,
    required this.defaultPricingProfileId,
  });

  static const defaults = OrgSettings(
    laborRate: 40.0,
    taxEnabled: false,
    taxRate: 0.07,
    ccEnabled: false,
    ccRate: 0.03,
    defaultPricingProfileId: 'default',
  );

  Map<String, dynamic> toMap({required int updatedAt}) => {
        'laborRate': laborRate,
        'taxEnabled': taxEnabled,
        'taxRate': taxRate,
        'ccEnabled': ccEnabled,
        'ccRate': ccRate,
        'defaultPricingProfileId': defaultPricingProfileId,
        'updatedAt': updatedAt,
        'deleted': false,
      };

  factory OrgSettings.fromMap(Map<String, dynamic>? data) {
    final d = data ?? const <String, dynamic>{};
    double numD(String k, double fallback) {
      final v = d[k];
      if (v is num) return v.toDouble();
      return fallback;
    }

    bool boolD(String k, bool fallback) {
      final v = d[k];
      if (v is bool) return v;
      return fallback;
    }

    return OrgSettings(
      laborRate: numD('laborRate', defaults.laborRate),
      taxEnabled: boolD('taxEnabled', defaults.taxEnabled),
      taxRate: numD('taxRate', defaults.taxRate),
      ccEnabled: boolD('ccEnabled', defaults.ccEnabled),
      ccRate: numD('ccRate', defaults.ccRate),
      defaultPricingProfileId:
          (d['defaultPricingProfileId'] as String?) ??
          defaults.defaultPricingProfileId,
    );
  }
}
