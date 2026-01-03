part of '../ui_prototype.dart';

mixin _SettingsStateAccess on State<SettingsPage> {
  Future<void> _save(OrgSettings s);
}

mixin _SettingsSectionsMixin on _SettingsStateAccess {
  Widget _moneyRow({
    required BuildContext context,
    required String label,
    required double value,
    required String suffix,
    required ValueChanged<double> onChanged,
  }) {
    final controller = TextEditingController(text: value.toStringAsFixed(2));
    return Row(
      children: [
        Expanded(child: Text(label)),
        SizedBox(
          width: 140,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(prefixText: '\$', suffixText: suffix),
            onSubmitted: (v) {
              final parsed = double.tryParse(v);
              if (parsed != null) onChanged(parsed);
            },
          ),
        ),
      ],
    );
  }

  Widget _percentRow({
    required BuildContext context,
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    final controller = TextEditingController(
      text: (value * 100).toStringAsFixed(2),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          SizedBox(
            width: 140,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(suffixText: '%'),
              onSubmitted: (v) {
                final parsed = double.tryParse(v);
                if (parsed != null) onChanged(parsed / 100);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsSection(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: false,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        children: [child],
      ),
    );
  }

  Widget _servicePricingCard(
    BuildContext context,
    List<_ServiceTypeStandard> serviceTypes,
  ) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Price per square foot. All multipliers are based on deviation from Standard Clean pricing.',
        ),
        const SizedBox(height: 12),
        Table(
          border: TableBorder.all(color: Colors.grey.shade400, width: 1),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: FlexColumnWidth(2.6),
            1: FlexColumnWidth(1.1),
            2: FlexColumnWidth(1.2),
          },
          children: [
            _tableRow(
              const ['Service type', '\$/Sq.Ft.', 'Multiplier'],
              isHeader: true,
              headerColor: theme.colorScheme.surfaceContainerHighest,
              headerTextColor: theme.colorScheme.onSurfaceVariant,
            ),
            ...serviceTypes.map(
              (standard) => _tableRow([
                standard.serviceType,
                '\$${standard.pricePerSqFt.toStringAsFixed(2)}',
                standard.multiplier.toStringAsFixed(2),
              ]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _serviceModifiersCard(BuildContext context, _SettingsData data) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Complexity'),
        const SizedBox(height: 12),
        Table(
          border: TableBorder.all(color: Colors.grey.shade400, width: 1),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1.2),
            2: FlexColumnWidth(2.6),
          },
          children: [
            _tableRow(
              const ['Level', 'Multiplier', 'Definition'],
              isHeader: true,
              headerColor: theme.colorScheme.surfaceContainerHighest,
              headerTextColor: theme.colorScheme.onSurfaceVariant,
            ),
            ...data.complexities.map(
              (standard) => _tableRow([
                standard.level,
                standard.multiplier.toStringAsFixed(2),
                standard.definition,
              ]),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text('Sizes'),
        const SizedBox(height: 12),
        Table(
          border: TableBorder.all(color: Colors.grey.shade400, width: 1),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1.2),
            2: FlexColumnWidth(2.6),
          },
          children: [
            _tableRow(
              const ['Size', 'Multiplier', 'Definition'],
              isHeader: true,
              headerColor: theme.colorScheme.surfaceContainerHighest,
              headerTextColor: theme.colorScheme.onSurfaceVariant,
            ),
            ...data.sizes.map(
              (standard) => _tableRow([
                standard.size,
                standard.multiplier.toStringAsFixed(2),
                standard.definition,
              ]),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text('Frequency standards for discounts'),
        const SizedBox(height: 12),
        Table(
          border: TableBorder.all(color: Colors.grey.shade400, width: 1),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: FlexColumnWidth(1.6),
            1: FlexColumnWidth(1.2),
            2: FlexColumnWidth(1.4),
          },
          children: [
            _tableRow(
              const ['Service type', 'Multiplier', 'Frequency'],
              isHeader: true,
              headerColor: theme.colorScheme.surfaceContainerHighest,
              headerTextColor: theme.colorScheme.onSurfaceVariant,
            ),
            ...data.frequencies.map(
              (standard) => _tableRow([
                standard.serviceType,
                standard.multiplier.toStringAsFixed(2),
                standard.frequency,
              ]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _quoteDefaultsCard(BuildContext context, OrgSettings s) {
    return Column(
      children: [
        _moneyRow(
          context: context,
          label: 'Default labor rate',
          value: s.laborRate,
          suffix: '/hr',
          onChanged: (v) => _save(s.copyWith(laborRate: v)),
        ),
        const Divider(),
        SwitchListTile(
          value: s.taxEnabled,
          onChanged: (v) => _save(s.copyWith(taxEnabled: v)),
          title: const Text('Tax'),
          subtitle: const Text('Default OFF'),
        ),
        if (s.taxEnabled)
          _percentRow(
            context: context,
            label: 'Tax rate',
            value: s.taxRate,
            onChanged: (v) => _save(s.copyWith(taxRate: v)),
          ),
        const Divider(),
        SwitchListTile(
          value: s.ccEnabled,
          onChanged: (v) => _save(s.copyWith(ccEnabled: v)),
          title: const Text('Credit card fee'),
          subtitle: const Text('Applied to subtotal + tax'),
        ),
        if (s.ccEnabled)
          _percentRow(
            context: context,
            label: 'CC rate',
            value: s.ccRate,
            onChanged: (v) => _save(s.copyWith(ccRate: v)),
          ),
      ],
    );
  }

  Widget _planTierCard(BuildContext context, List<_PlanTier> planTiers) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Service tiers based on client preferences and budget'),
        const SizedBox(height: 12),
        Table(
          border: TableBorder.all(color: Colors.grey.shade400, width: 1),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: FlexColumnWidth(1.2),
            1: FlexColumnWidth(1.2),
            2: FlexColumnWidth(2.6),
          },
          children: [
            _tableRow(
              const ['Tier', 'Multiplier', 'Description'],
              isHeader: true,
              headerColor: theme.colorScheme.surfaceContainerHighest,
              headerTextColor: theme.colorScheme.onSurfaceVariant,
            ),
            ...planTiers.map(
              (tier) => _tableRow([
                '${tier.name} (${tier.label})',
                tier.multiplier.toStringAsFixed(2),
                tier.description,
              ], rowColor: tier.color),
            ),
          ],
        ),
      ],
    );
  }

  Widget _addonsPricingCard(
    BuildContext context,
    List<_SubItemStandard> subItems,
  ) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Default sub-item standards'),
        const Text('Based on Standard Complexity and Medium Size'),
        const SizedBox(height: 12),
        Table(
          border: TableBorder.all(color: Colors.grey.shade400, width: 1),
          columnWidths: const {0: FlexColumnWidth(2.4), 1: FlexColumnWidth(1)},
          children: [
            _tableRow(
              const ['Sub-item', 'Time (min)'],
              isHeader: true,
              headerColor: theme.colorScheme.surfaceContainerHighest,
              headerTextColor: theme.colorScheme.onSurfaceVariant,
            ),
            ...subItems.map(
              (standard) => _tableRow([
                _subItemDisplayLabel(standard),
                standard.minutes.toString(),
              ]),
            ),
          ],
        ),
      ],
    );
  }

  String _subItemDisplayLabel(_SubItemStandard standard) {
    final description = standard.description.trim();
    if (description.isEmpty) {
      return standard.subItem;
    }
    return '${standard.subItem} ($description)';
  }

  Widget _roomTypeStandardsCard(
    BuildContext context,
    List<_RoomTypeStandard> roomTypes,
  ) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Default room type standards'),
        const Text(
          'Based on Standard Complexity, Medium Size, and Bi-weekly Frequency',
        ),
        const SizedBox(height: 12),
        Table(
          border: TableBorder.all(color: Colors.grey.shade400, width: 1),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: FlexColumnWidth(2.2),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
          },
          children: [
            _tableRow(
              const ['Room type', 'Time (min)', 'Sq.Ft.'],
              isHeader: true,
              headerColor: theme.colorScheme.surfaceContainerHighest,
              headerTextColor: theme.colorScheme.onSurfaceVariant,
            ),
            ...roomTypes.map(
              (standard) => _tableRow([
                standard.roomType,
                standard.minutes.toString(),
                standard.squareFeet.toString(),
              ]),
            ),
          ],
        ),
      ],
    );
  }

  TableRow _tableRow(
    List<String> cells, {
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
              child: Text(
                cell,
                softWrap: !isHeader,
                overflow: isHeader ? TextOverflow.ellipsis : null,
                style: TextStyle(
                  fontWeight: isHeader ? FontWeight.w600 : FontWeight.w400,
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
