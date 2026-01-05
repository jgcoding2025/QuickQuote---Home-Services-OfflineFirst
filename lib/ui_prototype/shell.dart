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

    return Scaffold(
      appBar: AppBar(
        title: const Text('QuickQuote'),
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
