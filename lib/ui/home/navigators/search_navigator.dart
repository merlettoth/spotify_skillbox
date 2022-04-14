// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:spotify_skillbox/ui/artist_screen/artist_widget.dart';
import 'package:spotify_skillbox/ui/search_screen/search_widget.dart';

class SearchNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const SearchNavigator({
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
            switch (settings.name) {
              case SearchWidget.routeName:
                return const SearchWidget();
              case ArtistWidget.routeName:
                return const ArtistWidget();
              default:
                return const SearchWidget();
            }
          },
        );
      },
    );
  }
}
