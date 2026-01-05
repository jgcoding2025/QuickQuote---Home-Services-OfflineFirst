part of '../ui_prototype.dart';

class PrototypeShell extends StatefulWidget {
  const PrototypeShell({super.key});

  @override
  State<PrototypeShell> createState() => _PrototypeShellState();
}

class _PrototypeShellState extends State<PrototypeShell> {
  int index = 0;

  Widget _buildTitle(BuildContext context) {
    final deps = AppDependencies.of(context);
    return ValueListenableBuilder<AppSession?>(
      valueListenable: deps.sessionController,
      builder: (context, session, _) {
        final orgId = session?.orgId;
        if (orgId == null || orgId.isEmpty) {
          return const Text('Quick Quote');
        }
        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('orgs')
              .doc(orgId)
              .snapshots()
              .map((snapshot) {
            unawaited(deps.metricsCollector.recordRead());
            return snapshot;
          }),
          builder: (context, snapshot) {
            final name = snapshot.data?.data()?['name'] as String?;
            if (name == null || name.trim().isEmpty) {
              return const Text('Quick Quote');
            }
            return Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'Quick Quote '),
                  TextSpan(
                    text: name.trim(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const ClientsPage(),
      const QuotesPage(),
      const SettingsPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: _buildTitle(context),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
            SyncStatusBanner.preferredHeight,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
            child: SyncStatusBanner(
              onInfo: () => _showSyncStatusHelp(context),
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
