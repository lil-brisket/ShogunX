import 'package:flutter/material.dart';
import 'character.dart';

enum TileType { village, wilderness, pvp, pve, safe, dangerous }
enum VillageType { konoha, suna, kiri, iwa, kumo }

class WorldTile {
  final int x;
  final int y;
  final TileType type;
  final String? villageType; // null for non-village tiles
  final String? villageName;
  final String? description;
  final List<String> availableActions; // move, rest, gather, etc.
  final bool isOccupied; // by another player
  final String? occupiedBy; // player ID if occupied
  
  // Tile properties
  final Map<String, double> statModifiers; // stat -> modifier
  final List<String> specialEffects;
  final int dangerLevel; // 0-10, higher = more dangerous
  final bool isRestricted; // requires special access

  WorldTile({
    required this.x,
    required this.y,
    required this.type,
    this.villageType,
    this.villageName,
    this.description,
    required this.availableActions,
    required this.isOccupied,
    this.occupiedBy,
    required this.statModifiers,
    required this.specialEffects,
    required this.dangerLevel,
    required this.isRestricted,
  });

  // Check if player can move to this tile
  bool canMoveTo(Character character) {
    if (isOccupied) return false;
    if (isRestricted && !_hasAccess(character)) return false;
    return true;
  }

  // Check if player has access to restricted tiles
  bool _hasAccess(Character character) {
    // Village tiles - check if player is from that village or has permission
    if (villageType != null && type == TileType.village) {
      return character.village.toLowerCase() == villageType!.toLowerCase();
    }
    
    // Dark Ops areas - check if player is in Dark Ops squad
    if (isRestricted && specialEffects.contains('dark_ops')) {
      // TODO: Implement Dark Ops squad check
      return false;
    }
    
    return false;
  }

  // Get tile color for UI
  Color get tileColor {
    switch (type) {
      case TileType.village:
        return Colors.blue;
      case TileType.wilderness:
        return Colors.green;
      case TileType.pvp:
        return Colors.red;
      case TileType.pve:
        return Colors.orange;
      case TileType.safe:
        return Colors.grey;
      case TileType.dangerous:
        return Colors.purple;
    }
  }

  // Get village color if applicable
  Color? get villageColor {
    if (villageType == null) return null;
    
    switch (villageType!.toLowerCase()) {
      case 'konoha':
        return Colors.red;
      case 'suna':
        return Colors.yellow;
      case 'kiri':
        return Colors.blue;
      case 'iwa':
        return Colors.brown;
      case 'kumo':
        return Colors.purple;
      default:
        return null;
    }
  }

  WorldTile copyWith({
    int? x,
    int? y,
    TileType? type,
    String? villageType,
    String? villageName,
    String? description,
    List<String>? availableActions,
    bool? isOccupied,
    String? occupiedBy,
    Map<String, double>? statModifiers,
    List<String>? specialEffects,
    int? dangerLevel,
    bool? isRestricted,
  }) {
    return WorldTile(
      x: x ?? this.x,
      y: y ?? this.y,
      type: type ?? this.type,
      villageType: villageType ?? this.villageType,
      villageName: villageName ?? this.villageName,
      description: description ?? this.description,
      availableActions: availableActions ?? this.availableActions,
      isOccupied: isOccupied ?? this.isOccupied,
      occupiedBy: occupiedBy ?? this.occupiedBy,
      statModifiers: statModifiers ?? this.statModifiers,
      specialEffects: specialEffects ?? this.specialEffects,
      dangerLevel: dangerLevel ?? this.dangerLevel,
      isRestricted: isRestricted ?? this.isRestricted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
      'type': type.name,
      'villageType': villageType,
      'villageName': villageName,
      'description': description,
      'availableActions': availableActions,
      'isOccupied': isOccupied,
      'occupiedBy': occupiedBy,
      'statModifiers': statModifiers,
      'specialEffects': specialEffects,
      'dangerLevel': dangerLevel,
      'isRestricted': isRestricted,
    };
  }

  factory WorldTile.fromJson(Map<String, dynamic> json) {
    return WorldTile(
      x: json['x'],
      y: json['y'],
      type: TileType.values.firstWhere((t) => t.name == json['type']),
      villageType: json['villageType'],
      villageName: json['villageName'],
      description: json['description'],
      availableActions: List<String>.from(json['availableActions']),
      isOccupied: json['isOccupied'],
      occupiedBy: json['occupiedBy'],
      statModifiers: Map<String, double>.from(json['statModifiers']),
      specialEffects: List<String>.from(json['specialEffects']),
      dangerLevel: json['dangerLevel'],
      isRestricted: json['isRestricted'],
    );
  }
}

class World {
  final String id;
  final int width;
  final int height;
  final List<WorldTile> tiles;
  final Map<String, WorldTile> villageLocations; // village -> tile
  final List<String> activePlayers; // players currently in world
  final DateTime lastUpdated;

  World({
    required this.id,
    required this.width,
    required this.height,
    required this.tiles,
    required this.villageLocations,
    required this.activePlayers,
    required this.lastUpdated,
  });

  // Get tile at specific coordinates
  WorldTile? getTileAt(int x, int y) {
    if (x < 0 || x >= width || y < 0 || y >= height) return null;
    return tiles.firstWhere((tile) => tile.x == x && tile.y == y);
  }

  // Get all tiles of a specific type
  List<WorldTile> getTilesByType(TileType type) {
    return tiles.where((tile) => tile.type == type).toList();
  }

  // Get village tile
  WorldTile? getVillageTile(String villageName) {
    return villageLocations[villageName.toLowerCase()];
  }

  // Check if coordinates are valid
  bool isValidCoordinate(int x, int y) {
    return x >= 0 && x < width && y >= 0 && y < height;
  }

  // Get adjacent tiles
  List<WorldTile> getAdjacentTiles(int x, int y) {
    final adjacent = <WorldTile>[];
    final directions = [
      [-1, 0], [1, 0], [0, -1], [0, 1], // cardinal directions
      [-1, -1], [-1, 1], [1, -1], [1, 1], // diagonal
    ];
    
    for (final direction in directions) {
      final newX = x + direction[0];
      final newY = y + direction[1];
      final tile = getTileAt(newX, newY);
      if (tile != null) {
        adjacent.add(tile);
      }
    }
    
    return adjacent;
  }

  // Get path between two points (simple implementation)
  List<WorldTile> getPath(int startX, int startY, int endX, int endY) {
    // TODO: Implement proper pathfinding algorithm
    final path = <WorldTile>[];
    final startTile = getTileAt(startX, startY);
    final endTile = getTileAt(endX, endY);
    
    if (startTile == null || endTile == null) return path;
    
    // Simple direct path for now
    path.add(startTile);
    path.add(endTile);
    
    return path;
  }

  World copyWith({
    String? id,
    int? width,
    int? height,
    List<WorldTile>? tiles,
    Map<String, WorldTile>? villageLocations,
    List<String>? activePlayers,
    DateTime? lastUpdated,
  }) {
    return World(
      id: id ?? this.id,
      width: width ?? this.width,
      height: height ?? this.height,
      tiles: tiles ?? this.tiles,
      villageLocations: villageLocations ?? this.villageLocations,
      activePlayers: activePlayers ?? this.activePlayers,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'width': width,
      'height': height,
      'tiles': tiles.map((tile) => tile.toJson()).toList(),
      'villageLocations': villageLocations.map((key, value) => MapEntry(key, value.toJson())),
      'activePlayers': activePlayers,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory World.fromJson(Map<String, dynamic> json) {
    return World(
      id: json['id'],
      width: json['width'],
      height: json['height'],
      tiles: (json['tiles'] as List).map((t) => WorldTile.fromJson(t)).toList(),
      villageLocations: (json['villageLocations'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, WorldTile.fromJson(value))
      ),
      activePlayers: List<String>.from(json['activePlayers']),
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}
