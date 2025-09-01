import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class CharacterPersistenceService {
  static final CharacterPersistenceService _instance = CharacterPersistenceService._internal();
  factory CharacterPersistenceService() => _instance;
  CharacterPersistenceService._internal();

  static const String _characterPrefix = 'character_';
  static const String _userCharacterPrefix = 'user_character_';

  // Save a character to local storage
  Future<void> saveCharacter(Character character) async {
    final prefs = await SharedPreferences.getInstance();
    final characterJson = character.toJson();
    final characterString = jsonEncode(characterJson);
    
    // Save character by ID
    await prefs.setString('${_characterPrefix}${character.id}', characterString);
    
    // Save character by user ID for easy lookup
    await prefs.setString('${_userCharacterPrefix}${character.userId}', characterString);
    
    print('✅ Character saved to local storage: ${character.name}');
  }

  // Load a character by ID
  Future<Character?> loadCharacter(String characterId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final characterString = prefs.getString('${_characterPrefix}$characterId');
      
      if (characterString != null) {
        final characterJson = jsonDecode(characterString) as Map<String, dynamic>;
        final character = Character.fromJson(characterJson);
        print('✅ Character loaded from local storage: ${character.name}');
        return character;
      }
      
      print('⚠️ Character not found in local storage: $characterId');
      return null;
    } catch (e) {
      print('❌ Error loading character: $e');
      return null;
    }
  }

  // Load a character by user ID
  Future<Character?> loadCharacterByUserId(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final characterString = prefs.getString('${_userCharacterPrefix}$userId');
      
      if (characterString != null) {
        final characterJson = jsonDecode(characterString) as Map<String, dynamic>;
        final character = Character.fromJson(characterJson);
        print('✅ Character loaded from local storage by user ID: ${character.name}');
        return character;
      }
      
      print('⚠️ Character not found in local storage for user: $userId');
      return null;
    } catch (e) {
      print('❌ Error loading character by user ID: $e');
      return null;
    }
  }

  // Update a character in local storage
  Future<void> updateCharacter(Character character) async {
    await saveCharacter(character);
    print('✅ Character updated in local storage: ${character.name}');
  }

  // Delete a character from local storage
  Future<void> deleteCharacter(String characterId, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Remove character by ID
    await prefs.remove('${_characterPrefix}$characterId');
    
    // Remove character by user ID
    await prefs.remove('${_userCharacterPrefix}$userId');
    
    print('✅ Character deleted from local storage: $characterId');
  }

  // Check if a character exists for a user
  Future<bool> characterExists(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('${_userCharacterPrefix}$userId');
  }

  // Get all saved character IDs
  Future<List<String>> getAllCharacterIds() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    
    return keys
        .where((key) => key.startsWith(_characterPrefix))
        .map((key) => key.substring(_characterPrefix.length))
        .toList();
  }

  // Clear all character data (for testing or reset)
  Future<void> clearAllCharacters() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    
    final characterKeys = keys.where((key) => 
        key.startsWith(_characterPrefix) || key.startsWith(_userCharacterPrefix)
    ).toList();
    
    for (final key in characterKeys) {
      await prefs.remove(key);
    }
    
    print('✅ All character data cleared from local storage');
  }

  // Get character data size (for debugging)
  Future<int> getCharacterDataSize() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    
    int totalSize = 0;
    for (final key in keys) {
      if (key.startsWith(_characterPrefix) || key.startsWith(_userCharacterPrefix)) {
        final value = prefs.getString(key);
        if (value != null) {
          totalSize += value.length;
        }
      }
    }
    
    return totalSize;
  }
}
