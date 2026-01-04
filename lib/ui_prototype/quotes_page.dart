part of '../ui_prototype.dart';

class QuotesPage extends StatelessWidget {
  const QuotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = AppDependencies.of(context);
    final quotesRepo = deps.quotesRepository;

    return RefreshIndicator(
      onRefresh: () => deps.syncService.downloadNow(
        reason: 'pull_to_refresh:quotes',
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Row(
            children: [
              Text('Quotes', style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const QuoteWizardPage()),
                ),
                icon: const Icon(Icons.add),
                label: const Text('New Quote'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          StreamBuilder<List<Quote>>(
            stream: quotesRepo.streamQuotes(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Error: ${snapshot.error}'),
                  ),
                );
              }
              if (!snapshot.hasData) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final quotes = snapshot.data!;
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
                    key: ValueKey(q.id),
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
                          duration: const Duration(seconds: 8),
                          content: Text('Deleted ${q.quoteName}'),
                          action: SnackBarAction(
                            label: 'UNDO',
                            onPressed: () {
                              quotesRepo.restoreQuote(q.id, backup).catchError(
                                (e) {
                                  debugPrint('Undo failed: $e');
                                },
                              );
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
                      child: const Icon(Icons.delete_outline),
                    ),
                    child: Card(
                      child: ListTile(
                        title: Text(q.quoteName),
                        subtitle: Text('Status: ${q.status}'),
                        trailing: Text('\$${q.total.toStringAsFixed(2)}'),
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
      ),
    );
  }
}
