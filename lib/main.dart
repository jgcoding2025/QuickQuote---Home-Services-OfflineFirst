import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app_dependencies.dart';
import 'data/app_controller.dart';
import 'data/clients_repo_local_first.dart';
import 'data/local_db.dart';
import 'data/org_settings_repo_local_first.dart';
import 'data/quotes_repo_local_first.dart';
import 'data/session_controller.dart';
import 'data/sync_service.dart';
import 'firebase_options.dart';
import 'ui_prototype.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details); // prints the error nicely
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('UNHANDLED: $error');
    debugPrintStack(stackTrace: stack);
    return true; // mark as handled so it doesn't crash the VM
  };

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);

  final db = AppDatabase();
  final sessionController = SessionController();
  final syncService = SyncService(db: db, session: sessionController);
  await syncService.start();
  final clientsRepository = ClientsRepositoryLocalFirst(
    db: db,
    sessionController: sessionController,
    syncService: syncService,
  );
  final quotesRepository = QuotesRepositoryLocalFirst(
    db: db,
    sessionController: sessionController,
    syncService: syncService,
  );
  final orgSettingsRepository = OrgSettingsRepositoryLocalFirst(
    db: db,
    sessionController: sessionController,
    syncService: syncService,
  );
  final appController = AppController(
    db: db,
    sessionController: sessionController,
    syncService: syncService,
  );

  final existingUser = FirebaseAuth.instance.currentUser;
  if (existingUser != null) {
    await appController.useExistingUser(existingUser);
  }

  runApp(
    AppDependencies(
      sessionController: sessionController,
      clientsRepository: clientsRepository,
      quotesRepository: quotesRepository,
      orgSettingsRepository: orgSettingsRepository,
      syncService: syncService,
      appController: appController,
      child: const UiPrototypeApp(),
    ),
  );
}
