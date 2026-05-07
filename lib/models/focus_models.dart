import 'dart:ui';

class SessionResponse {
  final String videoId;
  final String sceneIndexId;
  final Summary summary;
  final List<FocusEvent> events;

  SessionResponse({
    required this.videoId,
    required this.sceneIndexId,
    required this.summary,
    required this.events,
  });

  factory SessionResponse.fromJson(Map<String, dynamic> json) {
    return SessionResponse(
      videoId: json['video_id'] ?? '',
      sceneIndexId: json['scene_index_id'] ?? '',
      summary: Summary.fromJson(json['summary'] ?? {}),
      events: (json['events'] as List<dynamic>?)
          ?.map((e) => FocusEvent.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class Summary {
  final double totalDurationSeconds;
  final double focusTimeSeconds;
  final double distractionTimeSeconds;
  final double idleTimeSeconds;
  final double focusPercentage;
  final double distractionPercentage;
  final double idlePercentage;
  final String focusScore;
  final int eventCount;

  Summary({
    required this.totalDurationSeconds,
    required this.focusTimeSeconds,
    required this.distractionTimeSeconds,
    required this.idleTimeSeconds,
    required this.focusPercentage,
    required this.distractionPercentage,
    required this.idlePercentage,
    required this.focusScore,
    required this.eventCount,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      totalDurationSeconds: (json['total_duration_seconds'] ?? 0).toDouble(),
      focusTimeSeconds: (json['focus_time_seconds'] ?? 0).toDouble(),
      distractionTimeSeconds: (json['distraction_time_seconds'] ?? 0).toDouble(),
      idleTimeSeconds: (json['idle_time_seconds'] ?? 0).toDouble(),
      focusPercentage: (json['focus_percentage'] ?? 0).toDouble(),
      distractionPercentage: (json['distraction_percentage'] ?? 0).toDouble(),
      idlePercentage: (json['idle_percentage'] ?? 0).toDouble(),
      focusScore: json['focus_score'] ?? 'Unknown',
      eventCount: json['event_count'] ?? 0,
    );
  }

  String getDurationFormatted(double seconds) {
    int mins = (seconds / 60).toInt();
    int secs = (seconds % 60).toInt();
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }
}

class FocusEvent {
  final String type; // 'focus', 'distraction', 'idle'
  final double start;
  final double end;
  final double duration;
  final String description;

  FocusEvent({
    required this.type,
    required this.start,
    required this.end,
    required this.duration,
    required this.description,
  });

  factory FocusEvent.fromJson(Map<String, dynamic> json) {
    return FocusEvent(
      type: json['type'] ?? 'unknown',
      start: (json['start'] ?? 0).toDouble(),
      end: (json['end'] ?? 0).toDouble(),
      duration: (json['duration'] ?? 0).toDouble(),
      description: json['description'] ?? '',
    );
  }

  Color getEventColor() {
    switch (type.toLowerCase()) {
      case 'focus':
        return const Color(0xFF4CAF50); // Green
      case 'distraction':
        return const Color(0xFFF44336); // Red
      case 'idle':
        return const Color(0xFFFFC107); // Amber
      default:
        return const Color(0xFF9E9E9E); // Grey
    }
  }

  String getDurationFormatted() {
    int mins = (duration / 60).toInt();
    int secs = (duration % 60).toInt();
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }
}