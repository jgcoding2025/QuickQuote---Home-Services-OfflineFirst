part of '../ui_prototype.dart';

class SyncStatusBanner extends StatelessWidget {
  const SyncStatusBanner({super.key, this.onInfo});

  static const double preferredHeight = 88;

  final VoidCallback? onInfo;

  @override
  Widget build(BuildContext context) {
    final deps = AppDependencies.of(context);
    final syncService = deps.syncService;
    return ValueListenableBuilder<int>(
      valueListenable: syncService.debugTick,
      builder: (context, _, __) {
        final info = syncService.debugInfo;
        return StreamBuilder<SyncStatus>(
          stream: syncService.statusStream,
          initialData: syncService.currentStatus,
          builder: (context, snap) {
            return StreamBuilder<bool>(
              stream: syncService.hasPeerOnlineStream,
              initialData: syncService.hasPeerOnline,
              builder: (context, peerSnap) {
                final bannerState = resolveSyncBannerState(
                  status: snap.data ?? SyncStatus.offline,
                  hasPeerOnline: peerSnap.data ?? false,
                );
                return _SyncBanner(
                  state: bannerState,
                  lastUploadAt: info.lastUploadAt,
                  lastDownloadAt: info.lastDownloadAt,
                  onInfo: onInfo,
                );
              },
            );
          },
        );
      },
    );
  }
}

class _SyncBanner extends StatelessWidget {
  const _SyncBanner({
    required this.state,
    required this.lastUploadAt,
    required this.lastDownloadAt,
    this.onInfo,
  });

  final SyncBannerState state;
  final DateTime? lastUploadAt;
  final DateTime? lastDownloadAt;
  final VoidCallback? onInfo;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final bg = switch (state) {
      SyncBannerState.idle => cs.primaryContainer,
      SyncBannerState.syncing => cs.secondaryContainer,
      SyncBannerState.peerOnlineEditing => cs.tertiaryContainer,
      SyncBannerState.offline => cs.surfaceContainerHighest,
      SyncBannerState.error => cs.errorContainer,
    };

    final definition = state.definition;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Icon(definition.icon, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  definition.title,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(
                  definition.description,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.arrow_upward, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          _formatTime(lastUploadAt),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.arrow_downward, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          _formatTime(lastDownloadAt),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (onInfo != null)
            IconButton(
              tooltip: 'Sync status help',
              onPressed: onInfo,
              icon: const Icon(Icons.info_outline),
            ),
        ],
      ),
    );
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
