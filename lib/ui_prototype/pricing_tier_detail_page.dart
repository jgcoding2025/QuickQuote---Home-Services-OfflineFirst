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
  late List<_PlanTier> _planTiers;

  @override
  void initState() {
    super.initState();
    if (widget.isDefault) {
      unawaited(widget.pricingProfilesRepo.ensureDefaultCatalogSeeded());
    }
    _planTiers = List<_PlanTier>.from(widget.settingsData.planTiers);
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
              return ListView(
                padding: const EdgeInsets.all(16),
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
                    child: _planTiersSection(context),
                  ),
                  const SizedBox(height: 16),
                  _sectionTile(
                    context,
                    title: 'Service Types',
                    child: _serviceTypeSection(catalog, isEditable),
                  ),
                  const SizedBox(height: 16),
                  _sectionTile(
                    context,
                    title: 'Room Type Standards',
                    child: _roomTypeSection(catalog, isEditable),
                  ),
                  const SizedBox(height: 16),
                  _sectionTile(
                    context,
                    title: 'Add-on Items',
                    child: _subItemSection(catalog, isEditable),
                  ),
                  const SizedBox(height: 16),
                  _sectionTile(
                    context,
                    title: 'Complexity, Size, and Frequency',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _complexitySection(catalog, isEditable),
                        const SizedBox(height: 16),
                        _sizeSection(catalog, isEditable),
                        const SizedBox(height: 16),
                        _frequencySection(catalog, isEditable),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
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
        children: [
          const SizedBox(height: 8),
          child,
        ],
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
                    final laborRate =
                        double.tryParse(laborController.text.trim());
                    final taxRate =
                        double.tryParse(taxController.text.trim());
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

  Widget _planTiersSection(BuildContext context) {
    if (_planTiers.isEmpty) {
      return const Text('No plan tiers available.');
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
          rows: _planTiers.map((tier) {
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
    PricingProfileCatalog catalog,
    bool isEditable,
  ) {
    if (catalog.serviceTypes.isEmpty) {
      return const Text('No service types found.');
    }
    final sorted = catalog.serviceTypes.toList()
      ..sort((a, b) => a.row.compareTo(b.row));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isEditable)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _editServiceTypesTable(context, sorted),
              child: const Text('Edit'),
            ),
          ),
        _buildTable(
          context,
          headers: const [
            'Service type',
            'Description',
            '\$/Sq.Ft.',
            'Multiplier',
          ],
          columnWidths: const {
            0: FlexColumnWidth(1.6),
            1: FlexColumnWidth(3.2),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
          },
          rows: sorted.map((service) {
            return [
              service.serviceType,
              service.description,
              service.pricePerSqFt.toStringAsFixed(2),
              service.multiplier.toStringAsFixed(2),
            ];
          }).toList(),
        ),
      ],
    );
  }

  Widget _frequencySection(
    PricingProfileCatalog catalog,
    bool isEditable,
  ) {
    if (catalog.frequencies.isEmpty) {
      return const Text('No frequencies found.');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isEditable)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _editFrequenciesTable(
                context,
                catalog.frequencies,
              ),
              child: const Text('Edit'),
            ),
          ),
        _buildTable(
          context,
          headers: const ['Service type', 'Frequency', 'Multiplier'],
          columnWidths: const {
            0: FlexColumnWidth(1.8),
            1: FlexColumnWidth(1.6),
            2: FlexColumnWidth(1),
          },
          rows: catalog.frequencies.map((freq) {
            return [
              freq.serviceType,
              freq.frequency,
              freq.multiplier.toStringAsFixed(2),
            ];
          }).toList(),
        ),
      ],
    );
  }

  Widget _roomTypeSection(
    PricingProfileCatalog catalog,
    bool isEditable,
  ) {
    if (catalog.roomTypes.isEmpty) {
      return const Text('No room types found.');
    }
    final sorted = catalog.roomTypes.toList()
      ..sort((a, b) => a.row.compareTo(b.row));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isEditable)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _editRoomTypesTable(context, sorted),
              child: const Text('Edit'),
            ),
          ),
        _buildTable(
          context,
          headers: const ['Room type', 'Description', 'Minutes', 'Sq.Ft.'],
          columnWidths: const {
            0: FlexColumnWidth(1.6),
            1: FlexColumnWidth(3),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
          },
          rows: sorted.map((room) {
            return [
              room.roomType,
              room.description,
              room.minutes.toString(),
              room.squareFeet.toString(),
            ];
          }).toList(),
        ),
      ],
    );
  }

  Widget _subItemSection(
    PricingProfileCatalog catalog,
    bool isEditable,
  ) {
    if (catalog.subItems.isEmpty) {
      return const Text('No add-on items found.');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isEditable)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _editSubItemsTable(context, catalog.subItems),
              child: const Text('Edit'),
            ),
          ),
        _buildTable(
          context,
          headers: const ['Add-on item', 'Description', 'Minutes'],
          columnWidths: const {
            0: FlexColumnWidth(1.6),
            1: FlexColumnWidth(3),
            2: FlexColumnWidth(1),
          },
          rows: catalog.subItems.map((item) {
            return [
              item.subItem,
              item.description,
              item.minutes.toString(),
            ];
          }).toList(),
        ),
      ],
    );
  }

  Widget _sizeSection(
    PricingProfileCatalog catalog,
    bool isEditable,
  ) {
    if (catalog.sizes.isEmpty) {
      return const Text('No size standards found.');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isEditable)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _editSizesTable(context, catalog.sizes),
              child: const Text('Edit'),
            ),
          ),
        _buildTable(
          context,
          headers: const ['Size', 'Definition', 'Multiplier'],
          columnWidths: const {
            0: FlexColumnWidth(1.2),
            1: FlexColumnWidth(3),
            2: FlexColumnWidth(1),
          },
          rows: catalog.sizes.map((item) {
            return [
              item.size,
              item.definition,
              item.multiplier.toStringAsFixed(2),
            ];
          }).toList(),
        ),
      ],
    );
  }

  Widget _complexitySection(
    PricingProfileCatalog catalog,
    bool isEditable,
  ) {
    if (catalog.complexities.isEmpty) {
      return const Text('No complexity standards found.');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isEditable)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () =>
                  _editComplexitiesTable(context, catalog.complexities),
              child: const Text('Edit'),
            ),
          ),
        _buildTable(
          context,
          headers: const ['Complexity', 'Definition', 'Multiplier'],
          columnWidths: const {
            0: FlexColumnWidth(1.4),
            1: FlexColumnWidth(3),
            2: FlexColumnWidth(1),
          },
          rows: catalog.complexities.map((item) {
            return [
              item.level,
              item.definition,
              item.multiplier.toStringAsFixed(2),
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
    final priceController =
        TextEditingController(text: service.pricePerSqFt.toStringAsFixed(2));
    final multiplierController =
        TextEditingController(text: service.multiplier.toStringAsFixed(2));
    final descriptionController =
        TextEditingController(text: service.description);
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${service.serviceType}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                description: descriptionController.text.trim(),
                pricePerSqFt: price,
                multiplier: multiplier,
              );
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _editServiceTypesTable(
    BuildContext context,
    List<PricingProfileServiceType> items,
  ) async {
    var selected = items.first;
    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Service Type'),
          content: DropdownButtonFormField<String>(
            initialValue: selected.id,
            items: items
                .map(
                  (item) => DropdownMenuItem(
                    value: item.id,
                    child: Text(item.serviceType),
                  ),
                )
                .toList(),
            onChanged: (value) {
              final next = items.firstWhere((item) => item.id == value);
              setState(() => selected = next);
            },
            decoration: const InputDecoration(labelText: 'Service type'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(context);
                await _editServiceType(this.context, selected);
              },
              child: const Text('Edit'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editFrequency(
    BuildContext context,
    PricingProfileFrequency frequency,
  ) async {
    final multiplierController =
        TextEditingController(text: frequency.multiplier.toStringAsFixed(2));
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${frequency.frequency}'),
        content: TextField(
          controller: multiplierController,
          decoration: const InputDecoration(labelText: 'Multiplier'),
          keyboardType: TextInputType.number,
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
                multiplier: multiplier,
              );
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _editFrequenciesTable(
    BuildContext context,
    List<PricingProfileFrequency> items,
  ) async {
    var selected = items.first;
    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Frequency'),
          content: DropdownButtonFormField<String>(
            initialValue: selected.id,
            items: items
                .map(
                  (item) => DropdownMenuItem(
                    value: item.id,
                    child: Text('${item.frequency} (${item.serviceType})'),
                  ),
                )
                .toList(),
            onChanged: (value) {
              final next = items.firstWhere((item) => item.id == value);
              setState(() => selected = next);
            },
            decoration: const InputDecoration(labelText: 'Frequency'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(context);
                await _editFrequency(this.context, selected);
              },
              child: const Text('Edit'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editRoomType(
    BuildContext context,
    PricingProfileRoomType roomType,
  ) async {
    final descriptionController =
        TextEditingController(text: roomType.description);
    final minutesController =
        TextEditingController(text: roomType.minutes.toString());
    final squareFeetController =
        TextEditingController(text: roomType.squareFeet.toString());
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${roomType.roomType}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
              final squareFeet =
                  int.tryParse(squareFeetController.text.trim());
              await widget.pricingCatalogRepo.updateRoomType(
                id: roomType.id,
                description: descriptionController.text.trim(),
                minutes: minutes ?? roomType.minutes,
                squareFeet: squareFeet ?? roomType.squareFeet,
              );
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _editRoomTypesTable(
    BuildContext context,
    List<PricingProfileRoomType> items,
  ) async {
    var selected = items.first;
    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Room Type'),
          content: DropdownButtonFormField<String>(
            initialValue: selected.id,
            items: items
                .map(
                  (item) => DropdownMenuItem(
                    value: item.id,
                    child: Text(item.roomType),
                  ),
                )
                .toList(),
            onChanged: (value) {
              final next = items.firstWhere((item) => item.id == value);
              setState(() => selected = next);
            },
            decoration: const InputDecoration(labelText: 'Room type'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(context);
                await _editRoomType(this.context, selected);
              },
              child: const Text('Edit'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editSubItem(
    BuildContext context,
    PricingProfileSubItem subItem,
  ) async {
    final descriptionController =
        TextEditingController(text: subItem.description);
    final minutesController =
        TextEditingController(text: subItem.minutes.toString());
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${subItem.subItem}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                description: descriptionController.text.trim(),
                minutes: minutes ?? subItem.minutes,
              );
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _editSubItemsTable(
    BuildContext context,
    List<PricingProfileSubItem> items,
  ) async {
    var selected = items.first;
    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Add-on Item'),
          content: DropdownButtonFormField<String>(
            initialValue: selected.id,
            items: items
                .map(
                  (item) => DropdownMenuItem(
                    value: item.id,
                    child: Text(item.subItem),
                  ),
                )
                .toList(),
            onChanged: (value) {
              final next = items.firstWhere((item) => item.id == value);
              setState(() => selected = next);
            },
            decoration: const InputDecoration(labelText: 'Add-on item'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(context);
                await _editSubItem(this.context, selected);
              },
              child: const Text('Edit'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editSize(
    BuildContext context,
    PricingProfileSize size,
  ) async {
    final definitionController =
        TextEditingController(text: size.definition);
    final multiplierController =
        TextEditingController(text: size.multiplier.toStringAsFixed(2));
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${size.size}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                definition: definitionController.text.trim(),
                multiplier: multiplier,
              );
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _editSizesTable(
    BuildContext context,
    List<PricingProfileSize> items,
  ) async {
    var selected = items.first;
    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Size'),
          content: DropdownButtonFormField<String>(
            initialValue: selected.id,
            items: items
                .map(
                  (item) => DropdownMenuItem(
                    value: item.id,
                    child: Text(item.size),
                  ),
                )
                .toList(),
            onChanged: (value) {
              final next = items.firstWhere((item) => item.id == value);
              setState(() => selected = next);
            },
            decoration: const InputDecoration(labelText: 'Size'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(context);
                await _editSize(this.context, selected);
              },
              child: const Text('Edit'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editComplexity(
    BuildContext context,
    PricingProfileComplexity complexity,
  ) async {
    final definitionController =
        TextEditingController(text: complexity.definition);
    final multiplierController =
        TextEditingController(text: complexity.multiplier.toStringAsFixed(2));
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${complexity.level}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                definition: definitionController.text.trim(),
                multiplier: multiplier,
              );
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _editComplexitiesTable(
    BuildContext context,
    List<PricingProfileComplexity> items,
  ) async {
    var selected = items.first;
    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Complexity'),
          content: DropdownButtonFormField<String>(
            initialValue: selected.id,
            items: items
                .map(
                  (item) => DropdownMenuItem(
                    value: item.id,
                    child: Text(item.level),
                  ),
                )
                .toList(),
            onChanged: (value) {
              final next = items.firstWhere((item) => item.id == value);
              setState(() => selected = next);
            },
            decoration: const InputDecoration(labelText: 'Complexity'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(context);
                await _editComplexity(this.context, selected);
              },
              child: const Text('Edit'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editPlanTiersTable(BuildContext context) async {
    var selected = _planTiers.first;
    final multiplierController =
        TextEditingController(text: selected.multiplier.toStringAsFixed(2));
    final descriptionController =
        TextEditingController(text: selected.description);

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
                items: _planTiers
                    .map(
                      (tier) => DropdownMenuItem(
                        value: tier.name,
                        child: Text('${tier.name} (${tier.label})'),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  final next = _planTiers.firstWhere(
                    (tier) => tier.name == value,
                  );
                  setState(() {
                    selected = next;
                    multiplierController.text =
                        next.multiplier.toStringAsFixed(2);
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
                  _planTiers = _planTiers.map((tier) {
                    if (tier.name != selected.name) {
                      return tier;
                    }
                    return _PlanTier(
                      name: tier.name,
                      label: tier.label,
                      color: tier.color,
                      multiplier: multiplier,
                      description:
                          description.isEmpty ? tier.description : description,
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
                                : ThemeData.estimateBrightnessForColor(
                                          rowColor,
                                        ) ==
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
