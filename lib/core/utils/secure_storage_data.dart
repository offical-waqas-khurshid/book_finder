import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure Storage Instance
final _secureStorage = FlutterSecureStorage();

/// Provider to Manage Theme State
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
      (ref) => ThemeNotifier(),
);

/// Theme Notifier Class
class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light) {
    _loadTheme(); // Load saved theme on startup
  }

  /// Load saved theme from secure storage
  Future<void> _loadTheme() async {
    String? theme = await _secureStorage.read(key: "theme");
    if (theme == "dark") {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.light;
    }
  }

  /// Toggle theme and save selection
  Future<void> toggleTheme() async {
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
      await _secureStorage.write(key: "theme", value: "dark");
    } else {
      state = ThemeMode.light;
      await _secureStorage.write(key: "theme", value: "light");
    }
  }
}
