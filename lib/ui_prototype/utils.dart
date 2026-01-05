part of '../ui_prototype.dart';

Future<List<T>> _loadList<T>(
  String assetPath,
  T Function(Map<String, dynamic>) parser,
) async {
  final content = await rootBundle.loadString(assetPath);
  final data = jsonDecode(content) as List<dynamic>;
  return data
      .map((item) => parser(Map<String, dynamic>.from(item as Map)))
      .toList();
}

void _snack(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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

List<Widget> _simpleMenuLabels(List<DropdownMenuItem<String>> items) {
  return items
      .map((item) {
        final value = item.value ?? '';
        final label = value.startsWith('__room-category-')
            ? value.replaceFirst('__room-category-', '')
            : value.startsWith('__subitem-category-')
                ? value.replaceFirst('__subitem-category-', '')
                : value;
        return Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      })
      .toList();
}
