// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:spotify_skillbox/ui/collection_screen/collection_widget.dart';

class CollectionNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const CollectionNavigator({
    Key? key,
    required this.navigatorKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (BuildContext context) {
            return const CollectionWidget();
          },
        );
      },
    );
  }
}
