// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:spotify_skillbox/data/services.dart';
import 'package:spotify_skillbox/data/src/repository/napster_api_client.dart';
import 'package:spotify_skillbox/ui/app/app.dart';
import 'package:spotify_skillbox/ui/app/app_state.dart';
import 'package:spotify_skillbox/utils/url_constants.dart';

class AppDependencies extends StatelessWidget {
  final App app;

  const AppDependencies({Key? key, required this.app}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = AppState();
    final dio = Dio();
    final napsterApiClient = NapsterApiClient(dio, UrlConstants.baseUrl, UrlConstants.apiKey);
    final napsterService = NapsterServiceImpl(napsterApiClient);
    final collectionService = CollectionServiceImpl(appState.orderStreamController.stream);
    final playerService = PlayerServiceImpl(collectionService.tracks);

    return MultiProvider(
      providers: [
        Provider<AppState>(create: (_) => appState),
        Provider<NapsterService>(create: (_) => napsterService),
        Provider<CollectionService>(create: (_) => collectionService),
        Provider<PlayerService>(create: (_) => playerService),
      ],
      child: app,
    );
  }
}
