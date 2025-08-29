enum ChatType { world, village, clan, private, system }
enum MessageType { text, image, system, announcement }

class ChatMessage {
  final String id;
  final String senderId;
  final String? senderName;
  final String? senderAvatar;
  final ChatType chatType;
  final MessageType messageType;
  final String content;
  final DateTime timestamp;
  final DateTime? editedAt;
  final bool isEdited;
  final bool isDeleted;
  
  // Chat-specific properties
  final String? targetId; // village, clan, or user ID
  final String? villageName; // for village chat
  final String? clanName; // for clan chat
  final String? recipientId; // for private messages
  
  // Message properties
  final List<String> mentions; // mentioned user IDs
  final List<String> attachments; // file URLs
  final Map<String, dynamic> metadata; // additional data
  
  // Moderation
  final bool isModerated;
  final String? moderationReason;
  final bool isPinned; // for announcements
  
  // Reactions
  final Map<String, List<String>> reactions; // emoji -> user IDs
  final int reactionCount;

  ChatMessage({
    required this.id,
    required this.senderId,
    this.senderName,
    this.senderAvatar,
    required this.chatType,
    required this.messageType,
    required this.content,
    required this.timestamp,
    this.editedAt,
    required this.isEdited,
    required this.isDeleted,
    this.targetId,
    this.villageName,
    this.clanName,
    this.recipientId,
    required this.mentions,
    required this.attachments,
    required this.metadata,
    required this.isModerated,
    this.moderationReason,
    required this.isPinned,
    required this.reactions,
    required this.reactionCount,
  });

  // Check if message is visible to user
  bool isVisibleTo(String userId, {String? userVillage, String? userClan}) {
    if (isDeleted) return false;
    if (isModerated) return false;
    
    switch (chatType) {
      case ChatType.world:
        return true; // World chat is visible to everyone
      case ChatType.village:
        return userVillage == villageName; // Only village members
      case ChatType.clan:
        return userClan == clanName; // Only clan members
      case ChatType.private:
        return senderId == userId || recipientId == userId; // Only participants
      case ChatType.system:
        return true; // System messages are visible to everyone
    }
  }

  // Check if user can edit this message
  bool canEdit(String userId) {
    if (isDeleted) return false;
    if (isModerated) return false;
    if (messageType != MessageType.text) return false;
    
    // Users can only edit their own messages
    return senderId == userId;
  }

  // Check if user can delete this message
  bool canDelete(String userId, {bool isModerator = false}) {
    if (isDeleted) return false;
    
    // Moderators can delete any message
    if (isModerator) return true;
    
    // Users can only delete their own messages
    return senderId == userId;
  }

  // Check if user can react to this message
  bool canReact(String userId) {
    if (isDeleted) return false;
    if (isModerated) return false;
    
    // Users can't react to their own messages
    return senderId != userId;
  }

  // Add reaction
  ChatMessage addReaction(String emoji, String userId) {
    if (reactions.containsKey(emoji)) {
      final userList = List<String>.from(reactions[emoji]!);
      if (!userList.contains(userId)) {
        userList.add(userId);
        final newReactions = Map<String, List<String>>.from(reactions);
        newReactions[emoji] = userList;
        return copyWith(
          reactions: newReactions,
          reactionCount: reactionCount + 1,
        );
      }
    } else {
      final newReactions = Map<String, List<String>>.from(reactions);
      newReactions[emoji] = [userId];
      return copyWith(
        reactions: newReactions,
        reactionCount: reactionCount + 1,
      );
    }
    return this;
  }

  // Remove reaction
  ChatMessage removeReaction(String emoji, String userId) {
    if (reactions.containsKey(emoji)) {
      final userList = List<String>.from(reactions[emoji]!);
      if (userList.contains(userId)) {
        userList.remove(userId);
        final newReactions = Map<String, List<String>>.from(reactions);
        if (userList.isEmpty) {
          newReactions.remove(emoji);
        } else {
          newReactions[emoji] = userList;
        }
        return copyWith(
          reactions: newReactions,
          reactionCount: reactionCount - 1,
        );
      }
    }
    return this;
  }

  // Check if user has reacted with emoji
  bool hasReaction(String userId, String emoji) {
    return reactions[emoji]?.contains(userId) ?? false;
  }

  // Get reaction count for specific emoji
  int getReactionCount(String emoji) {
    return reactions[emoji]?.length ?? 0;
  }

  // Get chat display name
  String get chatDisplayName {
    switch (chatType) {
      case ChatType.world:
        return 'World Chat';
      case ChatType.village:
        return '${villageName ?? 'Unknown'} Village';
      case ChatType.clan:
        return '${clanName ?? 'Unknown'} Clan';
      case ChatType.private:
        return 'Private Chat';
      case ChatType.system:
        return 'System';
    }
  }

  // Get message preview (truncated content)
  String get preview {
    if (content.length <= 100) return content;
    return '${content.substring(0, 97)}...';
  }

  // Check if message is recent (within last hour)
  bool get isRecent {
    final oneHourAgo = DateTime.now().subtract(const Duration(hours: 1));
    return timestamp.isAfter(oneHourAgo);
  }

  ChatMessage copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? senderAvatar,
    ChatType? chatType,
    MessageType? messageType,
    String? content,
    DateTime? timestamp,
    DateTime? editedAt,
    bool? isEdited,
    bool? isDeleted,
    String? targetId,
    String? villageName,
    String? clanName,
    String? recipientId,
    List<String>? mentions,
    List<String>? attachments,
    Map<String, dynamic>? metadata,
    bool? isModerated,
    String? moderationReason,
    bool? isPinned,
    Map<String, List<String>>? reactions,
    int? reactionCount,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      chatType: chatType ?? this.chatType,
      messageType: messageType ?? this.messageType,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      editedAt: editedAt ?? this.editedAt,
      isEdited: isEdited ?? this.isEdited,
      isDeleted: isDeleted ?? this.isDeleted,
      targetId: targetId ?? this.targetId,
      villageName: villageName ?? this.villageName,
      clanName: clanName ?? this.clanName,
      recipientId: recipientId ?? this.recipientId,
      mentions: mentions ?? this.mentions,
      attachments: attachments ?? this.attachments,
      metadata: metadata ?? this.metadata,
      isModerated: isModerated ?? this.isModerated,
      moderationReason: moderationReason ?? this.moderationReason,
      isPinned: isPinned ?? this.isPinned,
      reactions: reactions ?? this.reactions,
      reactionCount: reactionCount ?? this.reactionCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'chatType': chatType.name,
      'messageType': messageType.name,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'editedAt': editedAt?.toIso8601String(),
      'isEdited': isEdited,
      'isDeleted': isDeleted,
      'targetId': targetId,
      'villageName': villageName,
      'clanName': clanName,
      'recipientId': recipientId,
      'mentions': mentions,
      'attachments': attachments,
      'metadata': metadata,
      'isModerated': isModerated,
      'moderationReason': moderationReason,
      'isPinned': isPinned,
      'reactions': reactions,
      'reactionCount': reactionCount,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      senderId: json['senderId'],
      senderName: json['senderName'],
      senderAvatar: json['senderAvatar'],
      chatType: ChatType.values.firstWhere((t) => t.name == json['chatType']),
      messageType: MessageType.values.firstWhere((t) => t.name == json['messageType']),
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      editedAt: json['editedAt'] != null ? DateTime.parse(json['editedAt']) : null,
      isEdited: json['isEdited'],
      isDeleted: json['isDeleted'],
      targetId: json['targetId'],
      villageName: json['villageName'],
      clanName: json['clanName'],
      recipientId: json['recipientId'],
      mentions: List<String>.from(json['mentions']),
      attachments: List<String>.from(json['attachments']),
      metadata: Map<String, dynamic>.from(json['metadata']),
      isModerated: json['isModerated'],
      moderationReason: json['moderationReason'],
      isPinned: json['isPinned'],
      reactions: (json['reactions'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, List<String>.from(value))
      ),
      reactionCount: json['reactionCount'],
    );
  }
}
