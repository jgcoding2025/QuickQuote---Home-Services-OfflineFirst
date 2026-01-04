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
  late final Future<_QuoteSettingsData> _settingsFuture;
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

  @override
  void initState() {
    super.initState();
    _settingsFuture = _loadQuoteSettingsData();
    _syncFromQuote(widget.quote);
    _startRemoteWatch();
  }

  @override
  void dispose() {
    _remoteSubscription?.cancel();
    _autoSaveDebouncer.dispose();
    super.dispose();
  }

  void _startRemoteWatch() {
    _remoteSubscription = widget.repo
        .watchQuoteById(widget.quote.id)
        .listen((quote) {
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

  void _applyRemoteQuote(Quote quote) {
    setState(() {
      _syncFromQuote(quote);
      _isDirty = false;
      _hasRemoteUpdate = false;
      _pendingRemoteQuote = null;
      _remoteRevision += 1;
    });
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
  Widget build(BuildContext context) => _buildQuoteEditor(context);
}
