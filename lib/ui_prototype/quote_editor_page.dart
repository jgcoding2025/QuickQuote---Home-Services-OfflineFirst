part of '../ui_prototype.dart';

class QuoteEditorPage extends StatefulWidget {
  const QuoteEditorPage({super.key, required this.repo, required this.quote});
  final QuotesRepositoryLocalFirst repo;
  final Quote quote;

  @override
  State<QuoteEditorPage> createState() => _QuoteEditorPageState();
}

class _QuoteEditorPageState extends State<QuoteEditorPage>
    with
        _QuoteEditorStateAccess,
        _QuoteEditorDataMixin,
        _QuoteEditorBuildMixin,
        _QuoteEditorSectionsMixin,
        _QuoteEditorItemsMixin,
        _QuoteEditorItemCardsMixin,
        _QuoteEditorUiHelpers {
  static const List<String> _levelOptions = [
    'Main Floor',
    'Basement',
    'Upstairs',
    'Floor 3',
    'Floor 4',
    'Floor 5',
  ];

  @override
  late Future<_QuoteSettingsData> _settingsFuture;
  bool _settingsFutureReady = false;
  @override
  List<_ServiceTypeStandard> _serviceTypeStandards = const [];
  @override
  List<_FrequencyStandard> _frequencyStandards = const [];
  @override
  List<_RoomTypeStandard> _roomTypeStandards = const [];
  @override
  List<_SubItemStandard> _subItemStandards = const [];
  @override
  List<_SizeStandard> _sizeStandards = const [];
  @override
  List<_ComplexityStandard> _complexityStandards = const [];

  // Defaults (generic app defaults; later pulled from org settings)
  @override
  double laborRate = 40.0;
  @override
  bool taxEnabled = false;
  @override
  bool ccEnabled = false;
  @override
  double taxRate = 0.07; // IN
  @override
  double ccRate = 0.03; // 3%
  @override
  String pricingProfileId = 'default';
  @override
  bool _isDirty = false;
  @override
  bool _applyingRemote = false;
  @override
  bool _hasRemoteUpdate = false;
  Quote? _pendingRemoteQuote;
  StreamSubscription<Quote?>? _remoteSubscription;
  @override
  int _remoteRevision = 0;
  @override
  final Debouncer _autoSaveDebouncer = Debouncer(
    const Duration(milliseconds: 800),
  );
  @override
  int _autoSaveGeneration = 0;
  @override
  bool _isGeneratingDocument = false;

  @override
  String customerName = '';
  @override
  String address = '';
  @override
  String quoteDate = '';
  @override
  String totalSqFt = '';
  @override
  bool useTotalSqFt = true;
  @override
  String estimatedSqFt = '';

  @override
  bool petsPresent = false;
  @override
  bool homeOccupied = true;
  @override
  String entryCode = '';
  @override
  String paymentMethod = '';
  @override
  bool feedbackDiscussed = false;

  @override
  String defaultRoomType = 'Bedroom';
  @override
  String defaultLevel = 'Main Floor';
  @override
  String defaultSize = 'M';
  @override
  String defaultComplexity = 'Medium';

  @override
  String serviceType = 'Standard Clean';
  @override
  String frequency = 'Bi-weekly';
  @override
  String lastProClean = '> 1 month';
  @override
  String quoteName = '';
  @override
  String status = 'Draft';

  @override
  String subItemType = 'Ceiling Fan';
  @override
  String specialNotes = '';

  @override
  final items = <_QuoteItem>[];

  late PricingProfilesRepositoryLocalFirst _pricingProfilesRepo;
  late OrgSettingsRepositoryLocalFirst _orgSettingsRepo;
  StreamSubscription<List<PricingProfileHeader>>? _profilesSub;
  StreamSubscription<OrgSettings>? _orgSettingsSub;
  List<PricingProfileHeader> _pricingProfiles = const [];
  OrgSettings _orgSettings = OrgSettings.defaults;
  bool _pricingProfileMissing = false;
  bool _pricingProfileDeleted = false;
  String? _missingPricingProfileName;

  @override
  List<PricingProfileHeader> get pricingProfiles => _pricingProfiles;

  @override
  set pricingProfiles(List<PricingProfileHeader> value) {
    _pricingProfiles = value;
  }

  @override
  bool get pricingProfileMissing => _pricingProfileMissing;

  @override
  set pricingProfileMissing(bool value) {
    _pricingProfileMissing = value;
  }

  @override
  bool get pricingProfileDeleted => _pricingProfileDeleted;

  @override
  set pricingProfileDeleted(bool value) {
    _pricingProfileDeleted = value;
  }

  @override
  String? get missingPricingProfileName => _missingPricingProfileName;

  @override
  set missingPricingProfileName(String? value) {
    _missingPricingProfileName = value;
  }

  @override
  void initState() {
    super.initState();
    _syncFromQuote(widget.quote);
    // _settingsFuture = _loadQuoteSettingsData();
    _startRemoteWatch();
  }

  @override
  void dispose() {
    _remoteSubscription?.cancel();
    _profilesSub?.cancel();
    _orgSettingsSub?.cancel();
    _autoSaveDebouncer.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final deps = AppDependencies.of(context);
    _pricingProfilesRepo = deps.pricingProfilesRepository;
    _orgSettingsRepo = deps.orgSettingsRepository;

    if (!_settingsFutureReady) {
      _settingsFuture = _loadQuoteSettingsData();
      _settingsFutureReady = true;
    }

    _profilesSub ??= _pricingProfilesRepo.streamProfiles().listen((profiles) {
      setState(() {
        _pricingProfiles = profiles;
      });
      _refreshPricingProfileStatus(profiles);
    });
    _orgSettingsSub ??= _orgSettingsRepo.stream().listen((settings) {
      setState(() {
        _orgSettings = settings;
      });
    });
  }

  void _startRemoteWatch() {
    _remoteSubscription = widget.repo.watchQuoteById(widget.quote.id).listen((
      quote,
    ) {
      if (!mounted || quote == null) return;
      if (!_isDirty) {
        _applyRemoteQuote(quote);
      } else {
        setState(() {
          _pendingRemoteQuote = quote;
          _hasRemoteUpdate = true;
        });
      }
    });
  }

  @override
  Future<void> _selectPricingProfile(String profileId) async {
    if (profileId == pricingProfileId) {
      return;
    }
    setState(() {
      pricingProfileId = profileId;
      _settingsFuture = _loadQuoteSettingsData();
      _settingsFutureReady = true;
      _isDirty = true;
      _autoSaveGeneration += 1;
    });
    if (profileId == 'default') {
      setState(() {
        laborRate = _orgSettings.laborRate;
        taxEnabled = _orgSettings.taxEnabled;
        taxRate = _orgSettings.taxRate;
        ccEnabled = _orgSettings.ccEnabled;
        ccRate = _orgSettings.ccRate;
        _pricingProfileMissing = false;
        _pricingProfileDeleted = false;
        _missingPricingProfileName = null;
      });
    } else {
      final header = await _pricingProfilesRepo.getProfileById(profileId);
      if (!mounted) {
        return;
      }
      if (header == null) {
        setState(() {
          _pricingProfileMissing = true;
          _pricingProfileDeleted = false;
          _missingPricingProfileName = null;
        });
        _snack(context, 'Loading pricing profile...');
        return;
      }
      if (header.deleted) {
        setState(() {
          _pricingProfileMissing = false;
          _pricingProfileDeleted = true;
          _missingPricingProfileName = header.name;
        });
        _snack(context, 'Pricing profile was deleted.');
        return;
      }
      setState(() {
        laborRate = header.laborRate;
        taxEnabled = header.taxEnabled;
        taxRate = header.taxRate;
        ccEnabled = header.ccEnabled;
        ccRate = header.ccRate;
        _pricingProfileMissing = false;
        _pricingProfileDeleted = false;
        _missingPricingProfileName = null;
      });
    }
    _scheduleAutoSave();
  }

  void _applyRemoteQuote(Quote quote) {
    setState(() {
      _syncFromQuote(quote);
      _isDirty = false;
      _hasRemoteUpdate = false;
      _pendingRemoteQuote = null;
      _remoteRevision += 1;
    });
  }

  void _setPricingProfileStatus({
    required bool missing,
    required bool deleted,
    String? name,
  }) {
    if (_pricingProfileMissing == missing &&
        _pricingProfileDeleted == deleted &&
        _missingPricingProfileName == name) {
      return;
    }
    setState(() {
      _pricingProfileMissing = missing;
      _pricingProfileDeleted = deleted;
      _missingPricingProfileName = name;
    });
  }

  Future<void> _refreshPricingProfileStatus(
    List<PricingProfileHeader> profiles,
  ) async {
    final currentId = pricingProfileId;
    if (currentId == 'default') {
      _setPricingProfileStatus(missing: false, deleted: false, name: null);
      return;
    }
    PricingProfileHeader? match;
    for (final profile in profiles) {
      if (profile.id == currentId) {
        match = profile;
        break;
      }
    }
    if (match != null) {
      final wasMissing = _pricingProfileMissing || _pricingProfileDeleted;
      _setPricingProfileStatus(missing: false, deleted: false, name: null);
      if (wasMissing) {
        setState(() {
          _settingsFuture = _loadQuoteSettingsData();
          _settingsFutureReady = true;
        });
      }
      return;
    }
    final header = await _pricingProfilesRepo.getProfileById(currentId);
    if (!mounted) return;
    if (header == null) {
      _setPricingProfileStatus(missing: true, deleted: false, name: null);
      return;
    }
    if (header.deleted) {
      _setPricingProfileStatus(
        missing: false,
        deleted: true,
        name: header.name,
      );
      return;
    }
    _setPricingProfileStatus(missing: true, deleted: false, name: header.name);
  }

  @override
  void _refreshFromRemote() {
    final quote = _pendingRemoteQuote;
    if (quote == null) {
      return;
    }
    _applyRemoteQuote(quote);
  }

  @override
  Future<void> _generateFinalizedDocument(
    FinalizedDocumentType docType,
  ) async {
    if (_isGeneratingDocument) {
      return;
    }
    final deps = AppDependencies.of(context);
    final orgId = deps.sessionController.value?.orgId;
    if (orgId == null) {
      _snack(context, 'Organization not ready yet.');
      return;
    }
    setState(() => _isGeneratingDocument = true);
    try {
      final draft = _buildDraft();
      final quote = Quote(
        id: widget.quote.id,
        clientId: draft.clientId,
        clientName: draft.clientName,
        quoteName: draft.quoteName,
        quoteDate: draft.quoteDate,
        serviceType: draft.serviceType,
        frequency: draft.frequency,
        lastProClean: draft.lastProClean,
        status: draft.status,
        total: draft.total,
        address: draft.address,
        totalSqFt: draft.totalSqFt,
        useTotalSqFt: draft.useTotalSqFt,
        estimatedSqFt: draft.estimatedSqFt,
        petsPresent: draft.petsPresent,
        homeOccupied: draft.homeOccupied,
        entryCode: draft.entryCode,
        paymentMethod: draft.paymentMethod,
        feedbackDiscussed: draft.feedbackDiscussed,
        laborRate: draft.laborRate,
        taxEnabled: draft.taxEnabled,
        ccEnabled: draft.ccEnabled,
        taxRate: draft.taxRate,
        ccRate: draft.ccRate,
        pricingProfileId: draft.pricingProfileId,
        defaultRoomType: draft.defaultRoomType,
        defaultLevel: draft.defaultLevel,
        defaultSize: draft.defaultSize,
        defaultComplexity: draft.defaultComplexity,
        subItemType: draft.subItemType,
        specialNotes: draft.specialNotes,
        items: draft.items,
      );
      final document = await deps.pdfService.generateFinalizedDocument(
        quote: quote,
        docType: docType,
        orgId: orgId,
      );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${document.title} generated.'),
          action: SnackBarAction(
            label: 'Open PDF',
            onPressed: () => _openFinalizedDocument(context, document),
          ),
        ),
      );
    } catch (e, s) {
      debugPrint('PDF generation failed: $e');
      debugPrintStack(stackTrace: s);
      if (mounted) {
        _snack(context, 'Failed to generate PDF.');
      }
    } finally {
      if (mounted) {
        setState(() => _isGeneratingDocument = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => _buildQuoteEditor(context);
}
