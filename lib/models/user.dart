import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String email;
  final DateTime createdAt;
  final DateTime lastLogin;
  final bool isActive;
  final bool isVerified;
  
  // Profile settings
  final String? displayName;
  final String? avatarUrl;
  final String? bio;
  final Map<String, dynamic> preferences; // theme, notifications, etc.
  
  // Account status
  final bool isBanned;
  final String? banReason;
  final DateTime? banExpiry;
  final int warningCount;
  
  // Social features
  final List<String> friends; // friend user IDs
  final List<String> blockedUsers; // blocked user IDs
  final List<String> ignoredUsers; // ignored user IDs
  
  // Game-specific
  final String? currentCharacterId; // active character
  final List<String> characterIds; // all characters
  final String? lastVillage; // last visited village
  final DateTime? lastActivity;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.createdAt,
    required this.lastLogin,
    required this.isActive,
    required this.isVerified,
    this.displayName,
    this.avatarUrl,
    this.bio,
    required this.preferences,
    required this.isBanned,
    this.banReason,
    this.banExpiry,
    required this.warningCount,
    required this.friends,
    required this.blockedUsers,
    required this.ignoredUsers,
    this.currentCharacterId,
    required this.characterIds,
    this.lastVillage,
    this.lastActivity,
  });

  // Check if user is banned
  bool get isCurrentlyBanned {
    if (!isBanned) return false;
    if (banExpiry == null) return true; // permanent ban
    return DateTime.now().isBefore(banExpiry!);
  }

  // Check if user can play
  bool get canPlay {
    return isActive && !isCurrentlyBanned;
  }

  // Get display name (username fallback)
  String get effectiveDisplayName => displayName ?? username;

  // Check if user is friends with another user
  bool isFriendsWith(String userId) => friends.contains(userId);

  // Check if user has blocked another user
  bool hasBlocked(String userId) => blockedUsers.contains(userId);

  // Check if user has ignored another user
  bool hasIgnored(String userId) => ignoredUsers.contains(userId);

  // Check if user can interact with another user
  bool canInteractWith(String userId) {
    return !hasBlocked(userId) && !hasIgnored(userId);
  }

  // Get user preference
  T? getPreference<T>(String key, {T? defaultValue}) {
    final value = preferences[key];
    if (value is T) return value;
    return defaultValue;
  }

  // Set user preference
  User setPreference(String key, dynamic value) {
    final newPreferences = Map<String, dynamic>.from(preferences);
    newPreferences[key] = value;
    return copyWith(preferences: newPreferences);
  }

  // Add friend
  User addFriend(String userId) {
    if (friends.contains(userId)) return this;
    return copyWith(friends: [...friends, userId]);
  }

  // Remove friend
  User removeFriend(String userId) {
    if (!friends.contains(userId)) return this;
    return copyWith(friends: friends.where((id) => id != userId).toList());
  }

  // Block user
  User blockUser(String userId) {
    if (blockedUsers.contains(userId)) return this;
    return copyWith(blockedUsers: [...blockedUsers, userId]);
  }

  // Unblock user
  User unblockUser(String userId) {
    if (!blockedUsers.contains(userId)) return this;
    return copyWith(blockedUsers: blockedUsers.where((id) => id != userId).toList());
  }

  // Ignore user
  User ignoreUser(String userId) {
    if (ignoredUsers.contains(userId)) return this;
    return copyWith(ignoredUsers: [...ignoredUsers, userId]);
  }

  // Unignore user
  User unignoreUser(String userId) {
    if (!ignoredUsers.contains(userId)) return this;
    return copyWith(ignoredUsers: ignoredUsers.where((id) => id != userId).toList());
  }

  // Update last activity
  User updateLastActivity() {
    return copyWith(lastActivity: DateTime.now());
  }

  // Update last login
  User updateLastLogin() {
    return copyWith(lastLogin: DateTime.now());
  }

  User copyWith({
    String? id,
    String? username,
    String? email,
    DateTime? createdAt,
    DateTime? lastLogin,
    bool? isActive,
    bool? isVerified,
    String? displayName,
    String? avatarUrl,
    String? bio,
    Map<String, dynamic>? preferences,
    bool? isBanned,
    String? banReason,
    DateTime? banExpiry,
    int? warningCount,
    List<String>? friends,
    List<String>? blockedUsers,
    List<String>? ignoredUsers,
    String? currentCharacterId,
    List<String>? characterIds,
    String? lastVillage,
    DateTime? lastActivity,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? this.isVerified,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      preferences: preferences ?? this.preferences,
      isBanned: isBanned ?? this.isBanned,
      banReason: banReason ?? this.banReason,
      banExpiry: banExpiry ?? this.banExpiry,
      warningCount: warningCount ?? this.warningCount,
      friends: friends ?? this.friends,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      ignoredUsers: ignoredUsers ?? this.ignoredUsers,
      currentCharacterId: currentCharacterId ?? this.currentCharacterId,
      characterIds: characterIds ?? this.characterIds,
      lastVillage: lastVillage ?? this.lastVillage,
      lastActivity: lastActivity ?? this.lastActivity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin.toIso8601String(),
      'isActive': isActive,
      'isVerified': isVerified,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'preferences': preferences,
      'isBanned': isBanned,
      'banReason': banReason,
      'banExpiry': banExpiry?.toIso8601String(),
      'warningCount': warningCount,
      'friends': friends,
      'blockedUsers': blockedUsers,
      'ignoredUsers': ignoredUsers,
      'currentCharacterId': currentCharacterId,
      'characterIds': characterIds,
      'lastVillage': lastVillage,
      'lastActivity': lastActivity?.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      createdAt: DateTime.parse(json['createdAt']),
      lastLogin: DateTime.parse(json['lastLogin']),
      isActive: json['isActive'],
      isVerified: json['isVerified'],
      displayName: json['displayName'],
      avatarUrl: json['avatarUrl'],
      bio: json['bio'],
      preferences: Map<String, dynamic>.from(json['preferences']),
      isBanned: json['isBanned'],
      banReason: json['banReason'],
      banExpiry: json['banExpiry'] != null ? DateTime.parse(json['banExpiry']) : null,
      warningCount: json['warningCount'],
      friends: List<String>.from(json['friends']),
      blockedUsers: List<String>.from(json['blockedUsers']),
      ignoredUsers: List<String>.from(json['ignoredUsers']),
      currentCharacterId: json['currentCharacterId'],
      characterIds: List<String>.from(json['characterIds']),
      lastVillage: json['lastVillage'],
      lastActivity: json['lastActivity'] != null ? DateTime.parse(json['lastActivity']) : null,
    );
  }

  // Firestore serialization methods
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'createdAt': createdAt,
      'lastLogin': lastLogin,
      'isActive': isActive,
      'isVerified': isVerified,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'preferences': preferences,
      'isBanned': isBanned,
      'banReason': banReason,
      'banExpiry': banExpiry,
      'warningCount': warningCount,
      'friends': friends,
      'blockedUsers': blockedUsers,
      'ignoredUsers': ignoredUsers,
      'currentCharacterId': currentCharacterId,
      'characterIds': characterIds,
      'lastVillage': lastVillage,
      'lastActivity': lastActivity,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastLogin: (map['lastLogin'] as Timestamp).toDate(),
      isActive: map['isActive'],
      isVerified: map['isVerified'],
      displayName: map['displayName'],
      avatarUrl: map['avatarUrl'],
      bio: map['bio'],
      preferences: Map<String, dynamic>.from(map['preferences']),
      isBanned: map['isBanned'],
      banReason: map['banReason'],
      banExpiry: map['banExpiry'] != null ? (map['banExpiry'] as Timestamp).toDate() : null,
      warningCount: map['warningCount'],
      friends: List<String>.from(map['friends']),
      blockedUsers: List<String>.from(map['blockedUsers']),
      ignoredUsers: List<String>.from(map['ignoredUsers']),
      currentCharacterId: map['currentCharacterId'],
      characterIds: List<String>.from(map['characterIds']),
      lastVillage: map['lastVillage'],
      lastActivity: map['lastActivity'] != null ? (map['lastActivity'] as Timestamp).toDate() : null,
    );
  }
}
