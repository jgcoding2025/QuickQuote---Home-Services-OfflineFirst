part of '../ui_prototype.dart';

mixin _SettingsPricingProfilesMixin on _SettingsStateAccess {
  PricingProfilesRepositoryLocalFirst get pricingProfilesRepo;
  PricingProfileCatalogRepositoryLocalFirst get pricingCatalogRepo;

  Stream<List<PricingProfileHeader>>? _profilesStream;
  List<PricingProfileHeader> _lastProfiles = const [];

  Stream<List<PricingProfileHeader>> profiles$() {
    return _profilesStream ??= pricingProfilesRepo.streamProfiles();
  }

  Widget _pricingProfilesCard(
    BuildContext context,
    OrgSettings settings,
    _SettingsData data,
  ) {
    return StreamBuilder<List<PricingProfileHeader>>(
      stream: profiles$(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _lastProfiles = snapshot.data!;
        }
        final profiles = snapshot.hasData ? snapshot.data! : _lastProfiles;
        final showEmptyState =
            snapshot.connectionState != ConnectionState.waiting &&
                profiles.isEmpty;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Manage pricing tiers and profile catalogs.'),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.icon(
                onPressed: () =>
                    _showDuplicateProfileDialog(context, profiles),
                icon: const Icon(Icons.copy),
                label: const Text('Duplicate Profile'),
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
              onTap: () => _openPricingTierDetail(
                context,
                data,
                settings,
                PricingProfileHeader(
                  id: 'default',
                  orgId: '',
                  name: 'Default',
                  laborRate: settings.laborRate,
                  taxEnabled: settings.taxEnabled,
                  taxRate: settings.taxRate,
                  ccEnabled: settings.ccEnabled,
                  ccRate: settings.ccRate,
                  updatedAt: 0,
                  deleted: false,
                ),
                isDefault: true,
              ),
              isLocked: true,
            ),
            const SizedBox(height: 8),
            if (showEmptyState)
              const Text('No custom profiles yet.')
            else if (profiles.isEmpty)
              const Text('Loading...')
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
                  onTap: () => _openPricingTierDetail(
                    context,
                    data,
                    settings,
                    profile,
                  ),
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
    VoidCallback? onTap,
    bool isLocked = false,
    VoidCallback? onDelete,
  }) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: onTap,
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
                tooltip: 'Delete',
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDuplicateProfileDialog(
    BuildContext context,
    List<PricingProfileHeader> profiles,
  ) async {
    final controller = TextEditingController(text: 'Custom Profile');
    var selectedSourceId = 'default';
    final name = await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Duplicate Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedSourceId,
                items: [
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
                ],
                onChanged: (value) {
                  setState(() {
                    selectedSourceId = value ?? 'default';
                  });
                },
                decoration: const InputDecoration(labelText: 'Source profile'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                decoration: const InputDecoration(labelText: 'Profile name'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(
                context,
                '${selectedSourceId}::${controller.text}',
              ),
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
    if (name == null) {
      return;
    }
    final parts = name.split('::');
    final sourceProfileId = parts.isNotEmpty ? parts.first : 'default';
    final desiredName = parts.length > 1 ? parts[1] : '';
    try {
      await pricingProfilesRepo.createProfileByDuplicatingProfile(
        sourceProfileId,
        desiredName,
      );
      if (!mounted) return;
      _snack(this.context, 'Pricing profile created.');
    } catch (e) {
      if (!mounted) return;
      _snack(this.context, 'Unable to create profile.');
    }
  }

  void _openPricingTierDetail(
    BuildContext context,
    _SettingsData data,
    OrgSettings settings,
    PricingProfileHeader profile, {
    bool isDefault = false,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PricingTierDetailPage(
          profileId: profile.id,
          initialProfile: profile,
          isDefault: isDefault,
          orgSettings: settings,
          pricingProfilesRepo: pricingProfilesRepo,
          pricingCatalogRepo: pricingCatalogRepo,
          settingsData: data,
        ),
      ),
    );
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

}
