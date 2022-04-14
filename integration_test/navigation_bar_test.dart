import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotify_skillbox/main.dart' as app;
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const activeColor = Color.fromRGBO(141, 108, 234, 1);
  const inactiveColor = Colors.white;

  testWidgets('checking navigationbar switching', (tester) async {
    await app.main();
    await tester.pump(const Duration(seconds: 3));

    final artistsNavBarItemFinder = find.byKey(const Key('artists_key'));
    final searchNavBarItemFinder = find.byKey(const Key('search_key'));
    final collectionNavBarItemFinder = find.byKey(const Key('collection_key'));

    final artistsIconFinder = find.byIcon(Icons.library_music);
    final searchIconFinder = find.byIcon(Icons.search).last;
    final collectionIconFinder = find.byIcon(Icons.favorite_border);

    expect((tester.widget(artistsIconFinder) as Icon).color, activeColor);
    expect((tester.widget(searchIconFinder) as Icon).color, inactiveColor);
    expect((tester.widget(collectionIconFinder) as Icon).color, inactiveColor);

    await tester.tap(searchNavBarItemFinder);
    await tester.pump(const Duration(seconds: 1));

    expect((tester.widget(artistsIconFinder) as Icon).color, inactiveColor);
    expect((tester.widget(searchIconFinder) as Icon).color, activeColor);
    expect((tester.widget(collectionIconFinder) as Icon).color, inactiveColor);

    await tester.tap(collectionNavBarItemFinder);
    await tester.pump(const Duration(seconds: 1));

    expect((tester.widget(artistsIconFinder) as Icon).color, inactiveColor);
    expect((tester.widget(searchIconFinder) as Icon).color, inactiveColor);
    expect((tester.widget(collectionIconFinder) as Icon).color, activeColor);

    await tester.tap(artistsNavBarItemFinder);
    await tester.pump(const Duration(seconds: 1));

    expect((tester.widget(artistsIconFinder) as Icon).color, activeColor);
    expect((tester.widget(searchIconFinder) as Icon).color, inactiveColor);
    expect((tester.widget(collectionIconFinder) as Icon).color, inactiveColor);
  });
}
