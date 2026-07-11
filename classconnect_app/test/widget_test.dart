// Basic widget tests that don't require Firebase to be initialized.
// Screens that depend on FirebaseAuth/Firestore (AuthGate, LoginScreen, etc.)
// need Firebase test mocks and are covered once the Firebase project is wired up.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:classconnect_app/widgets/primary_button.dart';
import 'package:classconnect_app/widgets/app_text_field.dart';

void main() {
  testWidgets('PrimaryButton calls onPressed when tapped', (
    WidgetTester tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: PrimaryButton(label: 'Go', onPressed: () => tapped = true),
      ),
    );

    expect(find.text('Go'), findsOneWidget);
    await tester.tap(find.text('Go'));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('PrimaryButton shows a spinner instead of the label when loading', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PrimaryButton(label: 'Go', onPressed: () {}, isLoading: true),
      ),
    );

    expect(find.text('Go'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('AppTextField runs its validator', (WidgetTester tester) async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: AppTextField(
              controller: controller,
              label: 'Email',
              validator: (value) =>
                  value != null && value.contains('@') ? null : 'Invalid',
            ),
          ),
        ),
      ),
    );

    expect(formKey.currentState!.validate(), isFalse);
    await tester.pump();
    expect(find.text('Invalid'), findsOneWidget);
  });
}
