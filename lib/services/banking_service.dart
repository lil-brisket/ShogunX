import '../models/models.dart';
import 'game_service.dart';

enum TransactionType {
  deposit,
  withdraw,
  transfer,
  fee,
  mission_reward,
  purchase
}

class BankTransaction {
  final String id;
  final String characterId;
  final TransactionType type;
  final int amount;
  final String description;
  final DateTime timestamp;
  final String? recipientId; // For transfers
  final Map<String, dynamic> metadata;

  const BankTransaction({
    required this.id,
    required this.characterId,
    required this.type,
    required this.amount,
    required this.description,
    required this.timestamp,
    this.recipientId,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'characterId': characterId,
      'type': type.name,
      'amount': amount,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'recipientId': recipientId,
      'metadata': metadata,
    };
  }

  factory BankTransaction.fromJson(Map<String, dynamic> json) {
    return BankTransaction(
      id: json['id'],
      characterId: json['characterId'],
      type: TransactionType.values.firstWhere((e) => e.name == json['type']),
      amount: json['amount'],
      description: json['description'],
      timestamp: DateTime.parse(json['timestamp']),
      recipientId: json['recipientId'],
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }
}

class BankingResult {
  final bool success;
  final String message;
  final Character? updatedCharacter;
  final BankTransaction? transaction;

  const BankingResult({
    required this.success,
    required this.message,
    this.updatedCharacter,
    this.transaction,
  });
}

class BankingService {
  static final BankingService _instance = BankingService._internal();
  factory BankingService() => _instance;
  BankingService._internal();

  final GameService _gameService = GameService();
  final List<BankTransaction> _transactions = [];

  static const int TRANSFER_FEE = 0; // No transfer fee
  static const int MIN_TRANSFER_AMOUNT = 100; // Minimum transfer amount

  // Deposit ryo from hand to bank
  Future<BankingResult> depositRyo(String characterId, int amount) async {
    if (amount <= 0) {
      return const BankingResult(
        success: false,
        message: 'Deposit amount must be greater than 0',
      );
    }

    final character = await _gameService.getCharacter(characterId);
    if (character == null) {
      return const BankingResult(
        success: false,
        message: 'Character not found',
      );
    }

    if (character.ryoOnHand < amount) {
      return const BankingResult(
        success: false,
        message: 'Insufficient ryo on hand',
      );
    }

    // Update character ryo
    final updatedCharacter = character.copyWith(
      ryoOnHand: character.ryoOnHand - amount,
      ryoBanked: character.ryoBanked + amount,
    );

    await _gameService.saveCharacter(updatedCharacter);

    // Create transaction record
    final transaction = BankTransaction(
      id: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      characterId: characterId,
      type: TransactionType.deposit,
      amount: amount,
      description: 'Deposited $amount ryo to bank',
      timestamp: DateTime.now(),
    );

    _transactions.add(transaction);

    return BankingResult(
      success: true,
      message: 'Successfully deposited $amount ryo',
      updatedCharacter: updatedCharacter,
      transaction: transaction,
    );
  }

  // Withdraw ryo from bank to hand
  Future<BankingResult> withdrawRyo(String characterId, int amount) async {
    if (amount <= 0) {
      return const BankingResult(
        success: false,
        message: 'Withdrawal amount must be greater than 0',
      );
    }

    final character = await _gameService.getCharacter(characterId);
    if (character == null) {
      return const BankingResult(
        success: false,
        message: 'Character not found',
      );
    }

    if (character.ryoBanked < amount) {
      return const BankingResult(
        success: false,
        message: 'Insufficient ryo in bank',
      );
    }

    // Update character ryo
    final updatedCharacter = character.copyWith(
      ryoOnHand: character.ryoOnHand + amount,
      ryoBanked: character.ryoBanked - amount,
    );

    await _gameService.saveCharacter(updatedCharacter);

    // Create transaction record
    final transaction = BankTransaction(
      id: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      characterId: characterId,
      type: TransactionType.withdraw,
      amount: amount,
      description: 'Withdrew $amount ryo from bank',
      timestamp: DateTime.now(),
    );

    _transactions.add(transaction);

    return BankingResult(
      success: true,
      message: 'Successfully withdrew $amount ryo',
      updatedCharacter: updatedCharacter,
      transaction: transaction,
    );
  }

  // Transfer ryo between players
  Future<BankingResult> transferRyo(
    String senderCharacterId,
    String recipientCharacterId,
    int amount, {
    String? message,
  }) async {
    if (amount < MIN_TRANSFER_AMOUNT) {
      return BankingResult(
        success: false,
        message: 'Minimum transfer amount is $MIN_TRANSFER_AMOUNT ryo',
      );
    }

    final sender = await _gameService.getCharacter(senderCharacterId);
    final recipient = await _gameService.getCharacter(recipientCharacterId);

    if (sender == null) {
      return const BankingResult(
        success: false,
        message: 'Sender character not found',
      );
    }

    if (recipient == null) {
      return const BankingResult(
        success: false,
        message: 'Recipient character not found',
      );
    }

    if (sender.id == recipient.id) {
      return const BankingResult(
        success: false,
        message: 'Cannot transfer to yourself',
      );
    }

    if (sender.ryoOnHand < amount) {
      return BankingResult(
        success: false,
        message: 'Insufficient ryo (need $amount ryo)',
      );
    }

    // Update sender
    final updatedSender = sender.copyWith(
      ryoOnHand: sender.ryoOnHand - amount,
    );

    // Update recipient
    final updatedRecipient = recipient.copyWith(
      ryoOnHand: recipient.ryoOnHand + amount,
    );

    await _gameService.saveCharacter(updatedSender);
    await _gameService.saveCharacter(updatedRecipient);

    // Create transfer transaction for sender
    final senderTransaction = BankTransaction(
      id: 'txn_${DateTime.now().millisecondsSinceEpoch}_sender',
      characterId: senderCharacterId,
      type: TransactionType.transfer,
      amount: -amount,
      description: 'Transferred $amount ryo to ${recipient.name}',
      timestamp: DateTime.now(),
      recipientId: recipientCharacterId,
      metadata: {
        'message': message,
        'recipient_name': recipient.name,
      },
    );

    // Create transfer transaction for recipient
    final recipientTransaction = BankTransaction(
      id: 'txn_${DateTime.now().millisecondsSinceEpoch}_recipient',
      characterId: recipientCharacterId,
      type: TransactionType.transfer,
      amount: amount,
      description: 'Received $amount ryo from ${sender.name}',
      timestamp: DateTime.now(),
      recipientId: senderCharacterId,
      metadata: {
        'message': message,
        'sender_name': sender.name,
      },
    );

    _transactions.addAll([senderTransaction, recipientTransaction]);

    return BankingResult(
      success: true,
      message: 'Successfully transferred $amount ryo to ${recipient.name}',
      updatedCharacter: updatedSender,
      transaction: senderTransaction,
    );
  }

  // Get transaction history for a character
  Future<List<BankTransaction>> getTransactionHistory(
    String characterId, {
    int limit = 50,
    TransactionType? type,
  }) async {
    var transactions = _transactions
        .where((t) => t.characterId == characterId)
        .toList();

    if (type != null) {
      transactions = transactions.where((t) => t.type == type).toList();
    }

    transactions.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return transactions.take(limit).toList();
  }

  // Get character balance info
  Future<Map<String, dynamic>> getBalanceInfo(String characterId) async {
    final character = await _gameService.getCharacter(characterId);
    if (character == null) {
      return {};
    }

    final recentTransactions = await getTransactionHistory(characterId, limit: 10);
    final totalTransacted = recentTransactions
        .map((t) => t.amount.abs())
        .fold<int>(0, (sum, amount) => sum + amount);

    return {
      'ryoOnHand': character.ryoOnHand,
      'ryoBanked': character.ryoBanked,
      'totalRyo': character.ryoOnHand + character.ryoBanked,
      'recentTransactions': recentTransactions,
      'totalTransacted': totalTransacted,
    };
  }

  // Search for players to transfer to
  Future<List<Character>> searchPlayersForTransfer(
    String query, {
    String? excludeCharacterId,
    int limit = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    // In a real app, this would search a database
    // For now, return some dummy characters
    final dummyCharacters = [
      Character(
        id: 'char_search_1',
        userId: 'user_search_1',
        name: 'NinjaKing',
        village: 'Konoha',
        ninjaRank: 'Jounin',
        elements: ['Fire'],
        strength: 10000,
        intelligence: 8000,
        speed: 12000,
        defense: 9000,
        willpower: 7000,
        bukijutsu: 15000,
        ninjutsu: 20000,
        taijutsu: 18000,
        bloodlineEfficiency: 2000,
        jutsuMastery: {},
        currentHp: 200000,
        currentChakra: 150000,
        currentStamina: 180000,
        experience: 25000,
        level: 20,
        ryoOnHand: 5000,
        ryoBanked: 15000,
        villageLoyalty: 500,
        outlawInfamy: 0,
        studentIds: [],
        pvpWins: 15,
        pvpLosses: 3,
        pveWins: 45,
        pveLosses: 5,
        gender: 'male',
      ),
      Character(
        id: 'char_search_2',
        userId: 'user_search_2',
        name: 'SakuraWarrior',
        village: 'Suna',
        ninjaRank: 'Chunin',
        elements: ['Wind', 'Earth'],
        strength: 8000,
        intelligence: 12000,
        speed: 10000,
        defense: 11000,
        willpower: 9000,
        bukijutsu: 12000,
        ninjutsu: 18000,
        taijutsu: 14000,
        bloodlineEfficiency: 1000,
        jutsuMastery: {},
        currentHp: 180000,
        currentChakra: 210000,
        currentStamina: 190000,
        experience: 18000,
        level: 15,
        ryoOnHand: 3000,
        ryoBanked: 8000,
        villageLoyalty: 300,
        outlawInfamy: 0,
        studentIds: [],
        pvpWins: 8,
        pvpLosses: 4,
        pveWins: 25,
        pveLosses: 3,
        gender: 'female',
      ),
    ];

    return dummyCharacters
        .where((c) => c.id != excludeCharacterId)
        .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
        .take(limit)
        .toList();
  }

  // Utility methods for formatting
  String formatRyo(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]},',
    );
  }

  String getTransactionIcon(TransactionType type) {
    switch (type) {
      case TransactionType.deposit:
        return '📥';
      case TransactionType.withdraw:
        return '📤';
      case TransactionType.transfer:
        return '💸';
      case TransactionType.fee:
        return '💳';
      case TransactionType.mission_reward:
        return '🎁';
      case TransactionType.purchase:
        return '🛒';
    }
  }
}