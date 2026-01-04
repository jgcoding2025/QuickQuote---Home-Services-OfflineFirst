part of '../ui_prototype.dart';

mixin _QuoteEditorStateAccess on State<QuoteEditorPage> {
  Future<_QuoteSettingsData> get _settingsFuture;

  List<_ServiceTypeStandard> get _serviceTypeStandards;
  set _serviceTypeStandards(List<_ServiceTypeStandard> value);

  List<_FrequencyStandard> get _frequencyStandards;
  set _frequencyStandards(List<_FrequencyStandard> value);

  List<_RoomTypeStandard> get _roomTypeStandards;
  set _roomTypeStandards(List<_RoomTypeStandard> value);

  List<_SubItemStandard> get _subItemStandards;
  set _subItemStandards(List<_SubItemStandard> value);

  List<_SizeStandard> get _sizeStandards;
  set _sizeStandards(List<_SizeStandard> value);

  List<_ComplexityStandard> get _complexityStandards;
  set _complexityStandards(List<_ComplexityStandard> value);

  bool get _isDirty;
  set _isDirty(bool value);

  bool get _applyingRemote;
  set _applyingRemote(bool value);

  bool get _hasRemoteUpdate;
  set _hasRemoteUpdate(bool value);

  int get _remoteRevision;
  set _remoteRevision(int value);

  Debouncer get _autoSaveDebouncer;
  int get _autoSaveGeneration;
  set _autoSaveGeneration(int value);

  double get laborRate;
  set laborRate(double value);

  bool get taxEnabled;
  set taxEnabled(bool value);

  bool get ccEnabled;
  set ccEnabled(bool value);

  double get taxRate;
  set taxRate(double value);

  double get ccRate;
  set ccRate(double value);

  String get customerName;
  set customerName(String value);

  String get address;
  set address(String value);

  String get quoteDate;
  set quoteDate(String value);

  String get totalSqFt;
  set totalSqFt(String value);

  bool get useTotalSqFt;
  set useTotalSqFt(bool value);

  String get estimatedSqFt;
  set estimatedSqFt(String value);

  bool get petsPresent;
  set petsPresent(bool value);

  bool get homeOccupied;
  set homeOccupied(bool value);

  String get entryCode;
  set entryCode(String value);

  String get paymentMethod;
  set paymentMethod(String value);

  bool get feedbackDiscussed;
  set feedbackDiscussed(bool value);

  String get defaultRoomType;
  set defaultRoomType(String value);

  String get defaultLevel;
  set defaultLevel(String value);

  String get defaultSize;
  set defaultSize(String value);

  String get defaultComplexity;
  set defaultComplexity(String value);

  String get serviceType;
  set serviceType(String value);

  String get frequency;
  set frequency(String value);

  String get lastProClean;
  set lastProClean(String value);

  String get quoteName;
  set quoteName(String value);

  String get status;
  set status(String value);

  String get subItemType;
  set subItemType(String value);

  String get specialNotes;
  set specialNotes(String value);

  List<_QuoteItem> get items;

  Future<bool> _confirmDiscardChanges();
  Future<void> _saveQuote();
  void _refreshFromRemote();
  void _markDirty([VoidCallback? update]);
  Future<void> _autoSaveQuote(int generation, SyncService syncService);

  String _resolveOption(String current, List<String> options);
  void _syncOption(String current, String resolved, ValueSetter<String> assign);
  _Totals _calcTotals();
  double _serviceTypeRate();
  double _frequencyMultiplier();
  double _sizeMultiplier(String size);
  double _complexityMultiplier(String complexity);
  double _itemAmount(_QuoteItem item);
  void _syncEstimatedSqFt();

  List<DropdownMenuItem<String>> _roomTypeMenuItems(
    List<_RoomTypeStandard> roomTypes,
    List<String> fallbackOptions,
  );
  List<DropdownMenuItem<String>> _subItemMenuItems(
    List<_SubItemStandard> subItems,
    List<String> fallbackOptions,
  );
  String _subItemLabel(_SubItemStandard item);
  String? _subItemLabelFor(String name, List<_SubItemStandard> subItems);

  Widget _buildCustomerDetailsSection();
  Widget _buildQuoteDetailsSection({
    required List<DropdownMenuItem<String>> serviceTypeMenuItems,
    required List<String> frequencyOptions,
    required String resolvedServiceType,
    required String resolvedFrequency,
  });
  Widget _buildDiscussSection();
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
  });
  Widget _buildAdditionalItemsSection({
    required String resolvedSubItem,
    required List<String> subItemOptions,
    required List<String> roomTypeOptions,
    required List<DropdownMenuItem<String>> roomTypeMenuItems,
    required List<DropdownMenuItem<String>> subItemMenuItems,
    required List<String> sizeOptions,
    required List<String> complexityOptions,
    required List<String> roomTitles,
  });
  Widget _buildSpecialNotesSection();
  Widget _buildPricingSection({
    required _Totals totals,
    required double serviceTypeRate,
    required double frequencyMultiplier,
    required double sqFt,
    required double sqFtEstimate,
  });
  Widget _buildActionButtons();

  // ignore: unused_element_parameter
  Widget _sectionCard(
    BuildContext context,
    String title,
    Widget child, {
    // ignore: unused_element_parameter
    bool initiallyExpanded,
    bool isComplete,
  });
  InputDecoration _fieldDecoration(String label);
  Widget _choiceChips({
    required String label,
    required List<String> options,
    required String value,
    required ValueChanged<String> onChanged,
  });
  Widget _pricingBlock(
    BuildContext context,
    String title,
    List<Widget> children,
  );
  Widget _row(String label, String value, {bool bold});
  String _money(double v);
  Widget _pill(String label);
  Widget _buildRoomGroupSection({
    required Iterable<MapEntry<int, _QuoteItem>> roomEntries,
    required Iterable<MapEntry<int, _QuoteItem>> allEntries,
    required String emptyLabel,
    required List<String> levelOptions,
    required List<String> roomTypeOptions,
    required List<String> subItemOptions,
    required List<_SubItemStandard> subItemStandards,
    required List<DropdownMenuItem<String>> roomTypeMenuItems,
    required List<DropdownMenuItem<String>> subItemMenuItems,
    required List<String> sizeOptions,
    required List<String> complexityOptions,
    required List<String> roomTitles,
  });
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
  });

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
  });

  String _uniqueRoomTitle(String baseTitle, {String? currentTitle});
}

mixin _QuoteEditorDataMixin on _QuoteEditorStateAccess {
  Future<_QuoteSettingsData> _loadQuoteSettingsData() async {
    final serviceTypes = await _loadList(
      'assets/settings/service_type_standards.json',
      _ServiceTypeStandard.fromJson,
    );
    final frequencies = await _loadList(
      'assets/settings/frequency_standards.json',
      _FrequencyStandard.fromJson,
    );
    final roomTypes = await _loadList(
      'assets/settings/room_type_standards.json',
      _RoomTypeStandard.fromJson,
    );
    final subItems = await _loadList(
      'assets/settings/sub_item_standards.json',
      _SubItemStandard.fromJson,
    );
    final sizes = await _loadList(
      'assets/settings/size_standards.json',
      _SizeStandard.fromJson,
    );
    final complexities = await _loadList(
      'assets/settings/complexity_standards.json',
      _ComplexityStandard.fromJson,
    );

    return _QuoteSettingsData(
      serviceTypes: serviceTypes,
      frequencies: frequencies,
      roomTypes: roomTypes,
      subItems: subItems,
      sizes: sizes,
      complexities: complexities,
    );
  }

  @override
  String _resolveOption(String current, List<String> options) {
    if (options.contains(current)) {
      return current;
    }
    return options.isNotEmpty ? options.first : current;
  }

  @override
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

  _ServiceTypeStandard? _serviceTypeStandardFor(String value) {
    for (final standard in _serviceTypeStandards) {
      if (standard.serviceType == value) {
        return standard;
      }
    }
    return null;
  }

  String _baseServiceType(String value) {
    if (value.contains('Standard Clean')) {
      return 'Standard Clean';
    }
    if (value.contains('Deep Clean')) {
      return 'Deep Clean';
    }
    return value;
  }

  double _serviceTypeMultiplier() {
    return _serviceTypeStandardFor(serviceType)?.multiplier ?? 1.0;
  }

  @override
  double _sizeMultiplier(String size) {
    for (final standard in _sizeStandards) {
      if (standard.size == size) {
        return standard.multiplier;
      }
    }
    return 1.0;
  }

  @override
  double _complexityMultiplier(String complexity) {
    for (final standard in _complexityStandards) {
      if (standard.level == complexity) {
        return standard.multiplier;
      }
    }
    return 1.0;
  }

  @override
  double _serviceTypeRate() {
    return _serviceTypeStandardFor(serviceType)?.pricePerSqFt ?? 0.12;
  }

  @override
  double _frequencyMultiplier() {
    if (_frequencyStandards.isEmpty) {
      return 1.0;
    }
    for (final standard in _frequencyStandards) {
      if (standard.serviceType == serviceType &&
          standard.frequency == frequency) {
        return standard.multiplier;
      }
    }
    final baseType = _baseServiceType(serviceType);
    if (baseType != serviceType) {
      for (final standard in _frequencyStandards) {
        if (standard.serviceType == baseType &&
            standard.frequency == frequency) {
          return standard.multiplier;
        }
      }
    }
    return 1.0;
  }

  double _combinedMultiplier() =>
      _serviceTypeMultiplier() * _frequencyMultiplier();

  double _itemAdjustedMinutes(_QuoteItem item) {
    return (item.minutes * item.qty).toDouble();
  }

  @override
  Future<bool> _confirmDiscardChanges() async {
    if (!_isDirty) {
      return true;
    }
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text(
          'You have unsaved updates. Do you want to discard them and exit?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep editing'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    return shouldLeave ?? false;
  }

  void _syncFromQuote(Quote quote) {
    _applyingRemote = true;
    try {
      quoteName = quote.quoteName;
      quoteDate = quote.quoteDate.isEmpty ? _today() : quote.quoteDate;
      customerName = quote.clientName;
      serviceType = quote.serviceType;
      frequency = quote.frequency;
      lastProClean = quote.lastProClean;
      status = quote.status;
      address = quote.address;
      totalSqFt = quote.totalSqFt;
      useTotalSqFt = quote.useTotalSqFt;
      estimatedSqFt = quote.estimatedSqFt;
      petsPresent = quote.petsPresent;
      homeOccupied = quote.homeOccupied;
      entryCode = quote.entryCode;
      paymentMethod = quote.paymentMethod;
      feedbackDiscussed = quote.feedbackDiscussed;
      laborRate = quote.laborRate;
      taxEnabled = quote.taxEnabled;
      ccEnabled = quote.ccEnabled;
      taxRate = quote.taxRate;
      ccRate = quote.ccRate;
      if (quote.defaultRoomType.isNotEmpty) {
        defaultRoomType = quote.defaultRoomType;
      }
      if (quote.defaultLevel.isNotEmpty) {
        defaultLevel = quote.defaultLevel;
      }
      if (quote.defaultSize.isNotEmpty) {
        defaultSize = quote.defaultSize;
      }
      if (quote.defaultComplexity.isNotEmpty) {
        defaultComplexity = quote.defaultComplexity;
      }
      if (quote.subItemType.isNotEmpty) {
        subItemType = quote.subItemType;
      }
      specialNotes = quote.specialNotes;
      items
        ..clear()
        ..addAll(quote.items.map((item) => _QuoteItem.fromMap(item)));
    } finally {
      _applyingRemote = false;
    }
  }

  @override
  void _markDirty([VoidCallback? update]) {
    if (_applyingRemote) {
      return;
    }
    setState(() {
      update?.call();
      _isDirty = true;
      _autoSaveGeneration += 1;
    });
    _scheduleAutoSave();
  }

  void _scheduleAutoSave() {
    final syncService = AppDependencies.of(context).syncService;
    final generation = _autoSaveGeneration;
    _autoSaveDebouncer.run(() {
      unawaited(_autoSaveQuote(generation, syncService));
    });
  }

  @override
  Future<void> _saveQuote() async {
    final draft = _buildDraft();

    try {
      // Capture navigator BEFORE the async gap (avoids context-across-await lint)
      final navigator = Navigator.of(context);

      await widget.repo.updateQuote(widget.quote.id, draft);

      if (!mounted) return;

      setState(() => _isDirty = false);
      _snack(context, 'Quote saved');

      // Let the snackbar paint, then pop
      await Future<void>.delayed(const Duration(milliseconds: 100));

      if (!mounted) return;
      navigator.pop();
    } catch (e, s) {
      debugPrint('Save failed: $e');
      debugPrintStack(stackTrace: s);
      if (mounted) _snack(context, 'Save failed');
      rethrow; // keep during debug
    }
  }

  QuoteDraft _buildDraft() {
    final totals = _calcTotals();
    return QuoteDraft(
      clientId: widget.quote.clientId,
      clientName: customerName,
      quoteName: quoteName,
      quoteDate: quoteDate.trim().isEmpty ? _today() : quoteDate,
      serviceType: serviceType,
      frequency: frequency,
      lastProClean: lastProClean,
      status: status,
      total: totals.total,
      address: address,
      totalSqFt: totalSqFt,
      useTotalSqFt: useTotalSqFt,
      estimatedSqFt: estimatedSqFt,
      petsPresent: petsPresent,
      homeOccupied: homeOccupied,
      entryCode: entryCode,
      paymentMethod: paymentMethod,
      feedbackDiscussed: feedbackDiscussed,
      laborRate: laborRate,
      taxEnabled: taxEnabled,
      ccEnabled: ccEnabled,
      taxRate: taxRate,
      ccRate: ccRate,
      defaultRoomType: defaultRoomType,
      defaultLevel: defaultLevel,
      defaultSize: defaultSize,
      defaultComplexity: defaultComplexity,
      subItemType: subItemType,
      specialNotes: specialNotes,
      items: items.map((item) => item.toMap()).toList(),
    );
  }

  @override
  Future<void> _autoSaveQuote(
    int generation,
    SyncService syncService,
  ) async {
    if (!_isDirty) return;
    final draft = _buildDraft();
    final draftSnapshot = jsonEncode(draft.toMap());
    try {
      await widget.repo.updateQuote(widget.quote.id, draft);
      if (!mounted) return;
      final currentSnapshot = jsonEncode(_buildDraft().toMap());
      if (generation == _autoSaveGeneration &&
          currentSnapshot == draftSnapshot) {
        setState(() => _isDirty = false);
      }
      if (syncService.canSyncNow) {
        await syncService.flushOutboxNow();
      }
    } catch (e, s) {
      debugPrint('Auto-save failed: $e');
      debugPrintStack(stackTrace: s);
    }
  }

  String _today() {
    final now = DateTime.now();
    final mm = now.month.toString().padLeft(2, '0');
    final dd = now.day.toString().padLeft(2, '0');
    final yyyy = now.year.toString();
    return '$mm/$dd/$yyyy';
  }

  @override
  _Totals _calcTotals() {
    final totalMinutes = items.fold<double>(
      0,
      (total, i) => total + (i.include ? _itemAdjustedMinutes(i) : 0),
    );
    final adjustedMinutes = totalMinutes * _combinedMultiplier();
    final hours = adjustedMinutes / 60.0;
    final subtotal = hours * laborRate;
    final tax = taxEnabled ? subtotal * taxRate : 0.0;
    final ccFee = ccEnabled ? (subtotal + tax) * ccRate : 0.0; // your rule
    final total = subtotal + tax + ccFee;
    return _Totals(adjustedMinutes, hours, subtotal, tax, ccFee, total);
  }

  @override
  double _itemAmount(_QuoteItem item) {
    final minutes = item.include ? _itemAdjustedMinutes(item) : 0;
    final adjustedMinutes = minutes * _combinedMultiplier();
    return (adjustedMinutes / 60.0) * laborRate;
  }

  @override
  void _syncEstimatedSqFt() {
    final total = items
        .where((item) => item.type == 'Room')
        .fold<int>(
          0,
          (runningTotal, item) =>
              runningTotal + (item.estSqFt * item.qty),
        );
    estimatedSqFt = total == 0 ? '' : total.toString();
  }
}
