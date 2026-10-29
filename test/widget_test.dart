import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_flavours/app.dart';
import 'package:flutter_flavours/core/config/app_config.dart';
import 'package:flutter_flavours/core/state/app_state.dart';

void main() {
  testWidgets('Multi-Tenant App smoke test', (WidgetTester tester) async {
    // Initialize default config for testing
    await AppConfig.initialize(overrideFlavor: 'devKgf');

    final appState = AppState();

    await tester.pumpWidget(
      AppStateProvider(
        state: appState,
        child: const MultiTenantApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify tenant and environment branding is rendered
    expect(find.text('KGF'), findsWidgets);
    expect(find.text('Sign in to your portal'), findsOneWidget);
  });
}
