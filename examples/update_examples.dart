// Example usage of the UpdateManager for adding project updates

import 'package:flutter/material.dart';
import '../lib/services/update_manager.dart';
import '../lib/models/models.dart';

class UpdateExamples {
  
  /// Example: Adding a new feature update
  static Future<void> exampleFeatureUpdate() async {
    await UpdateManager.addFeatureUpdate(
      title: 'Real-time Multiplayer Chat',
      description: 'Players can now chat with each other in real-time across all villages. Join conversations and make new ninja friends!',
      version: '2.1.0',
      priority: UpdatePriority.high,
      tags: ['chat', 'multiplayer', 'social'],
      icon: Icons.chat_bubble,
      color: Colors.blue,
    );
  }

  /// Example: Adding a bug fix update
  static Future<void> exampleBugFixUpdate() async {
    await UpdateManager.addBugFixUpdate(
      title: 'Fixed Mission Reward Calculation',
      description: 'Fixed an issue where mission rewards were not calculating correctly for high-level missions.',
      version: '1.2.1',
      priority: UpdatePriority.normal,
      tags: ['missions', 'rewards', 'calculation'],
    );
  }

  /// Example: Adding a balance update
  static Future<void> exampleBalanceUpdate() async {
    await UpdateManager.addBalanceUpdate(
      title: 'Jutsu Damage Rebalancing',
      description: 'Adjusted damage values for fire-based jutsus to improve combat balance across all ranks.',
      version: '1.3.2',
      priority: UpdatePriority.normal,
      tags: ['jutsu', 'combat', 'fire-element'],
    );
  }

  /// Example: Adding a content update
  static Future<void> exampleContentUpdate() async {
    await UpdateManager.addContentUpdate(
      title: 'New S-Rank Missions Available',
      description: 'Three new S-rank missions have been added for elite ninjas. Face the ultimate challenges and earn legendary rewards!',
      version: '1.4.0',
      priority: UpdatePriority.high,
      tags: ['missions', 's-rank', 'elite', 'legendary'],
    );
  }

  /// Example: Adding a temporary event update
  static Future<void> exampleEventUpdate() async {
    await UpdateManager.addEventUpdate(
      title: 'Chunin Exams Tournament',
      description: 'The Chunin Exams are starting! Participate in the tournament for exclusive rewards and rank advancement.',
      version: '1.5.0',
      priority: UpdatePriority.high,
      tags: ['tournament', 'chunin-exams', 'event'],
      expiresAt: DateTime.now().add(const Duration(days: 14)), // Event lasts 2 weeks
    );
  }

  /// Example: Adding a maintenance update
  static Future<void> exampleMaintenanceUpdate() async {
    await UpdateManager.addMaintenanceUpdate(
      title: 'Server Maintenance Completed',
      description: 'Scheduled maintenance has been completed. Performance improvements and bug fixes have been applied.',
      version: '1.2.3',
      priority: UpdatePriority.normal,
      tags: ['maintenance', 'performance', 'server'],
    );
  }

  /// Example: Adding a security update
  static Future<void> exampleSecurityUpdate() async {
    await UpdateManager.addSecurityUpdate(
      title: 'Security Enhancement',
      description: 'Enhanced account security measures have been implemented to better protect your ninja data.',
      version: '1.1.8',
      priority: UpdatePriority.critical,
      tags: ['security', 'accounts', 'protection'],
    );
  }

  /// Example: Using the development milestone shortcuts
  static Future<void> exampleMilestones() async {
    // When you complete Phase 2 development
    await UpdateManager.addDevelopmentMilestone('phase_2_complete');
    
    // When you implement the clan system
    await UpdateManager.addDevelopmentMilestone('clan_system');
    
    // When you add PvP features
    await UpdateManager.addDevelopmentMilestone('pvp_system');
    
    // When you enhance the training system
    await UpdateManager.addDevelopmentMilestone('training_system');
    
    // When you expand the world map
    await UpdateManager.addDevelopmentMilestone('world_expansion');
  }

  /// Example: Custom update with all parameters
  static Future<void> exampleCustomUpdate() async {
    await UpdateManager.addFeatureUpdate(
      title: 'Bloodline Techniques Released',
      description: 'Unlock your ninja\'s true potential with bloodline techniques! Sharingan, Byakugan, and other legendary abilities are now available.',
      version: '3.0.0',
      priority: UpdatePriority.critical,
      tags: ['bloodlines', 'techniques', 'sharingan', 'byakugan', 'legendary'],
      icon: Icons.remove_red_eye,
      color: Colors.red,
    );
  }
}

// Usage Instructions:
/*
To add these updates to your game, simply call the methods:

1. In your development workflow:
   - When you complete a feature: UpdateExamples.exampleFeatureUpdate()
   - When you fix a bug: UpdateExamples.exampleBugFixUpdate()
   - When you reach a milestone: UpdateManager.addDevelopmentMilestone('clan_system')

2. From anywhere in your app:
   - Import the UpdateManager
   - Call the appropriate method
   - The update will appear in the Home screen immediately

3. For automatic updates based on git commits or CI/CD:
   - Integrate UpdateManager calls into your deployment scripts
   - Add updates when specific branches are merged
   - Trigger updates when version tags are created

Example integration in a deployment script:
```
if (newVersion.contains('clan')) {
  await UpdateManager.addDevelopmentMilestone('clan_system');
}
```
*/