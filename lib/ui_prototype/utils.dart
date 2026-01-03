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
