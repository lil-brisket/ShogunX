class MedicalRank {
  final String name;
  final int minExp;
  final int maxExp;
  final double cpPerHp;
  final double spPerHp;
  final double healingEfficiency;
  final String description;

  const MedicalRank({
    required this.name,
    required this.minExp,
    required this.maxExp,
    required this.cpPerHp,
    required this.spPerHp,
    required this.healingEfficiency,
    required this.description,
  });

  static const List<MedicalRank> ranks = [
    MedicalRank(
      name: 'Novice Medic',
      minExp: 0,
      maxExp: 25000,
      cpPerHp: 2.0,
      spPerHp: 1.5,
      healingEfficiency: 1.0,
      description: 'Basic healing abilities, high resource cost',
    ),
    MedicalRank(
      name: 'Apprentice Medic',
      minExp: 25001,
      maxExp: 50000,
      cpPerHp: 1.5,
      spPerHp: 1.2,
      healingEfficiency: 1.2,
      description: 'Improved efficiency, moderate resource cost',
    ),
    MedicalRank(
      name: 'Expert Medic',
      minExp: 50001,
      maxExp: 100000,
      cpPerHp: 1.0,
      spPerHp: 0.8,
      healingEfficiency: 1.5,
      description: 'Advanced healing, good resource efficiency',
    ),
    MedicalRank(
      name: 'Master Medic',
      minExp: 100001,
      maxExp: 999999,
      cpPerHp: 0.7,
      spPerHp: 0.5,
      healingEfficiency: 2.0,
      description: 'Master level healing, excellent efficiency',
    ),
  ];

  static MedicalRank getRankByExp(int exp) {
    for (final rank in ranks) {
      if (exp >= rank.minExp && exp <= rank.maxExp) {
        return rank;
      }
    }
    return ranks.first; // Default to Novice
  }

  static MedicalRank getNextRank(int currentExp) {
    for (final rank in ranks) {
      if (currentExp < rank.minExp) {
        return rank;
      }
    }
    return ranks.last; // Already at max rank
  }

  static int getExpToNextRank(int currentExp) {
    final nextRank = getNextRank(currentExp);
    return nextRank.minExp - currentExp;
  }

  static double getProgressToNextRank(int currentExp) {
    final currentRank = getRankByExp(currentExp);
    final expInCurrentRank = currentExp - currentRank.minExp;
    final expNeededForCurrentRank = currentRank.maxExp - currentRank.minExp;
    
    if (expNeededForCurrentRank == 0) return 1.0;
    return expInCurrentRank / expNeededForCurrentRank;
  }
}
