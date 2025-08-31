import 'package:shared_preferences/shared_preferences.dart';

class AvatarService {
  static final AvatarService _instance = AvatarService._internal();
  factory AvatarService() => _instance;
  AvatarService._internal();

  static const String _avatarHistoryKey = 'avatar_history';
  static const int _maxHistorySize = 5;

  // Get the list of recently used avatar URLs
  Future<List<String>> getAvatarHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = prefs.getStringList(_avatarHistoryKey) ?? [];
      return history;
    } catch (e) {
      // Return empty list if there's an error
      return [];
    }
  }

  // Add a new avatar URL to history
  Future<void> addAvatarToHistory(String avatarUrl) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = prefs.getStringList(_avatarHistoryKey) ?? [];
      
      // Remove the URL if it already exists to avoid duplicates
      history.remove(avatarUrl);
      
      // Add the new URL to the beginning
      history.insert(0, avatarUrl);
      
      // Keep only the last 5 URLs
      if (history.length > _maxHistorySize) {
        history.removeRange(_maxHistorySize, history.length);
      }
      
      await prefs.setStringList(_avatarHistoryKey, history);
    } catch (e) {
      // Silently fail if there's an error saving
    }
  }

  // Remove a specific avatar URL from history
  Future<void> removeAvatarFromHistory(String avatarUrl) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = prefs.getStringList(_avatarHistoryKey) ?? [];
      
      history.remove(avatarUrl);
      await prefs.setStringList(_avatarHistoryKey, history);
    } catch (e) {
      // Silently fail if there's an error
    }
  }

  // Clear all avatar history
  Future<void> clearAvatarHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_avatarHistoryKey);
    } catch (e) {
      // Silently fail if there's an error
    }
  }

  // Check if a URL is valid (basic validation)
  bool isValidAvatarUrl(String url) {
    if (url.isEmpty) return false;
    
    // Basic URL validation
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }


}
