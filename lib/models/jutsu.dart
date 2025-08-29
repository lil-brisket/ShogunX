import 'package:flutter/material.dart';
import 'package:ninja_world_mmo/models/character.dart';

enum JutsuType { ninjutsu, taijutsu, bukijutsu, bloodline }
enum JutsuElement { fire, water, earth, wind, lightning, neutral }

class Jutsu {
  final String id;
  final String name;
  final String description;
  final JutsuType type;
  final JutsuElement element;
  final String? bloodline; // null for non-bloodline jutsu
  
  // Costs and cooldowns
  final int chakraCost;
  final int staminaCost;
  final int cooldownTurns;
  final int range; // 0 = self, 1 = melee, 2+ = ranged
  
  // Power and scaling
  final int basePower;
  final Map<String, double> statScaling; // stat -> scaling multiplier
  final List<String> effects; // status effects, buffs, debuffs
  
  // Mastery system
  final int maxMasteryLevel; // 10 for normal, 15 for bloodline
  final Map<int, int> masteryBonuses; // level -> power bonus
  
  // Requirements
  final int requiredLevel;
  final Map<String, int> statRequirements;
  final List<String> requiredElements;
  final String? requiredBloodline;
  
  // UI and display
  final String iconPath;
  final List<String> tags;
  final bool isActive;

  Jutsu({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.element,
    this.bloodline,
    required this.chakraCost,
    required this.staminaCost,
    required this.cooldownTurns,
    required this.range,
    required this.basePower,
    required this.statScaling,
    required this.effects,
    required this.maxMasteryLevel,
    required this.masteryBonuses,
    required this.requiredLevel,
    required this.statRequirements,
    required this.requiredElements,
    this.requiredBloodline,
    required this.iconPath,
    required this.tags,
    required this.isActive,
  });

  // Check if character can learn this jutsu
  bool canLearn(Character character) {
    if (!isActive) return false;
    if (character.level < requiredLevel) return false;
    
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

  // Get power at specific mastery level
  int getPowerAtLevel(int masteryLevel) {
    if (masteryLevel < 1 || masteryLevel > maxMasteryLevel) {
      throw ArgumentError('Invalid mastery level');
    }
    
    final bonus = masteryBonuses[masteryLevel] ?? 0;
    return basePower + bonus;
  }

  // Check if character can use this jutsu (has enough CP/STA)
  bool canUse(Character character) {
    return character.currentChakra >= chakraCost && 
           character.currentStamina >= staminaCost;
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
      case 'bloodlineEfficiency': return character.bloodlineEfficiency;
      default: return 0;
    }
  }

  // Get element color for UI
  Color get elementColor {
    switch (element) {
      case JutsuElement.fire:
        return Colors.red;
      case JutsuElement.water:
        return Colors.blue;
      case JutsuElement.earth:
        return Colors.brown;
      case JutsuElement.wind:
        return Colors.green;
      case JutsuElement.lightning:
        return Colors.yellow;
      case JutsuElement.neutral:
        return Colors.grey;
    }
  }

  // Get type icon for UI
  IconData get typeIcon {
    switch (type) {
      case JutsuType.ninjutsu:
        return Icons.auto_fix_high;
      case JutsuType.taijutsu:
        return Icons.sports_martial_arts;
      case JutsuType.bukijutsu:
        return Icons.gps_fixed;
      case JutsuType.bloodline:
        return Icons.psychology;
    }
  }

  Jutsu copyWith({
    String? id,
    String? name,
    String? description,
    JutsuType? type,
    JutsuElement? element,
    String? bloodline,
    int? chakraCost,
    int? staminaCost,
    int? cooldownTurns,
    int? range,
    int? basePower,
    Map<String, double>? statScaling,
    List<String>? effects,
    int? maxMasteryLevel,
    Map<int, int>? masteryBonuses,
    int? requiredLevel,
    Map<String, int>? statRequirements,
    List<String>? requiredElements,
    String? requiredBloodline,
    String? iconPath,
    List<String>? tags,
    bool? isActive,
  }) {
    return Jutsu(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      element: element ?? this.element,
      bloodline: bloodline ?? this.bloodline,
      chakraCost: chakraCost ?? this.chakraCost,
      staminaCost: staminaCost ?? this.staminaCost,
      cooldownTurns: cooldownTurns ?? this.cooldownTurns,
      range: range ?? this.range,
      basePower: basePower ?? this.basePower,
      statScaling: statScaling ?? this.statScaling,
      effects: effects ?? this.effects,
      maxMasteryLevel: maxMasteryLevel ?? this.maxMasteryLevel,
      masteryBonuses: masteryBonuses ?? this.masteryBonuses,
      requiredLevel: requiredLevel ?? this.requiredLevel,
      statRequirements: statRequirements ?? this.statRequirements,
      requiredElements: requiredElements ?? this.requiredElements,
      requiredBloodline: requiredBloodline ?? this.requiredBloodline,
      iconPath: iconPath ?? this.iconPath,
      tags: tags ?? this.tags,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.name,
      'element': element.name,
      'bloodline': bloodline,
      'chakraCost': chakraCost,
      'staminaCost': staminaCost,
      'cooldownTurns': cooldownTurns,
      'range': range,
      'basePower': basePower,
      'statScaling': statScaling,
      'effects': effects,
      'maxMasteryLevel': maxMasteryLevel,
      'masteryBonuses': masteryBonuses,
      'requiredLevel': requiredLevel,
      'statRequirements': statRequirements,
      'requiredElements': requiredElements,
      'requiredBloodline': requiredBloodline,
      'iconPath': iconPath,
      'tags': tags,
      'isActive': isActive,
    };
  }

  factory Jutsu.fromJson(Map<String, dynamic> json) {
    return Jutsu(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: JutsuType.values.firstWhere((t) => t.name == json['type']),
      element: JutsuElement.values.firstWhere((e) => e.name == json['element']),
      bloodline: json['bloodline'],
      chakraCost: json['chakraCost'],
      staminaCost: json['staminaCost'],
      cooldownTurns: json['cooldownTurns'],
      range: json['range'],
      basePower: json['basePower'],
      statScaling: Map<String, double>.from(json['statScaling']),
      effects: List<String>.from(json['effects']),
      maxMasteryLevel: json['maxMasteryLevel'],
      masteryBonuses: Map<int, int>.from(json['masteryBonuses']),
      requiredLevel: json['requiredLevel'],
      statRequirements: Map<String, int>.from(json['statRequirements']),
      requiredElements: List<String>.from(json['requiredElements']),
      requiredBloodline: json['requiredBloodline'],
      iconPath: json['iconPath'],
      tags: List<String>.from(json['tags']),
      isActive: json['isActive'],
    );
  }
}
