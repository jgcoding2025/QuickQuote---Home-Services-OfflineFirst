part of '../ui_prototype.dart';

mixin _QuoteEditorSectionsMixin on _QuoteEditorStateAccess {
  @override
  Widget _buildCustomerDetailsSection() {
    return _sectionCard(
      context,
      'Customer Details',
      Column(
        children: [
          TextFormField(
            key: ValueKey('quote-customerName-$_remoteRevision'),
            initialValue: customerName,
            decoration: _fieldDecoration('Customer'),
            onChanged: (v) => _markDirty(() => customerName = v),
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: ValueKey('quote-address-$_remoteRevision'),
            initialValue: address,
            decoration: _fieldDecoration('Address'),
            onChanged: (v) => _markDirty(() => address = v),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  key: ValueKey('quote-date-$_remoteRevision'),
                  initialValue: quoteDate,
                  decoration: _fieldDecoration('Date'),
                  onChanged: (v) => _markDirty(() => quoteDate = v),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  key: ValueKey('quote-totalSqFt-$_remoteRevision'),
                  initialValue: totalSqFt,
                  decoration: _fieldDecoration('Total Sq Ft'),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => _markDirty(() => totalSqFt = v),
                ),
              ),
            ],
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: useTotalSqFt,
            onChanged: (v) => _markDirty(() => useTotalSqFt = v ?? false),
            title: const Text('Use Total Sq Ft'),
          ),
          TextFormField(
            key: ValueKey('quote-estimatedSqFt-$_remoteRevision'),
            initialValue: estimatedSqFt,
            decoration: _fieldDecoration('Estimated Sq Ft (rooms)'),
            keyboardType: TextInputType.number,
            readOnly: true,
            enabled: false,
          ),
        ],
      ),
      isComplete:
          customerName.trim().isNotEmpty &&
          address.trim().isNotEmpty &&
          quoteDate.trim().isNotEmpty,
    );
  }

  @override
  Widget _buildQuoteDetailsSection({
    required List<DropdownMenuItem<String>> pricingProfileMenuItems,
    required String resolvedPricingProfile,
    required List<DropdownMenuItem<String>> serviceTypeMenuItems,
    required List<String> frequencyOptions,
    required String resolvedServiceType,
    required String resolvedFrequency,
    required List<String> statusOptions,
    required String resolvedStatus,
  }) {
    return _sectionCard(
      context,
      'Quote Details',
      Column(
        children: [
          TextFormField(
            key: ValueKey('quote-quoteName-$_remoteRevision'),
            initialValue: quoteName,
            minLines: 2,
            maxLines: 2,
            decoration: _fieldDecoration('Quote Name'),
            onChanged: (v) => _markDirty(() => quoteName = v),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            key: ValueKey('quote-status-$_remoteRevision'),
            value: resolvedStatus,
            items: statusOptions
                .map(
                  (option) => DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  ),
                )
                .toList(),
            onChanged: (v) => _markDirty(() => status = v ?? status),
            decoration: _fieldDecoration('Quote Status'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            key: ValueKey('quote-pricingProfile-$_remoteRevision'),
            initialValue: resolvedPricingProfile,
            items: pricingProfileMenuItems,
            isExpanded: true,
            onChanged: (v) {
              final selected = v ?? pricingProfileId;
              unawaited(_selectPricingProfile(selected));
            },
            decoration: _fieldDecoration('Pricing Profile'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            key: ValueKey('quote-serviceType-$_remoteRevision'),
            initialValue: resolvedServiceType,
            items: serviceTypeMenuItems,
            isExpanded: true,
            isDense: false, // ✅ IMPORTANT: gives the field enough height
            itemHeight: null,
            selectedItemBuilder: (context) {
              // Build the "closed" display widgets in the same order as the items list
              final theme = Theme.of(context);
              // You have _serviceTypeStandards available in this file (it’s set in build_mixin)
              // We'll map serviceType -> description for quick lookup
              final descByType = {
                for (final s in _serviceTypeStandards)
                  s.serviceType: s.description,
              };

              return serviceTypeMenuItems.map((menuItem) {
                final type = menuItem.value ?? '';
                final desc = (descByType[type] ?? '').trim();

                return Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(type, maxLines: 1, overflow: TextOverflow.ellipsis),
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
            onChanged: (v) => _markDirty(() {
              final nextServiceType = v ?? serviceType;
              if (nextServiceType == serviceType) {
                return;
              }
              quoteName = _updateQuoteNameForServiceType(
                quoteName,
                serviceType,
                nextServiceType,
              );
              serviceType = nextServiceType;
            }),
            decoration: _fieldDecoration('Service Type').copyWith(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            key: ValueKey('quote-frequency-$_remoteRevision'),
            initialValue: resolvedFrequency,
            items: frequencyOptions
                .map(
                  (value) => DropdownMenuItem(value: value, child: Text(value)),
                )
                .toList(),
            isExpanded: true,
            onChanged: (v) => _markDirty(() => frequency = v ?? frequency),
            decoration: _fieldDecoration('Frequency'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            key: ValueKey('quote-lastProClean-$_remoteRevision'),
            initialValue: lastProClean,
            items: const [
              DropdownMenuItem(value: '< 2 weeks', child: Text('< 2 weeks')),
              DropdownMenuItem(
                value: '2 - 4 weeks',
                child: Text('2 - 4 weeks'),
              ),
              DropdownMenuItem(value: '> 1 month', child: Text('> 1 month')),
              DropdownMenuItem(value: 'Never', child: Text('Never')),
            ],
            isExpanded: true,
            onChanged: (v) =>
                _markDirty(() => lastProClean = v ?? lastProClean),
            decoration: _fieldDecoration('Last Professional Cleaning'),
          ),
          const Divider(height: 32),
          Row(
            children: [
              const Text('Labor Rate'),
              const Spacer(),
              SizedBox(
                width: 120,
                child: TextFormField(
                  key: ValueKey('quote-laborRate-$_remoteRevision'),
                  initialValue: laborRate.toStringAsFixed(0),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(prefixText: '\$'),
                  onChanged: (v) {
                    final parsed = double.tryParse(v);
                    if (parsed != null) {
                      _markDirty(() => laborRate = parsed);
                    }
                  },
                ),
              ),
              const SizedBox(width: 6),
              const Text('/hr'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  key: ValueKey('quote-taxRate-$_remoteRevision'),
                  initialValue: (taxRate * 100).toStringAsFixed(2),
                  keyboardType: TextInputType.number,
                  decoration: _fieldDecoration('Tax Rate (%)'),
                  onChanged: (v) {
                    final parsed = double.tryParse(v);
                    if (parsed != null) {
                      _markDirty(() => taxRate = parsed / 100);
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  key: ValueKey('quote-ccRate-$_remoteRevision'),
                  initialValue: (ccRate * 100).toStringAsFixed(2),
                  keyboardType: TextInputType.number,
                  decoration: _fieldDecoration('CC Fee Rate (%)'),
                  onChanged: (v) {
                    final parsed = double.tryParse(v);
                    if (parsed != null) {
                      _markDirty(() => ccRate = parsed / 100);
                    }
                  },
                ),
              ),
            ],
          ),
          SwitchListTile(
            value: taxEnabled,
            onChanged: (v) => _markDirty(() => taxEnabled = v),
            title: const Text('Tax enabled'),
          ),
          SwitchListTile(
            value: ccEnabled,
            onChanged: (v) => _markDirty(() => ccEnabled = v),
            title: const Text('Credit card fee enabled'),
          ),
        ],
      ),
      isComplete: quoteName.trim().isNotEmpty,
    );
  }

  String _updateQuoteNameForServiceType(
    String current,
    String previousType,
    String nextType,
  ) {
    if (current.trim().isEmpty) {
      return current;
    }
    if (current.contains('\n')) {
      final lines = current.split('\n');
      lines[lines.length - 1] = nextType;
      return lines.join('\n');
    }
    if (current.contains(previousType)) {
      return current.replaceFirst(previousType, nextType);
    }
    return current;
  }

  @override
  Widget _buildDiscussSection() {
    return _sectionCard(
      context,
      'Discuss',
      Column(
        children: [
          SwitchListTile(
            value: homeOccupied,
            onChanged: (v) => _markDirty(() => homeOccupied = v),
            title: const Text('Home Occupied'),
            subtitle: Text(homeOccupied ? 'Yes' : 'No'),
          ),
          const SizedBox(height: 4),
          TextFormField(
            key: ValueKey('quote-entryCode-$_remoteRevision'),
            initialValue: entryCode,
            decoration: _fieldDecoration('Entry'),
            onChanged: (v) => _markDirty(() => entryCode = v),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            key: ValueKey('quote-paymentMethod-$_remoteRevision'),
            initialValue: paymentMethod,
            items: const [
              DropdownMenuItem(value: 'Zelle', child: Text('Zelle')),
              DropdownMenuItem(value: 'Card', child: Text('Card')),
              DropdownMenuItem(value: 'Check', child: Text('Check')),
              DropdownMenuItem(value: 'Cash', child: Text('Cash')),
            ],
            isExpanded: true,
            onChanged: (v) =>
                _markDirty(() => paymentMethod = v ?? paymentMethod),
            decoration: _fieldDecoration('Payment Method'),
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: feedbackDiscussed,
            onChanged: (v) => _markDirty(() => feedbackDiscussed = v ?? false),
            title: const Text("Feedback, we don't live here :) discussed"),
          ),
        ],
      ),
    );
  }

  @override
  Widget _buildSpecialNotesSection() {
    return _sectionCard(
      context,
      'Special Notes',
      TextFormField(
        key: ValueKey('quote-specialNotes-$_remoteRevision'),
        initialValue: specialNotes,
        maxLines: 5,
        decoration: _fieldDecoration(''),
        onChanged: (v) => _markDirty(() => specialNotes = v),
      ),
    );
  }

  @override
  Widget _buildOccupantsSection() {
    return _sectionCard(
      context,
      'Occupants',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pets', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: petsPresent,
            onChanged: (v) => _markDirty(() => petsPresent = v),
            title: const Text('Enable pets'),
            subtitle: Text(
              petsPresent
                  ? '${pets.where((pet) => !pet.excluded).length} included'
                  : 'Disabled',
            ),
          ),
          if (petsPresent) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: petNameController,
                    decoration: _fieldDecoration('Name'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: petTypeController,
                    decoration: _fieldDecoration('Type'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: petNotesController,
              decoration: _fieldDecoration('Notes'),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: () {
                  final name = petNameController.text.trim();
                  if (name.isEmpty) {
                    _snack(context, 'Pet name is required.');
                    return;
                  }
                  final now = DateTime.now();
                  final pet = Pet(
                    id: now.microsecondsSinceEpoch.toString(),
                    name: name,
                    type: petTypeController.text.trim(),
                    notes: petNotesController.text.trim(),
                    excluded: false,
                    addedAt: now.millisecondsSinceEpoch,
                  );
                  _markDirty(() => pets.add(pet));
                  petNameController.clear();
                  petTypeController.clear();
                  petNotesController.clear();
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Pet'),
              ),
            ),
            const SizedBox(height: 12),
            if (pets.isEmpty)
              Text(
                'No pets added yet.',
                style: Theme.of(context).textTheme.bodySmall,
              )
            else
              _buildOccupantsTable(
                headers: const [
                  'Name',
                  'Type',
                  'Notes',
                  'Time Added',
                  'Excluded',
                  '',
                ],
                columnWidths: const {
                  0: FlexColumnWidth(1.2),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1.6),
                  3: FlexColumnWidth(1),
                  4: FixedColumnWidth(120),
                  5: FixedColumnWidth(60),
                },
                rows: [
                  for (final pet in pets)
                    _occupantsRow(
                      [
                        Text(pet.name),
                        Text(pet.type),
                        Text(pet.notes),
                        Text(_formatTimestamp(pet.addedAt)),
                        Switch(
                          value: pet.excluded,
                          onChanged: (value) => _markDirty(() {
                            final index = pets.indexOf(pet);
                            pets[index] = pet.copyWith(excluded: value);
                          }),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _markDirty(() {
                            pets.remove(pet);
                          }),
                        ),
                      ],
                    ),
                ],
              ),
          ],
          const SizedBox(height: 24),
          Text('Household', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: householdNameController,
                  decoration: _fieldDecoration('Name'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: householdRelationshipController,
                  decoration: _fieldDecoration('Relationship'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: householdNotesController,
            decoration: _fieldDecoration('Notes'),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: () {
                final name = householdNameController.text.trim();
                if (name.isEmpty) {
                  _snack(context, 'Household member name is required.');
                  return;
                }
                final now = DateTime.now();
                final member = HouseholdMember(
                  id: now.microsecondsSinceEpoch.toString(),
                  name: name,
                  relationship: householdRelationshipController.text.trim(),
                  notes: householdNotesController.text.trim(),
                  addedAt: now.millisecondsSinceEpoch,
                );
                _markDirty(() => householdMembers.add(member));
                householdNameController.clear();
                householdRelationshipController.clear();
                householdNotesController.clear();
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Household Member'),
            ),
          ),
          const SizedBox(height: 12),
          if (householdMembers.isEmpty)
            Text(
              'No household members added yet.',
              style: Theme.of(context).textTheme.bodySmall,
            )
          else
            _buildOccupantsTable(
              headers: const [
                'Name',
                'Relationship',
                'Notes',
                'Time Added',
                '',
              ],
              columnWidths: const {
                0: FlexColumnWidth(1.2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1.6),
                3: FlexColumnWidth(1),
                4: FixedColumnWidth(60),
              },
              rows: [
                for (final member in householdMembers)
                  _occupantsRow(
                    [
                      Text(member.name),
                      Text(member.relationship),
                      Text(member.notes),
                      Text(_formatTimestamp(member.addedAt)),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _markDirty(() {
                          householdMembers.remove(member);
                        }),
                      ),
                    ],
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Table _buildOccupantsTable({
    required List<String> headers,
    required List<TableRow> rows,
    Map<int, TableColumnWidth>? columnWidths,
  }) {
    final theme = Theme.of(context);
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300, width: 1),
      columnWidths: columnWidths,
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        _occupantsHeaderRow(
          headers,
          headerColor: theme.colorScheme.surfaceContainerHighest,
          headerTextColor: theme.colorScheme.onSurfaceVariant,
        ),
        ...rows,
      ],
    );
  }

  TableRow _occupantsHeaderRow(
    List<String> headers, {
    required Color headerColor,
    required Color headerTextColor,
  }) {
    return _occupantsRow(
      headers
          .map(
            (header) => Text(
              header,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: headerTextColor,
              ),
            ),
          )
          .toList(),
      rowColor: headerColor,
    );
  }

  TableRow _occupantsRow(
    List<Widget> cells, {
    Color? rowColor,
  }) {
    return TableRow(
      decoration: rowColor == null ? null : BoxDecoration(color: rowColor),
      children: cells
          .map(
            (cell) => Padding(
              padding: const EdgeInsets.all(8),
              child: cell,
            ),
          )
          .toList(),
    );
  }

  @override
  Widget _buildPricingSection({
    required _Totals totals,
    required double serviceTypeRate,
    required double frequencyMultiplier,
    required double sqFt,
    required double sqFtEstimate,
  }) {
    return _sectionCard(
      context,
      'Pricing',
      Column(
        children: [
          _pricingBlock(context, 'Square Footage Estimate', [
            _row('Sq Ft', sqFt.toStringAsFixed(0)),
            _row('Rate', '\$${serviceTypeRate.toStringAsFixed(2)}/sq ft'),
            _row('Multiplier', frequencyMultiplier.toStringAsFixed(2)),
            const Divider(),
            _row('Total', _money(sqFtEstimate), bold: true),
          ]),
          const SizedBox(height: 12),
          _pricingBlock(context, 'Labor Hours Estimate', [
            _row('Labor', '${totals.hours.toStringAsFixed(2)} hrs'),
            _row('Subtotal', _money(totals.subtotal)),
            _row('Tax', _money(totals.tax)),
            _row('CC Fee', _money(totals.ccFee)),
            const Divider(),
            _row('Total', _money(totals.total), bold: true),
          ]),
        ],
      ),
    );
  }

  @override
  Widget _buildActionButtons() {
    return Column(
      children: [
        FilledButton.icon(
          onPressed: _isGeneratingDocument
              ? null
              : () => _generateFinalizedDocument(
                    FinalizedDocumentType.quote,
                  ),
          icon: const Icon(Icons.picture_as_pdf_outlined),
          label: const Text('Generate Quote PDF'),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: _isGeneratingDocument
              ? null
              : () => _generateFinalizedDocument(
                    FinalizedDocumentType.invoice,
                  ),
          icon: const Icon(Icons.receipt_long),
          label: const Text('Generate Invoice PDF'),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _saveQuote,
          icon: const Icon(Icons.save_outlined),
          label: const Text('Save Quote'),
        ),
      ],
    );
  }
}
