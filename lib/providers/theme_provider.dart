import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemePreference();
  }

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
  }

  void _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'Roboto',
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF5A3E7D),         // Dark Purple
        secondary: Color(0xFFFFFFFF),       // Light Gray
        background: Color(0xFFFFFFFF),      // Very Light Gray
        onBackground: Color(0xFF5A3E7D),    // Dark Purple
        onPrimary: Colors.white,            // White
      ),
      scaffoldBackgroundColor: const Color(0xFFEFEFEF), // Very Light Gray
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: Color(0xFF5A3E7D),         // Dark Purple
          fontFamily: 'Roboto',             // Roboto font
        ),
        bodyMedium: TextStyle(
          color: Color(0xFF5A3E7D),         // Dark Purple
          fontFamily: 'Roboto',             // Roboto font
        ),
        bodySmall: TextStyle(
          color: Color(0xFF919191),         // Gray
          fontFamily: 'Roboto',             // Roboto font
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF7F7F8),  // Very Light Gray
        iconTheme: IconThemeData(color: Color(0xFF5A3E7D)),  // Dark Purple
        titleTextStyle: TextStyle(
          color: Color(0xFF5A3E7D),         // Dark Purple
          fontSize: 20,
          fontFamily: 'Roboto',             // Roboto font
        ),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Color(0xFF5A3E7D),  // Dark Purple
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5A3E7D),  // Dark Purple
          foregroundColor: Colors.white,             // White
          textStyle: const TextStyle(fontFamily: 'Roboto'), // Roboto font
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF5A3E7D)),  // Dark Purple
        ),
      ),
      iconTheme: const IconThemeData(
        color: Color(0xFF2B0262),  // Custom icon color for light mode
      ),
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      fontFamily: 'Roboto',
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFBB86FC),         // Muted Purple (lighter than light theme)
        secondary: Color(0xFF03DAC6),       // Teal (modern accent color)
        background: Color(0xFF121212),      // Dark background
        surface: Color(0xFF1E1E1E),         // Dark surface for cards
        onBackground: Colors.white,         // White on dark background
        onPrimary: Colors.black,            // Black on purple
        onSecondary: Colors.black,          // Black on teal
        onSurface: Colors.white,            // White on dark surface
      ),
      scaffoldBackgroundColor: const Color(0xFF121212), // Dark background
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: Colors.white,             // White text
          fontFamily: 'Roboto',            // Roboto font
        ),
        bodyMedium: TextStyle(
          color: Colors.white,             // White text
          fontFamily: 'Roboto',            // Roboto font
        ),
        bodySmall: TextStyle(
          color: Color(0xFFB0B0B0),        // Light gray for subtle text
          fontFamily: 'Roboto',            // Roboto font
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),  // Dark surface
        iconTheme: IconThemeData(color: Colors.white),  // White icons
        titleTextStyle: TextStyle(
          color: Colors.white,               // White text
          fontSize: 20,
          fontFamily: 'Roboto',              // Roboto font
        ),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Color(0xFFBB86FC),  // Muted Purple
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFBB86FC),  // Muted Purple
          foregroundColor: Colors.black,             // Black text
          textStyle: const TextStyle(fontFamily: 'Roboto'), // Roboto font
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFBB86FC)),  // Muted Purple
        ),
        labelStyle: TextStyle(
          color: Colors.white,  // White labels
        ),
        hintStyle: TextStyle(
          color: Color(0xFFB0B0B0),  // Light gray hint text
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all(const Color(0xFFBB86FC)),  // Muted Purple thumb
        trackColor: MaterialStateProperty.all(const Color(0xFF1E1E1E)),  // Dark track
      ),
      iconTheme: const IconThemeData(
        color: Color(0xFFB3B3B3),  // Custom icon color for dark mode (light gray)
      ),
    );
  }
}
// ThemeData get darkTheme {
//   return ThemeData(
//     fontFamily: 'Roboto',
//     colorScheme: const ColorScheme.dark(
//       primary: Color(0xFF2E0061),         // Dark Purple
//       secondary: Color(0xFFB9B9BC),       // Medium Gray
//       background: Color(0xFF2E2C30),      // Dark Gray
//       onBackground: Color(0xFFF7F7F8),    // Very Light Gray
//       onPrimary: Color(0xFFF7F7F8),       // Very Light Gray
//     ),
//     scaffoldBackgroundColor: const Color(0xFF2E2C30),  // Dark Gray
//     textTheme: const TextTheme(
//       bodyLarge: TextStyle(
//         color: Color(0xFFF7F7F8),         // Very Light Gray
//         fontFamily: 'Roboto',              // SF Pro font
//       ),
//       bodyMedium: TextStyle(
//         color: Color(0xFFF7F7F8),         // Very Light Gray
//         fontFamily: 'Roboto',              // SF Pro font
//       ),
//     ),
//     appBarTheme: const AppBarTheme(
//       backgroundColor: Color(0xFF5A3E7D),  // Dark Purple
//       iconTheme: IconThemeData(color: Color(0xFFF7F7F8)),  // Very Light Gray
//       titleTextStyle: TextStyle(
//         fontWeight: FontWeight.w500,
//         color: Color(0xFF000000),         // Very Light Gray
//         fontSize: 20,
//         fontFamily: 'Roboto',              // SF Pro font
//       ),
//     ),
//     buttonTheme: const ButtonThemeData(
//       buttonColor: Color(0xFF5A3E7D),  // Dark Purple
//       textTheme: ButtonTextTheme.primary,
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: const Color(0xFF5A3E7D),  // Dark Purple
//         foregroundColor: const Color(0xFFF7F7F8),  // Very Light Gray
//         textStyle: const TextStyle(fontFamily: 'Roboto'), // SF Pro font
//       ),
//     ),
//     inputDecorationTheme: const InputDecorationTheme(
//       border: OutlineInputBorder(),
//       focusedBorder: OutlineInputBorder(
//         borderSide: BorderSide(color: Color(0xFF5A3E7D)),  // Dark Purple
//       ),
//     ),
//   );
// }
