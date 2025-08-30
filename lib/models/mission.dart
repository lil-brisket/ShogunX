import 'package:flutter/material.dart';
import 'character.dart';

enum MissionRank { D, C, B, A, S }

enum MissionType { mission, quest, darkOps }

class Mission {
  final String id;
  final String title;
  final String description;
  final MissionRank rank;
  final MissionType type;
  final String village;
  final int requiredLevel;
  final int requiredRank; // 0=Academy, 1=Genin, 2=Chunin, 3=Jounin, 4=Elite Jounin, 5=Kage
  
  // Rewards
  final int experienceReward;
  final int ryoReward;
  final List<String> itemRewards;
  final List<String> jutsuRewards;
  
  // Requirements
  final Map<String, int> statRequirements; // stat -> minimum value
  final List<String> requiredElements;
  final String? requiredBloodline;
  
  // Mission details
  final int estimatedDuration; // in minutes
  final bool isRepeatable;
  final bool isActive;
  final DateTime? expiryDate;
  
  // Special properties
  final bool isDarkOps;
  final bool isStoryline;
  final String? prerequisiteMissionId;
  final List<String> tags;

  Mission({
    required this.id,
    required this.title,
    required this.description,
    required this.rank,
    required this.type,
    required this.village,
    required this.requiredLevel,
    required this.requiredRank,
    required this.experienceReward,
    required this.ryoReward,
    required this.itemRewards,
    required this.jutsuRewards,
    required this.statRequirements,
    required this.requiredElements,
    this.requiredBloodline,
    required this.estimatedDuration,
    required this.isRepeatable,
    required this.isActive,
    this.expiryDate,
    required this.isDarkOps,
    required this.isStoryline,
    this.prerequisiteMissionId,
    required this.tags,
  });

  // Check if character can accept this mission
  bool canAccept(Character character) {
    if (!isActive) return false;
    if (character.level < requiredLevel) return false;
    
    // Check rank requirement
    final characterRank = _getRankValue(character.ninjaRank);
    if (characterRank < requiredRank) return false;
    
    // Check stat requirements
    for (final entry in statRequirements.entries) {
      final statValue = _getStatValue(character, entry.key);
      if (statValue < entry.value) return false;
    }
    
    // Check element requirements
    if (requiredElements.isNotEmpty) {
      final hasRequiredElement = requiredElements.any(
        (element) => character.elements.contains(element)
      );
      if (!hasRequiredElement) return false;
    }
    
    // Check bloodline requirement
    if (requiredBloodline != null && character.bloodline != requiredBloodline) {
      return false;
    }
    
    return true;
  }

  int _getRankValue(String rank) {
    switch (rank) {
      case 'Academy Student': return 0;
      case 'Genin': return 1;
      case 'Chunin': return 2;
      case 'Jounin': return 3;
      case 'Elite Jounin': return 4;
      case 'Kage': return 5;
      default: return 0;
    }
  }

  int _getStatValue(Character character, String stat) {
    switch (stat) {
      case 'strength': return character.strength;
      case 'intelligence': return character.intelligence;
      case 'speed': return character.speed;
      case 'defense': return character.defense;
      case 'willpower': return character.willpower;
      case 'bukijutsu': return character.bukijutsu;
      case 'ninjutsu': return character.ninjutsu;
      case 'taijutsu': return character.taijutsu;
              case 'genjutsu': return character.genjutsu;
      default: return 0;
    }
  }

  // Get rank color for UI
  Color get rankColor {
    switch (rank) {
      case MissionRank.D:
        return Colors.grey;
      case MissionRank.C:
        return Colors.blue;
      case MissionRank.B:
        return Colors.green;
      case MissionRank.A:
        return Colors.orange;
      case MissionRank.S:
        return Colors.red;
    }
  }

  // Get rank name
  String get rankName => rank.name;

  Mission copyWith({
    String? id,
    String? title,
    String? description,
    MissionRank? rank,
    MissionType? type,
    String? village,
    int? requiredLevel,
    int? requiredRank,
    int? experienceReward,
    int? ryoReward,
    List<String>? itemRewards,
    List<String>? jutsuRewards,
    Map<String, int>? statRequirements,
    List<String>? requiredElements,
    String? requiredBloodline,
    int? estimatedDuration,
    bool? isRepeatable,
    bool? isActive,
    DateTime? expiryDate,
    bool? isDarkOps,
    bool? isStoryline,
    String? prerequisiteMissionId,
    List<String>? tags,
  }) {
    return Mission(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      rank: rank ?? this.rank,
      type: type ?? this.type,
      village: village ?? this.village,
      requiredLevel: requiredLevel ?? this.requiredLevel,
      requiredRank: requiredRank ?? this.requiredRank,
      experienceReward: experienceReward ?? this.experienceReward,
      ryoReward: ryoReward ?? this.ryoReward,
      itemRewards: itemRewards ?? this.itemRewards,
      jutsuRewards: jutsuRewards ?? this.jutsuRewards,
      statRequirements: statRequirements ?? this.statRequirements,
      requiredElements: requiredElements ?? this.requiredElements,
      requiredBloodline: requiredBloodline ?? this.requiredBloodline,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      isRepeatable: isRepeatable ?? this.isRepeatable,
      isActive: isActive ?? this.isActive,
      expiryDate: expiryDate ?? this.expiryDate,
      isDarkOps: isDarkOps ?? this.isDarkOps,
      isStoryline: isStoryline ?? this.isStoryline,
      prerequisiteMissionId: prerequisiteMissionId ?? this.prerequisiteMissionId,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'rank': rank.name,
      'type': type.name,
      'village': village,
      'requiredLevel': requiredLevel,
      'requiredRank': requiredRank,
      'experienceReward': experienceReward,
      'ryoReward': ryoReward,
      'itemRewards': itemRewards,
      'jutsuRewards': jutsuRewards,
      'statRequirements': statRequirements,
      'requiredElements': requiredElements,
      'requiredBloodline': requiredBloodline,
      'estimatedDuration': estimatedDuration,
      'isRepeatable': isRepeatable,
      'isActive': isActive,
      'expiryDate': expiryDate?.toIso8601String(),
      'isDarkOps': isDarkOps,
      'isStoryline': isStoryline,
      'prerequisiteMissionId': prerequisiteMissionId,
      'tags': tags,
    };
  }

  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      rank: MissionRank.values.firstWhere((r) => r.name == json['rank']),
      type: MissionType.values.firstWhere((t) => t.name == json['type']),
      village: json['village'],
      requiredLevel: json['requiredLevel'],
      requiredRank: json['requiredRank'],
      experienceReward: json['experienceReward'],
      ryoReward: json['ryoReward'],
      itemRewards: List<String>.from(json['itemRewards']),
      jutsuRewards: List<String>.from(json['jutsuRewards']),
      statRequirements: Map<String, int>.from(json['statRequirements']),
      requiredElements: List<String>.from(json['requiredElements']),
      requiredBloodline: json['requiredBloodline'],
      estimatedDuration: json['estimatedDuration'],
      isRepeatable: json['isRepeatable'],
      isActive: json['isActive'],
      expiryDate: json['expiryDate'] != null ? DateTime.parse(json['expiryDate']) : null,
      isDarkOps: json['isDarkOps'],
      isStoryline: json['isStoryline'],
      prerequisiteMissionId: json['prerequisiteMissionId'],
      tags: List<String>.from(json['tags']),
    );
  }
}
