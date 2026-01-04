part of '../ui_prototype.dart';

class DebugSyncBanner extends StatelessWidget {
  const DebugSyncBanner({super.key, this.onInfo});

  final VoidCallback? onInfo;

  static const double preferredHeight = 64;

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) {
      return const SizedBox.shrink();
    }
    final deps = AppDependencies.of(context);
    final syncService = deps.syncService;
    return ValueListenableBuilder<int>(
      valueListenable: syncService.debugTick,
      builder: (context, _, __) {
        final info = syncService.debugInfo;
        final cs = Theme.of(context).colorScheme;
        final statusIcon = _statusIcon(syncService.currentStatus);
        final statusColor = _statusColor(syncService.currentStatus, cs);
        return Material(
          color: cs.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => syncService.downloadNow(
                    reason: 'debug_banner_tap',
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Icon(statusIcon, size: 18, color: statusColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: [
                                  _DebugPill(
                                    icon: Icons.arrow_upward,
                                    label: info.uploadLabel,
                                    colors: _segmentColorsForUpload(
                                      info.uploadState,
                                      cs,
                                    ),
                                  ),
                                  _DebugPill(
                                    icon: Icons.arrow_downward,
                                    label: info.downloadLabel,
                                    colors: _segmentColorsForDownload(
                                      info.downloadState,
                                      cs,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'U ${_formatTime(info.lastUploadAt)} • D ${_formatTime(info.lastDownloadAt)}',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (onInfo != null)
                IconButton(
                  tooltip: 'Sync diagnostics',
                  onPressed: onInfo,
                  icon: const Icon(Icons.info_outline),
                ),
            ],
          ),
        );
      },
    );
  }

  IconData _statusIcon(SyncStatus status) {
    switch (status) {
      case SyncStatus.online:
        return Icons.wifi;
      case SyncStatus.syncing:
        return Icons.sync;
      case SyncStatus.error:
        return Icons.error_outline;
      case SyncStatus.offline:
      default:
        return Icons.wifi_off;
    }
  }

  Color _statusColor(SyncStatus status, ColorScheme scheme) {
    switch (status) {
      case SyncStatus.online:
        return scheme.primary;
      case SyncStatus.syncing:
        return scheme.secondary;
      case SyncStatus.error:
        return scheme.error;
      case SyncStatus.offline:
      default:
        return scheme.onSurfaceVariant;
    }
  }

  _SegmentColors _segmentColorsForUpload(
    DebugState state,
    ColorScheme scheme,
  ) {
    switch (state) {
      case DebugState.syncing:
        return _SegmentColors(
          scheme.secondaryContainer,
          scheme.onSecondaryContainer,
        );
      case DebugState.error:
        return _SegmentColors(
          scheme.errorContainer,
          scheme.onErrorContainer,
        );
      case DebugState.enabled:
        return _SegmentColors(
          scheme.tertiaryContainer,
          scheme.onTertiaryContainer,
        );
      case DebugState.paused:
      default:
        return _SegmentColors(
          scheme.surfaceContainerHighest,
          scheme.onSurfaceVariant,
        );
    }
  }

  _SegmentColors _segmentColorsForDownload(
    DebugState state,
    ColorScheme scheme,
  ) {
    switch (state) {
      case DebugState.armed:
        return _SegmentColors(
          scheme.secondaryContainer,
          scheme.onSecondaryContainer,
        );
      case DebugState.active:
        return _SegmentColors(
          scheme.tertiaryContainer,
          scheme.onTertiaryContainer,
        );
      case DebugState.error:
        return _SegmentColors(
          scheme.errorContainer,
          scheme.onErrorContainer,
        );
      case DebugState.manual:
      case DebugState.paused:
      default:
        return _SegmentColors(
          scheme.surfaceContainerHighest,
          scheme.onSurfaceVariant,
        );
    }
  }

  String _formatTime(DateTime? value) {
    if (value == null) {
      return '—';
    }
    final local = value.toLocal();
    final hh = local.hour.toString().padLeft(2, '0');
    final mm = local.minute.toString().padLeft(2, '0');
    final ss = local.second.toString().padLeft(2, '0');
    return '$hh:$mm:$ss';
  }
}

class _DebugPill extends StatelessWidget {
  const _DebugPill({
    required this.icon,
    required this.label,
    required this.colors,
  });

  final IconData icon;
  final String label;
  final _SegmentColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colors.foreground),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colors.foreground,
                ),
          ),
        ],
      ),
    );
  }
}

class _SegmentColors {
  const _SegmentColors(this.background, this.foreground);

  final Color background;
  final Color foreground;
}
