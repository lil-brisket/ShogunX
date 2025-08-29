import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/game_service.dart';
import '../models/models.dart';

// Game Service Provider
final gameServiceProvider = Provider<GameService>((ref) => GameService());

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

// Tab Selection Providers
final selectedTabProvider = StateProvider<int>((ref) => 0);
final selectedVillageTabProvider = StateProvider<int>((ref) => 0);
final selectedLoadoutTabProvider = StateProvider<int>((ref) => 0);
