part of '../ui_prototype.dart';

mixin _QuoteEditorBuildMixin on _QuoteEditorStateAccess {
  List<DropdownMenuItem<String>> _serviceTypeMenuItems(
    BuildContext context,
    List<_ServiceTypeStandard> serviceTypes,
    List<String> fallbackOptions,
  ) {
    if (serviceTypes.isEmpty) {
      return fallbackOptions
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList();
    }
    final theme = Theme.of(context);
    final items = <DropdownMenuItem<String>>[];
    String? currentCategory;
    final seenServiceTypes = <String>{};
    final sorted = serviceTypes.toList()
      ..sort((a, b) => a.row.compareTo(b.row));
    for (final item in sorted) {
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
            padding: const EdgeInsets.only(left: 12),
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

  List<DropdownMenuItem<String>> _pricingProfileMenuItems(
    List<PricingProfileHeader> profiles, {
    String? missingProfileId,
    String? missingProfileLabel,
  }) {
    return [
      const DropdownMenuItem(
        value: 'default',
        child: Text('Default (locked)'),
      ),
      ...profiles.map(
        (profile) => DropdownMenuItem(
          value: profile.id,
          child: Text(profile.name),
        ),
      ),
      if (missingProfileId != null)
        DropdownMenuItem(
          value: missingProfileId,
          child: Text(missingProfileLabel ?? 'Loading pricing profile...'),
        ),
    ];
  }

  Widget _buildQuoteEditor(BuildContext context) {
    return PopScope(
      canPop: !_isDirty,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _confirmDiscardChanges();
        if (!context.mounted) {
          return;
        }
        if (shouldPop) {
          setState(() => _isDirty = false);
          Navigator.pop(context, result);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Quote'),
          actions: [
            IconButton(
              icon: const Icon(Icons.picture_as_pdf_outlined),
              onPressed: () => _snack(context, 'Later: PDF preview/share'),
            ),
          ],
        ),
        body: FutureBuilder<_QuoteSettingsData>(
          future: _settingsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('Failed to load quote settings.'),
              );
            }

            final data = snapshot.data ?? _QuoteSettingsData.empty();
            _serviceTypeStandards = data.serviceTypes;
            _frequencyStandards = data.frequencies;
            _roomTypeStandards = data.roomTypes;
            _subItemStandards = data.subItems;
            _sizeStandards = data.sizes;
            _complexityStandards = data.complexities;
            final serviceTypeOptions = data.serviceTypes.isNotEmpty
                ? {
                    for (final standard
                        in (data.serviceTypes.toList()
                          ..sort((a, b) => a.row.compareTo(b.row))))
                      standard.serviceType,
                  }.toList()
                : [serviceType];
            final missingProfileId =
                pricingProfileId != 'default' &&
                        pricingProfiles
                            .every((profile) => profile.id != pricingProfileId)
                    ? pricingProfileId
                    : null;
            final pricingProfileOptions = [
              'default',
              ...pricingProfiles.map((profile) => profile.id),
              if (missingProfileId != null) missingProfileId,
            ];
            final roomTypeOptions = data.roomTypes.isNotEmpty
                ? data.roomTypes.map((room) => room.roomType).toList()
                : [defaultRoomType];
            final subItemOptions = data.subItems.isNotEmpty
                ? data.subItems.map(_subItemLabel).toList()
                : [subItemType];
            final sizeOptions = data.sizes.isNotEmpty
                ? data.sizes.map((size) => size.size).toList()
                : [defaultSize];
            final complexityOptions = data.complexities.isNotEmpty
                ? data.complexities.map((level) => level.level).toList()
                : [defaultComplexity];
            final frequencyOptions = data.frequencies.isNotEmpty
                ? data.frequencies
                      .map((standard) => standard.frequency)
                      .toSet()
                      .toList()
                : [frequency];
            final roomTypeMenuItems = _roomTypeMenuItems(
              data.roomTypes,
              roomTypeOptions,
            );
            final serviceTypeMenuItems = _serviceTypeMenuItems(
              context,
              data.serviceTypes,
              serviceTypeOptions,
            );
            final missingProfileLabel = pricingProfileDeleted
                ? 'Deleted profile${missingPricingProfileName == null ? '' : ': $missingPricingProfileName'}'
                : 'Loading pricing profile...';
            final pricingProfileMenuItems = _pricingProfileMenuItems(
              pricingProfiles,
              missingProfileId: missingProfileId,
              missingProfileLabel:
                  missingProfileId == null ? null : missingProfileLabel,
            );
            final subItemMenuItems = _subItemMenuItems(
              data.subItems,
              subItemOptions,
            );

            final resolvedServiceType = _resolveOption(
              serviceType,
              serviceTypeOptions,
            );
            final resolvedPricingProfile = _resolveOption(
              pricingProfileId,
              pricingProfileOptions,
            );
            final resolvedRoomType = _resolveOption(
              defaultRoomType,
              roomTypeOptions,
            );
            final resolvedSize = _resolveOption(defaultSize, sizeOptions);
            final resolvedComplexity = _resolveOption(
              defaultComplexity,
              complexityOptions,
            );
            final resolvedSubItem = _resolveOption(subItemType, subItemOptions);
            final resolvedFrequency = _resolveOption(
              frequency,
              frequencyOptions,
            );

            _syncOption(
              defaultRoomType,
              resolvedRoomType,
              (v) => defaultRoomType = v,
            );
            _syncOption(
              serviceType,
              resolvedServiceType,
              (v) => serviceType = v,
            );
            _syncOption(defaultSize, resolvedSize, (v) => defaultSize = v);
            _syncOption(
              defaultComplexity,
              resolvedComplexity,
              (v) => defaultComplexity = v,
            );
            _syncOption(subItemType, resolvedSubItem, (v) => subItemType = v);
            _syncOption(frequency, resolvedFrequency, (v) => frequency = v);
            _syncOption(
              pricingProfileId,
              resolvedPricingProfile,
              (v) => pricingProfileId = v,
            );

            final totals = _calcTotals();
            final roomTitles = items
                .where((item) => item.type == 'Room')
                .map((item) => item.title)
                .toSet();
            final serviceTypeRate = _serviceTypeRate();
            final frequencyMultiplier = _frequencyMultiplier();
            final sqFt = double.tryParse(totalSqFt) ?? 0.0;
            final sqFtEstimate = sqFt * serviceTypeRate * frequencyMultiplier;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (pricingProfileDeleted)
                  Card(
                    color: Theme.of(context).colorScheme.errorContainer,
                    child: ListTile(
                      title: const Text('Pricing profile deleted'),
                      subtitle: Text(
                        missingPricingProfileName == null
                            ? 'This quote references a deleted profile.'
                            : 'This quote references the deleted profile "$missingPricingProfileName".',
                      ),
                      trailing: FilledButton(
                        onPressed: () => _selectPricingProfile('default'),
                        child: const Text('Switch to Default'),
                      ),
                    ),
                  )
                else if (pricingProfileMissing)
                  Card(
                    child: ListTile(
                      leading: const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      title: const Text('Loading pricing profile...'),
                      subtitle: const Text(
                        'Keeping your selection while profiles sync.',
                      ),
                    ),
                  ),
                if (_hasRemoteUpdate)
                  Card(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    child: ListTile(
                      leading: const Icon(Icons.sync),
                      title: const Text('Updated on another device'),
                      subtitle:
                          const Text('Refresh to load the latest changes.'),
                      trailing: TextButton(
                        onPressed: _refreshFromRemote,
                        child: const Text('Refresh'),
                      ),
                    ),
                  ),
                if (_hasRemoteUpdate) const SizedBox(height: 12),
                Text('Quote', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                _buildCustomerDetailsSection(),
                const SizedBox(height: 12),
                _buildQuoteDetailsSection(
                  pricingProfileMenuItems: pricingProfileMenuItems,
                  resolvedPricingProfile: resolvedPricingProfile,
                  serviceTypeMenuItems: serviceTypeMenuItems,
                  frequencyOptions: frequencyOptions,
                  resolvedServiceType: resolvedServiceType,
                  resolvedFrequency: resolvedFrequency,
                ),
                const SizedBox(height: 12),
                _buildDiscussSection(),
                const SizedBox(height: 12),
                _buildRoomsSection(
                  resolvedRoomType: resolvedRoomType,
                  resolvedSize: resolvedSize,
                  resolvedComplexity: resolvedComplexity,
                  roomTypeOptions: roomTypeOptions,
                  subItemOptions: subItemOptions,
                  roomTypeMenuItems: roomTypeMenuItems,
                  subItemMenuItems: subItemMenuItems,
                  sizeOptions: sizeOptions,
                  complexityOptions: complexityOptions,
                  subItemStandards: data.subItems,
                  roomTitles: roomTitles.toList(),
                ),
                const SizedBox(height: 12),
                _buildAdditionalItemsSection(
                  resolvedSubItem: resolvedSubItem,
                  subItemOptions: subItemOptions,
                  roomTypeOptions: roomTypeOptions,
                  roomTypeMenuItems: roomTypeMenuItems,
                  subItemMenuItems: subItemMenuItems,
                  sizeOptions: sizeOptions,
                  complexityOptions: complexityOptions,
                  roomTitles: roomTitles.toList(),
                ),
                const SizedBox(height: 12),
                _buildSpecialNotesSection(),
                const SizedBox(height: 12),
                _buildPricingSection(
                  totals: totals,
                  serviceTypeRate: serviceTypeRate,
                  frequencyMultiplier: frequencyMultiplier,
                  sqFt: sqFt,
                  sqFtEstimate: sqFtEstimate,
                ),
                const SizedBox(height: 12),
                _buildActionButtons(),
                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
    );
  }
}
