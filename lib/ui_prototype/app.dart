part of '../ui_prototype.dart';

class UiPrototypeApp extends StatelessWidget {
  const UiPrototypeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = AppDependencies.of(context);
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
      home: ValueListenableBuilder<AppSession?>(
        valueListenable: deps.sessionController,
        builder: (context, session, _) {
          if (session == null) {
            return const LoginPage();
          }
          if (!session.hasOrg) {
            return const OnboardingPage();
          }
          return const PrototypeShell();
        },
      ),
    );
  }
}
