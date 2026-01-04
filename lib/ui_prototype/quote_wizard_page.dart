part of '../ui_prototype.dart';

class QuoteWizardPage extends StatefulWidget {
  const QuoteWizardPage({super.key, this.initialClientId});

  final String? initialClientId;

  @override
  State<QuoteWizardPage> createState() => _QuoteWizardPageState();
}

class _QuoteWizardPageState extends State<QuoteWizardPage> {
  late ClientsRepositoryLocalFirst _clientsRepo;
  late QuotesRepositoryLocalFirst _quotesRepo;
  late OrgSettingsRepositoryLocalFirst _orgSettingsRepo;
  late PricingProfilesRepositoryLocalFirst _pricingProfilesRepo;
  late PricingProfileCatalogRepositoryLocalFirst _pricingCatalogRepo;
  StreamSubscription<OrgSettings>? _orgSettingsSub;
  OrgSettings _orgSettings = OrgSettings.defaults;
  String pricingProfileId = 'default';

  String? clientId;
  String clientName = '';
  String serviceType = 'Standard Clean';
  String frequency = 'Bi-weekly';
  String lastProClean = '> 1 month';
  bool _isCreatingQuote = false;
  Client? _selectedClient;
  List<_ServiceTypeStandard> _serviceTypeStandards = const [];
  List<String> _serviceTypeOptions = const [
    'Standard Clean',
    'Deep Clean',
    'Move-out Clean',
  ];
  List<String> _frequencyOptions = const [];

  @override
  void initState() {
    super.initState();
    _loadSettingsOptions();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final deps = AppDependencies.of(context);
    _clientsRepo = deps.clientsRepository;
    _quotesRepo = deps.quotesRepository;
    _orgSettingsRepo = deps.orgSettingsRepository;
    _pricingProfilesRepo = deps.pricingProfilesRepository;
    _pricingCatalogRepo = deps.pricingProfileCatalogRepository;

    _orgSettingsSub ??= _orgSettingsRepo.stream().listen((settings) {
      if (!mounted) {
        return;
      }
      final nextProfileId = settings.defaultPricingProfileId.isEmpty
          ? 'default'
          : settings.defaultPricingProfileId;
      setState(() {
        _orgSettings = settings;
        if (pricingProfileId != nextProfileId) {
          pricingProfileId = nextProfileId;
          _loadSettingsOptionsForProfile(nextProfileId);
        }
      });
    });
  }

  @override
  void dispose() {
    _orgSettingsSub?.cancel();
    super.dispose();
  }

  bool _initFailed = false;
  bool _didInitClient = false;

  Future<void> _loadSettingsOptions() async {
    await _loadSettingsOptionsForProfile(pricingProfileId);
  }

  Future<void> _loadSettingsOptionsForProfile(String profileId) async {
    try {
      final serviceTypes = profileId == 'default'
          ? await _loadList(
              'assets/settings/service_type_standards.json',
              _ServiceTypeStandard.fromJson,
            )
          : await _loadProfileServiceTypes(profileId);
      final frequencies = profileId == 'default'
          ? await _loadList(
              'assets/settings/frequency_standards.json',
              _FrequencyStandard.fromJson,
            )
          : await _loadProfileFrequencies(profileId);

      if (serviceTypes.isEmpty) {
        throw StateError('Service type standards failed to load (empty list)');
      }

      if (frequencies.isEmpty) {
        throw StateError('Frequency standards failed to load (empty list)');
      }

      if (!mounted) return;
      setState(() {
        if (serviceTypes.isNotEmpty) {
          final sorted = serviceTypes.toList()
            ..sort((a, b) => a.row.compareTo(b.row));
          _serviceTypeStandards = sorted;
          _serviceTypeOptions = sorted.map((s) => s.serviceType).toList();
          if (!_serviceTypeOptions.contains(serviceType)) {
            serviceType = _serviceTypeOptions.first;
          }
        }
        if (frequencies.isNotEmpty) {
          _frequencyOptions = frequencies
              .map((f) => f.frequency)
              .toSet()
              .toList();
          if (!_frequencyOptions.contains(frequency)) {
            frequency = _frequencyOptions.first;
          }
        }
      });
    } catch (e, s) {
      _initFailed = true;
      debugPrint('Settings load failed: $e');
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }

  Future<List<_ServiceTypeStandard>> _loadProfileServiceTypes(
    String profileId,
  ) async {
    final catalog = await _pricingCatalogRepo.loadCatalog(profileId);
    return catalog.serviceTypes
        .map(
          (row) => _ServiceTypeStandard(
            row: row.row,
            category: row.category,
            serviceType: row.serviceType,
            description: row.description,
            pricePerSqFt: row.pricePerSqFt,
            multiplier: row.multiplier,
          ),
        )
        .toList();
  }

  Future<List<_FrequencyStandard>> _loadProfileFrequencies(
    String profileId,
  ) async {
    final catalog = await _pricingCatalogRepo.loadCatalog(profileId);
    return catalog.frequencies
        .map(
          (row) => _FrequencyStandard(
            serviceType: row.serviceType,
            multiplier: row.multiplier,
            frequency: row.frequency,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_initFailed) {
      return Scaffold(
        appBar: AppBar(title: const Text('New Quote')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Failed to load quote settings.\nPlease restart the app.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('New Quote')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Client', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          StreamBuilder<List<Client>>(
            stream: _clientsRepo.streamClients(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Card(
                  child: ListTile(
                    title: const Text('Unable to load clients'),
                    subtitle: Text('${snapshot.error}'),
                  ),
                );
              }
              if (!snapshot.hasData) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              final clients = snapshot.data!;
              if (clients.isEmpty) {
                return const Card(
                  child: ListTile(
                    title: Text('No clients yet'),
                    subtitle: Text('Create a client first to build a quote.'),
                  ),
                );
              }

              if (!_didInitClient && clientId == null) {
                _didInitClient = true;

                final preferred = clients.where(
                  (c) => c.id == widget.initialClientId,
                );
                final selected = preferred.isNotEmpty
                    ? preferred.first
                    : clients.first;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) return;
                  setState(() {
                    clientId = selected.id;
                    clientName = selected.displayName;
                    _selectedClient = selected;
                  });
                });
              }

              return DropdownButtonFormField<String>(
                initialValue: clientId,
                items: clients
                    .map(
                      (c) => DropdownMenuItem(
                        value: c.id,
                        child: Text(c.displayName),
                      ),
                    )
                    .toList(),
                isExpanded: true,
                onChanged: (v) {
                  final selected = clients.firstWhere((c) => c.id == v);
                  setState(() {
                    clientId = selected.id;
                    clientName = selected.displayName;
                    _selectedClient = selected;
                  });
                },
                decoration: const InputDecoration(labelText: 'Select client'),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Pricing Profile',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          StreamBuilder<List<PricingProfileHeader>>(
            stream: _pricingProfilesRepo.streamProfiles(),
            builder: (context, snapshot) {
              final profiles = snapshot.data ?? const [];
              final items = [
                const DropdownMenuItem(
                  value: 'default',
                  child: Text('Default'),
                ),
                ...profiles.map(
                  (profile) => DropdownMenuItem(
                    value: profile.id,
                    child: Text(profile.name),
                  ),
                ),
              ];
              if (!items.any((item) => item.value == pricingProfileId)) {
                pricingProfileId = 'default';
              }
              return DropdownButtonFormField<String>(
                value: pricingProfileId,
                items: items,
                isExpanded: true,
                onChanged: (value) {
                  final next = value ?? 'default';
                  setState(() {
                    pricingProfileId = next;
                  });
                  unawaited(_loadSettingsOptionsForProfile(next));
                },
                decoration: const InputDecoration(
                  labelText: 'Select pricing profile',
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text('Quote Details', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          _serviceTypeDropdown(),
          const SizedBox(height: 12),
          _dropdown(
            'Frequency',
            frequency,
            _frequencyOptions,
            (v) => setState(() => frequency = v),
          ),
          const SizedBox(height: 12),
          _dropdown(
            'Last Professional Cleaning',
            lastProClean,
            const ['< 2 weeks', '2 - 4 weeks', '> 1 month', 'Never'],
            (v) => setState(() => lastProClean = v),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _isCreatingQuote
                ? null
                : () async {
                    if (clientId == null) {
                      _snack(context, 'Select a client to continue.');
                      return;
                    }

                    setState(() => _isCreatingQuote = true);

                    try {
                      final lastName =
                          _selectedClient?.lastName.trim().isNotEmpty == true
                          ? _selectedClient!.lastName.trim()
                          : _fallbackLastName();
                      final quoteTitle =
                          '${_today()} | $lastName\n$serviceType';
                      final newId = _quotesRepo.newQuoteId();
                      final profileId = pricingProfileId;
                      final header = profileId == 'default'
                          ? null
                          : await _pricingProfilesRepo.getProfileById(
                              profileId,
                            );
                      final ratesSource = header == null
                          ? _orgSettings
                          : OrgSettings(
                              laborRate: header.laborRate,
                              taxEnabled: header.taxEnabled,
                              taxRate: header.taxRate,
                              ccEnabled: header.ccEnabled,
                              ccRate: header.ccRate,
                              defaultPricingProfileId:
                                  _orgSettings.defaultPricingProfileId,
                            );
                      final draft = QuoteDraft(
                        clientId: clientId!,
                        clientName: clientName,
                        quoteName: quoteTitle,
                        quoteDate: _today(),
                        serviceType: serviceType,
                        frequency: frequency,
                        lastProClean: lastProClean,
                        status: 'Draft',
                        total: 0.0,
                        address: _formatClientAddress(_selectedClient),
                        totalSqFt: '',
                        useTotalSqFt: true,
                        estimatedSqFt: '',
                        petsPresent: false,
                        homeOccupied: true,
                        entryCode: '',
                        paymentMethod: 'Zelle',
                        feedbackDiscussed: false,
                        laborRate: ratesSource.laborRate,
                        taxEnabled: ratesSource.taxEnabled,
                        ccEnabled: ratesSource.ccEnabled,
                        taxRate: ratesSource.taxRate,
                        ccRate: ratesSource.ccRate,
                        pricingProfileId: profileId,
                        defaultRoomType: 'Bedroom',
                        defaultLevel: 'Main Floor',
                        defaultSize: 'M',
                        defaultComplexity: 'Medium',
                        subItemType: 'Ceiling Fan',
                        specialNotes: '',
                        items: const [],
                      );

                      await _quotesRepo.setQuote(newId, draft, isNew: true);

                      if (!mounted) return;

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => QuoteEditorPage(
                            repo: _quotesRepo,
                            quote: Quote(
                              id: newId,
                              clientId: draft.clientId,
                              clientName: draft.clientName,
                              quoteName: draft.quoteName,
                              quoteDate: draft.quoteDate,
                              serviceType: draft.serviceType,
                              frequency: draft.frequency,
                              lastProClean: draft.lastProClean,
                              status: draft.status,
                              total: draft.total,
                              address: draft.address,
                              totalSqFt: draft.totalSqFt,
                              useTotalSqFt: draft.useTotalSqFt,
                              estimatedSqFt: draft.estimatedSqFt,
                              petsPresent: draft.petsPresent,
                              homeOccupied: draft.homeOccupied,
                              entryCode: draft.entryCode,
                              paymentMethod: draft.paymentMethod,
                              feedbackDiscussed: draft.feedbackDiscussed,
                              laborRate: draft.laborRate,
                              taxEnabled: draft.taxEnabled,
                              ccEnabled: draft.ccEnabled,
                              taxRate: draft.taxRate,
                              ccRate: draft.ccRate,
                              pricingProfileId: draft.pricingProfileId,
                              defaultRoomType: draft.defaultRoomType,
                              defaultLevel: draft.defaultLevel,
                              defaultSize: draft.defaultSize,
                              defaultComplexity: draft.defaultComplexity,
                              subItemType: draft.subItemType,
                              specialNotes: draft.specialNotes,
                              items: draft.items,
                            ),
                          ),
                        ),
                      );
                    } catch (e, s) {
                      debugPrint('Quote create failed: $e');
                      debugPrintStack(stackTrace: s);

                      if (!context.mounted) return;
                      _snack(
                        context,
                        'Unable to start quote. Please try again.',
                      );
                    } finally {
                      if (mounted) setState(() => _isCreatingQuote = false);
                    }
                  },
            child: _isCreatingQuote
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text('Starting...'),
                    ],
                  )
                : const Text('Continue to Rooms'),
          ),
        ],
      ),
    );
  }

  Widget _dropdown(
    String label,
    String value,
    List<String> items,
    ValueChanged<String> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: items
          .map((s) => DropdownMenuItem(value: s, child: Text(s)))
          .toList(),
      isExpanded: true,
      onChanged: (v) => onChanged(v ?? value),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  String _today() {
    final now = DateTime.now();
    final mm = now.month.toString().padLeft(2, '0');
    final dd = now.day.toString().padLeft(2, '0');
    final yyyy = now.year.toString();
    return '$mm/$dd/$yyyy';
  }

  String _formatClientAddress(Client? client) {
    if (client == null) {
      return '';
    }
    final street = [
      client.street1,
      client.street2,
    ].where((line) => line.trim().isNotEmpty).join(', ');
    final cityStateZip = [
      client.city,
      client.state,
      client.zip,
    ].where((part) => part.trim().isNotEmpty).join(' ');
    final parts = [
      if (street.trim().isNotEmpty) street,
      if (cityStateZip.trim().isNotEmpty) cityStateZip,
    ];
    return parts.join(', ');
  }

  String _fallbackLastName() {
    final parts = clientName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) {
      return 'Client';
    }
    return parts.last;
  }

  Widget _serviceTypeDropdown() {
    final items = _serviceTypeMenuItems();
    final theme = Theme.of(context);
    // quick lookup: serviceType -> description
    final descByType = {
      for (final s in _serviceTypeStandards) s.serviceType: s.description,
    };

    return DropdownButtonFormField<String>(
      initialValue: serviceType,
      items: items,
      isExpanded: true,
      isDense: false,
      itemHeight: null,

      selectedItemBuilder: (context) {
        return items.map((menuItem) {
          final v = menuItem.value ?? '';

          // headings: just show the text (won’t actually be selected, but needed for list length)
          if (menuItem.enabled == false) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Text(
                v.replaceFirst(
                  '__service-category-',
                  '',
                ), // "Residential", etc.
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            );
          }

          final desc = (descByType[v] ?? '').trim();

          return Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(v, maxLines: 1, overflow: TextOverflow.ellipsis),
                if (desc.isNotEmpty)
                  Text(
                    desc,
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          );
        }).toList();
      },

      onChanged: (v) => setState(() => serviceType = v ?? serviceType),
      decoration: InputDecoration(
        labelText: 'Service Type',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 12,
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _serviceTypeMenuItems() {
    if (_serviceTypeStandards.isEmpty) {
      return _serviceTypeOptions
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList();
    }
    final theme = Theme.of(context);
    final items = <DropdownMenuItem<String>>[];
    String? currentCategory;
    final seenServiceTypes = <String>{};
    for (final item in _serviceTypeStandards) {
      if (seenServiceTypes.contains(item.serviceType)) {
        continue;
      }
      if (item.category != currentCategory) {
        currentCategory = item.category;
        items.add(
          DropdownMenuItem<String>(
            value: '__service-category-${item.category}',
            enabled: false,
            child: Text(
              item.category,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        );
      }
      items.add(
        DropdownMenuItem<String>(
          value: item.serviceType,
          child: Padding(
            padding: const EdgeInsets.only(left: 12), // ✅ indent under heading
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.serviceType,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.description.trim().isNotEmpty)
                  Text(
                    item.description,
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ),
      );
      seenServiceTypes.add(item.serviceType);
    }
    return items;
  }
}
