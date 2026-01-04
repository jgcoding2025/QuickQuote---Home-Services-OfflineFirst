part of '../ui_prototype.dart';

class ClientEditorPage extends StatefulWidget {
  const ClientEditorPage({super.key, required this.repo, this.existing});

  final ClientsRepositoryLocalFirst repo;
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
  bool _applyingRemote = false;
  bool _hasRemoteUpdate = false;
  Client? _pendingRemoteClient;
  StreamSubscription<Client?>? _remoteSubscription;
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
    _startRemoteWatch();

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
    _remoteSubscription?.cancel();
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
    _autoSaveDebouncer.dispose();
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

  void _startRemoteWatch() {
    if (clientId == null) return;
    _remoteSubscription =
        widget.repo.watchClientById(clientId!).listen((client) {
      if (!mounted || client == null) return;
      if (!_isDirty) {
        _applyRemoteClient(client);
      } else {
        setState(() {
          _pendingRemoteClient = client;
          _hasRemoteUpdate = true;
        });
      }
    });
  }

  void _applyRemoteClient(Client client) {
    _load(client, notify: false, applyingRemote: true);
    setState(() {
      _hasRemoteUpdate = false;
      _pendingRemoteClient = null;
    });
  }

  void _refreshFromRemote() {
    final client = _pendingRemoteClient;
    if (client == null) {
      return;
    }
    _applyRemoteClient(client);
  }

  @override
  Widget build(BuildContext context) {
    final isExisting = clientId != null;
    final deps = AppDependencies.of(context);
    final quotesRepo = deps.quotesRepository;

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
          bottom: kDebugMode
              ? PreferredSize(
                  preferredSize:
                      const Size.fromHeight(DebugSyncBanner.preferredHeight),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: DebugSyncBanner(
                      onInfo: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SettingsPage(),
                        ),
                      ),
                    ),
                  ),
                )
              : null,
        ),
        body: RefreshIndicator(
          onRefresh: () => deps.syncService.downloadNow(
            reason: 'pull_to_refresh:client_editor',
          ),
          child: ListView(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              if (_hasRemoteUpdate)
                Card(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: ListTile(
                    leading: const Icon(Icons.sync),
                    title: const Text('Updated on another device'),
                    subtitle:
                        const Text('Refresh to load the latest changes.'),
                    trailing: TextButton(
                      onPressed: _refreshFromRemote,
                      child: const Text('Refresh'),
                    ),
                  ),
                ),
              if (_hasRemoteUpdate) const SizedBox(height: 12),
              ..._buildClientDetailsForm(),
              const SizedBox(height: 16),
              _buildSaveActions(),
              const SizedBox(height: 24),
              _buildQuotesSection(
                isExisting: isExisting,
                quotesRepo: quotesRepo,
              ),
              const SizedBox(height: 12),
              _buildNewQuoteButton(isExisting),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
