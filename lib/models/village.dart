class Village {
  final String id;
  final String name;
  final String description;
  final String kageId; // Current Kage
  final List<String> councilMemberIds; // Council members
  final Map<String, dynamic> settings; // Village-specific settings
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastUpdated;

  Village({
    required this.id,
    required this.name,
    required this.description,
    required this.kageId,
    required this.councilMemberIds,
    required this.settings,
    required this.isActive,
    required this.createdAt,
    this.lastUpdated,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'kageId': kageId,
      'councilMemberIds': councilMemberIds,
      'settings': settings,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  factory Village.fromJson(Map<String, dynamic> json) {
    return Village(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      kageId: json['kageId'],
      councilMemberIds: List<String>.from(json['councilMemberIds']),
      settings: Map<String, dynamic>.from(json['settings']),
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      lastUpdated: json['lastUpdated'] != null 
          ? DateTime.parse(json['lastUpdated']) 
          : null,
    );
  }

  Village copyWith({
    String? id,
    String? name,
    String? description,
    String? kageId,
    List<String>? councilMemberIds,
    Map<String, dynamic>? settings,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastUpdated,
  }) {
    return Village(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      kageId: kageId ?? this.kageId,
      councilMemberIds: councilMemberIds ?? this.councilMemberIds,
      settings: settings ?? this.settings,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
