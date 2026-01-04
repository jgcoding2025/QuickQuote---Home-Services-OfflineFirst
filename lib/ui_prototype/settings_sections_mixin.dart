part of '../ui_prototype.dart';

mixin _SettingsStateAccess on State<SettingsPage> {
  Future<void> _save(OrgSettings s);
}

mixin _SettingsSectionsMixin on _SettingsStateAccess {
  Widget _settingsSection(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: false,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        children: [child],
      ),
    );
  }
}
