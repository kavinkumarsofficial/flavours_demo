import 'package:flutter/material.dart';
import 'app.dart';
import 'core/config/app_config.dart';
import 'core/state/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize centralized configuration automatically resolved from active build variant / appFlavor
  await AppConfig.initialize();

  final appState = AppState();

  runApp(
    AppStateProvider(
      state: appState,
      child: const MultiTenantApp(),
    ),
  );
}
