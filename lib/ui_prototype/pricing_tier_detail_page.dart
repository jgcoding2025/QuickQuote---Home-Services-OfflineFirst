part of '../ui_prototype.dart';

class PricingTierDetailPage extends StatefulWidget {
  const PricingTierDetailPage({
    super.key,
    required this.profileId,
    required this.initialProfile,
    required this.isDefault,
    required this.orgSettings,
    required this.pricingProfilesRepo,
    required this.pricingCatalogRepo,
    required this.settingsData,
  });

  final String profileId;
  final PricingProfileHeader initialProfile;
  final bool isDefault;
  final OrgSettings orgSettings;
  final PricingProfilesRepositoryLocalFirst pricingProfilesRepo;
  final PricingProfileCatalogRepositoryLocalFirst pricingCatalogRepo;
  final SettingsData settingsData;

  @override
  State<PricingTierDetailPage> createState() => _PricingTierDetailPageState();
}

class _PricingTierDetailPageState extends State<PricingTierDetailPage> {
  late List<PlanTier> planTiers;

  @override
  void initState() {
    super.initState();
    unawaited(widget.pricingProfilesRepo.ensureDefaultCatalogSeeded());
    planTiers = List<PlanTier>.from(widget.settingsData.planTiers);
  }

  @override
  Widget build(BuildContext context) {
    final isEditable = !widget.isDefault;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialProfile.name),
        actions: [
          if (isEditable)
            IconButton(
              tooltip: 'Rename profile',
              onPressed: () => _renameProfile(context, widget.initialProfile),
              icon: const Icon(Icons.edit),
            ),
        ],
        bottom: kDebugMode
            ? PreferredSize(
                preferredSize:
                    const Size.fromHeight(SyncStatusBanner.preferredHeight),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: SyncStatusBanner(
                    onInfo: () => _showSyncStatusHelp(context),
                  ),
                ),
              )
            : null,
      ),
      body: StreamBuilder<List<PricingProfileHeader>>(
        stream: widget.pricingProfilesRepo.streamProfiles(),
        builder: (context, snapshot) {
          final profiles = snapshot.data ?? const [];
          final profile = profiles.firstWhere(
            (p) => p.id == widget.profileId,
            orElse: () => widget.initialProfile,
          );
          return StreamBuilder<PricingProfileCatalog>(
            stream: widget.pricingCatalogRepo.streamCatalog(widget.profileId),
            builder: (context, catalogSnap) {
              final catalog = catalogSnap.data ?? PricingProfileCatalog.empty();
              if (widget.isDefault) {
                return _buildCatalogView(
                  context,
                  profile,
                  catalog,
                  catalog,
                  isEditable,
                );
              }
              return StreamBuilder<PricingProfileCatalog>(
                stream: widget.pricingCatalogRepo.streamCatalog('default'),
                builder: (context, defaultSnap) {
                  final defaultCatalog =
                      defaultSnap.data ?? PricingProfileCatalog.empty();
                  return _buildCatalogView(
                    context,
                    profile,
                    catalog,
                    defaultCatalog,
                    isEditable,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCatalogView(
    BuildContext context,
    PricingProfileHeader profile,
    PricingProfileCatalog catalog,
    PricingProfileCatalog defaultCatalog,
    bool isEditable,
  ) {
    final syncService = AppDependencies.of(context).syncService;
    return RefreshIndicator(
      onRefresh: () => syncService.downloadNow(
        reason: 'pull_to_refresh:pricing_profile',
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          _sectionTile(
            context,
            title: 'Labor Rate, Taxes, and Fees',
            child: _laborAndFeesSection(profile, isEditable),
          ),
          const SizedBox(height: 16),
          _sectionTile(
            context,
            title: 'Plan Tiers',
            child: planTiersSection(context),
          ),
          const SizedBox(height: 16),
          _sectionTile(
            context,
            title: 'Service Types',
            child: _serviceTypeSection(
              context,
              catalog,
              isEditable,
              defaultCatalog: defaultCatalog,
            ),
          ),
          const SizedBox(height: 16),
          _sectionTile(
            context,
            title: 'Room Type Standards',
            child: _roomTypeSection(
              context,
              catalog,
              isEditable,
              defaultCatalog: defaultCatalog,
            ),
          ),
          const SizedBox(height: 16),
          _sectionTile(
            context,
            title: 'Add-on Items',
            child: _subItemSection(
              context,
              catalog,
              isEditable,
              defaultCatalog: defaultCatalog,
            ),
          ),
          const SizedBox(height: 16),
          _sectionTile(
            context,
            title: 'Complexity, Size, and Frequency',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _complexitySection(
                  context,
                  catalog,
                  isEditable,
                  defaultCatalog: defaultCatalog,
                ),
                const SizedBox(height: 16),
                _sizeSection(
                  context,
                  catalog,
                  isEditable,
                  defaultCatalog: defaultCatalog,
                ),
                const SizedBox(height: 16),
                _frequencySection(
                  context,
                  catalog,
                  isEditable,
                  defaultCatalog: defaultCatalog,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTile(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Card(
      child: ExpansionTile(
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [const SizedBox(height: 8), child],
      ),
    );
  }

  Widget _laborAndFeesSection(PricingProfileHeader profile, bool isEditable) {
    final laborController = TextEditingController(
      text: profile.laborRate.toStringAsFixed(2),
    );
    final taxController = TextEditingController(
      text: profile.taxRate.toStringAsFixed(2),
    );
    final ccController = TextEditingController(
      text: profile.ccRate.toStringAsFixed(2),
    );
    var taxEnabled = profile.taxEnabled;
    var ccEnabled = profile.ccEnabled;

    return StatefulBuilder(
      builder: (context, setLocalState) {
        return Column(
          children: [
            TextField(
              controller: laborController,
              enabled: isEditable,
              decoration: const InputDecoration(
                labelText: 'Labor rate (\$/hr)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              value: taxEnabled,
              onChanged: isEditable
                  ? (value) => setLocalState(() => taxEnabled = value)
                  : null,
              title: const Text('Tax enabled'),
            ),
            if (taxEnabled)
              TextField(
                controller: taxController,
                enabled: isEditable,
                decoration: const InputDecoration(
                  labelText: 'Tax rate (decimal)',
                ),
                keyboardType: TextInputType.number,
              ),
            const SizedBox(height: 8),
            SwitchListTile(
              value: ccEnabled,
              onChanged: isEditable
                  ? (value) => setLocalState(() => ccEnabled = value)
                  : null,
              title: const Text('Credit card fee enabled'),
            ),
            if (ccEnabled)
              TextField(
                controller: ccController,
                enabled: isEditable,
                decoration: const InputDecoration(
                  labelText: 'CC rate (decimal)',
                ),
                keyboardType: TextInputType.number,
              ),
            if (isEditable)
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: () async {
                    final laborRate = double.tryParse(
                      laborController.text.trim(),
                    );
                    final taxRate = double.tryParse(taxController.text.trim());
                    final ccRate = double.tryParse(ccController.text.trim());
                    await widget.pricingProfilesRepo.updateProfileHeader(
                      widget.profileId,
                      laborRate: laborRate ?? profile.laborRate,
                      taxEnabled: taxEnabled,
                      taxRate: taxRate ?? profile.taxRate,
                      ccEnabled: ccEnabled,
                      ccRate: ccRate ?? profile.ccRate,
                    );
                    if (context.mounted) {
                      _snack(context, 'Profile updated.');
                    }
                  },
                  child: const Text('Save'),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget planTiersSection(BuildContext context) {
    if (planTiers.isEmpty) {
      return const Text('No plan tiers available.');
    }
    final columnWidths = <int, TableColumnWidth>{
      0: const FlexColumnWidth(1.6),
      1: const FlexColumnWidth(3.2),
      2: const FlexColumnWidth(1),
      3: const FlexColumnWidth(1),
    };
    if (isEditable) {
      columnWidths[4] = const FlexColumnWidth(1.2);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => _editPlanTiersTable(context),
            child: const Text('Edit'),
          ),
        ),
        _buildTable(
          context,
          headers: const ['Tier', 'Multiplier', 'Description'],
          columnWidths: const {
            0: FlexColumnWidth(1.4),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(3),
          },
          rows: planTiers.map((tier) {
            return [
              '${tier.name} (${tier.label})',
              tier.multiplier.toStringAsFixed(2),
              tier.description,
            ];
          }).toList(),
        ),
      ],
    );
  }

  Widget _serviceTypeSection(
    BuildContext context,
    PricingProfileCatalog catalog,
    bool isEditable, {
    required PricingProfileCatalog defaultCatalog,
  }) {
    if (catalog.serviceTypes.isEmpty) {
      if (!isEditable) {
        return const Text('No service types found.');
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('No service types found.'),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => _addServiceType(context),
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ),
        ],
      );
    }
    final sorted = _sortedServiceTypes(catalog.serviceTypes);
    final defaultSorted = _sortedServiceTypes(defaultCatalog.serviceTypes);
    final defaultMatches = _matchDefaultsByKey<PricingProfileServiceType>(
      items: sorted,
      defaults: defaultSorted,
      key: (item) => item.row.toString(),
      id: (item) => item.id,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isEditable)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => _addServiceType(context),
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ),
        _buildTable(
          context,
          headers: const [
            'Service type',
            'Description',
            '\$/Sq.Ft.',
            'Multiplier',
            if (isEditable) 'Actions',
          ],
          columnWidths: columnWidths,
          rows: sorted.map((service) {
            final defaultItem = defaultMatches[service.id];
            return [
              _diffCell(
                context,
                service.serviceType,
                _textDiff(service.serviceType, defaultItem?.serviceType),
              ),
              _diffCell(
                context,
                service.description,
                _textDiff(service.description, defaultItem?.description),
              ),
              _diffCell(
                context,
                service.pricePerSqFt.toStringAsFixed(2),
                _doubleDiff(service.pricePerSqFt, defaultItem?.pricePerSqFt),
              ),
              _diffCell(
                context,
                service.multiplier.toStringAsFixed(2),
                _doubleDiff(service.multiplier, defaultItem?.multiplier),
              ),
              if (isEditable)
                _rowActions(
                  context,
                  onEdit: () => _editServiceType(context, service),
                  onReset: defaultItem == null
                      ? null
                      : () => _resetServiceType(service, defaultItem),
                  onDelete: () => _deleteWithUndo(
                    context,
                    label: service.serviceType,
                    delete: () => widget.pricingCatalogRepo.deleteServiceType(
                      service.id,
                    ),
                    restore: () =>
                        widget.pricingCatalogRepo.restoreServiceType(
                          service.id,
                        ),
                  ),
                  hasDiff: _serviceTypeDiff(service, defaultItem),
                ),
            ];
          }).toList(),
        ),
      ],
    );
  }

  Widget _frequencySection(
    BuildContext context,
    PricingProfileCatalog catalog,
    bool isEditable, {
    required PricingProfileCatalog defaultCatalog,
  }) {
    if (catalog.frequencies.isEmpty) {
      if (!isEditable) {
        return const Text('No frequencies found.');
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('No frequencies found.'),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => _addFrequency(context),
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ),
        ],
      );
    }
    final sorted = _sortedFrequencies(catalog.frequencies);
    final defaultSorted = _sortedFrequencies(defaultCatalog.frequencies);
    final defaultMatches = _matchDefaultsByKey<PricingProfileFrequency>(
      items: sorted,
      defaults: defaultSorted,
      key: (item) =>
          '${_normalizeText(item.serviceType)}::'
          '${_normalizeText(item.frequency)}',
      id: (item) => item.id,
    );
    final columnWidths = <int, TableColumnWidth>{
      0: const FlexColumnWidth(1.8),
      1: const FlexColumnWidth(1.6),
      2: const FlexColumnWidth(1),
    };
    if (isEditable) {
      columnWidths[3] = const FlexColumnWidth(1.2);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isEditable)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => _addFrequency(context),
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ),
        _buildTable(
          context,
          headers: const [
            'Service type',
            'Frequency',
            'Multiplier',
            if (isEditable) 'Actions',
          ],
          columnWidths: columnWidths,
          rows: sorted.map((freq) {
            final defaultItem = defaultMatches[freq.id];
            return [
              _diffCell(
                context,
                freq.serviceType,
                _textDiff(freq.serviceType, defaultItem?.serviceType),
              ),
              _diffCell(
                context,
                freq.frequency,
                _textDiff(freq.frequency, defaultItem?.frequency),
              ),
              _diffCell(
                context,
                freq.multiplier.toStringAsFixed(2),
                _doubleDiff(freq.multiplier, defaultItem?.multiplier),
              ),
              if (isEditable)
                _rowActions(
                  context,
                  onEdit: () => _editFrequency(context, freq),
                  onReset: defaultItem == null
                      ? null
                      : () => _resetFrequency(freq, defaultItem),
                  onDelete: () => _deleteWithUndo(
                    context,
                    label: freq.frequency,
                    delete: () =>
                        widget.pricingCatalogRepo.deleteFrequency(freq.id),
                    restore: () =>
                        widget.pricingCatalogRepo.restoreFrequency(freq.id),
                  ),
                  hasDiff: _frequencyDiff(freq, defaultItem),
                ),
            ];
          }).toList(),
        ),
      ],
    );
  }

  Widget _roomTypeSection(
    BuildContext context,
    PricingProfileCatalog catalog,
    bool isEditable, {
    required PricingProfileCatalog defaultCatalog,
  }) {
    if (catalog.roomTypes.isEmpty) {
      if (!isEditable) {
        return const Text('No room types found.');
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('No room types found.'),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => _addRoomType(context),
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ),
        ],
      );
    }
    final sorted = _sortedRoomTypes(catalog.roomTypes);
    final defaultSorted = _sortedRoomTypes(defaultCatalog.roomTypes);
    final defaultMatches = _matchDefaultsByKey<PricingProfileRoomType>(
      items: sorted,
      defaults: defaultSorted,
      key: (item) => item.row.toString(),
      id: (item) => item.id,
    );
    final columnWidths = <int, TableColumnWidth>{
      0: const FlexColumnWidth(1.6),
      1: const FlexColumnWidth(3),
      2: const FlexColumnWidth(1),
      3: const FlexColumnWidth(1),
    };
    if (isEditable) {
      columnWidths[4] = const FlexColumnWidth(1.2);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isEditable)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => _addRoomType(context),
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ),
        _buildTable(
          context,
          headers: const [
            'Room type',
            'Description',
            'Minutes',
            'Sq.Ft.',
            if (isEditable) 'Actions',
          ],
          columnWidths: columnWidths,
          rows: sorted.map((room) {
            final defaultItem = defaultMatches[room.id];
            return [
              _diffCell(
                context,
                room.roomType,
                _textDiff(room.roomType, defaultItem?.roomType),
              ),
              _diffCell(
                context,
                room.description,
                _textDiff(room.description, defaultItem?.description),
              ),
              _diffCell(
                context,
                room.minutes.toString(),
                _intDiff(room.minutes, defaultItem?.minutes),
              ),
              _diffCell(
                context,
                room.squareFeet.toString(),
                _intDiff(room.squareFeet, defaultItem?.squareFeet),
              ),
              if (isEditable)
                _rowActions(
                  context,
                  onEdit: () => _editRoomType(context, room),
                  onReset: defaultItem == null
                      ? null
                      : () => _resetRoomType(room, defaultItem),
                  onDelete: () => _deleteWithUndo(
                    context,
                    label: room.roomType,
                    delete: () =>
                        widget.pricingCatalogRepo.deleteRoomType(room.id),
                    restore: () =>
                        widget.pricingCatalogRepo.restoreRoomType(room.id),
                  ),
                  hasDiff: _roomTypeDiff(room, defaultItem),
                ),
            ];
          }).toList(),
        ),
      ],
    );
  }

  Widget _subItemSection(
    BuildContext context,
    PricingProfileCatalog catalog,
    bool isEditable, {
    required PricingProfileCatalog defaultCatalog,
  }) {
    if (catalog.subItems.isEmpty) {
      if (!isEditable) {
        return const Text('No add-on items found.');
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('No add-on items found.'),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => _addSubItem(context),
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ),
        ],
      );
    }
    final sorted = _sortedSubItems(catalog.subItems);
    final defaultSorted = _sortedSubItems(defaultCatalog.subItems);
    final defaultMatches = _matchDefaultsByKey<PricingProfileSubItem>(
      items: sorted,
      defaults: defaultSorted,
      key: (item) =>
          '${_normalizeText(item.subItem)}::${_normalizeText(item.description)}'
          '::${item.minutes}',
      id: (item) => item.id,
    );
    final columnWidths = <int, TableColumnWidth>{
      0: const FlexColumnWidth(1.6),
      1: const FlexColumnWidth(3),
      2: const FlexColumnWidth(1),
    };
    if (isEditable) {
      columnWidths[3] = const FlexColumnWidth(1.2);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isEditable)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => _addSubItem(context),
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ),
        _buildTable(
          context,
          headers: const [
            'Add-on item',
            'Description',
            'Minutes',
            if (isEditable) 'Actions',
          ],
          columnWidths: columnWidths,
          rows: sorted.map((item) {
            final defaultItem = defaultMatches[item.id];
            return [
              _diffCell(
                context,
                item.subItem,
                _textDiff(item.subItem, defaultItem?.subItem),
              ),
              _diffCell(
                context,
                item.description,
                _textDiff(item.description, defaultItem?.description),
              ),
              _diffCell(
                context,
                item.minutes.toString(),
                _intDiff(item.minutes, defaultItem?.minutes),
              ),
              if (isEditable)
                _rowActions(
                  context,
                  onEdit: () => _editSubItem(context, item),
                  onReset: defaultItem == null
                      ? null
                      : () => _resetSubItem(item, defaultItem),
                  onDelete: () => _deleteWithUndo(
                    context,
                    label: item.subItem,
                    delete: () =>
                        widget.pricingCatalogRepo.deleteSubItem(item.id),
                    restore: () =>
                        widget.pricingCatalogRepo.restoreSubItem(item.id),
                  ),
                  hasDiff: _subItemDiff(item, defaultItem),
                ),
            ];
          }).toList(),
        ),
      ],
    );
  }

  Widget _sizeSection(
    BuildContext context,
    PricingProfileCatalog catalog,
    bool isEditable, {
    required PricingProfileCatalog defaultCatalog,
  }) {
    if (catalog.sizes.isEmpty) {
      if (!isEditable) {
        return const Text('No size standards found.');
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('No size standards found.'),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => _addSize(context),
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ),
        ],
      );
    }
    final sorted = _sortedSizes(catalog.sizes);
    final defaultSorted = _sortedSizes(defaultCatalog.sizes);
    final defaultMatches = _matchDefaultsByKey<PricingProfileSize>(
      items: sorted,
      defaults: defaultSorted,
      key: (item) =>
          '${_normalizeText(item.size)}::${_normalizeText(item.definition)}',
      id: (item) => item.id,
    );
    final columnWidths = <int, TableColumnWidth>{
      0: const FlexColumnWidth(1.2),
      1: const FlexColumnWidth(3),
      2: const FlexColumnWidth(1),
    };
    if (isEditable) {
      columnWidths[3] = const FlexColumnWidth(1.2);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isEditable)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => _addSize(context),
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ),
        _buildTable(
          context,
          headers: const [
            'Size',
            'Definition',
            'Multiplier',
            if (isEditable) 'Actions',
          ],
          columnWidths: columnWidths,
          rows: sorted.map((item) {
            final defaultItem = defaultMatches[item.id];
            return [
              _diffCell(
                context,
                item.size,
                _textDiff(item.size, defaultItem?.size),
              ),
              _diffCell(
                context,
                item.definition,
                _textDiff(item.definition, defaultItem?.definition),
              ),
              _diffCell(
                context,
                item.multiplier.toStringAsFixed(2),
                _doubleDiff(item.multiplier, defaultItem?.multiplier),
              ),
              if (isEditable)
                _rowActions(
                  context,
                  onEdit: () => _editSize(context, item),
                  onReset: defaultItem == null
                      ? null
                      : () => _resetSize(item, defaultItem),
                  onDelete: () => _deleteWithUndo(
                    context,
                    label: item.size,
                    delete: () =>
                        widget.pricingCatalogRepo.deleteSize(item.id),
                    restore: () =>
                        widget.pricingCatalogRepo.restoreSize(item.id),
                  ),
                  hasDiff: _sizeDiff(item, defaultItem),
                ),
            ];
          }).toList(),
        ),
      ],
    );
  }

  Widget _complexitySection(
    BuildContext context,
    PricingProfileCatalog catalog,
    bool isEditable, {
    required PricingProfileCatalog defaultCatalog,
  }) {
    if (catalog.complexities.isEmpty) {
      if (!isEditable) {
        return const Text('No complexity standards found.');
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('No complexity standards found.'),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => _addComplexity(context),
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ),
        ],
      );
    }
    final sorted = _sortedComplexities(catalog.complexities);
    final defaultSorted = _sortedComplexities(defaultCatalog.complexities);
    final defaultMatches = _matchDefaultsByKey<PricingProfileComplexity>(
      items: sorted,
      defaults: defaultSorted,
      key: (item) =>
          '${_normalizeText(item.level)}::${_normalizeText(item.definition)}',
      id: (item) => item.id,
    );
    final columnWidths = <int, TableColumnWidth>{
      0: const FlexColumnWidth(1.4),
      1: const FlexColumnWidth(3),
      2: const FlexColumnWidth(1),
    };
    if (isEditable) {
      columnWidths[3] = const FlexColumnWidth(1.2);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isEditable)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => _addComplexity(context),
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ),
        _buildTable(
          context,
          headers: const [
            'Complexity',
            'Definition',
            'Multiplier',
            if (isEditable) 'Actions',
          ],
          columnWidths: columnWidths,
          rows: sorted.map((item) {
            final defaultItem = defaultMatches[item.id];
            return [
              _diffCell(
                context,
                item.level,
                _textDiff(item.level, defaultItem?.level),
              ),
              _diffCell(
                context,
                item.definition,
                _textDiff(item.definition, defaultItem?.definition),
              ),
              _diffCell(
                context,
                item.multiplier.toStringAsFixed(2),
                _doubleDiff(item.multiplier, defaultItem?.multiplier),
              ),
              if (isEditable)
                _rowActions(
                  context,
                  onEdit: () => _editComplexity(context, item),
                  onReset: defaultItem == null
                      ? null
                      : () => _resetComplexity(item, defaultItem),
                  onDelete: () => _deleteWithUndo(
                    context,
                    label: item.level,
                    delete: () => widget.pricingCatalogRepo.deleteComplexity(
                      item.id,
                    ),
                    restore: () => widget.pricingCatalogRepo.restoreComplexity(
                      item.id,
                    ),
                  ),
                  hasDiff: _complexityDiff(item, defaultItem),
                ),
            ];
          }).toList(),
        ),
      ],
    );
  }

  Future<void> _editServiceType(
    BuildContext context,
    PricingProfileServiceType service,
  ) async {
    final nameController = TextEditingController(text: service.serviceType);
    final priceController = TextEditingController(
      text: service.pricePerSqFt.toStringAsFixed(2),
    );
    final multiplierController = TextEditingController(
      text: service.multiplier.toStringAsFixed(2),
    );
    final descriptionController = TextEditingController(
      text: service.description,
    );
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${service.serviceType}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Service type'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price per sq ft'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: multiplierController,
              decoration: const InputDecoration(labelText: 'Multiplier'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final price =
                  double.tryParse(priceController.text.trim()) ??
                  service.pricePerSqFt;
              final multiplier =
                  double.tryParse(multiplierController.text.trim()) ??
                  service.multiplier;
              await widget.pricingCatalogRepo.updateServiceType(
                id: service.id,
                serviceType: nameController.text.trim().isEmpty
                    ? service.serviceType
                    : nameController.text.trim(),
                description: descriptionController.text.trim(),
                pricePerSqFt: price,
                multiplier: multiplier,
              );
              if (context.mounted) {
                Navigator.pop(context);
                setState(() {});
                _snack(context, 'Service type updated.');
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _editFrequency(
    BuildContext context,
    PricingProfileFrequency frequency,
  ) async {
    final serviceTypeController = TextEditingController(
      text: frequency.serviceType,
    );
    final frequencyController = TextEditingController(
      text: frequency.frequency,
    );
    final multiplierController = TextEditingController(
      text: frequency.multiplier.toStringAsFixed(2),
    );
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${frequency.frequency}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: serviceTypeController,
              decoration: const InputDecoration(labelText: 'Service type'),
            ),
            TextField(
              controller: frequencyController,
              decoration: const InputDecoration(labelText: 'Frequency'),
            ),
            TextField(
              controller: multiplierController,
              decoration: const InputDecoration(labelText: 'Multiplier'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final multiplier =
                  double.tryParse(multiplierController.text.trim()) ??
                  frequency.multiplier;
              await widget.pricingCatalogRepo.updateFrequency(
                id: frequency.id,
                serviceType: serviceTypeController.text.trim().isEmpty
                    ? frequency.serviceType
                    : serviceTypeController.text.trim(),
                frequency: frequencyController.text.trim().isEmpty
                    ? frequency.frequency
                    : frequencyController.text.trim(),
                multiplier: multiplier,
              );
              if (context.mounted) {
                Navigator.pop(context);
                setState(() {});
                _snack(context, 'Frequency updated.');
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _editRoomType(
    BuildContext context,
    PricingProfileRoomType roomType,
  ) async {
    final nameController = TextEditingController(text: roomType.roomType);
    final descriptionController = TextEditingController(
      text: roomType.description,
    );
    final minutesController = TextEditingController(
      text: roomType.minutes.toString(),
    );
    final squareFeetController = TextEditingController(
      text: roomType.squareFeet.toString(),
    );
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${roomType.roomType}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Room type'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: minutesController,
              decoration: const InputDecoration(labelText: 'Minutes'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: squareFeetController,
              decoration: const InputDecoration(labelText: 'Square feet'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final minutes = int.tryParse(minutesController.text.trim());
              final squareFeet = int.tryParse(squareFeetController.text.trim());
              await widget.pricingCatalogRepo.updateRoomType(
                id: roomType.id,
                roomType: nameController.text.trim().isEmpty
                    ? roomType.roomType
                    : nameController.text.trim(),
                description: descriptionController.text.trim(),
                minutes: minutes ?? roomType.minutes,
                squareFeet: squareFeet ?? roomType.squareFeet,
              );
              if (context.mounted) {
                Navigator.pop(context);
                setState(() {});
                _snack(context, 'Room type updated.');
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _editSubItem(
    BuildContext context,
    PricingProfileSubItem subItem,
  ) async {
    final nameController = TextEditingController(text: subItem.subItem);
    final descriptionController = TextEditingController(
      text: subItem.description,
    );
    final minutesController = TextEditingController(
      text: subItem.minutes.toString(),
    );
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${subItem.subItem}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Add-on item'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: minutesController,
              decoration: const InputDecoration(labelText: 'Minutes'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final minutes = int.tryParse(minutesController.text.trim());
              await widget.pricingCatalogRepo.updateSubItem(
                id: subItem.id,
                subItem: nameController.text.trim().isEmpty
                    ? subItem.subItem
                    : nameController.text.trim(),
                description: descriptionController.text.trim(),
                minutes: minutes ?? subItem.minutes,
              );
              if (context.mounted) {
                Navigator.pop(context);
                setState(() {});
                _snack(context, 'Add-on item updated.');
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _editSize(BuildContext context, PricingProfileSize size) async {
    final nameController = TextEditingController(text: size.size);
    final definitionController = TextEditingController(text: size.definition);
    final multiplierController = TextEditingController(
      text: size.multiplier.toStringAsFixed(2),
    );
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${size.size}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Size'),
            ),
            TextField(
              controller: definitionController,
              decoration: const InputDecoration(labelText: 'Definition'),
            ),
            TextField(
              controller: multiplierController,
              decoration: const InputDecoration(labelText: 'Multiplier'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final multiplier =
                  double.tryParse(multiplierController.text.trim()) ??
                  size.multiplier;
              await widget.pricingCatalogRepo.updateSize(
                id: size.id,
                size: nameController.text.trim().isEmpty
                    ? size.size
                    : nameController.text.trim(),
                definition: definitionController.text.trim(),
                multiplier: multiplier,
              );
              if (context.mounted) {
                Navigator.pop(context);
                setState(() {});
                _snack(context, 'Size updated.');
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _editComplexity(
    BuildContext context,
    PricingProfileComplexity complexity,
  ) async {
    final levelController = TextEditingController(text: complexity.level);
    final definitionController = TextEditingController(
      text: complexity.definition,
    );
    final multiplierController = TextEditingController(
      text: complexity.multiplier.toStringAsFixed(2),
    );
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${complexity.level}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: levelController,
              decoration: const InputDecoration(labelText: 'Complexity'),
            ),
            TextField(
              controller: definitionController,
              decoration: const InputDecoration(labelText: 'Definition'),
            ),
            TextField(
              controller: multiplierController,
              decoration: const InputDecoration(labelText: 'Multiplier'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final multiplier =
                  double.tryParse(multiplierController.text.trim()) ??
                  complexity.multiplier;
              await widget.pricingCatalogRepo.updateComplexity(
                id: complexity.id,
                level: levelController.text.trim().isEmpty
                    ? complexity.level
                    : levelController.text.trim(),
                definition: definitionController.text.trim(),
                multiplier: multiplier,
              );
              if (context.mounted) {
                Navigator.pop(context);
                setState(() {});
                _snack(context, 'Complexity updated.');
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _editPlanTiersTable(BuildContext context) async {
    var selected = planTiers.first;
    final multiplierController = TextEditingController(
      text: selected.multiplier.toStringAsFixed(2),
    );
    final descriptionController = TextEditingController(
      text: selected.description,
    );

    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Plan Tier'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: selected.name,
                items: planTiers
                    .map(
                      (tier) => DropdownMenuItem(
                        value: tier.name,
                        child: Text('${tier.name} (${tier.label})'),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  final next = planTiers.firstWhere(
                    (tier) => tier.name == value,
                  );
                  setState(() {
                    selected = next;
                    multiplierController.text = next.multiplier.toStringAsFixed(
                      2,
                    );
                    descriptionController.text = next.description;
                  });
                },
                decoration: const InputDecoration(labelText: 'Tier'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: multiplierController,
                decoration: const InputDecoration(labelText: 'Multiplier'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final multiplier =
                    double.tryParse(multiplierController.text.trim()) ??
                    selected.multiplier;
                final description = descriptionController.text.trim();
                setState(() {
                  planTiers = planTiers.map((tier) {
                    if (tier.name != selected.name) {
                      return tier;
                    }
                    return PlanTier(
                      name: tier.name,
                      label: tier.label,
                      color: tier.color,
                      multiplier: multiplier,
                      description: description.isEmpty
                          ? tier.description
                          : description,
                    );
                  }).toList();
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addServiceType(BuildContext context) async {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController(text: '0');
    final multiplierController = TextEditingController(text: '1');
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Service Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Service type'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price per sq ft'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: multiplierController,
              decoration: const InputDecoration(labelText: 'Multiplier'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isEmpty) {
                return;
              }
              final price =
                  double.tryParse(priceController.text.trim()) ?? 0;
              final multiplier =
                  double.tryParse(multiplierController.text.trim()) ?? 1;
              await widget.pricingCatalogRepo.createServiceType(
                profileId: widget.profileId,
                serviceType: name,
                description: descriptionController.text.trim(),
                pricePerSqFt: price,
                multiplier: multiplier,
              );
              if (context.mounted) {
                Navigator.pop(context);
                setState(() {});
                _snack(context, 'Service type added.');
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _addFrequency(BuildContext context) async {
    final serviceTypeController = TextEditingController();
    final frequencyController = TextEditingController();
    final multiplierController = TextEditingController(text: '1');
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Frequency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: serviceTypeController,
              decoration: const InputDecoration(labelText: 'Service type'),
            ),
            TextField(
              controller: frequencyController,
              decoration: const InputDecoration(labelText: 'Frequency'),
            ),
            TextField(
              controller: multiplierController,
              decoration: const InputDecoration(labelText: 'Multiplier'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final serviceType = serviceTypeController.text.trim();
              final frequency = frequencyController.text.trim();
              if (serviceType.isEmpty || frequency.isEmpty) {
                return;
              }
              final multiplier =
                  double.tryParse(multiplierController.text.trim()) ?? 1;
              await widget.pricingCatalogRepo.createFrequency(
                profileId: widget.profileId,
                serviceType: serviceType,
                frequency: frequency,
                multiplier: multiplier,
              );
              if (context.mounted) {
                Navigator.pop(context);
                setState(() {});
                _snack(context, 'Frequency added.');
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _addRoomType(BuildContext context) async {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final minutesController = TextEditingController(text: '0');
    final squareFeetController = TextEditingController(text: '0');
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Room Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Room type'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: minutesController,
              decoration: const InputDecoration(labelText: 'Minutes'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: squareFeetController,
              decoration: const InputDecoration(labelText: 'Sq. Ft.'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isEmpty) {
                return;
              }
              final minutes = int.tryParse(minutesController.text.trim()) ?? 0;
              final squareFeet =
                  int.tryParse(squareFeetController.text.trim()) ?? 0;
              await widget.pricingCatalogRepo.createRoomType(
                profileId: widget.profileId,
                roomType: name,
                description: descriptionController.text.trim(),
                minutes: minutes,
                squareFeet: squareFeet,
              );
              if (context.mounted) {
                Navigator.pop(context);
                setState(() {});
                _snack(context, 'Room type added.');
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _addSubItem(BuildContext context) async {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final minutesController = TextEditingController(text: '0');
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Add-on Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Add-on item'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: minutesController,
              decoration: const InputDecoration(labelText: 'Minutes'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isEmpty) {
                return;
              }
              final minutes = int.tryParse(minutesController.text.trim()) ?? 0;
              await widget.pricingCatalogRepo.createSubItem(
                profileId: widget.profileId,
                subItem: name,
                description: descriptionController.text.trim(),
                minutes: minutes,
              );
              if (context.mounted) {
                Navigator.pop(context);
                setState(() {});
                _snack(context, 'Add-on item added.');
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _addSize(BuildContext context) async {
    final nameController = TextEditingController();
    final definitionController = TextEditingController();
    final multiplierController = TextEditingController(text: '1');
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Size'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Size'),
            ),
            TextField(
              controller: definitionController,
              decoration: const InputDecoration(labelText: 'Definition'),
            ),
            TextField(
              controller: multiplierController,
              decoration: const InputDecoration(labelText: 'Multiplier'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isEmpty) {
                return;
              }
              final multiplier =
                  double.tryParse(multiplierController.text.trim()) ?? 1;
              await widget.pricingCatalogRepo.createSize(
                profileId: widget.profileId,
                size: name,
                definition: definitionController.text.trim(),
                multiplier: multiplier,
              );
              if (context.mounted) {
                Navigator.pop(context);
                setState(() {});
                _snack(context, 'Size added.');
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _addComplexity(BuildContext context) async {
    final levelController = TextEditingController();
    final definitionController = TextEditingController();
    final multiplierController = TextEditingController(text: '1');
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Complexity'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: levelController,
              decoration: const InputDecoration(labelText: 'Complexity'),
            ),
            TextField(
              controller: definitionController,
              decoration: const InputDecoration(labelText: 'Definition'),
            ),
            TextField(
              controller: multiplierController,
              decoration: const InputDecoration(labelText: 'Multiplier'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final level = levelController.text.trim();
              if (level.isEmpty) {
                return;
              }
              final multiplier =
                  double.tryParse(multiplierController.text.trim()) ?? 1;
              await widget.pricingCatalogRepo.createComplexity(
                profileId: widget.profileId,
                level: level,
                definition: definitionController.text.trim(),
                multiplier: multiplier,
              );
              if (context.mounted) {
                Navigator.pop(context);
                setState(() {});
                _snack(context, 'Complexity added.');
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _resetServiceType(
    PricingProfileServiceType service,
    PricingProfileServiceType defaultItem,
  ) async {
    await widget.pricingCatalogRepo.updateServiceType(
      id: service.id,
      serviceType: defaultItem.serviceType,
      description: defaultItem.description,
      pricePerSqFt: defaultItem.pricePerSqFt,
      multiplier: defaultItem.multiplier,
    );
    if (mounted) {
      setState(() {});
      _snack(context, 'Service type reset.');
    }
  }

  Future<void> _resetFrequency(
    PricingProfileFrequency frequency,
    PricingProfileFrequency defaultItem,
  ) async {
    await widget.pricingCatalogRepo.updateFrequency(
      id: frequency.id,
      serviceType: defaultItem.serviceType,
      frequency: defaultItem.frequency,
      multiplier: defaultItem.multiplier,
    );
    if (mounted) {
      setState(() {});
      _snack(context, 'Frequency reset.');
    }
  }

  Future<void> _resetRoomType(
    PricingProfileRoomType roomType,
    PricingProfileRoomType defaultItem,
  ) async {
    await widget.pricingCatalogRepo.updateRoomType(
      id: roomType.id,
      roomType: defaultItem.roomType,
      description: defaultItem.description,
      minutes: defaultItem.minutes,
      squareFeet: defaultItem.squareFeet,
    );
    if (mounted) {
      setState(() {});
      _snack(context, 'Room type reset.');
    }
  }

  Future<void> _resetSubItem(
    PricingProfileSubItem item,
    PricingProfileSubItem defaultItem,
  ) async {
    await widget.pricingCatalogRepo.updateSubItem(
      id: item.id,
      subItem: defaultItem.subItem,
      description: defaultItem.description,
      minutes: defaultItem.minutes,
    );
    if (mounted) {
      setState(() {});
      _snack(context, 'Add-on item reset.');
    }
  }

  Future<void> _resetSize(
    PricingProfileSize size,
    PricingProfileSize defaultItem,
  ) async {
    await widget.pricingCatalogRepo.updateSize(
      id: size.id,
      size: defaultItem.size,
      definition: defaultItem.definition,
      multiplier: defaultItem.multiplier,
    );
    if (mounted) {
      setState(() {});
      _snack(context, 'Size reset.');
    }
  }

  Future<void> _resetComplexity(
    PricingProfileComplexity item,
    PricingProfileComplexity defaultItem,
  ) async {
    await widget.pricingCatalogRepo.updateComplexity(
      id: item.id,
      level: defaultItem.level,
      definition: defaultItem.definition,
      multiplier: defaultItem.multiplier,
    );
    if (mounted) {
      setState(() {});
      _snack(context, 'Complexity reset.');
    }
  }

  Future<void> _deleteWithUndo(
    BuildContext context, {
    required String label,
    required Future<void> Function() delete,
    required Future<void> Function() restore,
  }) async {
    await delete();
    if (!context.mounted) {
      return;
    }
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            await restore();
            if (context.mounted) {
              setState(() {});
              _snack(context, '$label restored.');
            }
          },
        ),
      ),
    );
  }

  Widget _rowActions(
    BuildContext context, {
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    required bool hasDiff,
    VoidCallback? onReset,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final resetColor = hasDiff ? colorScheme.primary : null;
    return Wrap(
      spacing: 4,
      children: [
        IconButton(
          tooltip: 'Edit',
          onPressed: onEdit,
          icon: const Icon(Icons.edit),
        ),
        IconButton(
          tooltip: onReset == null ? 'No default match' : 'Reset to default',
          onPressed: onReset,
          icon: Icon(Icons.restart_alt, color: resetColor),
        ),
        IconButton(
          tooltip: 'Delete',
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline),
        ),
      ],
    );
  }

  Widget _diffCell(BuildContext context, String value, bool isChanged) {
    final colorScheme = Theme.of(context).colorScheme;
    final highlight = colorScheme.primaryContainer.withOpacity(0.35);
    return Container(
      decoration: isChanged
          ? BoxDecoration(
              color: highlight,
              borderRadius: BorderRadius.circular(4),
            )
          : null,
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      child: Text(value),
    );
  }

  bool _textDiff(String value, String? defaultValue) {
    if (defaultValue == null) {
      return true;
    }
    return _normalizeText(value) != _normalizeText(defaultValue);
  }

  bool _doubleDiff(double value, double? defaultValue) {
    if (defaultValue == null) {
      return true;
    }
    return (value - defaultValue).abs() > 0.0001;
  }

  bool _intDiff(int value, int? defaultValue) {
    if (defaultValue == null) {
      return true;
    }
    return value != defaultValue;
  }

  bool _serviceTypeDiff(
    PricingProfileServiceType service,
    PricingProfileServiceType? defaultItem,
  ) {
    if (defaultItem == null) {
      return true;
    }
    return _textDiff(service.serviceType, defaultItem.serviceType) ||
        _textDiff(service.description, defaultItem.description) ||
        _doubleDiff(service.pricePerSqFt, defaultItem.pricePerSqFt) ||
        _doubleDiff(service.multiplier, defaultItem.multiplier);
  }

  bool _frequencyDiff(
    PricingProfileFrequency item,
    PricingProfileFrequency? defaultItem,
  ) {
    if (defaultItem == null) {
      return true;
    }
    return _textDiff(item.serviceType, defaultItem.serviceType) ||
        _textDiff(item.frequency, defaultItem.frequency) ||
        _doubleDiff(item.multiplier, defaultItem.multiplier);
  }

  bool _roomTypeDiff(
    PricingProfileRoomType item,
    PricingProfileRoomType? defaultItem,
  ) {
    if (defaultItem == null) {
      return true;
    }
    return _textDiff(item.roomType, defaultItem.roomType) ||
        _textDiff(item.description, defaultItem.description) ||
        _intDiff(item.minutes, defaultItem.minutes) ||
        _intDiff(item.squareFeet, defaultItem.squareFeet);
  }

  bool _subItemDiff(
    PricingProfileSubItem item,
    PricingProfileSubItem? defaultItem,
  ) {
    if (defaultItem == null) {
      return true;
    }
    return _textDiff(item.subItem, defaultItem.subItem) ||
        _textDiff(item.description, defaultItem.description) ||
        _intDiff(item.minutes, defaultItem.minutes);
  }

  bool _sizeDiff(
    PricingProfileSize item,
    PricingProfileSize? defaultItem,
  ) {
    if (defaultItem == null) {
      return true;
    }
    return _textDiff(item.size, defaultItem.size) ||
        _textDiff(item.definition, defaultItem.definition) ||
        _doubleDiff(item.multiplier, defaultItem.multiplier);
  }

  bool _complexityDiff(
    PricingProfileComplexity item,
    PricingProfileComplexity? defaultItem,
  ) {
    if (defaultItem == null) {
      return true;
    }
    return _textDiff(item.level, defaultItem.level) ||
        _textDiff(item.definition, defaultItem.definition) ||
        _doubleDiff(item.multiplier, defaultItem.multiplier);
  }

  String _normalizeText(String value) {
    return value.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();
  }

  List<PricingProfileServiceType> _sortedServiceTypes(
    List<PricingProfileServiceType> items,
  ) {
    final sorted = items.toList();
    sorted.sort((a, b) => a.row.compareTo(b.row));
    return sorted;
  }

  List<PricingProfileRoomType> _sortedRoomTypes(
    List<PricingProfileRoomType> items,
  ) {
    final sorted = items.toList();
    sorted.sort((a, b) => a.row.compareTo(b.row));
    return sorted;
  }

  List<PricingProfileFrequency> _sortedFrequencies(
    List<PricingProfileFrequency> items,
  ) {
    final sorted = items.toList();
    sorted.sort((a, b) {
      final serviceCompare =
          _normalizeText(a.serviceType).compareTo(_normalizeText(b.serviceType));
      if (serviceCompare != 0) {
        return serviceCompare;
      }
      return _normalizeText(a.frequency)
          .compareTo(_normalizeText(b.frequency));
    });
    return sorted;
  }

  List<PricingProfileSubItem> _sortedSubItems(
    List<PricingProfileSubItem> items,
  ) {
    final sorted = items.toList();
    sorted.sort((a, b) {
      final nameCompare =
          _normalizeText(a.subItem).compareTo(_normalizeText(b.subItem));
      if (nameCompare != 0) {
        return nameCompare;
      }
      final descriptionCompare = _normalizeText(a.description)
          .compareTo(_normalizeText(b.description));
      if (descriptionCompare != 0) {
        return descriptionCompare;
      }
      return a.id.compareTo(b.id);
    });
    return sorted;
  }

  List<PricingProfileSize> _sortedSizes(List<PricingProfileSize> items) {
    final sorted = items.toList();
    sorted.sort((a, b) {
      final nameCompare =
          _normalizeText(a.size).compareTo(_normalizeText(b.size));
      if (nameCompare != 0) {
        return nameCompare;
      }
      final definitionCompare = _normalizeText(a.definition)
          .compareTo(_normalizeText(b.definition));
      if (definitionCompare != 0) {
        return definitionCompare;
      }
      return a.id.compareTo(b.id);
    });
    return sorted;
  }

  List<PricingProfileComplexity> _sortedComplexities(
    List<PricingProfileComplexity> items,
  ) {
    final sorted = items.toList();
    sorted.sort((a, b) {
      final nameCompare =
          _normalizeText(a.level).compareTo(_normalizeText(b.level));
      if (nameCompare != 0) {
        return nameCompare;
      }
      final definitionCompare = _normalizeText(a.definition)
          .compareTo(_normalizeText(b.definition));
      if (definitionCompare != 0) {
        return definitionCompare;
      }
      return a.id.compareTo(b.id);
    });
    return sorted;
  }

  Map<String, T> _matchDefaultsByKey<T>({
    required List<T> items,
    required List<T> defaults,
    required String Function(T) key,
    required String Function(T) id,
  }) {
    final pool = <String, List<T>>{};
    for (final defaultItem in defaults) {
      pool.putIfAbsent(key(defaultItem), () => []).add(defaultItem);
    }
    final matches = <String, T>{};
    for (final item in items) {
      final available = pool[key(item)];
      if (available != null && available.isNotEmpty) {
        matches[id(item)] = available.removeAt(0);
      }
    }
    return matches;
  }

  Future<void> _renameProfile(
    BuildContext context,
    PricingProfileHeader profile,
  ) async {
    final controller = TextEditingController(text: profile.name);
    final nextName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Profile'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Profile name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (nextName == null || nextName.isEmpty) {
      return;
    }
    await widget.pricingProfilesRepo.updateProfileHeader(
      widget.profileId,
      name: nextName,
    );
  }

  Widget _buildTable(
    BuildContext context, {
    required List<String> headers,
    required List<List<Object>> rows,
    Map<int, TableColumnWidth>? columnWidths,
  }) {
    final theme = Theme.of(context);
    return Table(
      border: TableBorder.all(color: Colors.grey.shade400, width: 1),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: columnWidths,
      children: [
        _tableRow(
          headers,
          isHeader: true,
          headerColor: theme.colorScheme.surfaceContainerHighest,
          headerTextColor: theme.colorScheme.onSurfaceVariant,
        ),
        ...rows.map((cells) => _tableRow(cells)),
      ],
    );
  }

  TableRow _tableRow(
    List<Object> cells, {
    bool isHeader = false,
    Color? rowColor,
    Color? headerColor,
    Color? headerTextColor,
  }) {
    final effectiveHeaderColor = headerColor ?? Colors.grey.shade200;
    final effectiveHeaderTextColor =
        headerTextColor ??
        (ThemeData.estimateBrightnessForColor(effectiveHeaderColor) ==
                Brightness.dark
            ? Colors.white
            : Colors.black);
    return TableRow(
      decoration: isHeader
          ? BoxDecoration(color: effectiveHeaderColor)
          : rowColor == null
          ? null
          : BoxDecoration(color: rowColor),
      children: cells
          .map(
            (cell) => Padding(
              padding: const EdgeInsets.all(8),
              child: cell is Widget
                  ? cell
                  : Text(
                      cell.toString(),
                      softWrap: !isHeader,
                      overflow: isHeader ? TextOverflow.ellipsis : null,
                      style: TextStyle(
                        fontWeight: isHeader
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isHeader
                            ? effectiveHeaderTextColor
                            : rowColor == null
                            ? null
                            : ThemeData.estimateBrightnessForColor(rowColor) ==
                                  Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
            ),
          )
          .toList(),
    );
  }
}
