part of '../ui_prototype.dart';

class PrototypeShell extends StatefulWidget {
  const PrototypeShell({super.key});

  @override
  State<PrototypeShell> createState() => _PrototypeShellState();
}

class _PrototypeShellState extends State<PrototypeShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final deps = AppDependencies.of(context);
    final pages = <Widget>[
      const ClientsPage(),
      const QuotesPage(),
      const SettingsPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('QuickQuote'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
            kDebugMode
                ? 44 + DebugSyncBanner.preferredHeight + 8
                : 44,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StreamBuilder<SyncStatus>(
                  stream: deps.syncService.statusStream,
                  initialData: deps.syncService.currentStatus,
                  builder: (context, snap) {
                    return StreamBuilder<bool>(
                      stream: deps.syncService.hasPeerOnlineStream,
                      initialData: deps.syncService.hasPeerOnline,
                      builder: (context, peerSnap) {
                        final bannerState = resolveSyncBannerState(
                          status: snap.data ?? SyncStatus.offline,
                          hasPeerOnline: peerSnap.data ?? false,
                        );
                        return _SyncBanner(
                          state: bannerState,
                          onInfo: () => _showSyncStatusHelp(context),
                        );
                      },
                    );
                  },
                ),
                if (kDebugMode) const SizedBox(height: 8),
                if (kDebugMode)
                  DebugSyncBanner(
                    onInfo: () => setState(() => index = 2),
                  ),
              ],
            ),
          ),
        ),
      ),
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.people_alt_outlined),
            label: 'Clients',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Quotes',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  void _showSyncStatusHelp(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sync Status Help'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: SyncBannerState.values.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final definition = SyncBannerState.values[index].definition;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(definition.icon, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            definition.title,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            definition.description,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class _SyncBanner extends StatelessWidget {
  const _SyncBanner({required this.state, this.onInfo});
  final SyncBannerState state;
  final VoidCallback? onInfo;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final bg = switch (state) {
      SyncBannerState.idle => cs.primaryContainer,
      SyncBannerState.syncing => cs.secondaryContainer,
      SyncBannerState.peerOnlineEditing => cs.tertiaryContainer,
      SyncBannerState.offline => cs.surfaceContainerHighest,
      SyncBannerState.error => cs.errorContainer,
    };

    final definition = state.definition;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Icon(definition.icon, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  definition.title,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(
                  definition.description,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
          if (onInfo != null)
            IconButton(
              tooltip: 'Sync status help',
              onPressed: onInfo,
              icon: const Icon(Icons.info_outline),
            ),
        ],
      ),
    );
  }
}
