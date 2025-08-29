enum ClanRank { member, advisor, shogun }

class Clan {
  final String id;
  final String name;
  final String description;
  final String village;
  final String leaderId; // Shogun
  final List<String> advisorIds; // Advisors
  final List<String> memberIds;
  final DateTime createdAt;
  final bool isActive;
  
  // Clan bonuses
  final Map<String, double> statBonuses; // stat -> percentage bonus
  final List<String> specialAbilities;
  final int maxMembers;
  
  // Clan settings
  final bool isPublic; // Can players apply publicly
  final bool isDarkOps; // Dark Ops exclusive clan
  final String? requirements; // Application requirements
  final int applicationFee;

  Clan({
    required this.id,
    required this.name,
    required this.description,
    required this.village,
    required this.leaderId,
    required this.advisorIds,
    required this.memberIds,
    required this.createdAt,
    required this.isActive,
    required this.statBonuses,
    required this.specialAbilities,
    required this.maxMembers,
    required this.isPublic,
    required this.isDarkOps,
    this.requirements,
    required this.applicationFee,
  });

  // Get clan rank for a specific member
  ClanRank getMemberRank(String memberId) {
    if (memberId == leaderId) return ClanRank.shogun;
    if (advisorIds.contains(memberId)) return ClanRank.advisor;
    if (memberIds.contains(memberId)) return ClanRank.member;
    throw ArgumentError('Member not found in clan');
  }

  // Check if clan can accept new members
  bool get canAcceptMembers => memberIds.length < maxMembers && isActive;

  // Get total member count
  int get totalMembers => 1 + advisorIds.length + memberIds.length; // +1 for leader

  // Check if member can be promoted to advisor
  bool canPromoteToAdvisor(String memberId) {
    if (!memberIds.contains(memberId)) return false;
    if (advisorIds.length >= 2) return false; // Max 2 advisors
    return true;
  }

  // Check if member can be promoted to leader
  bool canPromoteToLeader(String memberId) {
    if (!advisorIds.contains(memberId)) return false;
    return true;
  }

  // Get all member IDs including leader and advisors
  List<String> get allMemberIds => [leaderId, ...advisorIds, ...memberIds];

  // Check if clan is full
  bool get isFull => totalMembers >= maxMembers;

  Clan copyWith({
    String? id,
    String? name,
    String? description,
    String? village,
    String? leaderId,
    List<String>? advisorIds,
    List<String>? memberIds,
    DateTime? createdAt,
    bool? isActive,
    Map<String, double>? statBonuses,
    List<String>? specialAbilities,
    int? maxMembers,
    bool? isPublic,
    bool? isDarkOps,
    String? requirements,
    int? applicationFee,
  }) {
    return Clan(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      village: village ?? this.village,
      leaderId: leaderId ?? this.leaderId,
      advisorIds: advisorIds ?? this.advisorIds,
      memberIds: memberIds ?? this.memberIds,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      statBonuses: statBonuses ?? this.statBonuses,
      specialAbilities: specialAbilities ?? this.specialAbilities,
      maxMembers: maxMembers ?? this.maxMembers,
      isPublic: isPublic ?? this.isPublic,
      isDarkOps: isDarkOps ?? this.isDarkOps,
      requirements: requirements ?? this.requirements,
      applicationFee: applicationFee ?? this.applicationFee,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'village': village,
      'leaderId': leaderId,
      'advisorIds': advisorIds,
      'memberIds': memberIds,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
      'statBonuses': statBonuses,
      'specialAbilities': specialAbilities,
      'maxMembers': maxMembers,
      'isPublic': isPublic,
      'isDarkOps': isDarkOps,
      'requirements': requirements,
      'applicationFee': applicationFee,
    };
  }

  factory Clan.fromJson(Map<String, dynamic> json) {
    return Clan(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      village: json['village'],
      leaderId: json['leaderId'],
      advisorIds: List<String>.from(json['advisorIds']),
      memberIds: List<String>.from(json['memberIds']),
      createdAt: DateTime.parse(json['createdAt']),
      isActive: json['isActive'],
      statBonuses: Map<String, double>.from(json['statBonuses']),
      specialAbilities: List<String>.from(json['specialAbilities']),
      maxMembers: json['maxMembers'],
      isPublic: json['isPublic'],
      isDarkOps: json['isDarkOps'],
      requirements: json['requirements'],
      applicationFee: json['applicationFee'],
    );
  }
}
