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
  late final Future<SettingsData> _settingsDataFuture;
  bool _inviteLoading = false;
  String? _inviteCode;
  String? _inviteError;
  MetricsRange _metricsRange = MetricsRange.last20Minutes;

  String _formatRole(String role) {
    if (role == 'owner') {
      return 'Owner';
    }
    return role;
  }

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
    final deps = AppDependencies.of(context);
    return FutureBuilder<SettingsData>(
      future: _settingsDataFuture,
      builder: (context, dataSnap) {
        if (dataSnap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (dataSnap.hasError) {
          return const Center(child: Text('Failed to load settings data.'));
        }
        final data = dataSnap.data ?? SettingsData.empty();
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
                    const SizedBox(height: 24),
                    _settingsSection(
                      context,
                      title: 'Read/Writes to Database',
                      child: _readWriteMetricsCard(context),
                    ),
                  ],
                );

                if (isWide) {
                  return RefreshIndicator(
                    onRefresh: () => deps.syncService.downloadNow(
                      reason: 'pull_to_refresh:settings',
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: 360, child: leftColumn),
                              const SizedBox(width: 20),
                              Expanded(child: rightColumn),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => deps.syncService.downloadNow(
                    reason: 'pull_to_refresh:settings',
                  ),
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      leftColumn,
                      const SizedBox(height: 24),
                      rightColumn,
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<SettingsData> _loadSettingsData() async {
    final planTiers = await _loadList(
      'assets/settings/plan_tiers.json',
      PlanTier.fromJson,
    );
    final serviceTypes = await _loadList(
      'assets/settings/service_type_standards.json',
      ServiceTypeStandard.fromJson,
    );
    final complexities = await _loadList(
      'assets/settings/complexity_standards.json',
      ComplexityStandard.fromJson,
    );
    final sizes = await _loadList(
      'assets/settings/size_standards.json',
      SizeStandard.fromJson,
    );
    final frequencies = await _loadList(
      'assets/settings/frequency_standards.json',
      FrequencyStandard.fromJson,
    );
    final roomTypes = await _loadList(
      'assets/settings/room_type_standards.json',
      RoomTypeStandard.fromJson,
    );
    final subItems = await _loadList(
      'assets/settings/sub_item_standards.json',
      SubItemStandard.fromJson,
    );

    return SettingsData(
      planTiers: planTiers,
      serviceTypes: serviceTypes,
      complexities: complexities,
      sizes: sizes,
      frequencies: frequencies,
      roomTypes: roomTypes,
      subItems: subItems,
    );
  }

  Widget _readWriteMetricsCard(BuildContext context) {
    final deps = AppDependencies.of(context);
    final metricsCollector = deps.metricsCollector;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder<List<MetricsBucket>>(
          future: metricsCollector.snapshot(_metricsRange),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Text('Unable to load usage data.');
            }
            final buckets = snapshot.data ?? const <MetricsBucket>[];
            return _MetricsGraphPanel(
              buckets: buckets,
              range: _metricsRange,
            );
          },
        ),
        const SizedBox(height: 12),
        _metricsRangeSelector(context),
      ],
    );
  }

  Widget _metricsRangeSelector(BuildContext context) {
    return SegmentedButton<MetricsRange>(
      segments: const [
        ButtonSegment(
          value: MetricsRange.last20Minutes,
          label: Text('20 minutes'),
        ),
        ButtonSegment(
          value: MetricsRange.last1Hour,
          label: Text('1 hour'),
        ),
        ButtonSegment(
          value: MetricsRange.last24Hours,
          label: Text('1 day'),
        ),
      ],
      selected: {_metricsRange},
      onSelectionChanged: (selection) {
        setState(() {
          _metricsRange = selection.first;
        });
      },
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
                        .snapshots()
                        .map((snapshot) {
                        unawaited(
                          deps.metricsCollector.recordRead(),
                        );
                        return snapshot;
                      }),
              builder: (context, snapshot) {
                final name = snapshot.data?.data()?['name'] as String?;
                return Text('Org: ${name ?? orgId ?? 'None'}');
              },
            ),
            const SizedBox(height: 8),
            Text('Role: ${_formatRole(session?.role ?? 'Offline')}'),
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
                    .snapshots()
                    .map((snapshot) {
                  unawaited(
                    deps.metricsCollector.recordRead(
                      count: snapshot.docs.length,
                    ),
                  );
                  return snapshot;
                }),
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
                        final name = data['name'] as String?;
                        final active = data['active'] as bool? ?? true;
                        final isSelf = doc.id == session?.userId;
                        final displayName = (name == null || name.isEmpty)
                            ? 'Member'
                            : name;
                        final displayRole = _formatRole(role);
                        return Card(
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        displayName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      displayRole,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  email,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
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
                  Expanded(child: SelectableText('Invite Code: $_inviteCode')),
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

class _MetricsGraphPanel extends StatelessWidget {
  const _MetricsGraphPanel({
    required this.buckets,
    required this.range,
  });

  final List<MetricsBucket> buckets;
  final MetricsRange range;

  @override
  Widget build(BuildContext context) {
    if (buckets.isEmpty) {
      return const Text('No recent database activity recorded.');
    }
    final totals = _metricsTotals(buckets);
    final readColor = Theme.of(context).colorScheme.primary;
    final writeColor = Theme.of(context).colorScheme.tertiary;
    return LayoutBuilder(
      builder: (context, constraints) {
        final graph = _ReadWriteGraph(
          buckets: buckets,
          readColor: readColor,
          writeColor: writeColor,
          height: 160,
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _rangeLabel(range),
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _LegendChip(
                  color: readColor,
                  label: 'Reads (${totals.reads})',
                ),
                _LegendChip(
                  color: writeColor,
                  label: 'Writes (${totals.writes})',
                ),
              ],
            ),
            const SizedBox(height: 12),
            graph,
          ],
        );
      },
    );
  }
}

class _ReadWriteGraph extends StatelessWidget {
  const _ReadWriteGraph({
    required this.buckets,
    required this.readColor,
    required this.writeColor,
    required this.height,
  });

  final List<MetricsBucket> buckets;
  final Color readColor;
  final Color writeColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    final maxValue = buckets.fold<int>(
      0,
      (max, bucket) {
        final localMax = bucket.reads > bucket.writes
            ? bucket.reads
            : bucket.writes;
        return localMax > max ? localMax : max;
      },
    );
    if (maxValue == 0) {
      return SizedBox(
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              'No reads or writes yet',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
      );
    }
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _ReadWriteGraphPainter(
          buckets: buckets,
          readColor: readColor,
          writeColor: writeColor,
          gridColor: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
    );
  }
}

class _ReadWriteGraphPainter extends CustomPainter {
  _ReadWriteGraphPainter({
    required this.buckets,
    required this.readColor,
    required this.writeColor,
    required this.gridColor,
  });

  final List<MetricsBucket> buckets;
  final Color readColor;
  final Color writeColor;
  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (buckets.isEmpty) {
      return;
    }
    final maxValue = buckets.fold<int>(
      0,
      (max, bucket) {
        final localMax = bucket.reads > bucket.writes
            ? bucket.reads
            : bucket.writes;
        return localMax > max ? localMax : max;
      },
    );
    if (maxValue == 0) {
      return;
    }

    final baselinePaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      baselinePaint,
    );

    final bucketWidth = size.width / buckets.length;
    final barWidth = bucketWidth * 0.35;
    final gap = bucketWidth * 0.1;
    final padding = bucketWidth * 0.1;

    for (var i = 0; i < buckets.length; i++) {
      final bucket = buckets[i];
      final startX = i * bucketWidth + padding;
      final readHeight = (bucket.reads / maxValue) * size.height;
      final writeHeight = (bucket.writes / maxValue) * size.height;
      final readRect = Rect.fromLTWH(
        startX,
        size.height - readHeight,
        barWidth,
        readHeight,
      );
      final writeRect = Rect.fromLTWH(
        startX + barWidth + gap,
        size.height - writeHeight,
        barWidth,
        writeHeight,
      );
      canvas.drawRect(readRect, Paint()..color = readColor);
      canvas.drawRect(writeRect, Paint()..color = writeColor);
    }
  }

  @override
  bool shouldRepaint(covariant _ReadWriteGraphPainter oldDelegate) {
    return oldDelegate.buckets != buckets ||
        oldDelegate.readColor != readColor ||
        oldDelegate.writeColor != writeColor ||
        oldDelegate.gridColor != gridColor;
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}

String _rangeLabel(MetricsRange range) {
  switch (range) {
    case MetricsRange.last20Minutes:
      return 'Last 20 minutes';
    case MetricsRange.last1Hour:
      return 'Last 1 hour';
    case MetricsRange.last24Hours:
      return 'Last 24 hours';
  }
}

({int reads, int writes}) _metricsTotals(List<MetricsBucket> buckets) {
  var reads = 0;
  var writes = 0;
  for (final bucket in buckets) {
    reads += bucket.reads;
    writes += bucket.writes;
  }
  return (reads: reads, writes: writes);
}
