import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/game_service.dart';
import '../services/banking_service.dart';
import '../services/shop_service.dart';
import '../providers/shop_provider.dart';
import '../models/models.dart';

// Game Service Provider
final gameServiceProvider = Provider<GameService>((ref) => GameService());

// Banking Service Provider
final bankingServiceProvider = Provider<BankingService>((ref) => BankingService());

// Shop Service Provider
final shopServiceProvider = Provider<ShopService>((ref) => ShopService());

// Shop Provider
final shopProviderProvider = ChangeNotifierProvider<ShopProvider>((ref) => ShopProvider());

// Character Providers
final characterProvider = FutureProvider.family<Character?, String>((ref, characterId) async {
  final gameService = ref.watch(gameServiceProvider);
  return await gameService.getCharacter(characterId);
});

final userCharactersProvider = FutureProvider.family<List<Character>, String>((ref, userId) async {
  final gameService = ref.watch(gameServiceProvider);
  return await gameService.getUserCharacters(userId);
});

// Mission Providers
final missionsByVillageProvider = FutureProvider.family<List<Mission>, String>((ref, village) async {
  final gameService = ref.watch(gameServiceProvider);
  return await gameService.getMissionsByVillage(village);
});

// Clan Providers
final clansByVillageProvider = FutureProvider.family<List<Clan>, String>((ref, village) async {
  final gameService = ref.watch(gameServiceProvider);
  return await gameService.getClansByVillage(village);
});

// Chat Providers
final chatMessagesProvider = FutureProvider<List<ChatMessage>>((ref) async {
  final gameService = ref.watch(gameServiceProvider);
  return await gameService.getChatMessages();
});

// World Provider
final worldProvider = FutureProvider<World>((ref) async {
  final gameService = ref.watch(gameServiceProvider);
  return await gameService.getWorld();
});

// Game Updates Providers
final gameUpdatesProvider = FutureProvider<List<GameUpdate>>((ref) async {
  final gameService = ref.watch(gameServiceProvider);
  return await gameService.getGameUpdates();
});

final gameUpdatesNotifierProvider = StateNotifierProvider<GameUpdatesNotifier, AsyncValue<List<GameUpdate>>>((ref) {
  final gameService = ref.watch(gameServiceProvider);
  return GameUpdatesNotifier(gameService);
});

// Tab Selection Providers
final selectedTabProvider = StateProvider<int>((ref) => 0);
final selectedVillageTabProvider = StateProvider<int>((ref) => 0);
final selectedLoadoutTabProvider = StateProvider<int>((ref) => 0);

// Game Updates State Notifier
class GameUpdatesNotifier extends StateNotifier<AsyncValue<List<GameUpdate>>> {
  final GameService _gameService;

  GameUpdatesNotifier(this._gameService) : super(const AsyncValue.loading()) {
    _loadUpdates();
  }

  Future<void> _loadUpdates() async {
    try {
      state = const AsyncValue.loading();
      final updates = await _gameService.getGameUpdates();
      state = AsyncValue.data(updates);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addUpdate(GameUpdate update) async {
    try {
      await _gameService.addGameUpdate(update);
      await _loadUpdates(); // Refresh the list
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addProjectUpdate({
    required String title,
    required String description,
    UpdateType type = UpdateType.feature,
    UpdatePriority priority = UpdatePriority.normal,
    String? version,
    List<String> tags = const [],
  }) async {
    try {
      await _gameService.addProjectUpdate(
        title: title,
        description: description,
        type: type,
        priority: priority,
        version: version,
        tags: tags,
      );
      await _loadUpdates(); // Refresh the list
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> removeUpdate(String updateId) async {
    try {
      await _gameService.removeGameUpdate(updateId);
      await _loadUpdates(); // Refresh the list
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    await _loadUpdates();
  }
}

// Banking Providers
final bankingNotifierProvider = StateNotifierProvider.family<BankingNotifier, AsyncValue<Map<String, dynamic>>, String>((ref, characterId) {
  final bankingService = ref.watch(bankingServiceProvider);
  return BankingNotifier(bankingService, characterId, ref);
});

final transactionHistoryProvider = FutureProvider.family<List<BankTransaction>, String>((ref, characterId) async {
  final bankingService = ref.watch(bankingServiceProvider);
  return await bankingService.getTransactionHistory(characterId);
});

final playerSearchProvider = FutureProvider.family<List<Character>, String>((ref, query) async {
  final bankingService = ref.watch(bankingServiceProvider);
  return await bankingService.searchPlayersForTransfer(query);
});

// Banking State Notifier
class BankingNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final BankingService _bankingService;
  final String _characterId;
  final Ref _ref;

  BankingNotifier(this._bankingService, this._characterId, this._ref) : super(const AsyncValue.loading()) {
    _loadBalance();
  }

  Future<void> _loadBalance() async {
    try {
      state = const AsyncValue.loading();
      final balance = await _bankingService.getBalanceInfo(_characterId);
      state = AsyncValue.data(balance);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<BankingResult> deposit(int amount) async {
    final result = await _bankingService.depositRyo(_characterId, amount);
    if (result.success) {
      await _loadBalance();
      // Invalidate character provider to refresh character data
      _ref.invalidate(characterProvider(_characterId));
    }
    return result;
  }

  Future<BankingResult> withdraw(int amount) async {
    final result = await _bankingService.withdrawRyo(_characterId, amount);
    if (result.success) {
      await _loadBalance();
      // Invalidate character provider to refresh character data
      _ref.invalidate(characterProvider(_characterId));
    }
    return result;
  }

  Future<BankingResult> transferTo(String recipientCharacterId, int amount, {String? message}) async {
    final result = await _bankingService.transferRyo(
      _characterId,
      recipientCharacterId,
      amount,
      message: message,
    );
    if (result.success) {
      await _loadBalance();
      // Invalidate character providers for both sender and recipient
      _ref.invalidate(characterProvider(_characterId));
      _ref.invalidate(characterProvider(recipientCharacterId));
      // Also invalidate transaction history
      _ref.invalidate(transactionHistoryProvider(_characterId));
      _ref.invalidate(transactionHistoryProvider(recipientCharacterId));
    }
    return result;
  }

  Future<void> refresh() async {
    await _loadBalance();
  }
}
