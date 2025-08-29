import 'package:flutter/material.dart';

class ThemeService {
  // Singleton pattern
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  // Color palette
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color primaryOrangeDark = Color(0xFFE55A2B);
  static const Color primaryOrangeLight = Color(0xFFFF8A65);
  
  static const Color darkBackground = Color(0xFF0A0A0A);
  static const Color darkSurface = Color(0xFF1A1A1A);
  static const Color darkSurfaceVariant = Color(0xFF2A2A2A);
  static const Color darkOnSurface = Color(0xFFE0E0E0);
  static const Color darkOnSurfaceVariant = Color(0xFFB0B0B0);
  
  static const Color accentBlue = Color(0xFF2196F3);
  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color accentRed = Color(0xFFF44336);
  static const Color accentYellow = Color(0xFFFFEB3B);
  static const Color accentPurple = Color(0xFF9C27B0);

  // Dark theme with orange accents
  ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    // Color scheme
    colorScheme: const ColorScheme.dark(
      primary: primaryOrange,
      onPrimary: Colors.white,
      primaryContainer: primaryOrangeDark,
      onPrimaryContainer: Colors.white,
      secondary: accentBlue,
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFF1976D2),
      onSecondaryContainer: Colors.white,
      tertiary: accentGreen,
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFF388E3C),
      onTertiaryContainer: Colors.white,
      error: accentRed,
      onError: Colors.white,
      errorContainer: Color(0xFFD32F2F),
      onErrorContainer: Colors.white,
      surface: darkSurface,
      onSurface: darkOnSurface,
      surfaceContainerHighest: darkSurfaceVariant,
      onSurfaceVariant: darkOnSurfaceVariant,
      outline: Color(0xFF404040),
      outlineVariant: Color(0xFF606060),
      shadow: Colors.black26,
      scrim: Colors.black54,
      inverseSurface: Colors.white,
      onInverseSurface: Colors.black,
      inversePrimary: primaryOrangeLight,
    ),
    
    // App bar theme
    appBarTheme: const AppBarTheme(
      backgroundColor: darkSurface,
      foregroundColor: darkOnSurface,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: darkOnSurface,
      ),
    ),
    
    // Bottom navigation bar theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkSurface,
      selectedItemColor: primaryOrange,
      unselectedItemColor: darkOnSurfaceVariant,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    
    // Card theme
    cardTheme: CardThemeData(
      color: darkSurfaceVariant,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(8),
    ),
    
    // Elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryOrange,
        foregroundColor: Colors.white,
        elevation: 4,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    // Outlined button theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryOrange,
        side: const BorderSide(color: primaryOrange, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    // Text button theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryOrange,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkSurfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF404040)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF404040)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryOrange, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: accentRed, width: 2),
      ),
      labelStyle: const TextStyle(color: darkOnSurfaceVariant),
      hintStyle: const TextStyle(color: darkOnSurfaceVariant),
    ),
    
    // Chip theme
    chipTheme: ChipThemeData(
      backgroundColor: darkSurfaceVariant,
      selectedColor: primaryOrange,
      labelStyle: const TextStyle(color: darkOnSurface),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    
    // Divider theme
    dividerTheme: const DividerThemeData(
      color: Color(0xFF404040),
      thickness: 1,
      space: 1,
    ),
    
    // Icon theme
    iconTheme: const IconThemeData(
      color: darkOnSurfaceVariant,
      size: 24,
    ),
    
    // Text theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: darkOnSurface,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: darkOnSurface,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: darkOnSurface,
      ),
      headlineLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: darkOnSurface,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: darkOnSurface,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: darkOnSurface,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: darkOnSurface,
      ),
      titleMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: darkOnSurface,
      ),
      titleSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: darkOnSurface,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: darkOnSurface,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: darkOnSurface,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: darkOnSurface,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: darkOnSurface,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: darkOnSurface,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: darkOnSurface,
      ),
    ),
    
    // Dialog theme
    dialogTheme: DialogThemeData(
      backgroundColor: darkSurface,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: darkOnSurface,
      ),
    ),
    
    // Snackbar theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: darkSurfaceVariant,
      contentTextStyle: const TextStyle(color: darkOnSurface),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      behavior: SnackBarBehavior.floating,
    ),
    
    // Progress indicator theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryOrange,
      linearTrackColor: Color(0xFF404040),
    ),
    
    // Switch theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryOrange;
        }
        return darkOnSurfaceVariant;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryOrange.withValues(alpha: 0.5);
        }
        return Color(0xFF404040);
      }),
    ),
    
    // Checkbox theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryOrange;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
      side: const BorderSide(color: Color(0xFF404040)),
    ),
    
    // Radio theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryOrange;
        }
        return darkOnSurfaceVariant;
      }),
    ),
    
    // Slider theme
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryOrange,
      inactiveTrackColor: Color(0xFF404040),
      thumbColor: primaryOrange,
      overlayColor: primaryOrange.withValues(alpha: 0.2),
    ),
  );

  // Get specific colors for different UI elements
  Color get primaryColor => primaryOrange;
  Color get secondaryColor => accentBlue;
  Color get successColor => accentGreen;
  Color get errorColor => accentRed;
  Color get warningColor => accentYellow;
  Color get infoColor => accentPurple;
  
  // Get background colors
  Color get backgroundColor => darkBackground;
  Color get surfaceColor => darkSurface;
  Color get surfaceVariantColor => darkSurfaceVariant;
  
  // Get text colors
  Color get onSurfaceColor => darkOnSurface;
  Color get onSurfaceVariantColor => darkOnSurfaceVariant;
  
  // Get status colors
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
      case 'completed':
      case 'active':
        return accentGreen;
      case 'error':
      case 'failed':
      case 'danger':
        return accentRed;
      case 'warning':
      case 'pending':
        return accentYellow;
      case 'info':
      case 'neutral':
        return accentBlue;
      default:
        return darkOnSurfaceVariant;
    }
  }
  
  // Get rank colors for missions
  Color getMissionRankColor(String rank) {
    switch (rank.toUpperCase()) {
      case 'S':
        return accentRed;
      case 'A':
        return primaryOrange;
      case 'B':
        return accentGreen;
      case 'C':
        return accentBlue;
      case 'D':
        return darkOnSurfaceVariant;
      default:
        return darkOnSurfaceVariant;
    }
  }
  
  // Get rarity colors for items
  Color getItemRarityColor(String rarity) {
    switch (rarity.toLowerCase()) {
      case 'legendary':
        return primaryOrange;
      case 'epic':
        return accentPurple;
      case 'rare':
        return accentBlue;
      case 'uncommon':
        return accentGreen;
      case 'common':
        return darkOnSurfaceVariant;
      default:
        return darkOnSurfaceVariant;
    }
  }
  
  // Get element colors for jutsu
  Color getElementColor(String element) {
    switch (element.toLowerCase()) {
      case 'fire':
        return accentRed;
      case 'water':
        return accentBlue;
      case 'earth':
        return Color(0xFF8D6E63); // Brown
      case 'wind':
        return accentGreen;
      case 'lightning':
        return accentYellow;
      case 'neutral':
        return darkOnSurfaceVariant;
      default:
        return darkOnSurfaceVariant;
    }
  }
}
