// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:faso_bidile/main.dart';
import 'package:faso_bidile/components/categories/parametre.dart';

void main() {
  testWidgets('App launches correctly', (WidgetTester tester) async {
    // Créer une instance d'AppSettings pour le test
    final appSettings = AppSettings();
    await appSettings.initialize();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(settings: appSettings));

    // Attendre que l'app se charge complètement
    await tester.pumpAndSettle();

    // Vérifier que l'app se lance correctement
    // Vous pouvez adapter ce test selon votre interface
    expect(find.byType(MaterialApp), findsOneWidget);

    // Si vous avez des éléments spécifiques à tester sur votre page d'accueil
    // vous pouvez les ajouter ici, par exemple :
    // expect(find.text('Faso Bidile'), findsOneWidget);
  });
}