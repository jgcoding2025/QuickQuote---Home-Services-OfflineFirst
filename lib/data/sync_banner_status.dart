import 'package:flutter/material.dart';

import 'sync_service.dart';

enum SyncBannerState {
  offline,
  syncing,
  idle,
  peerOnlineEditing,
  error,
}

class SyncBannerStatusDefinition {
  const SyncBannerStatusDefinition({
    required this.title,
    required this.description,
    required this.icon,
    required this.recommendedPollingSeconds,
    required this.recommendedUploadSeconds,
    required this.recommendedDownloadSeconds,
  });

  final String title;
  final String description;
  final IconData icon;
  final int recommendedPollingSeconds;
  final int recommendedUploadSeconds;
  final int recommendedDownloadSeconds;
}

extension SyncBannerStateDefinition on SyncBannerState {
  SyncBannerStatusDefinition get definition {
    switch (this) {
      case SyncBannerState.offline:
        return const SyncBannerStatusDefinition(
          title: 'Offline',
          description:
              'No network connection detected. Changes are queued until the app is back online.',
          icon: Icons.wifi_off,
          recommendedPollingSeconds: 0,
          recommendedUploadSeconds: 0,
          recommendedDownloadSeconds: 0,
        );
      case SyncBannerState.syncing:
        return const SyncBannerStatusDefinition(
          title: 'Syncing',
          description:
              'Uploading and downloading updates now to keep every device aligned.',
          icon: Icons.sync,
          recommendedPollingSeconds: 3,
          recommendedUploadSeconds: 2,
          recommendedDownloadSeconds: 3,
        );
      case SyncBannerState.idle:
        return const SyncBannerStatusDefinition(
          title: 'Up to date',
          description:
              'Everything is synced. Monitoring for changes and syncing on demand.',
          icon: Icons.wifi,
          recommendedPollingSeconds: 6,
          recommendedUploadSeconds: 2,
          recommendedDownloadSeconds: 6,
        );
      case SyncBannerState.peerOnlineEditing:
        return const SyncBannerStatusDefinition(
          title: 'Collaborating',
          description:
              'Another device is online. Polling frequently to merge their edits quickly.',
          icon: Icons.people_alt_outlined,
          recommendedPollingSeconds: 3,
          recommendedUploadSeconds: 2,
          recommendedDownloadSeconds: 3,
        );
      case SyncBannerState.error:
        return const SyncBannerStatusDefinition(
          title: 'Sync issue',
          description:
              'A sync error occurred. We will keep retrying and preserve your changes locally.',
          icon: Icons.error_outline,
          recommendedPollingSeconds: 10,
          recommendedUploadSeconds: 5,
          recommendedDownloadSeconds: 10,
        );
    }
  }
}

SyncBannerState resolveSyncBannerState({
  required SyncStatus status,
  required bool hasPeerOnline,
}) {
  switch (status) {
    case SyncStatus.offline:
      return SyncBannerState.offline;
    case SyncStatus.error:
      return SyncBannerState.error;
    case SyncStatus.syncing:
      return SyncBannerState.syncing;
    case SyncStatus.online:
      if (hasPeerOnline) {
        return SyncBannerState.peerOnlineEditing;
      }
      return SyncBannerState.idle;
  }
}
