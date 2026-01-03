part of '../ui_prototype.dart';

class QuoteEditorPage extends StatefulWidget {
  const QuoteEditorPage({super.key, required this.repo, required this.quote});
  final QuotesRepo repo;
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
    quoteName = widget.quote.quoteName;
    quoteDate = widget.quote.quoteDate.isEmpty
        ? _today()
        : widget.quote.quoteDate;
    customerName = widget.quote.clientName;
    serviceType = widget.quote.serviceType;
    frequency = widget.quote.frequency;
    lastProClean = widget.quote.lastProClean;
    status = widget.quote.status;
    if (widget.quote.address.isNotEmpty) {
      address = widget.quote.address;
    }
    if (widget.quote.totalSqFt.isNotEmpty) {
      totalSqFt = widget.quote.totalSqFt;
    }
    useTotalSqFt = widget.quote.useTotalSqFt;
    if (widget.quote.estimatedSqFt.isNotEmpty) {
      estimatedSqFt = widget.quote.estimatedSqFt;
    }
    petsPresent = widget.quote.petsPresent;
    homeOccupied = widget.quote.homeOccupied;
    if (widget.quote.entryCode.isNotEmpty) {
      entryCode = widget.quote.entryCode;
    }
    if (widget.quote.paymentMethod.isNotEmpty) {
      paymentMethod = widget.quote.paymentMethod;
    }
    feedbackDiscussed = widget.quote.feedbackDiscussed;
    laborRate = widget.quote.laborRate;
    taxEnabled = widget.quote.taxEnabled;
    ccEnabled = widget.quote.ccEnabled;
    taxRate = widget.quote.taxRate;
    ccRate = widget.quote.ccRate;
    if (widget.quote.defaultRoomType.isNotEmpty) {
      defaultRoomType = widget.quote.defaultRoomType;
    }
    if (widget.quote.defaultLevel.isNotEmpty) {
      defaultLevel = widget.quote.defaultLevel;
    }
    if (widget.quote.defaultSize.isNotEmpty) {
      defaultSize = widget.quote.defaultSize;
    }
    if (widget.quote.defaultComplexity.isNotEmpty) {
      defaultComplexity = widget.quote.defaultComplexity;
    }
    if (widget.quote.subItemType.isNotEmpty) {
      subItemType = widget.quote.subItemType;
    }
    specialNotes = widget.quote.specialNotes;
    items.addAll(widget.quote.items.map((item) => _QuoteItem.fromMap(item)));
  }

  @override
  Widget build(BuildContext context) => _buildQuoteEditor(context);
}
