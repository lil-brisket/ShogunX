import 'package:flutter/material.dart';

enum UpdatePriority {
  low,
  normal, 
  high,
  critical
}

enum UpdateType {
  feature,
  bugfix,
  balance,
  content,
  event,
  maintenance,
  security
}

class GameUpdate {
  final String id;
  final String title;
  final String description;
  final UpdateType type;
  final UpdatePriority priority;
  final DateTime timestamp;
  final String? version;
  final List<String> tags;
  final IconData icon;
  final Color color;
  final bool isActive;
  final DateTime? expiresAt;
  final String? link;
  final Map<String, dynamic> metadata;

  const GameUpdate({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.priority = UpdatePriority.normal,
    required this.timestamp,
    this.version,
    this.tags = const [],
    this.icon = Icons.announcement,
    this.color = Colors.blue,
    this.isActive = true,
    this.expiresAt,
    this.link,
    this.metadata = const {},
  });

  GameUpdate copyWith({
    String? id,
    String? title,
    String? description,
    UpdateType? type,
    UpdatePriority? priority,
    DateTime? timestamp,
    String? version,
    List<String>? tags,
    IconData? icon,
    Color? color,
    bool? isActive,
    DateTime? expiresAt,
    String? link,
    Map<String, dynamic>? metadata,
  }) {
    return GameUpdate(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      timestamp: timestamp ?? this.timestamp,
      version: version ?? this.version,
      tags: tags ?? this.tags,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isActive: isActive ?? this.isActive,
      expiresAt: expiresAt ?? this.expiresAt,
      link: link ?? this.link,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameUpdate &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.type == type &&
        other.priority == priority &&
        other.timestamp == timestamp &&
        other.version == version &&
        other.tags.toString() == tags.toString() &&
        other.icon == icon &&
        other.color == color &&
        other.isActive == isActive &&
        other.expiresAt == expiresAt &&
        other.link == link &&
        other.metadata.toString() == metadata.toString();
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      description,
      type,
      priority,
      timestamp,
      version,
      tags,
      icon,
      color,
      isActive,
      expiresAt,
      link,
      metadata,
    );
  }

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  bool get shouldShow {
    return isActive && !isExpired;
  }

  String get priorityString {
    switch (priority) {
      case UpdatePriority.low:
        return 'Low';
      case UpdatePriority.normal:
        return 'Normal';
      case UpdatePriority.high:
        return 'High';
      case UpdatePriority.critical:
        return 'Critical';
    }
  }

  String get typeString {
    switch (type) {
      case UpdateType.feature:
        return 'Feature';
      case UpdateType.bugfix:
        return 'Bug Fix';
      case UpdateType.balance:
        return 'Balance';
      case UpdateType.content:
        return 'Content';
      case UpdateType.event:
        return 'Event';
      case UpdateType.maintenance:
        return 'Maintenance';
      case UpdateType.security:
        return 'Security';
    }
  }
}