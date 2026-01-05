part of '../ui_prototype.dart';

mixin _QuoteEditorUiHelpers on _QuoteEditorStateAccess {
  @override
  Widget _choiceChips({
    required String label,
    required List<String> options,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options
              .map(
                (option) => ChoiceChip(
                  label: Text(option),
                  selected: option == value,
                  onSelected: (selected) {
                    if (selected) {
                      onChanged(option);
                    }
                  },
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  @override
  String _subItemLabel(SubItemStandard item) {
    final description = item.description.trim();
    if (description.isEmpty) {
      return item.subItem;
    }
    return '${item.subItem} ($description)';
  }

  @override
  String? _subItemLabelFor(String name, List<SubItemStandard> subItems) {
    for (final item in subItems) {
      if (item.subItem == name) {
        return _subItemLabel(item);
      }
    }
    return null;
  }

  @override
  Widget _pricingBlock(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    final textStyle = Theme.of(context).textTheme.titleSmall;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: textStyle),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  Widget _row(String label, String value, {bool bold = false}) {
    final style = bold ? const TextStyle(fontWeight: FontWeight.bold) : null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: style),
          const Spacer(),
          Text(value, style: style),
        ],
      ),
    );
  }

  @override
  String _money(double v) => '\$${v.toStringAsFixed(2)}';

  @override
  String _formatTimestamp(int timestamp) {
    if (timestamp <= 0) {
      return '--';
    }
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final mm = date.month.toString().padLeft(2, '0');
    final dd = date.day.toString().padLeft(2, '0');
    final yyyy = date.year.toString();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$mm/$dd/$yyyy $hour:$minute';
  }

  @override
  Widget _sectionCard(
    BuildContext context,
    String title,
    Widget child, {
    bool initiallyExpanded = false,
    bool isComplete = true,
  }) {
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    return Card(
      child: ExpansionTile(
        shape: const Border(), // removes the expanded outline/dividers
        collapsedShape:
            const Border(), // removes the collapsed outline/dividers
        initiallyExpanded: initiallyExpanded,
        maintainState: true,
        title: Row(
          children: [
            Expanded(child: Text(title, style: titleStyle)),
            if (!isComplete)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 16,
                      color: Colors.deepOrange,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Incomplete',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        childrenPadding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        children: [child],
      ),
    );
  }

  @override
  InputDecoration _fieldDecoration(String label) {
    return InputDecoration(
      labelText: label.isEmpty ? null : label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget _pill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}
