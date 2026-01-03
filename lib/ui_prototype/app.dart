part of '../ui_prototype.dart';

class UiPrototypeApp extends StatelessWidget {
  const UiPrototypeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickQuote',
      theme: ThemeData(
        useMaterial3: true,
        dividerColor:
            Colors.transparent, // removes ExpansionTile dividers app-wide

        expansionTileTheme: const ExpansionTileThemeData(
          shape: Border(), // no border when expanded
          collapsedShape: Border(), // no border when collapsed
          tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),

        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4DFFDB)),
      ),
      home: const PrototypeShell(),
    );
  }
}
