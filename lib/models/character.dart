class Character {
  final String id;
  final String userId;
  final String name;
  final String village;
  final String? clanId;
  final String? clanRank;
  final String ninjaRank;
  final List<String> elements;
  final String? bloodline;
  
  // Core Stats (max 250k)
  final int strength;
  final int intelligence;
  final int speed;
  final int defense;
  final int willpower;
  
  // Combat Stats (max 500k)
  final int bukijutsu;
  final int ninjutsu;
  final int taijutsu;
  final int genjutsu;
  
  // Jutsu Mastery
  final Map<String, int> jutsuMastery; // jutsuId -> level (1-10, 1-15 for bloodline)
  
  // Current Status
  final int currentHp;
  final int currentChakra;
  final int currentStamina;
  final int experience;
  final int level;
  
  // Regeneration Rates (per 30 seconds)
  final int hpRegenRate;
  final int cpRegenRate;
  final int spRegenRate;
  
  // Resources
  final int ryoOnHand;
  final int ryoBanked;
  
  // Reputation
  final int villageLoyalty;
  final int outlawInfamy;
  
  // Relationships
  final String? marriedTo;
  final String? senseiId;
  final List<String> studentIds;
  
  // Records
  final int pvpWins;
  final int pvpLosses;
  final int pveWins;
  final int pveLosses;
  
  // Medical System
  final int medicalExp;
  
  // Settings
  final String? avatarUrl;
  final String gender;
  
  Character({
    required this.id,
    required this.userId,
    required this.name,
    required this.village,
    this.clanId,
    this.clanRank,
    required this.ninjaRank,
    required this.elements,
    this.bloodline,
    required this.strength,
    required this.intelligence,
    required this.speed,
    required this.defense,
    required this.willpower,
    required this.bukijutsu,
    required this.ninjutsu,
    required this.taijutsu,
    required this.genjutsu,
    required this.jutsuMastery,
    required this.currentHp,
    required this.currentChakra,
    required this.currentStamina,
    required this.experience,
    required this.level,
    required this.hpRegenRate,
    required this.cpRegenRate,
    required this.spRegenRate,
    required this.ryoOnHand,
    required this.ryoBanked,
    required this.villageLoyalty,
    required this.outlawInfamy,
    this.marriedTo,
    this.senseiId,
    required this.studentIds,
    required this.pvpWins,
    required this.pvpLosses,
    required this.pveWins,
    required this.pveLosses,
    required this.medicalExp,
    this.avatarUrl,
    required this.gender,
  });

  // Getters for calculated stats
  int get maxHp => (strength * 2 + defense) * 10;
  int get maxChakra => (intelligence * 2 + willpower) * 10;
  int get maxStamina => (speed * 2 + willpower) * 10;
  
  double get hpPercentage => currentHp / maxHp;
  double get chakraPercentage => currentChakra / maxChakra;
  double get staminaPercentage => currentStamina / maxStamina;
  
  // PvP/PvE record calculations
  double get pvpWinRate => pvpWins + pvpLosses > 0 ? pvpWins / (pvpWins + pvpLosses) : 0.0;
  double get pveWinRate => pveWins + pveLosses > 0 ? pveWins / (pveWins + pveLosses) : 0.0;
  
  // Rank progression
  bool get canAdvanceRank {
    switch (ninjaRank) {
      case 'Academy Student':
        return level >= 5;
      case 'Genin':
        return level >= 15;
      case 'Chunin':
        return level >= 30;
      case 'Jounin':
        return level >= 50;
      case 'Elite Jounin':
        return level >= 75;
      case 'Kage':
        return false; // Kage is the highest rank
      default:
        return false;
    }
  }

  // Check if character is currently training any stat
  bool get isTraining => false; // This will be updated by the training provider

  Character copyWith({
    String? id,
    String? userId,
    String? name,
    String? village,
    String? clanId,
    String? clanRank,
    String? ninjaRank,
    List<String>? elements,
    String? bloodline,
    int? strength,
    int? intelligence,
    int? speed,
    int? defense,
    int? willpower,
    int? bukijutsu,
    int? ninjutsu,
    int? taijutsu,
    int? genjutsu,
    Map<String, int>? jutsuMastery,
    int? currentHp,
    int? currentChakra,
    int? currentStamina,
    int? experience,
    int? level,
    int? hpRegenRate,
    int? cpRegenRate,
    int? spRegenRate,
    int? ryoOnHand,
    int? ryoBanked,
    int? villageLoyalty,
    int? outlawInfamy,
    String? marriedTo,
    String? senseiId,
    List<String>? studentIds,
    int? pvpWins,
    int? pvpLosses,
    int? pveWins,
    int? pveLosses,
    int? medicalExp,
    String? avatarUrl,
    String? gender,
  }) {
    return Character(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      village: village ?? this.village,
      clanId: clanId ?? this.clanId,
      clanRank: clanRank ?? this.clanRank,
      ninjaRank: ninjaRank ?? this.ninjaRank,
      elements: elements ?? this.elements,
      bloodline: bloodline ?? this.bloodline,
      strength: strength ?? this.strength,
      intelligence: intelligence ?? this.intelligence,
      speed: speed ?? this.speed,
      defense: defense ?? this.defense,
      willpower: willpower ?? this.willpower,
      bukijutsu: bukijutsu ?? this.bukijutsu,
      ninjutsu: ninjutsu ?? this.ninjutsu,
      taijutsu: taijutsu ?? this.taijutsu,
      genjutsu: genjutsu ?? this.genjutsu,
      jutsuMastery: jutsuMastery ?? this.jutsuMastery,
      currentHp: currentHp ?? this.currentHp,
      currentChakra: currentChakra ?? this.currentChakra,
      currentStamina: currentStamina ?? this.currentStamina,
      experience: experience ?? this.experience,
      level: level ?? this.level,
      hpRegenRate: hpRegenRate ?? this.hpRegenRate,
      cpRegenRate: cpRegenRate ?? this.cpRegenRate,
      spRegenRate: spRegenRate ?? this.spRegenRate,
      ryoOnHand: ryoOnHand ?? this.ryoOnHand,
      ryoBanked: ryoBanked ?? this.ryoBanked,
      villageLoyalty: villageLoyalty ?? this.villageLoyalty,
      outlawInfamy: outlawInfamy ?? this.outlawInfamy,
      marriedTo: marriedTo ?? this.marriedTo,
      senseiId: senseiId ?? this.senseiId,
      studentIds: studentIds ?? this.studentIds,
      pvpWins: pvpWins ?? this.pvpWins,
      pvpLosses: pvpLosses ?? this.pvpLosses,
      pveWins: pveWins ?? this.pveWins,
      pveLosses: pveLosses ?? this.pveLosses,
      medicalExp: medicalExp ?? this.medicalExp,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      gender: gender ?? this.gender,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'village': village,
      'clanId': clanId,
      'clanRank': clanRank,
      'ninjaRank': ninjaRank,
      'elements': elements,
      'bloodline': bloodline,
      'strength': strength,
      'intelligence': intelligence,
      'speed': speed,
      'defense': defense,
      'willpower': willpower,
      'bukijutsu': bukijutsu,
      'ninjutsu': ninjutsu,
      'taijutsu': taijutsu,
      'genjutsu': genjutsu,
      'jutsuMastery': jutsuMastery,
      'currentHp': currentHp,
      'currentChakra': currentChakra,
      'currentStamina': currentStamina,
      'experience': experience,
      'level': level,
      'hpRegenRate': hpRegenRate,
      'cpRegenRate': cpRegenRate,
      'spRegenRate': spRegenRate,
      'ryoOnHand': ryoOnHand,
      'ryoBanked': ryoBanked,
      'villageLoyalty': villageLoyalty,
      'outlawInfamy': outlawInfamy,
      'marriedTo': marriedTo,
      'senseiId': senseiId,
      'studentIds': studentIds,
      'pvpWins': pvpWins,
      'pvpLosses': pvpLosses,
      'pveWins': pveWins,
      'pveLosses': pveLosses,
      'medicalExp': medicalExp,
      'avatarUrl': avatarUrl,
      'gender': gender,
    };
  }

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      village: json['village'],
      clanId: json['clanId'],
      clanRank: json['clanRank'],
      ninjaRank: json['ninjaRank'],
      elements: List<String>.from(json['elements']),
      bloodline: json['bloodline'],
      strength: json['strength'],
      intelligence: json['intelligence'],
      speed: json['speed'],
      defense: json['defense'],
      willpower: json['willpower'],
      bukijutsu: json['bukijutsu'],
      ninjutsu: json['ninjutsu'],
      taijutsu: json['taijutsu'],
      genjutsu: json['genjutsu'],
      jutsuMastery: Map<String, int>.from(json['jutsuMastery']),
      currentHp: json['currentHp'],
      currentChakra: json['currentChakra'],
      currentStamina: json['currentStamina'],
      experience: json['experience'],
      level: json['level'],
      hpRegenRate: json['hpRegenRate'] ?? 0,
      cpRegenRate: json['cpRegenRate'] ?? 0,
      spRegenRate: json['spRegenRate'] ?? 0,
      ryoOnHand: json['ryoOnHand'],
      ryoBanked: json['ryoBanked'],
      villageLoyalty: json['villageLoyalty'],
      outlawInfamy: json['outlawInfamy'],
      marriedTo: json['marriedTo'],
      senseiId: json['senseiId'],
      studentIds: List<String>.from(json['studentIds']),
      pvpWins: json['pvpWins'],
      pvpLosses: json['pvpLosses'],
      pveWins: json['pveWins'],
      pveLosses: json['pveLosses'],
      medicalExp: json['medicalExp'] ?? 0,
      avatarUrl: json['avatarUrl'],
      gender: json['gender'],
    );
  }
}
