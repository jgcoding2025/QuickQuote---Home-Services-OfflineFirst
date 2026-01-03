part of '../ui_prototype.dart';

class ClientDetailPage extends StatelessWidget {
  const ClientDetailPage({super.key, required this.clientName});
  final String clientName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(clientName)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Quotes', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          const Card(
            child: ListTile(
              title: Text('12/15/2025 | Smith | Standard Clean'),
              subtitle: Text('Status: Sent • Total: \$160.00'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
          const Card(
            child: ListTile(
              title: Text('11/02/2025 | Smith | Deep Clean'),
              subtitle: Text('Status: Accepted • Total: \$320.00'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
        ],
      ),
    );
  }
}
