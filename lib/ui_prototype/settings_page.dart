part of '../ui_prototype.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with _SettingsStateAccess, _SettingsSectionsMixin {
  static const orgId = 'demo-org'; // same org id as your shell
  final repo = OrgSettingsRepo(orgId: orgId);
  late final Future<_SettingsData> _settingsDataFuture;

  @override
  void initState() {
    super.initState();
    _settingsDataFuture = _loadSettingsData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_SettingsData>(
      future: _settingsDataFuture,
      builder: (context, dataSnap) {
        if (dataSnap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (dataSnap.hasError) {
          return const Center(child: Text('Failed to load settings data.'));
        }
        final data = dataSnap.data ?? _SettingsData.empty();
        return StreamBuilder<OrgSettings>(
          stream: repo.stream(),
          builder: (context, snap) {
            final s = snap.data ?? OrgSettings.defaults;
            return LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 900;
                final leftColumn = Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _settingsSection(
                      context,
                      title: 'Service types',
                      child: _servicePricingCard(context, data.serviceTypes),
                    ),
                    const SizedBox(height: 20),
                    _settingsSection(
                      context,
                      title: 'Complexity, size, and frequency',
                      child: _serviceModifiersCard(context, data),
                    ),
                    const SizedBox(height: 20),
                    _settingsSection(
                      context,
                      title: 'Labor Rate, Taxes, Fees',
                      child: _quoteDefaultsCard(context, s),
                    ),
                    const SizedBox(height: 20),
                    _settingsSection(
                      context,
                      title: 'Room type standards',
                      child: _roomTypeStandardsCard(context, data.roomTypes),
                    ),
                  ],
                );

                final rightColumn = Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _settingsSection(
                      context,
                      title: 'Plan tiers',
                      child: _planTierCard(context, data.planTiers),
                    ),
                    const SizedBox(height: 20),
                    _settingsSection(
                      context,
                      title: 'Add-on items',
                      child: _addonsPricingCard(context, data.subItems),
                    ),
                  ],
                );

                if (isWide) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: leftColumn),
                        const SizedBox(width: 20),
                        SizedBox(width: 320, child: rightColumn),
                      ],
                    ),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    leftColumn,
                    const SizedBox(height: 24),
                    rightColumn,
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Future<_SettingsData> _loadSettingsData() async {
    final planTiers = await _loadList(
      'assets/settings/plan_tiers.json',
      _PlanTier.fromJson,
    );
    final serviceTypes = await _loadList(
      'assets/settings/service_type_standards.json',
      _ServiceTypeStandard.fromJson,
    );
    final complexities = await _loadList(
      'assets/settings/complexity_standards.json',
      _ComplexityStandard.fromJson,
    );
    final sizes = await _loadList(
      'assets/settings/size_standards.json',
      _SizeStandard.fromJson,
    );
    final frequencies = await _loadList(
      'assets/settings/frequency_standards.json',
      _FrequencyStandard.fromJson,
    );
    final roomTypes = await _loadList(
      'assets/settings/room_type_standards.json',
      _RoomTypeStandard.fromJson,
    );
    final subItems = await _loadList(
      'assets/settings/sub_item_standards.json',
      _SubItemStandard.fromJson,
    );

    return _SettingsData(
      planTiers: planTiers,
      serviceTypes: serviceTypes,
      complexities: complexities,
      sizes: sizes,
      frequencies: frequencies,
      roomTypes: roomTypes,
      subItems: subItems,
    );
  }

  @override
  Future<void> _save(OrgSettings s) async {
    // fire-and-forget feel, but still await to keep it simple
    try {
      await repo.save(s);
    } catch (e) {
      if (mounted) _snack(context, 'Save failed: $e');
    } finally {}
  }
}
