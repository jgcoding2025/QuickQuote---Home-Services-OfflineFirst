import 'package:flutter/material.dart';

import 'data/clients_repo_local_first.dart';
import 'data/app_controller.dart';
import 'data/finalized_documents_repo_local_first.dart';
import 'data/metrics_collector.dart';
import 'data/org_settings_repo_local_first.dart';
import 'data/pricing_profile_catalog_repo_local_first.dart';
import 'data/pricing_profiles_repo_local_first.dart';
import 'data/quotes_repo_local_first.dart';
import 'data/session_controller.dart';
import 'data/sync_service.dart';
import 'pdf/pdf_service.dart';

class AppDependencies extends InheritedWidget {
  const AppDependencies({
    super.key,
    required this.sessionController,
    required this.clientsRepository,
    required this.quotesRepository,
    required this.orgSettingsRepository,
    required this.pricingProfilesRepository,
    required this.pricingProfileCatalogRepository,
    required this.finalizedDocumentsRepository,
    required this.pdfService,
    required this.syncService,
    required this.appController,
    required this.metricsCollector,
    required super.child,
  });

  final SessionController sessionController;
  final ClientsRepositoryLocalFirst clientsRepository;
  final QuotesRepositoryLocalFirst quotesRepository;
  final OrgSettingsRepositoryLocalFirst orgSettingsRepository;
  final PricingProfilesRepositoryLocalFirst pricingProfilesRepository;
  final PricingProfileCatalogRepositoryLocalFirst
      pricingProfileCatalogRepository;
  final FinalizedDocumentsRepositoryLocalFirst finalizedDocumentsRepository;
  final PdfService pdfService;
  final SyncService syncService;
  final AppController appController;
  final MetricsCollector metricsCollector;

  static AppDependencies of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppDependencies>();
    assert(result != null, 'No AppDependencies found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AppDependencies oldWidget) => false;
}
