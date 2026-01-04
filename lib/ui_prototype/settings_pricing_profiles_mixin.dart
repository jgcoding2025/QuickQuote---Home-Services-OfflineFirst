part of '../ui_prototype.dart';

mixin _SettingsPricingProfilesMixin on _SettingsStateAccess {
  PricingProfilesRepositoryLocalFirst get pricingProfilesRepo;
  PricingProfileCatalogRepositoryLocalFirst get pricingCatalogRepo;

  final Map<String, Stream<PricingProfileCatalog>> _catalogStreams = {};
  Stream<List<PricingProfileHeader>>? _profilesStream;

  Stream<PricingProfileCatalog> _catalog$(String profileId) {
    return _catalogStreams.putIfAbsent(
      profileId,
      () => pricingCatalogRepo.streamCatalog(profileId).asBroadcastStream(),
    );
  }

  Stream<List<PricingProfileHeader>> profiles$() {
    return _profilesStream ??=
        pricingProfilesRepo.streamProfiles().asBroadcastStream();
  }

  Widget _pricingProfilesCard(BuildContext context, OrgSettings settings) {
    return StreamBuilder<List<PricingProfileHeader>>(
      stream: profiles$(),
      builder: (context, snapshot) {
        final profiles = snapshot.data ?? const [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create custom pricing profiles by duplicating Default.',
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.icon(
                onPressed: () => _showDuplicateProfileDialog(context),
                icon: const Icon(Icons.copy),
                label: const Text('Duplicate Default'),
              ),
            ),
            const SizedBox(height: 12),
            _profileTile(
              context,
              title: 'Default',
              subtitle: 'Locked (uses asset catalog + org rates)',
              isDefault: settings.defaultPricingProfileId == 'default',
              onSetDefault: () => _save(
                settings.copyWith(defaultPricingProfileId: 'default'),
              ),
              isLocked: true,
            ),
            const SizedBox(height: 8),
            if (profiles.isEmpty)
              const Text('No custom profiles yet.')
            else
              ...profiles.map(
                (profile) => _profileTile(
                  context,
                  title: profile.name,
                  subtitle: 'Custom profile',
                  isDefault: settings.defaultPricingProfileId == profile.id,
                  onSetDefault: () => _save(
                    settings.copyWith(defaultPricingProfileId: profile.id),
                  ),
                  onEdit: () => _showEditProfileDialog(context, profile),
                  onDelete: () => _confirmDeleteProfile(context, profile),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _profileTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool isDefault,
    required VoidCallback onSetDefault,
    bool isLocked = false,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
  }) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: isDefault
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.circle_outlined),
        trailing: Wrap(
          spacing: 8,
          children: [
            if (!isDefault)
              IconButton(
                tooltip: 'Set as default',
                onPressed: onSetDefault,
                icon: const Icon(Icons.flag_outlined),
              ),
            if (!isLocked)
              IconButton(
                tooltip: 'Edit',
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
              ),
            if (!isLocked)
              IconButton(
                tooltip: 'Delete',
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDuplicateProfileDialog(BuildContext context) async {
    final controller = TextEditingController(text: 'Custom Profile');
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Duplicate Default'),
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
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Create'),
          ),
        ],
      ),
    );
    if (name == null) {
      return;
    }
    try {
      await pricingProfilesRepo.createProfileByDuplicatingDefault(name);
      if (mounted) {
        _snack(context, 'Pricing profile created.');
      }
    } catch (e) {
      if (mounted) {
        _snack(context, 'Unable to create profile.');
      }
    }
  }

  Future<void> _confirmDeleteProfile(
    BuildContext context,
    PricingProfileHeader profile,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete profile?'),
        content: Text(
          'Delete "${profile.name}"? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (shouldDelete != true) {
      return;
    }
    await pricingProfilesRepo.deleteProfile(profile.id);
  }

  Future<void> _showEditProfileDialog(
    BuildContext context,
    PricingProfileHeader profile,
  ) async {
    final nameController = TextEditingController(text: profile.name);
    final laborController =
        TextEditingController(text: profile.laborRate.toStringAsFixed(2));
    final taxController =
        TextEditingController(text: profile.taxRate.toStringAsFixed(2));
    final ccController =
        TextEditingController(text: profile.ccRate.toStringAsFixed(2));
    var taxEnabled = profile.taxEnabled;
    var ccEnabled = profile.ccEnabled;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            return AlertDialog(
              title: Text('Edit ${profile.name}'),
              content: SizedBox(
                width: 520,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration:
                            const InputDecoration(labelText: 'Profile name'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: laborController,
                        decoration: const InputDecoration(
                          labelText: 'Labor rate (\$/hr)',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SwitchListTile(
                        value: taxEnabled,
                        onChanged: (v) =>
                            setLocalState(() => taxEnabled = v),
                        title: const Text('Tax enabled'),
                      ),
                      if (taxEnabled)
                        TextField(
                          controller: taxController,
                          decoration: const InputDecoration(
                            labelText: 'Tax rate (decimal)',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      SwitchListTile(
                        value: ccEnabled,
                        onChanged: (v) =>
                            setLocalState(() => ccEnabled = v),
                        title: const Text('Credit card fee enabled'),
                      ),
                      if (ccEnabled)
                        TextField(
                          controller: ccController,
                          decoration: const InputDecoration(
                            labelText: 'CC rate (decimal)',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      const SizedBox(height: 12),
                      Text(
                        'Service Types',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      StreamBuilder<PricingProfileCatalog>(
                        stream: _catalog$(profile.id),
                        builder: (context, snapshot) {
                          final catalog =
                              snapshot.data ?? PricingProfileCatalog.empty();
                          if (catalog.serviceTypes.isEmpty) {
                            return const Text('No service types found.');
                          }
                          final sorted = catalog.serviceTypes.toList()
                            ..sort((a, b) => a.row.compareTo(b.row));
                          return Column(
                            children: sorted
                                .map(
                                  (service) => ListTile(
                                    dense: true,
                                    title: Text(service.serviceType),
                                    subtitle: Text(
                                      '\$${service.pricePerSqFt.toStringAsFixed(2)} / sq ft • ${service.multiplier.toStringAsFixed(2)}x',
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () => _editServiceType(
                                        context,
                                        service,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Frequencies',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      StreamBuilder<PricingProfileCatalog>(
                        stream: _catalog$(profile.id),
                        builder: (context, snapshot) {
                          final catalog =
                              snapshot.data ?? PricingProfileCatalog.empty();
                          if (catalog.frequencies.isEmpty) {
                            return const Text('No frequencies found.');
                          }
                          return Column(
                            children: catalog.frequencies
                                .map(
                                  (freq) => ListTile(
                                    dense: true,
                                    title: Text(
                                      '${freq.frequency} (${freq.serviceType})',
                                    ),
                                    subtitle: Text(
                                      '${freq.multiplier.toStringAsFixed(2)}x',
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () => _editFrequency(
                                        context,
                                        freq,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
                FilledButton(
                  onPressed: () async {
                    final laborRate =
                        double.tryParse(laborController.text.trim());
                    final taxRate =
                        double.tryParse(taxController.text.trim());
                    final ccRate =
                        double.tryParse(ccController.text.trim());
                    await pricingProfilesRepo.updateProfileHeader(
                      profile.id,
                      name: nameController.text.trim(),
                      laborRate: laborRate ?? profile.laborRate,
                      taxEnabled: taxEnabled,
                      taxRate: taxRate ?? profile.taxRate,
                      ccEnabled: ccEnabled,
                      ccRate: ccRate ?? profile.ccRate,
                    );
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
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
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${service.serviceType}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: priceController,
              decoration:
                  const InputDecoration(labelText: 'Price per sq ft'),
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
              await pricingCatalogRepo.updateServiceType(
                id: service.id,
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
              await pricingCatalogRepo.updateFrequency(
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
}
