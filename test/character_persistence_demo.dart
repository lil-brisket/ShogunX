import 'package:ninja_world_mmo/services/character_persistence_service.dart';
import 'package:ninja_world_mmo/models/models.dart';

void main() async {
  print('🧪 Testing Character Persistence System');
  print('=====================================');
  
  final persistenceService = CharacterPersistenceService();
  
  // Test 1: Create and save a character
  print('\n📝 Test 1: Creating and saving character...');
  
  final testCharacter = Character(
    id: 'demo_char_1',
    userId: 'demo_user_1',
    name: 'DemoNinja',
    village: 'Konoha',
    clanId: null,
    clanRank: null,
    ninjaRank: 'Academy Student',
    elements: ['Fire'],
    bloodline: null,
          strength: 1,
      intelligence: 1,
      speed: 1,
      defense: 1,
      willpower: 1,
      bukijutsu: 1,
      ninjutsu: 1,
      taijutsu: 1,
      genjutsu: 1,
    jutsuMastery: {},
    currentHp: 40000,
    currentChakra: 30000,
    currentStamina: 30000,
    experience: 0,
    level: 1,
    hpRegenRate: 100,
    cpRegenRate: 100,
    spRegenRate: 100,
    ryoOnHand: 1000,
    ryoBanked: 0,
    villageLoyalty: 100,
    outlawInfamy: 0,
    marriedTo: null,
    senseiId: null,
    studentIds: [],
    pvpWins: 0,
    pvpLosses: 0,
    pveWins: 0,
    pveLosses: 0,
    medicalExp: 0,
    avatarUrl: null,
    gender: 'Unknown',
    inventory: [],
    equippedItems: {},
  );
  
  try {
    await persistenceService.saveCharacter(testCharacter);
    print('✅ Character saved successfully');
  } catch (e) {
    print('❌ Error saving character: $e');
  }
  
  // Test 2: Load character by ID
  print('\n📖 Test 2: Loading character by ID...');
  
  try {
    final loadedCharacter = await persistenceService.loadCharacter('demo_char_1');
    if (loadedCharacter != null) {
      print('✅ Character loaded successfully: ${loadedCharacter.name}');
      print('   - Village: ${loadedCharacter.village}');
      print('   - Level: ${loadedCharacter.level}');
      print('   - HP: ${loadedCharacter.currentHp}');
    } else {
      print('❌ Character not found');
    }
  } catch (e) {
    print('❌ Error loading character: $e');
  }
  
  // Test 3: Load character by user ID
  print('\n👤 Test 3: Loading character by user ID...');
  
  try {
    final loadedCharacter = await persistenceService.loadCharacterByUserId('demo_user_1');
    if (loadedCharacter != null) {
      print('✅ Character loaded by user ID: ${loadedCharacter.name}');
    } else {
      print('❌ Character not found by user ID');
    }
  } catch (e) {
    print('❌ Error loading character by user ID: $e');
  }
  
  // Test 4: Check if character exists
  print('\n🔍 Test 4: Checking if character exists...');
  
  try {
    final exists = await persistenceService.characterExists('demo_user_1');
    print('Character exists: $exists');
  } catch (e) {
    print('❌ Error checking character existence: $e');
  }
  
  // Test 5: Update character
  print('\n🔄 Test 5: Updating character...');
  
  try {
    final updatedCharacter = testCharacter.copyWith(
      currentHp: 35000,
      experience: 500,
      level: 2,
    );
    
    await persistenceService.updateCharacter(updatedCharacter);
    print('✅ Character updated successfully');
    
    // Verify the update
    final reloadedCharacter = await persistenceService.loadCharacter('demo_char_1');
    if (reloadedCharacter != null) {
      print('   - New HP: ${reloadedCharacter.currentHp}');
      print('   - New Level: ${reloadedCharacter.level}');
      print('   - New Experience: ${reloadedCharacter.experience}');
    }
  } catch (e) {
    print('❌ Error updating character: $e');
  }
  
  // Test 6: Get all character IDs
  print('\n📋 Test 6: Getting all character IDs...');
  
  try {
    final characterIds = await persistenceService.getAllCharacterIds();
    print('Found ${characterIds.length} characters: $characterIds');
  } catch (e) {
    print('❌ Error getting character IDs: $e');
  }
  
  // Test 7: Get data size
  print('\n📊 Test 7: Getting data size...');
  
  try {
    final dataSize = await persistenceService.getCharacterDataSize();
    print('Character data size: $dataSize bytes');
  } catch (e) {
    print('❌ Error getting data size: $e');
  }
  
  // Test 8: Delete character
  print('\n🗑️ Test 8: Deleting character...');
  
  try {
    await persistenceService.deleteCharacter('demo_char_1', 'demo_user_1');
    print('✅ Character deleted successfully');
    
    // Verify deletion
    final deletedCharacter = await persistenceService.loadCharacter('demo_char_1');
    if (deletedCharacter == null) {
      print('✅ Character confirmed deleted');
    } else {
      print('❌ Character still exists after deletion');
    }
  } catch (e) {
    print('❌ Error deleting character: $e');
  }
  
  print('\n🎉 Character Persistence Demo Complete!');
}
