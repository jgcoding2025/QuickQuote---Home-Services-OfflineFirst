part of '../ui_prototype.dart';

class ClientEditorPage extends StatefulWidget {
  const ClientEditorPage({super.key, required this.repo, this.existing});

  final ClientsRepo repo;
  final Client? existing;

  @override
  State<ClientEditorPage> createState() => _ClientEditorPageState();
}

class _ClientEditorPageState extends State<ClientEditorPage>
    with _ClientEditorHelpers {
  @override
  String? clientId;

  @override
  bool _isSaving = false;
  @override
  bool _isDirty = false;
  @override
  late ClientDraft _baseline;
  @override
  bool _allowPopOnce = false;

  @override
  final firstName = TextEditingController();
  @override
  final lastName = TextEditingController();
  @override
  final street1 = TextEditingController();
  @override
  final street2 = TextEditingController();
  @override
  final city = TextEditingController();
  @override
  final state = TextEditingController();
  @override
  final zip = TextEditingController();
  @override
  final phone = TextEditingController();
  @override
  final email = TextEditingController();
  @override
  final notes = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load(widget.existing);

    // Mark dirty when any field changes
    for (final c in [
      firstName,
      lastName,
      street1,
      street2,
      city,
      state,
      zip,
      phone,
      email,
      notes,
    ]) {
      c.addListener(_handleChanged);
    }
  }

  @override
  void dispose() {
    for (final c in [
      firstName,
      lastName,
      street1,
      street2,
      city,
      state,
      zip,
      phone,
      email,
      notes,
    ]) {
      c.removeListener(_handleChanged);
    }
    firstName.dispose();
    lastName.dispose();
    street1.dispose();
    street2.dispose();
    city.dispose();
    state.dispose();
    zip.dispose();
    phone.dispose();
    email.dispose();
    notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isExisting = clientId != null;
    final quotesRepo = QuotesRepo(orgId: ClientsPage._tempOrgId);

    return PopScope(
      canPop:
          _allowPopOnce || !_isDirty, // block pop if there are unsaved changes
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (!_isDirty) {
          if (mounted) {
            Navigator.pop(context, result);
          }
          return;
        }

        final discard = await _confirmDiscardChanges(context);

        if (!context.mounted) {
          return;
        }

        if (discard) {
          Navigator.pop(context, result);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isExisting ? 'Client Details' : 'New Client'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ..._buildClientDetailsForm(),
            const SizedBox(height: 16),
            _buildSaveActions(),
            const SizedBox(height: 24),
            _buildQuotesSection(isExisting: isExisting, quotesRepo: quotesRepo),
            const SizedBox(height: 12),
            _buildNewQuoteButton(isExisting),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
