import 'package:flutter/material.dart';

import 'data/clients_repo_local_first.dart';
import 'data/app_controller.dart';
import 'data/org_settings_repo_local_first.dart';
import 'data/quotes_repo_local_first.dart';
import 'data/session_controller.dart';
import 'data/sync_service.dart';

class AppDependencies extends InheritedWidget {
  const AppDependencies({
    super.key,
    required this.sessionController,
    required this.clientsRepository,
    required this.quotesRepository,
    required this.orgSettingsRepository,
    required this.syncService,
    required this.appController,
    required super.child,
  });

  final SessionController sessionController;
  final ClientsRepositoryLocalFirst clientsRepository;
  final QuotesRepositoryLocalFirst quotesRepository;
  final OrgSettingsRepositoryLocalFirst orgSettingsRepository;
  final SyncService syncService;
  final AppController appController;

  static AppDependencies of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppDependencies>();
    assert(result != null, 'No AppDependencies found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AppDependencies oldWidget) => false;
}
