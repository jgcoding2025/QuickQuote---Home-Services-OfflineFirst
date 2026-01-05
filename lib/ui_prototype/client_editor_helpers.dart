part of '../ui_prototype.dart';

mixin _ClientEditorHelpers on State<ClientEditorPage> {
  String? get clientId;
  set clientId(String? value);

  bool get _isSaving;
  set _isSaving(bool value);

  bool get _isDirty;
  set _isDirty(bool value);

  bool get _applyingRemote;
  set _applyingRemote(bool value);

  ClientDraft get _baseline;
  set _baseline(ClientDraft value);

  final Debouncer _autoSaveDebouncer = Debouncer(
    const Duration(milliseconds: 800),
  );
  int _autoSaveGeneration = 0;

  set _allowPopOnce(bool value);

  TextEditingController get firstName;
  TextEditingController get lastName;
  TextEditingController get street1;
  TextEditingController get street2;
  TextEditingController get city;
  TextEditingController get state;
  TextEditingController get zip;
  TextEditingController get phone;
  TextEditingController get email;
  TextEditingController get notes;
  void _handleChanged() {
    if (_isSaving || _applyingRemote) return;
    final now = _draft().toMap();
    final base = _baseline.toMap();
    final changed = now.entries.any((e) => (base[e.key] ?? '') != e.value);

    if (changed != _isDirty) {
      setState(() => _isDirty = changed);
    }
    if (changed) {
      _autoSaveGeneration += 1;
      _scheduleAutoSave();
    }
  }

  void _load(Client? c, {bool notify = true, bool applyingRemote = false}) {
    if (applyingRemote) {
      _applyingRemote = true;
    }
    try {
      clientId = c?.id;
      final d = c?.toDraft() ?? ClientDraft();
      firstName.text = d.firstName;
      lastName.text = d.lastName;
      street1.text = d.street1;
      street2.text = d.street2;
      city.text = d.city;
      state.text = d.state;
      zip.text = d.zip;
      phone.text = d.phone;
      email.text = d.email;
      notes.text = d.notes;

      _baseline = _draft();
      _isDirty = false;

      if (notify) {
        setState(() {});
      }
    } finally {
      if (applyingRemote) {
        _applyingRemote = false;
      }
    }
  }

  ClientDraft _draft() => ClientDraft(
    firstName: firstName.text,
    lastName: lastName.text,
    street1: street1.text,
    street2: street2.text,
    city: city.text,
    state: state.text,
    zip: zip.text,
    phone: phone.text,
    email: email.text,
    notes: notes.text,
  );

  void _scheduleAutoSave() {
    final syncService = AppDependencies.of(context).syncService;
    final generation = _autoSaveGeneration;
    _autoSaveDebouncer.run(() {
      unawaited(_autoSave(generation, syncService));
    });
  }

  Future<void> _autoSave(int generation, SyncService syncService) async {
    if (_isSaving || !_isDirty) return;
    final draft = _draft();
    final draftSnapshot = jsonEncode(draft.toMap());
    var isNew = false;
    if (clientId == null) {
      clientId = widget.repo.newClientId();
      isNew = true;
    }
    try {
      await widget.repo.setClient(clientId!, draft, isNew: isNew);
      if (!mounted) return;
      final currentSnapshot = jsonEncode(_draft().toMap());
      if (generation == _autoSaveGeneration &&
          currentSnapshot == draftSnapshot) {
        setState(() {
          _baseline = draft;
          _isDirty = false;
        });
      }
      if (syncService.canSyncNow) {
        await syncService.flushOutboxNow();
      }
    } catch (e, s) {
      debugPrint('Auto-save failed: $e');
      debugPrintStack(stackTrace: s);
    }
  }

  String _clientDisplayName() {
    final name = ('${firstName.text} ${lastName.text}').trim();
    return name.isEmpty ? '(Unnamed Client)' : name;
  }

  String _money(double v) => '\$${v.toStringAsFixed(2)}';

  Future<void> _confirmDeleteClient() async {
    if (clientId == null || _isSaving) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete client?'),
        content: Text('Delete ${_clientDisplayName()}? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    if (!mounted) return;
    final id = clientId!;
    final backup = _draft();
    final messenger = ScaffoldMessenger.of(context);

    setState(() {
      _isSaving = true;
      _allowPopOnce = true;
      _isDirty = false;
    });

    Navigator.pop(context); // ✅ exit immediately

    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Text('Deleted ${_clientDisplayName()}'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            widget.repo.setClient(id, backup, isNew: true).catchError((e) {
              debugPrint('Undo failed: $e');
            });
          },
        ),
      ),
    );

    widget.repo.deleteClient(id).catchError((e) {
      debugPrint('Client delete failed: $e');
    });
  }

  Future<bool> _confirmDiscardChanges(BuildContext context) async {
    final discard = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text(
          'You have unsaved changes. If you leave now, they will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Stay'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    return discard == true;
  }

  List<Widget> _buildClientDetailsForm() {
    return [
      Text('Client Details', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 12),
      _field('First Name', firstName),
      _field('Last Name', lastName),
      const SizedBox(height: 12),
      _field('Street Address', street1),
      _field('Address Line 2 (optional)', street2),
      Row(
        children: [
          Expanded(child: _field('City', city)),
          const SizedBox(width: 12),
          SizedBox(width: 90, child: _field('State', state)),
        ],
      ),
      _field('Zip Code', zip),
      const SizedBox(height: 12),
      _field('Phone Number', phone, keyboard: TextInputType.phone),
      _field('Email Address', email, keyboard: TextInputType.emailAddress),
      const SizedBox(height: 12),
      TextField(
        controller: notes,
        maxLines: 4,
        decoration: InputDecoration(
          labelText: 'Notes',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    ];
  }

  Widget _buildSaveActions() {
    return Row(
      children: [
        Expanded(
          child: FilledButton(
            onPressed: _isSaving
                ? null
                : () {
                    final d = _draft();
                    if ((d.firstName + d.lastName).trim().isEmpty) {
                      _snack(
                        context,
                        'Please enter at least a first or last name.',
                      );
                      return;
                    }

                    setState(() => _isSaving = true);

                    late final Future<void> writeFuture;
                    if (clientId == null) {
                      final newId = widget.repo.newClientId();
                      clientId = newId;
                      writeFuture = widget.repo.setClient(
                        newId,
                        d,
                        isNew: true,
                      );
                    } else {
                      writeFuture = widget.repo.setClient(
                        clientId!,
                        d,
                        isNew: false,
                      );
                    }

                    setState(() {
                      _allowPopOnce = true;
                      _isDirty = false;
                    });

                    Navigator.pop(context); // ✅ exit immediately

                    writeFuture.catchError((e) {
                      debugPrint('Client save failed: $e');
                    });
                  },
            child: Text(_isSaving ? 'Saving…' : 'Save'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: (_isSaving || clientId == null)
                ? null
                : _confirmDeleteClient,
            child: const Text('Delete'),
          ),
        ),
      ],
    );
  }

  Widget _buildQuotesSection({
    required bool isExisting,
    required QuotesRepositoryLocalFirst quotesRepo,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quotes', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        if (!isExisting)
          const Card(
            child: ListTile(
              title: Text('Save this client to add quotes.'),
              subtitle: Text('Quotes appear here after you create them.'),
            ),
          )
        else
          StreamBuilder<List<Quote>>(
            stream: quotesRepo.streamQuotesForClient(clientId!),
            initialData: const [],
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Card(
                  child: ListTile(
                    title: const Text('Unable to load quotes'),
                    subtitle: Text('${snapshot.error}'),
                  ),
                );
              }
              final quotes = snapshot.data ?? const <Quote>[];
              if (quotes.isEmpty) {
                return const Card(
                  child: ListTile(
                    title: Text('No quotes yet'),
                    subtitle: Text('Tap New Quote to create one.'),
                  ),
                );
              }
              return Column(
                children: quotes.map((q) {
                  return Dismissible(
                    key: ValueKey('client-quote-${q.id}'),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (_) async {
                      return await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Delete quote?'),
                              content: Text('Delete "${q.quoteName}"?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('Cancel'),
                                ),
                                FilledButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          ) ??
                          false;
                    },
                    onDismissed: (_) {
                      final backup = QuoteDraft(
                        clientId: q.clientId,
                        clientName: q.clientName,
                        quoteName: q.quoteName,
                        quoteDate: q.quoteDate,
                        serviceType: q.serviceType,
                        frequency: q.frequency,
                        lastProClean: q.lastProClean,
                        status: q.status,
                        total: q.total,
                        address: q.address,
                        totalSqFt: q.totalSqFt,
                        useTotalSqFt: q.useTotalSqFt,
                        estimatedSqFt: q.estimatedSqFt,
                        petsPresent: q.petsPresent,
                        homeOccupied: q.homeOccupied,
                        entryCode: q.entryCode,
                        paymentMethod: q.paymentMethod,
                        feedbackDiscussed: q.feedbackDiscussed,
                        laborRate: q.laborRate,
                        taxEnabled: q.taxEnabled,
                        ccEnabled: q.ccEnabled,
                        taxRate: q.taxRate,
                        ccRate: q.ccRate,
                        defaultRoomType: q.defaultRoomType,
                        defaultLevel: q.defaultLevel,
                        defaultSize: q.defaultSize,
                        defaultComplexity: q.defaultComplexity,
                        subItemType: q.subItemType,
                        specialNotes: q.specialNotes,
                        items: q.items,
                      );

                      final messenger = ScaffoldMessenger.of(context);
                      messenger.clearSnackBars();
                      messenger.showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 5),
                          content: Text('Deleted ${q.quoteName}'),
                          action: SnackBarAction(
                            label: 'UNDO',
                            onPressed: () {
                              quotesRepo.restoreQuote(q.id, backup).catchError((
                                e,
                              ) {
                                debugPrint('Undo failed: $e');
                              });
                            },
                          ),
                        ),
                      );

                      quotesRepo.deleteQuote(q.id).catchError((e) {
                        debugPrint('Delete failed: $e');
                      });
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      color: Theme.of(context).colorScheme.errorContainer,
                      child: Icon(
                        Icons.delete_outline,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                    ),
                    child: Card(
                      child: ListTile(
                        title: Text(q.quoteName),
                        subtitle: Text(
                          'Status: ${q.status} • Total: ${_money(q.total)}',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                QuoteEditorPage(repo: quotesRepo, quote: q),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
      ],
    );
  }

  Widget _buildNewQuoteButton(bool isExisting) {
    return Row(
      children: [
        Expanded(
          child: FilledButton(
            onPressed: !isExisting
                ? null
                : () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          QuoteWizardPage(initialClientId: clientId),
                    ),
                  ),
            child: const Text('New Quote'),
          ),
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  Widget _field(
    String label,
    TextEditingController c, {
    TextInputType? keyboard,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}
