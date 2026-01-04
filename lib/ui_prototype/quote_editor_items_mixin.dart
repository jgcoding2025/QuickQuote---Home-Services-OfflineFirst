part of '../ui_prototype.dart';

mixin _QuoteEditorItemsMixin on _QuoteEditorStateAccess {
  _RoomTypeStandard? _roomTypeStandardFor(String roomType) {
    for (final standard in _roomTypeStandards) {
      if (standard.roomType == roomType) {
        return standard;
      }
    }
    return null;
  }

  _SubItemStandard? _subItemStandardForLabel(String label) {
    for (final standard in _subItemStandards) {
      if (standard.subItem == label || _subItemLabel(standard) == label) {
        return standard;
      }
    }
    return null;
  }

  _QuoteItem _applyRoomStandards(_QuoteItem draft) {
    final standard = _roomTypeStandardFor(draft.title);
    if (standard == null) {
      return draft;
    }
    return draft.copyWith(
      estSqFt: standard.squareFeet,
      minutes: standard.minutes,
    );
  }

  _QuoteItem _applyRoomMultipliers(_QuoteItem draft) {
    final sizeMultiplier = _sizeMultiplier(draft.size);
    final complexityMultiplier = _complexityMultiplier(draft.complexity);
    return draft.copyWith(
      estSqFt: (draft.estSqFt * sizeMultiplier).round(),
      minutes: (draft.minutes * sizeMultiplier * complexityMultiplier).round(),
    );
  }

  _QuoteItem _applySubItemStandards(_QuoteItem draft) {
    final standard = _subItemStandardForLabel(draft.title);
    if (standard == null) {
      return draft;
    }
    return draft.copyWith(minutes: standard.minutes);
  }

  @override
  String _uniqueRoomTitle(String baseTitle, {String? currentTitle}) {
    final existingTitles = items
        .where((item) => item.type == 'Room' && item.title != currentTitle)
        .map((item) => item.title)
        .toSet();
    if (!existingTitles.contains(baseTitle)) {
      return baseTitle;
    }
    var suffix = 2;
    while (existingTitles.contains('$baseTitle $suffix')) {
      suffix += 1;
    }
    return '$baseTitle $suffix';
  }

  @override
  List<DropdownMenuItem<String>> _roomTypeMenuItems(
    List<_RoomTypeStandard> roomTypes,
    List<String> fallbackOptions,
  ) {
    if (roomTypes.isEmpty) {
      return fallbackOptions
          .map((room) => DropdownMenuItem(value: room, child: Text(room)))
          .toList();
    }
    final sortedRooms = [...roomTypes]..sort((a, b) => a.row.compareTo(b.row));
    final items = <DropdownMenuItem<String>>[];
    String? currentCategory;
    for (final room in sortedRooms) {
      if (room.category != currentCategory) {
        currentCategory = room.category;
        items.add(
          DropdownMenuItem<String>(
            value: '__room-category-${room.category}',
            enabled: false,
            child: Text(
              room.category,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        );
      }
      items.add(
        DropdownMenuItem(
          value: room.roomType,
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(room.roomType),
                if (room.description.trim().isNotEmpty)
                  Text(
                    room.description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
        ),
      );
    }
    return items;
  }

  @override
  List<DropdownMenuItem<String>> _subItemMenuItems(
    List<_SubItemStandard> subItems,
    List<String> fallbackOptions,
  ) {
    if (subItems.isEmpty) {
      return fallbackOptions
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList();
    }
    final items = <DropdownMenuItem<String>>[];
    String? currentCategory;
    for (final item in subItems) {
      if (item.category != currentCategory) {
        currentCategory = item.category;
        items.add(
          DropdownMenuItem<String>(
            value: '__subitem-category-${item.category}',
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
        DropdownMenuItem(
          value: _subItemLabel(item),
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.subItem),
                if (item.description.trim().isNotEmpty)
                  Text(
                    item.description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
        ),
      );
    }
    return items;
  }

  String _preferredAddonTitle(
    _QuoteItem room,
    List<_SubItemStandard> subItemStandards,
    List<String> fallbackOptions,
  ) {
    final addonTitles = items
        .where(
          (item) => item.type != 'Room' && item.roomAssignment == room.title,
        )
        .map((item) => item.title)
        .toSet();
    final ceilingLabel = _subItemLabelFor('Ceiling Fan', subItemStandards);
    final windowLabel = _subItemLabelFor('Window: Standard', subItemStandards);
    if (ceilingLabel != null && !addonTitles.contains(ceilingLabel)) {
      return ceilingLabel;
    }
    if (windowLabel != null && !addonTitles.contains(windowLabel)) {
      return windowLabel;
    }
    return fallbackOptions.isNotEmpty ? fallbackOptions.first : 'Add-on';
  }

  @override
  Widget _buildRoomsSection({
    required String resolvedRoomType,
    required String resolvedSize,
    required String resolvedComplexity,
    required List<String> roomTypeOptions,
    required List<String> subItemOptions,
    required List<DropdownMenuItem<String>> roomTypeMenuItems,
    required List<DropdownMenuItem<String>> subItemMenuItems,
    required List<String> sizeOptions,
    required List<String> complexityOptions,
    required List<_SubItemStandard> subItemStandards,
    required List<String> roomTitles,
  }) {
    final levelOptions = _QuoteEditorPageState._levelOptions;
    return _sectionCard(
      context,
      'Rooms',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _choiceChips(
            label: 'Level',
            options: levelOptions,
            value: defaultLevel,
            onChanged: (value) => _markDirty(() => defaultLevel = value),
          ),
          const SizedBox(height: 12),
          _choiceChips(
            label: 'Size',
            options: sizeOptions,
            value: resolvedSize,
            onChanged: (value) => _markDirty(() => defaultSize = value),
          ),
          const SizedBox(height: 12),
          _choiceChips(
            label: 'Complexity',
            options: complexityOptions,
            value: resolvedComplexity,
            onChanged: (value) => _markDirty(() => defaultComplexity = value),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            key: ValueKey('quote-defaultRoomType-$_remoteRevision'),
            initialValue: resolvedRoomType,
            items: roomTypeMenuItems,
            isExpanded: true,
            itemHeight: null,
            selectedItemBuilder: (context) =>
                _simpleMenuLabels(roomTypeMenuItems),
            onChanged: (v) =>
                _markDirty(() => defaultRoomType = v ?? resolvedRoomType),
            decoration: _fieldDecoration('Room Type').copyWith(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: () => _addRoomQuick(
                resolvedRoomType: resolvedRoomType,
                resolvedSize: resolvedSize,
                resolvedComplexity: resolvedComplexity,
              ),
              icon: const Icon(Icons.add),
              label: const Text('Add Room'),
            ),
          ),
          const SizedBox(height: 8),
          _buildRoomGroupSection(
            roomEntries: items.asMap().entries.where(
              (entry) => entry.value.type == 'Room',
            ),
            allEntries: items.asMap().entries,
            emptyLabel: 'No rooms yet. Tap Add Room to start.',
            levelOptions: levelOptions,
            roomTypeOptions: roomTypeOptions,
            subItemOptions: subItemOptions,
            subItemStandards: subItemStandards,
            roomTypeMenuItems: roomTypeMenuItems,
            subItemMenuItems: subItemMenuItems,
            sizeOptions: sizeOptions,
            complexityOptions: complexityOptions,
            roomTitles: roomTitles,
          ),
        ],
      ),
      isComplete: items.any((item) => item.type == 'Room'),
    );
  }

  @override
  Widget _buildAdditionalItemsSection({
    required String resolvedSubItem,
    required List<String> subItemOptions,
    required List<String> roomTypeOptions,
    required List<DropdownMenuItem<String>> roomTypeMenuItems,
    required List<DropdownMenuItem<String>> subItemMenuItems,
    required List<String> sizeOptions,
    required List<String> complexityOptions,
    required List<String> roomTitles,
  }) {
    final levelOptions = _QuoteEditorPageState._levelOptions;
    return _sectionCard(
      context,
      'Additional Items',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: () => _markDirty(
                  () => items.add(
                    _applySubItemStandards(
                      _QuoteItem(
                        'Addon',
                        defaultLevel,
                        resolvedSubItem,
                        defaultSize,
                        defaultComplexity,
                        0,
                        30,
                        1,
                        true,
                        '',
                        '',
                      ),
                    ),
                  ),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Add-on'),
              ),
              OutlinedButton.icon(
                onPressed: () => _markDirty(
                  () => items.add(
                    _QuoteItem(
                      'Manual',
                      defaultLevel,
                      'Custom item',
                      defaultSize,
                      defaultComplexity,
                      0,
                      30,
                      1,
                      true,
                      '',
                      '',
                    ),
                  ),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Manual Item'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildItemSection(
            items.asMap().entries.where(
              (entry) =>
                  entry.value.type != 'Room' &&
                  entry.value.roomAssignment.trim().isEmpty,
            ),
            emptyLabel: 'No add-ons yet. Add one to estimate extras.',
            levelOptions: levelOptions,
            roomTypeOptions: roomTypeOptions,
            subItemOptions: subItemOptions,
            roomTypeMenuItems: roomTypeMenuItems,
            subItemMenuItems: subItemMenuItems,
            sizeOptions: sizeOptions,
            complexityOptions: complexityOptions,
            roomTitles: roomTitles,
          ),
        ],
      ),
    );
  }

  void _addRoomQuick({
    required String resolvedRoomType,
    required String resolvedSize,
    required String resolvedComplexity,
  }) {
    final draft = _applyRoomMultipliers(
      _applyRoomStandards(
        _QuoteItem(
          'Room',
          defaultLevel,
          resolvedRoomType,
          resolvedSize,
          resolvedComplexity,
          150,
          45,
          1,
          true,
          '',
          '',
        ),
      ),
    );

    _markDirty(() {
      final uniqueTitle = _uniqueRoomTitle(draft.title);
      items.add(draft.copyWith(title: uniqueTitle));
      _syncEstimatedSqFt();
    });
  }

  @override
  Future<void> _addAddonForRoom(
    _QuoteItem room, {
    required List<String> levelOptions,
    required List<String> roomTypeOptions,
    required List<String> subItemOptions,
    required List<_SubItemStandard> subItemStandards,
    required List<DropdownMenuItem<String>> roomTypeMenuItems,
    required List<DropdownMenuItem<String>> subItemMenuItems,
    required List<String> sizeOptions,
    required List<String> complexityOptions,
    required List<String> roomTitles,
  }) async {
    final addonTitle = _preferredAddonTitle(
      room,
      subItemStandards,
      subItemOptions,
    );
    final draft = _applySubItemStandards(
      _QuoteItem(
        'Addon',
        room.level,
        addonTitle,
        room.size,
        room.complexity,
        0,
        30,
        1,
        true,
        '',
        room.title,
      ),
    );

    final result = await showDialog<_QuoteItem>(
      context: context,
      builder: (_) => _EditItemDialog(
        item: draft,
        roomTypeStandards: _roomTypeStandards,
        subItemStandards: _subItemStandards,
        sizeStandards: _sizeStandards,
        complexityStandards: _complexityStandards,
        levelOptions: levelOptions,
        roomTypeOptions: roomTypeOptions,
        subItemOptions: subItemOptions,
        roomTypeMenuItems: roomTypeMenuItems,
        subItemMenuItems: subItemMenuItems,
        sizeOptions: sizeOptions,
        complexityOptions: complexityOptions,
        roomTitles: roomTitles,
      ),
    );

    if (result != null) {
      _markDirty(() => items.add(result));
    }
  }
}
