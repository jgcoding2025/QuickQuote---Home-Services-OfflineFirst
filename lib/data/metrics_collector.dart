import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum MetricsRange {
  last20Minutes,
  last1Hour,
  last24Hours,
}

class MetricsBucket {
  const MetricsBucket({
    required this.start,
    required this.end,
    required this.reads,
    required this.writes,
  });

  final DateTime start;
  final DateTime end;
  final int reads;
  final int writes;
}

abstract class MetricsCollector {
  Future<void> recordRead({int count = 1});
  Future<void> recordWrite({int count = 1});
  Future<List<MetricsBucket>> snapshot(MetricsRange range);
}

class MetricsCollectors {
  static MetricsCollector create({
    SharedPreferences? preferences,
    bool? enable,
  }) {
    final shouldEnable = enable ?? kDebugMode;
    if (!shouldEnable) {
      return const NoopMetricsCollector();
    }
    return SharedPreferencesMetricsCollector(preferences: preferences);
  }
}

class NoopMetricsCollector implements MetricsCollector {
  const NoopMetricsCollector();

  @override
  Future<void> recordRead({int count = 1}) async {}

  @override
  Future<void> recordWrite({int count = 1}) async {}

  @override
  Future<List<MetricsBucket>> snapshot(MetricsRange range) async =>
      const <MetricsBucket>[];
}

class SharedPreferencesMetricsCollector implements MetricsCollector {
  SharedPreferencesMetricsCollector({SharedPreferences? preferences})
      : _preferences = preferences;

  static const String _storageKey = 'metrics_events_v1';
  static const Duration _retention = Duration(hours: 24);

  final SharedPreferences? _preferences;

  @override
  Future<void> recordRead({int count = 1}) async {
    await _recordEvent(reads: count, writes: 0);
  }

  @override
  Future<void> recordWrite({int count = 1}) async {
    await _recordEvent(reads: 0, writes: count);
  }

  @override
  Future<List<MetricsBucket>> snapshot(MetricsRange range) async {
    final prefs = _preferences ?? await SharedPreferences.getInstance();
    final events = _loadEvents(prefs);
    final now = DateTime.now();
    final buckets = bucketMetrics(
      events,
      range: range,
      now: now,
    );
    return buckets;
  }

  Future<void> _recordEvent({required int reads, required int writes}) async {
    if (reads == 0 && writes == 0) {
      return;
    }
    final prefs = _preferences ?? await SharedPreferences.getInstance();
    final events = _loadEvents(prefs);
    final now = DateTime.now();
    events.add(
      _MetricsEvent(
        timestamp: now,
        reads: reads,
        writes: writes,
      ),
    );
    final cutoff = now.subtract(_retention);
    events.removeWhere((event) => event.timestamp.isBefore(cutoff));
    await _saveEvents(prefs, events);
  }

  List<_MetricsEvent> _loadEvents(SharedPreferences prefs) {
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) {
      return <_MetricsEvent>[];
    }
    final decoded = jsonDecode(raw);
    if (decoded is! List) {
      return <_MetricsEvent>[];
    }
    return decoded
        .whereType<Map<String, dynamic>>()
        .map(_MetricsEvent.fromJson)
        .toList();
  }

  Future<void> _saveEvents(
    SharedPreferences prefs,
    List<_MetricsEvent> events,
  ) async {
    final payload = jsonEncode(
      events.map((event) => event.toJson()).toList(),
    );
    await prefs.setString(_storageKey, payload);
  }
}

@visibleForTesting
List<MetricsBucket> bucketMetrics(
  List<_MetricsEvent> events, {
  required MetricsRange range,
  required DateTime now,
}) {
  final normalizedNow = DateTime(
    now.year,
    now.month,
    now.day,
    now.hour,
    now.minute,
    now.second,
    now.millisecond,
    now.microsecond,
  );
  final rangeDuration = _rangeDuration(range);
  final bucketSpan = _bucketSpan(range);
  final bucketCount = rangeDuration.inMilliseconds ~/ bucketSpan.inMilliseconds;
  final start = normalizedNow.subtract(rangeDuration);
  final buckets = <MetricsBucket>[];
  for (var i = 0; i < bucketCount; i++) {
    final bucketStart = start.add(
      Duration(milliseconds: bucketSpan.inMilliseconds * i),
    );
    final bucketEnd = bucketStart.add(bucketSpan);
    var reads = 0;
    var writes = 0;
    for (final event in events) {
      if (!event.timestamp.isBefore(bucketStart) &&
          event.timestamp.isBefore(bucketEnd)) {
        reads += event.reads;
        writes += event.writes;
      }
    }
    buckets.add(
      MetricsBucket(
        start: bucketStart,
        end: bucketEnd,
        reads: reads,
        writes: writes,
      ),
    );
  }
  return buckets;
}

Duration _rangeDuration(MetricsRange range) {
  switch (range) {
    case MetricsRange.last20Minutes:
      return const Duration(minutes: 20);
    case MetricsRange.last1Hour:
      return const Duration(hours: 1);
    case MetricsRange.last24Hours:
      return const Duration(hours: 24);
  }
}

Duration _bucketSpan(MetricsRange range) {
  switch (range) {
    case MetricsRange.last20Minutes:
      return const Duration(minutes: 1);
    case MetricsRange.last1Hour:
      return const Duration(minutes: 5);
    case MetricsRange.last24Hours:
      return const Duration(hours: 1);
  }
}

class _MetricsEvent {
  const _MetricsEvent({
    required this.timestamp,
    required this.reads,
    required this.writes,
  });

  final DateTime timestamp;
  final int reads;
  final int writes;

  factory _MetricsEvent.fromJson(Map<String, dynamic> json) {
    return _MetricsEvent(
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        json['timestamp'] as int,
      ),
      reads: json['reads'] as int? ?? 0,
      writes: json['writes'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.millisecondsSinceEpoch,
      'reads': reads,
      'writes': writes,
    };
  }
}

void metricsBucketingSelfCheck() {
  assert(() {
    final now = DateTime(2024, 1, 1, 12, 0, 0);
    final events = <_MetricsEvent>[
      _MetricsEvent(
        timestamp: DateTime(2024, 1, 1, 11, 50),
        reads: 2,
        writes: 1,
      ),
      _MetricsEvent(
        timestamp: DateTime(2024, 1, 1, 11, 59),
        reads: 3,
        writes: 0,
      ),
    ];
    final buckets = bucketMetrics(
      events,
      range: MetricsRange.last20Minutes,
      now: now,
    );
    if (buckets.length != 20) {
      throw StateError('Expected 20 buckets, got ${buckets.length}.');
    }
    final totalReads = buckets.fold<int>(
      0,
      (sum, bucket) => sum + bucket.reads,
    );
    final totalWrites = buckets.fold<int>(
      0,
      (sum, bucket) => sum + bucket.writes,
    );
    if (totalReads != 5 || totalWrites != 1) {
      throw StateError(
        'Unexpected totals: reads=$totalReads writes=$totalWrites.',
      );
    }
    return true;
  }());
}
