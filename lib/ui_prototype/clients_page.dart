part of '../ui_prototype.dart';

class ClientsPage extends StatelessWidget {
  const ClientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = AppDependencies.of(context);
    final repo = deps.clientsRepository;

    return RefreshIndicator(
      onRefresh: () => deps.syncService.downloadNow(
        reason: 'pull_to_refresh:clients',
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search clients',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text('Clients', style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ClientEditorPage(repo: repo),
                  ),
                ),
                icon: const Icon(Icons.add),
                label: const Text('New'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          StreamBuilder<List<Client>>(
            stream: repo.streamClients(),
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

              final clients = snapshot.data!;
              if (clients.isEmpty) {
                return const Card(
                  child: ListTile(
                    title: Text('No clients yet'),
                    subtitle: Text('Tap New to create one.'),
                  ),
                );
              }

              return Column(
                children: clients.map((c) {
                  return Dismissible(
                    key: ValueKey(c.id),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (_) async {
                      return await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Delete client?'),
                              content: Text(
                                'Delete ${c.displayName}? This cannot be undone.',
                              ),
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
                      final backup = c.toDraft();
                      final id = c.id;

                      // Show Undo immediately
                      final messenger = ScaffoldMessenger.of(context);
                      messenger.clearSnackBars();
                      messenger.showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 5),
                          content: Text('Deleted ${c.displayName}'),
                          action: SnackBarAction(
                            label: 'UNDO',
                            onPressed: () {
                              repo.restoreClient(id, backup).catchError((e) {
                                debugPrint('Undo failed: $e');
                              });
                            },
                          ),
                        ),
                      );

                      // Delete in the background (don’t block UI)
                      repo.deleteClient(id).catchError((e) {
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
                        title: Text(c.displayName),
                        subtitle: Text(
                          '${c.city}, ${c.state}'.trim().replaceAll(
                            RegExp(r'^, |, $'),
                            '',
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                ClientEditorPage(repo: repo, existing: c),
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
