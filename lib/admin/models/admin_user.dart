class AdminUser {
  final String id;
  final String username;
  final String email;
  final String rank;
  final int level;
  final int currentHp;
  final int maxHp;
  final int currentChakra;
  final int maxChakra;
  final int currentStamina;
  final int maxStamina;
  final String village;
  final Map<String, dynamic> stats;
  final List<String> inventory;
  final List<String> jutsus;
  final Map<String, dynamic> cooldowns;

  AdminUser({
    required this.id,
    required this.username,
    required this.email,
    required this.rank,
    required this.level,
    required this.currentHp,
    required this.maxHp,
    required this.currentChakra,
    required this.maxChakra,
    required this.currentStamina,
    required this.maxStamina,
    required this.village,
    required this.stats,
    required this.inventory,
    required this.jutsus,
    required this.cooldowns,
  });

  factory AdminUser.fromFirestore(Map<String, dynamic> data, String id) {
    return AdminUser(
      id: id,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      rank: data['rank'] ?? 'Academy Student',
      level: data['level'] ?? 1,
      currentHp: data['currentHp'] ?? 100,
      maxHp: data['maxHp'] ?? 100,
      currentChakra: data['currentChakra'] ?? 100,
      maxChakra: data['maxChakra'] ?? 100,
      currentStamina: data['currentStamina'] ?? 100,
      maxStamina: data['maxStamina'] ?? 100,
      village: data['village'] ?? 'Konoha',
      stats: data['stats'] ?? {},
      inventory: List<String>.from(data['inventory'] ?? []),
      jutsus: List<String>.from(data['jutsus'] ?? []),
      cooldowns: Map<String, dynamic>.from(data['cooldowns'] ?? {}),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'username': username,
      'email': email,
      'rank': rank,
      'level': level,
      'currentHp': currentHp,
      'maxHp': maxHp,
      'currentChakra': currentChakra,
      'maxChakra': maxChakra,
      'currentStamina': currentStamina,
      'maxStamina': maxStamina,
      'village': village,
      'stats': stats,
      'inventory': inventory,
      'jutsus': jutsus,
      'cooldowns': cooldowns,
    };
  }

  AdminUser copyWith({
    String? id,
    String? username,
    String? email,
    String? rank,
    int? level,
    int? currentHp,
    int? maxHp,
    int? currentChakra,
    int? maxChakra,
    int? currentStamina,
    int? maxStamina,
    String? village,
    Map<String, dynamic>? stats,
    List<String>? inventory,
    List<String>? jutsus,
    Map<String, dynamic>? cooldowns,
  }) {
    return AdminUser(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      rank: rank ?? this.rank,
      level: level ?? this.level,
      currentHp: currentHp ?? this.currentHp,
      maxHp: maxHp ?? this.maxHp,
      currentChakra: currentChakra ?? this.currentChakra,
      maxChakra: maxChakra ?? this.maxChakra,
      currentStamina: currentStamina ?? this.currentStamina,
      maxStamina: maxStamina ?? this.maxStamina,
      village: village ?? this.village,
      stats: stats ?? this.stats,
      inventory: inventory ?? this.inventory,
      jutsus: jutsus ?? this.jutsus,
      cooldowns: cooldowns ?? this.cooldowns,
    );
  }
}
