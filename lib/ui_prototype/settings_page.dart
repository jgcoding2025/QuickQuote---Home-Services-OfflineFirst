part of '../ui_prototype.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with _SettingsStateAccess, _SettingsSectionsMixin {
  late OrgSettingsRepositoryLocalFirst repo;
  late final Future<_SettingsData> _settingsDataFuture;
  bool _inviteLoading = false;
  String? _inviteCode;
  String? _inviteError;

  @override
  void initState() {
    super.initState();
    _settingsDataFuture = _loadSettingsData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    repo = AppDependencies.of(context).orgSettingsRepository;
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
                      title: 'Account & Team',
                      child: _accountCard(context),
                    ),
                    const SizedBox(height: 20),
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

  Widget _accountCard(BuildContext context) {
    final deps = AppDependencies.of(context);
    return ValueListenableBuilder<AppSession?>(
      valueListenable: deps.sessionController,
      builder: (context, session, _) {
        final isOwner = session?.role == 'owner';
        final isGuest = session?.isGuest ?? true;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${session?.email ?? 'Offline'}'),
            const SizedBox(height: 8),
            Text('Org ID: ${session?.orgId ?? 'None'}'),
            const SizedBox(height: 8),
            Text('Role: ${session?.role ?? 'Offline'}'),
            if (_inviteError != null) ...[
              const SizedBox(height: 12),
              Text(
                _inviteError!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 12),
            if (!isGuest && isOwner)
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _inviteLoading ? null : _createInviteCode,
                  child: const Text('Create Invite Code'),
                ),
              ),
            if (_inviteCode != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: SelectableText('Invite Code: $_inviteCode'),
                  ),
                  IconButton(
                    tooltip: 'Copy code',
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(text: _inviteCode ?? ''),
                      );
                      if (mounted) _snack(context, 'Invite code copied.');
                    },
                    icon: const Icon(Icons.copy),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            if (!isGuest)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _signOut,
                  child: const Text('Sign Out'),
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _createInviteCode() async {
    setState(() {
      _inviteLoading = true;
      _inviteError = null;
      _inviteCode = null;
    });
    try {
      final deps = AppDependencies.of(context);
      final code = await deps.appController.createInviteCode();
      if (mounted) {
        setState(() {
          _inviteCode = code;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _inviteError = e.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _inviteLoading = false;
        });
      }
    }
  }

  Future<void> _signOut() async {
    try {
      final deps = AppDependencies.of(context);
      await deps.appController.signOut();
      if (mounted) {
        _snack(context, 'Signed out. Local data kept offline.');
      }
    } catch (e) {
      if (mounted) {
        _snack(context, 'Sign out failed: $e');
      }
    }
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
