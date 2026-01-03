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
    final pages = <Widget>[
      const ClientsPage(),
      const QuotesPage(),
      const SettingsPage(),
    ];

    const orgId = ClientsPage._tempOrgId; // demo for now

    return Scaffold(
      appBar: AppBar(
        title: const Text('QuickQuote'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('orgs')
                  .doc(orgId)
                  .collection('clients')
                  .snapshots(includeMetadataChanges: true),
              builder: (context, snap) {
                final hasPending =
                    snap.data?.metadata.hasPendingWrites ?? false;

                final status = hasPending
                    ? _SyncStatus.syncing
                    : _SyncStatus.online;

                return _SyncBanner(status: status);
              },
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
}

enum _SyncStatus { online, offline, syncing, error }

class _SyncBanner extends StatelessWidget {
  const _SyncBanner({required this.status});
  final _SyncStatus status;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    String text;
    IconData icon;
    Color bg;

    switch (status) {
      case _SyncStatus.online:
        text = 'Online';
        icon = Icons.wifi;
        bg = cs.primaryContainer;
        break;
      case _SyncStatus.offline:
        text = 'Offline — changes will sync automatically';
        icon = Icons.wifi_off;
        bg = cs.surfaceContainerHighest;
        break;
      case _SyncStatus.syncing:
        text = 'Pending upload — syncing…';
        icon = Icons.cloud_upload_outlined;
        bg = cs.secondaryContainer;
        break;

      case _SyncStatus.error:
        text = 'Sync error — tap to retry';
        icon = Icons.error_outline;
        bg = cs.errorContainer;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
