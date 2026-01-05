import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app_dependencies.dart';
import 'data/app_controller.dart';
import 'data/clients_repo_local_first.dart';
import 'data/finalized_documents_repo_local_first.dart';
import 'data/local_db.dart';
import 'data/metrics_collector.dart';
import 'data/org_settings_repo_local_first.dart';
import 'data/pricing_profile_catalog_repo_local_first.dart';
import 'data/pricing_profiles_repo_local_first.dart';
import 'data/quotes_repo_local_first.dart';
import 'data/presence_service.dart';
import 'data/session_controller.dart';
import 'data/sync_service.dart';
import 'firebase_options.dart';
import 'pdf/pdf_service.dart';
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
  final metricsCollector = MetricsCollectors.create();
  final presenceService = PresenceService(metricsCollector: metricsCollector);
  final syncService = SyncService(
    db: db,
    session: sessionController,
    presenceService: presenceService,
    metricsCollector: metricsCollector,
  );
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
  final pricingProfilesRepository = PricingProfilesRepositoryLocalFirst(
    db: db,
    sessionController: sessionController,
    syncService: syncService,
  );
  final pricingProfileCatalogRepository =
      PricingProfileCatalogRepositoryLocalFirst(
        db: db,
        sessionController: sessionController,
        syncService: syncService,
      );
  final finalizedDocumentsRepository = FinalizedDocumentsRepositoryLocalFirst(
    db: db,
    sessionController: sessionController,
    syncService: syncService,
  );
  final pdfService = PdfService(
    finalizedDocsRepository: finalizedDocumentsRepository,
    pricingProfilesRepository: pricingProfilesRepository,
    pricingProfileCatalogRepository: pricingProfileCatalogRepository,
    orgSettingsRepository: orgSettingsRepository,
  );
  final appController = AppController(
    db: db,
    sessionController: sessionController,
    syncService: syncService,
    metricsCollector: metricsCollector,
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
      pricingProfilesRepository: pricingProfilesRepository,
      pricingProfileCatalogRepository: pricingProfileCatalogRepository,
      finalizedDocumentsRepository: finalizedDocumentsRepository,
      pdfService: pdfService,
      syncService: syncService,
      appController: appController,
      metricsCollector: metricsCollector,
      child: const UiPrototypeApp(),
    ),
  );
}
