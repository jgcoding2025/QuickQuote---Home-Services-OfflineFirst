part of '../ui_prototype.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with
        _SettingsStateAccess,
        _SettingsSectionsMixin,
        _SettingsPricingProfilesMixin {
  late OrgSettingsRepositoryLocalFirst repo;
  late PricingProfilesRepositoryLocalFirst _pricingProfilesRepo;
  late PricingProfileCatalogRepositoryLocalFirst _pricingCatalogRepo;
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
    final deps = AppDependencies.of(context);
    repo = deps.orgSettingsRepository;
    _pricingProfilesRepo = deps.pricingProfilesRepository;
    _pricingCatalogRepo = deps.pricingProfileCatalogRepository;
    unawaited(_pricingProfilesRepo.ensureDefaultCatalogSeeded());
  }

  @override
  PricingProfilesRepositoryLocalFirst get pricingProfilesRepo =>
      _pricingProfilesRepo;

  @override
  PricingProfileCatalogRepositoryLocalFirst get pricingCatalogRepo =>
      _pricingCatalogRepo;

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
                      title: 'Account & Team',
                      child: _accountCard(context),
                    ),
                  ],
                );

                final rightColumn = Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _settingsSection(
                      context,
                      title: 'Pricing Tiers',
                      child: _pricingProfilesCard(context, s, data),
                    ),
                  ],
                );

                if (isWide) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 360, child: leftColumn),
                        const SizedBox(width: 20),
                        Expanded(child: rightColumn),
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
        final orgId = session?.orgId;
        final peerStream = deps.syncService.hasPeerOnlineStream;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${session?.email ?? 'Offline'}'),
            const SizedBox(height: 8),
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: orgId == null || orgId.isEmpty
                  ? null
                  : FirebaseFirestore.instance
                      .collection('orgs')
                      .doc(orgId)
                      .snapshots(),
              builder: (context, snapshot) {
                final name = snapshot.data?.data()?['name'] as String?;
                return Text('Org: ${name ?? orgId ?? 'None'}');
              },
            ),
            const SizedBox(height: 8),
            Text('Role: ${session?.role ?? 'Offline'}'),
            const SizedBox(height: 12),
            StreamBuilder<bool>(
              stream: peerStream,
              initialData: deps.syncService.hasPeerOnline,
              builder: (context, snapshot) {
                final hasPeer = snapshot.data ?? false;
                return Row(
                  children: [
                    Icon(
                      hasPeer ? Icons.wifi_tethering : Icons.wifi_tethering_off,
                      color: hasPeer ? Colors.green : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      hasPeer
                          ? 'Another device is online'
                          : 'No other devices online',
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            if (!isGuest && orgId != null)
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('orgs')
                    .doc(orgId)
                    .collection('members')
                    .snapshots(),
                builder: (context, snapshot) {
                  final members = snapshot.data?.docs ?? const [];
                  if (members.isEmpty) {
                    return const Text('No additional team members yet.');
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Team (${members.length})',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      ...members.map((doc) {
                        final data = doc.data();
                        final email = data['email'] as String? ?? doc.id;
                        final role = data['role'] as String? ?? 'member';
                        final active = data['active'] as bool? ?? true;
                        final isSelf = doc.id == session?.userId;
                        return Card(
                          child: ListTile(
                            title: Text(email),
                            subtitle: Text(role),
                            trailing: isOwner
                                ? Switch(
                                    value: active,
                                    onChanged: isSelf
                                        ? null
                                        : (value) async {
                                            await doc.reference.update({
                                              'active': value,
                                            });
                                          },
                                  )
                                : Text(active ? 'Active' : 'Inactive'),
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
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
                      if (!context.mounted) return;
                      _snack(context, 'Invite code copied.');
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
                  onPressed: () async {
                    await deps.syncService.sync();
                    if (!context.mounted) return;
                    _snack(context, 'Sync started.');
                  },
                  child: const Text('Sync Now'),
                ),
              ),
            if (!isGuest) const SizedBox(height: 12),
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
