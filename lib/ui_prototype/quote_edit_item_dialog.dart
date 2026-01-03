part of '../ui_prototype.dart';

class _EditItemDialog extends StatefulWidget {
  const _EditItemDialog({
    required this.item,
    required this.roomTypeStandards,
    required this.subItemStandards,
    required this.sizeStandards,
    required this.complexityStandards,
    required this.levelOptions,
    required this.roomTypeOptions,
    required this.subItemOptions,
    required this.roomTypeMenuItems,
    required this.subItemMenuItems,
    required this.sizeOptions,
    required this.complexityOptions,
    required this.roomTitles,
  });
  final _QuoteItem item;
  final List<_RoomTypeStandard> roomTypeStandards;
  final List<_SubItemStandard> subItemStandards;
  final List<_SizeStandard> sizeStandards;
  final List<_ComplexityStandard> complexityStandards;
  final List<String> levelOptions;
  final List<String> roomTypeOptions;
  final List<String> subItemOptions;
  final List<DropdownMenuItem<String>> roomTypeMenuItems;
  final List<DropdownMenuItem<String>> subItemMenuItems;
  final List<String> sizeOptions;
  final List<String> complexityOptions;
  final List<String> roomTitles;

  @override
  State<_EditItemDialog> createState() => _EditItemDialogState();
}

class _EditItemDialogState extends State<_EditItemDialog> {
  late String type = widget.item.type;
  late String level = widget.item.level;
  late String title = widget.item.title;
  late String size = widget.item.size;
  late String complexity = widget.item.complexity;
  late int estSqFt = widget.item.estSqFt;
  late int minutes = widget.item.minutes;
  late int qty = widget.item.qty;
  late bool include = widget.item.include;
  late String notes = widget.item.notes;
  late String roomAssignment = widget.item.roomAssignment;
  late int baseEstSqFt;
  late int baseMinutes;

  @override
  void initState() {
    super.initState();
    baseEstSqFt = _normalizeBaseSqFt(widget.item);
    baseMinutes = _normalizeBaseMinutes(widget.item);
  }

  String _subItemLabel(_SubItemStandard item) {
    final description = item.description.trim();
    if (description.isEmpty) {
      return item.subItem;
    }
    return '${item.subItem} ($description)';
  }

  _RoomTypeStandard? _roomTypeStandardFor(String roomType) {
    for (final standard in widget.roomTypeStandards) {
      if (standard.roomType == roomType) {
        return standard;
      }
    }
    return null;
  }

  _SubItemStandard? _subItemStandardForLabel(String label) {
    for (final standard in widget.subItemStandards) {
      if (standard.subItem == label || _subItemLabel(standard) == label) {
        return standard;
      }
    }
    return null;
  }

  double _sizeMultiplier(String size) {
    for (final standard in widget.sizeStandards) {
      if (standard.size == size) {
        return standard.multiplier;
      }
    }
    return 1.0;
  }

  double _complexityMultiplier(String complexity) {
    for (final standard in widget.complexityStandards) {
      if (standard.level == complexity) {
        return standard.multiplier;
      }
    }
    return 1.0;
  }

  int _normalizeBaseSqFt(_QuoteItem item) {
    if (item.type != 'Room') {
      return item.estSqFt;
    }
    final standard = _roomTypeStandardFor(item.title);
    if (standard != null) {
      return standard.squareFeet;
    }
    return item.estSqFt;
  }

  int _normalizeBaseMinutes(_QuoteItem item) {
    if (item.type == 'Room') {
      final standard = _roomTypeStandardFor(item.title);
      if (standard != null) {
        return standard.minutes;
      }
    }
    if (item.type == 'Addon') {
      final standard = _subItemStandardForLabel(item.title);
      if (standard != null) {
        return standard.minutes;
      }
    }
    return item.minutes;
  }

  void _recalculateEstimates() {
    final sizeMultiplier = _sizeMultiplier(size);
    final complexityMultiplier = _complexityMultiplier(complexity);
    if (type == 'Room') {
      estSqFt = (baseEstSqFt * sizeMultiplier).round();
    }
    minutes =
        (baseMinutes * sizeMultiplier * complexityMultiplier).round();
  }

  void _applyStandardForTitle() {
    if (type == 'Room') {
      final standard = _roomTypeStandardFor(title);
      if (standard != null) {
        baseEstSqFt = standard.squareFeet;
        baseMinutes = standard.minutes;
      }
    } else if (type == 'Addon') {
      final standard = _subItemStandardForLabel(title);
      if (standard != null) {
        baseMinutes = standard.minutes;
      }
    }
    _recalculateEstimates();
  }

  String _resolveOption(String current, List<String> options) {
    if (options.contains(current)) {
      return current;
    }
    return options.isNotEmpty ? options.first : current;
  }

  List<String> _menuValues(List<DropdownMenuItem<String>> items) {
    return items
        .where((item) => item.enabled != false)
        .map((item) => item.value)
        .whereType<String>()
        .toList();
  }

  void _syncOption(
    String current,
    String resolved,
    ValueSetter<String> assign,
  ) {
    if (current == resolved) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => assign(resolved));
      }
    });
  }

  InputDecoration _dialogDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.blueGrey.withValues(alpha: 0.05),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

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
  Widget build(BuildContext context) {
    final roomTypeValues = _menuValues(widget.roomTypeMenuItems);
    final subItemValues = _menuValues(widget.subItemMenuItems);
    final levelOptions = widget.levelOptions.isNotEmpty
        ? widget.levelOptions
        : [level];
    final sizeOptions = widget.sizeOptions.isNotEmpty
        ? widget.sizeOptions
        : [size];
    final complexityOptions = widget.complexityOptions.isNotEmpty
        ? widget.complexityOptions
        : [complexity];
    final roomTypeOptions = roomTypeValues.isNotEmpty
        ? roomTypeValues
        : (widget.roomTypeOptions.isNotEmpty ? widget.roomTypeOptions : [title]);
    final subItemOptions = subItemValues.isNotEmpty
        ? subItemValues
        : (widget.subItemOptions.isNotEmpty ? widget.subItemOptions : [title]);

    final resolvedLevel = _resolveOption(level, levelOptions);
    final resolvedSize = _resolveOption(size, sizeOptions);
    final resolvedComplexity = _resolveOption(complexity, complexityOptions);
    final baseRoomOptions = widget.roomTitles;
    final roomAssignmentOptions = <String>['', ...baseRoomOptions];
    final resolvedRoomAssignment = _resolveOption(
      roomAssignment,
      roomAssignmentOptions,
    );
    final resolvedTitle = type == 'Room'
        ? _resolveOption(title, roomTypeOptions)
        : type == 'Addon'
            ? _resolveOption(title, subItemOptions)
            : title;

    _syncOption(level, resolvedLevel, (v) => level = v);
    _syncOption(size, resolvedSize, (v) => size = v);
    _syncOption(complexity, resolvedComplexity, (v) => complexity = v);
    if (type != 'Manual') {
      _syncOption(title, resolvedTitle, (v) => title = v);
    }
    _syncOption(
      roomAssignment,
      resolvedRoomAssignment,
      (v) => roomAssignment = v,
    );

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Edit item'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Item details'),
            DropdownButtonFormField<String>(
              initialValue: type,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'Room', child: Text('Room')),
                DropdownMenuItem(value: 'Addon', child: Text('Add-on')),
                DropdownMenuItem(value: 'Manual', child: Text('Manual')),
              ],
              onChanged: (v) => setState(() {
                type = v ?? type;
                if (type == 'Room' && roomAssignment.isNotEmpty) {
                  roomAssignment = '';
                }
                if (type == 'Room' &&
                    roomTypeOptions.isNotEmpty &&
                    !roomTypeOptions.contains(title)) {
                  title = roomTypeOptions.first;
                }
                if (type == 'Addon' &&
                    subItemOptions.isNotEmpty &&
                    !subItemOptions.contains(title)) {
                  title = subItemOptions.first;
                }
                if (type == 'Manual') {
                  baseEstSqFt = estSqFt;
                  baseMinutes = minutes;
                }
                _applyStandardForTitle();
              }),
              decoration: _dialogDecoration('Type'),
            ),
            const SizedBox(height: 12),
            if (type == 'Manual')
              TextFormField(
                initialValue: title,
                decoration: _dialogDecoration('Title'),
                onChanged: (v) => title = v,
              )
            else
              DropdownButtonFormField<String>(
                initialValue: type == 'Room'
                    ? _resolveOption(title, roomTypeOptions)
                    : _resolveOption(title, subItemOptions),
                isExpanded: true,
                itemHeight: null,
                items: type == 'Room'
                    ? widget.roomTypeMenuItems
                    : widget.subItemMenuItems,
                selectedItemBuilder: (context) => _simpleMenuLabels(
                  type == 'Room'
                      ? widget.roomTypeMenuItems
                      : widget.subItemMenuItems,
                ),
                onChanged: (v) => setState(() {
                  title = v ?? title;
                  _applyStandardForTitle();
                }),
                decoration: _dialogDecoration(
                  type == 'Room' ? 'Room Type' : 'Add-on Item',
                ).copyWith(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 12,
                  ),
                ),
              ),
            if (type != 'Room') ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: resolvedRoomAssignment,
                isExpanded: true,
                items: roomAssignmentOptions
                    .map(
                      (room) => DropdownMenuItem(
                        value: room,
                        child: Text(
                          room.isEmpty ? 'Unassigned' : room,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(
                  () => roomAssignment = v ?? resolvedRoomAssignment,
                ),
                decoration: _dialogDecoration('Assigned Room'),
              ),
            ],
            const SizedBox(height: 16),
            _sectionTitle('Level & sizing'),
            _choiceChips(
              label: 'Level',
              options: levelOptions,
              value: resolvedLevel,
              onChanged: (value) => setState(() => level = value),
            ),
            const SizedBox(height: 12),
            _choiceChips(
              label: 'Size',
              options: sizeOptions,
              value: resolvedSize,
              onChanged: (value) => setState(() {
                size = value;
                _recalculateEstimates();
              }),
            ),
            const SizedBox(height: 12),
            _choiceChips(
              label: 'Complexity',
              options: complexityOptions,
              value: resolvedComplexity,
              onChanged: (value) => setState(() {
                complexity = value;
                _recalculateEstimates();
              }),
            ),
            const SizedBox(height: 16),
            _sectionTitle('Estimate'),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    key: ValueKey('estSqFt-$estSqFt'),
                    initialValue: estSqFt.toString(),
                    decoration: _dialogDecoration('Est Sq Ft'),
                    keyboardType: TextInputType.number,
                    onChanged: (v) {
                      final parsed = int.tryParse(v);
                      if (parsed == null) {
                        return;
                      }
                      estSqFt = parsed;
                      if (type == 'Room') {
                        final multiplier = _sizeMultiplier(size);
                        if (multiplier != 0) {
                          baseEstSqFt = (parsed / multiplier).round();
                        }
                      } else {
                        baseEstSqFt = parsed;
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    key: ValueKey('minutes-$minutes'),
                    initialValue: minutes.toString(),
                    decoration: _dialogDecoration('Minutes'),
                    keyboardType: TextInputType.number,
                    onChanged: (v) {
                      final parsed = int.tryParse(v);
                      if (parsed == null) {
                        return;
                      }
                      minutes = parsed;
                      final multiplier =
                          _sizeMultiplier(size) *
                          _complexityMultiplier(complexity);
                      if (multiplier != 0) {
                        baseMinutes = (parsed / multiplier).round();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    key: ValueKey('qty-$qty'),
                    initialValue: qty.toString(),
                    decoration: _dialogDecoration('Qty'),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => qty = int.tryParse(v) ?? qty,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _sectionTitle('Notes'),
            TextFormField(
              initialValue: notes,
              decoration: _dialogDecoration('Notes'),
              onChanged: (v) => notes = v,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(
            context,
            _QuoteItem(
              type,
              level,
              title,
              size,
              complexity,
              estSqFt,
              minutes,
              qty,
              include,
              notes,
              roomAssignment,
            ),
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
