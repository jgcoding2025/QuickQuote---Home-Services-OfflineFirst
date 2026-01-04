part of '../ui_prototype.dart';

mixin _QuoteEditorItemCardsMixin on _QuoteEditorStateAccess {
  @override
  Widget _buildItemSection(
    Iterable<MapEntry<int, _QuoteItem>> entries, {
    required String emptyLabel,
    required List<String> levelOptions,
    required List<String> roomTypeOptions,
    required List<String> subItemOptions,
    required List<DropdownMenuItem<String>> roomTypeMenuItems,
    required List<DropdownMenuItem<String>> subItemMenuItems,
    required List<String> sizeOptions,
    required List<String> complexityOptions,
    required List<String> roomTitles,
  }) {
    final list = entries.toList();
    if (list.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(emptyLabel),
      );
    }
    return Column(
      children: list
          .map(
            (e) => _buildItemCard(
              e.key,
              e.value,
              levelOptions: levelOptions,
              roomTypeOptions: roomTypeOptions,
              subItemOptions: subItemOptions,
              roomTypeMenuItems: roomTypeMenuItems,
              subItemMenuItems: subItemMenuItems,
              sizeOptions: sizeOptions,
              complexityOptions: complexityOptions,
              roomTitles: roomTitles,
            ),
          )
          .toList(),
    );
  }

  @override
  Widget _buildRoomGroupSection({
    required Iterable<MapEntry<int, _QuoteItem>> roomEntries,
    required Iterable<MapEntry<int, _QuoteItem>> allEntries,
    required String emptyLabel,
    required List<String> levelOptions,
    required List<String> roomTypeOptions,
    required List<String> subItemOptions,
    required List<SubItemStandard> subItemStandards,
    required List<DropdownMenuItem<String>> roomTypeMenuItems,
    required List<DropdownMenuItem<String>> subItemMenuItems,
    required List<String> sizeOptions,
    required List<String> complexityOptions,
    required List<String> roomTitles,
  }) {
    final rooms = roomEntries.toList();
    if (rooms.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(emptyLabel),
      );
    }
    return Column(
      children: rooms
          .map(
            (roomEntry) => _buildRoomGroupCard(
              roomEntry: roomEntry,
              allEntries: allEntries,
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
          )
          .toList(),
    );
  }

  Widget _buildRoomGroupCard({
    required MapEntry<int, _QuoteItem> roomEntry,
    required Iterable<MapEntry<int, _QuoteItem>> allEntries,
    required List<String> levelOptions,
    required List<String> roomTypeOptions,
    required List<String> subItemOptions,
    required List<SubItemStandard> subItemStandards,
    required List<DropdownMenuItem<String>> roomTypeMenuItems,
    required List<DropdownMenuItem<String>> subItemMenuItems,
    required List<String> sizeOptions,
    required List<String> complexityOptions,
    required List<String> roomTitles,
  }) {
    final room = roomEntry.value;
    final addons = allEntries
        .where(
          (entry) =>
              entry.value.type != 'Room' &&
              entry.value.roomAssignment == room.title,
        )
        .toList();
    final roomTotal =
        _itemAmount(room) +
        addons.fold<double>(0, (total, e) => total + _itemAmount(e.value));
    final addonCount = addons.fold<int>(0, (total, e) => total + e.value.qty);

    return Card(
      child: ExpansionTile(
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Add-ons: $addonCount',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Text(_money(roomTotal)),
          ],
        ),
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        children: [
          _buildItemCard(
            roomEntry.key,
            roomEntry.value,
            levelOptions: levelOptions,
            roomTypeOptions: roomTypeOptions,
            subItemOptions: subItemOptions,
            roomTypeMenuItems: roomTypeMenuItems,
            subItemMenuItems: subItemMenuItems,
            sizeOptions: sizeOptions,
            complexityOptions: complexityOptions,
            roomTitles: roomTitles,
            onAddOn: () => _addAddonForRoom(
              room,
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
          ),
          if (addons.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('Room Add-ons', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            ...addons.map(
              (addon) => _buildItemCard(
                addon.key,
                addon.value,
                levelOptions: levelOptions,
                roomTypeOptions: roomTypeOptions,
                subItemOptions: subItemOptions,
                roomTypeMenuItems: roomTypeMenuItems,
                subItemMenuItems: subItemMenuItems,
                sizeOptions: sizeOptions,
                complexityOptions: complexityOptions,
                roomTitles: roomTitles,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildItemCard(
    int idx,
    _QuoteItem it, {
    required List<String> levelOptions,
    required List<String> roomTypeOptions,
    required List<String> subItemOptions,
    required List<DropdownMenuItem<String>> roomTypeMenuItems,
    required List<DropdownMenuItem<String>> subItemMenuItems,
    required List<String> sizeOptions,
    required List<String> complexityOptions,
    required List<String> roomTitles,
    VoidCallback? onAddOn,
  }) {
    return Card(
      child: InkWell(
        onTap: () async {
          final result = await showDialog<_QuoteItem>(
            context: context,
            builder: (_) => _EditItemDialog(
              item: it,
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
            _markDirty(() {
              var updated = result;
              if (updated.type == 'Room') {
                final uniqueTitle = _uniqueRoomTitle(
                  updated.title,
                  currentTitle: it.title,
                );
                updated = updated.copyWith(title: uniqueTitle);
                if (uniqueTitle != it.title) {
                  for (var i = 0; i < items.length; i += 1) {
                    final entry = items[i];
                    if (entry.type != 'Room' &&
                        entry.roomAssignment == it.title) {
                      items[i] = entry.copyWith(roomAssignment: uniqueTitle);
                    }
                  }
                }
              }
              items[idx] = updated;
              _syncEstimatedSqFt();
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: it.include,
                    onChanged: (v) => _markDirty(
                      () => items[idx] = it.copyWith(include: v ?? true),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      it.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Text(_money(_itemAmount(it))),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _pill('Level: ${it.level}'),
                  if (it.roomAssignment.trim().isNotEmpty && it.type != 'Room')
                    _pill('Room: ${it.roomAssignment}'),
                  _pill('Size: ${it.size}'),
                  _pill('Complexity: ${it.complexity}'),
                  _pill('Est Sq Ft: ${it.estSqFt}'),
                  _pill('Est Time: ${it.minutes} min'),
                  _pill('Qty: ${it.qty}'),
                ],
              ),
              if (it.notes.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('Notes: ${it.notes}'),
              ],
              Align(
                alignment: Alignment.centerRight,
                child: Wrap(
                  spacing: 8,
                  children: [
                    if (onAddOn != null)
                      TextButton.icon(
                        onPressed: onAddOn,
                        icon: const Icon(Icons.add),
                        label: const Text('Add-on'),
                      ),
                    TextButton.icon(
                      onPressed: () => _markDirty(() {
                        items.removeAt(idx);
                        _syncEstimatedSqFt();
                      }),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Remove'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
