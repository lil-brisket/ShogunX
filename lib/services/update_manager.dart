import 'package:flutter/material.dart';
import '../models/models.dart';
import 'game_service.dart';

class UpdateManager {
  static final GameService _gameService = GameService();

  /// Add a new feature update to the game
  static Future<void> addFeatureUpdate({
    required String title,
    required String description,
    String? version,
    UpdatePriority priority = UpdatePriority.normal,
    List<String> tags = const [],
    IconData? icon,
    Color? color,
  }) async {
    await _gameService.addProjectUpdate(
      title: title,
      description: description,
      type: UpdateType.feature,
      priority: priority,
      version: version,
      tags: tags,
      icon: icon,
      color: color,
    );
  }

  /// Add a bug fix update to the game
  static Future<void> addBugFixUpdate({
    required String title,
    required String description,
    String? version,
    UpdatePriority priority = UpdatePriority.normal,
    List<String> tags = const [],
  }) async {
    await _gameService.addProjectUpdate(
      title: title,
      description: description,
      type: UpdateType.bugfix,
      priority: priority,
      version: version,
      tags: tags,
    );
  }

  /// Add a balance update to the game
  static Future<void> addBalanceUpdate({
    required String title,
    required String description,
    String? version,
    UpdatePriority priority = UpdatePriority.normal,
    List<String> tags = const [],
  }) async {
    await _gameService.addProjectUpdate(
      title: title,
      description: description,
      type: UpdateType.balance,
      priority: priority,
      version: version,
      tags: tags,
    );
  }

  /// Add a content update to the game
  static Future<void> addContentUpdate({
    required String title,
    required String description,
    String? version,
    UpdatePriority priority = UpdatePriority.normal,
    List<String> tags = const [],
  }) async {
    await _gameService.addProjectUpdate(
      title: title,
      description: description,
      type: UpdateType.content,
      priority: priority,
      version: version,
      tags: tags,
    );
  }

  /// Add an event update to the game
  static Future<void> addEventUpdate({
    required String title,
    required String description,
    String? version,
    UpdatePriority priority = UpdatePriority.normal,
    List<String> tags = const [],
    DateTime? expiresAt,
  }) async {
    final update = GameUpdate(
      id: 'update_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: description,
      type: UpdateType.event,
      priority: priority,
      timestamp: DateTime.now(),
      version: version,
      tags: tags,
      icon: Icons.event,
      color: Colors.amber,
      expiresAt: expiresAt,
    );
    
    await _gameService.addGameUpdate(update);
  }

  /// Add a maintenance update to the game
  static Future<void> addMaintenanceUpdate({
    required String title,
    required String description,
    String? version,
    UpdatePriority priority = UpdatePriority.high,
    List<String> tags = const [],
  }) async {
    await _gameService.addProjectUpdate(
      title: title,
      description: description,
      type: UpdateType.maintenance,
      priority: priority,
      version: version,
      tags: tags,
    );
  }

  /// Add a security update to the game
  static Future<void> addSecurityUpdate({
    required String title,
    required String description,
    String? version,
    UpdatePriority priority = UpdatePriority.critical,
    List<String> tags = const [],
  }) async {
    await _gameService.addProjectUpdate(
      title: title,
      description: description,
      type: UpdateType.security,
      priority: priority,
      version: version,
      tags: tags,
    );
  }

  /// Quick method to add common development milestones
  static Future<void> addDevelopmentMilestone(String milestone) async {
    switch (milestone.toLowerCase()) {
      case 'phase_2_complete':
        await addFeatureUpdate(
          title: 'Phase 2 Development Complete',
          description: 'Clan & Dark Ops system, PvP system, Hospital system, Training & stat allocation, and expanded World map functionality are now live!',
          priority: UpdatePriority.high,
          version: '2.0.0',
          tags: ['milestone', 'phase-2'],
          icon: Icons.celebration,
          color: Colors.purple,
        );
        break;
      
      case 'clan_system':
        await addFeatureUpdate(
          title: 'Clan System Implemented',
          description: 'Players can now join clans, participate in Dark Ops missions, and benefit from clan bonuses and leadership roles.',
          priority: UpdatePriority.high,
          version: '1.5.0',
          tags: ['clans', 'social', 'dark-ops'],
          icon: Icons.group,
          color: Colors.purple,
        );
        break;
      
      case 'pvp_system':
        await addFeatureUpdate(
          title: 'PvP System Active',
          description: 'Sparring, tower battles, and competitive PvP are now available! Test your skills against other ninjas.',
          priority: UpdatePriority.high,
          version: '1.6.0',
          tags: ['pvp', 'combat', 'competitive'],
          icon: Icons.sports_kabaddi,
          color: Colors.red,
        );
        break;
      
      case 'training_system':
        await addFeatureUpdate(
          title: 'Training System Enhanced',
          description: 'New training methods for stats and jutsu mastery. Allocate training points strategically to build your perfect ninja.',
          priority: UpdatePriority.normal,
          version: '1.4.0',
          tags: ['training', 'stats', 'progression'],
          icon: Icons.fitness_center,
          color: Colors.green,
        );
        break;
      
      case 'world_expansion':
        await addContentUpdate(
          title: 'World Map Expanded',
          description: 'New zones, resource gathering locations, and interactive elements added to the 25x25 world grid.',
          priority: UpdatePriority.normal,
          version: '1.3.0',
          tags: ['world', 'exploration', 'content'],
        );
        break;
      
      default:
        await addFeatureUpdate(
          title: 'Development Milestone Reached',
          description: 'A new development milestone has been completed: $milestone',
          priority: UpdatePriority.normal,
          tags: ['milestone', 'development'],
        );
    }
  }

  /// Remove an update by ID
  static Future<void> removeUpdate(String updateId) async {
    await _gameService.removeGameUpdate(updateId);
  }

  /// Get all current updates
  static Future<List<GameUpdate>> getAllUpdates() async {
    return await _gameService.getGameUpdates();
  }
}