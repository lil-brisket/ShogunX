import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/regeneration_service.dart';
import '../models/models.dart';
import 'providers.dart';

// Regeneration service provider
final regenerationServiceProvider = Provider<RegenerationService>((ref) {
  final service = RegenerationService();
  
  // Set up callback to update game state when regeneration occurs
  service.onCharacterUpdated = (characterId, updatedCharacter) {
    ref.read(gameStateProvider.notifier).updateCharacter(updatedCharacter);
  };
  
  return service;
});

// Regeneration state provider for a specific character
final characterRegenerationProvider = StateNotifierProvider.family<CharacterRegenerationNotifier, CharacterRegenerationState, String>((ref, characterId) {
  final regenerationService = ref.watch(regenerationServiceProvider);
  return CharacterRegenerationNotifier(regenerationService, characterId);
});

// Regeneration state
class CharacterRegenerationState {
  final bool isActive;
  final Duration timeUntilNextRegeneration;
  final double regenerationProgress;
  final int hpRegenRate;
  final int cpRegenRate;
  final int spRegenRate;

  CharacterRegenerationState({
    required this.isActive,
    required this.timeUntilNextRegeneration,
    required this.regenerationProgress,
    required this.hpRegenRate,
    required this.cpRegenRate,
    required this.spRegenRate,
  });

  CharacterRegenerationState copyWith({
    bool? isActive,
    Duration? timeUntilNextRegeneration,
    double? regenerationProgress,
    int? hpRegenRate,
    int? cpRegenRate,
    int? spRegenRate,
  }) {
    return CharacterRegenerationState(
      isActive: isActive ?? this.isActive,
      timeUntilNextRegeneration: timeUntilNextRegeneration ?? this.timeUntilNextRegeneration,
      regenerationProgress: regenerationProgress ?? this.regenerationProgress,
      hpRegenRate: hpRegenRate ?? this.hpRegenRate,
      cpRegenRate: cpRegenRate ?? this.cpRegenRate,
      spRegenRate: spRegenRate ?? this.spRegenRate,
    );
  }
}

// Regeneration notifier
class CharacterRegenerationNotifier extends StateNotifier<CharacterRegenerationState> {
  final RegenerationService _regenerationService;
  final String _characterId;
  Timer? _updateTimer;

  CharacterRegenerationNotifier(this._regenerationService, this._characterId)
      : super(CharacterRegenerationState(
          isActive: false,
          timeUntilNextRegeneration: Duration.zero,
          regenerationProgress: 0.0,
          hpRegenRate: 0,
          cpRegenRate: 0,
          spRegenRate: 0,
        )) {
    // Start update timer to refresh regeneration state
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (_) => _updateRegenerationState());
  }

  void startRegeneration(Character character) {
    _regenerationService.startRegeneration(_characterId, character);
    _updateRegenerationState();
  }

  void stopRegeneration() {
    _regenerationService.stopRegeneration(_characterId);
    _updateRegenerationState();
  }

  void updateCharacter(Character character) {
    _regenerationService.updateCharacter(_characterId, character);
    _updateRegenerationState();
  }

  void _updateRegenerationState() {
    final isActive = _regenerationService.isCharacterActive(_characterId);
    final timeUntilNext = _regenerationService.getTimeUntilNextRegeneration(_characterId);
    final progress = _regenerationService.getRegenerationProgress(_characterId);
    
    // Get character from regeneration service to access regeneration rates
    final character = _regenerationService.getActiveCharacter(_characterId);
    final hpRegenRate = character?.hpRegenRate ?? 0;
    final cpRegenRate = character?.cpRegenRate ?? 0;
    final spRegenRate = character?.spRegenRate ?? 0;

    state = state.copyWith(
      isActive: isActive,
      timeUntilNextRegeneration: timeUntilNext,
      regenerationProgress: progress,
      hpRegenRate: hpRegenRate,
      cpRegenRate: cpRegenRate,
      spRegenRate: spRegenRate,
    );
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }
}
