import 'package:flutter/material.dart';
import 'package:holy_cross_music/app_state.dart';
import 'package:holy_cross_music/models/music.dart';
import 'package:holy_cross_music/screens/widgets.dart';
import 'package:provider/provider.dart';

class ServiceMusicPage extends StatelessWidget {
  const ServiceMusicPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();
    var currentService = appState.currentService;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: currentService.servicePrimaryColour(
          Theme.of(context).colorScheme.brightness,
        ),
        iconTheme: IconThemeData(
          color: currentService.serviceOnPrimaryColour(
            Theme.of(context).colorScheme.brightness,
          ),
        ),
        title: Text(
          Music.parseDate(currentService.date),
          style: TextStyle(
            color: currentService.serviceOnPrimaryColour(
              Theme.of(context).colorScheme.brightness,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ServiceTitleWidget(currentService: currentService),
            if (currentService.organist! != '')
              ServiceOrganistWidget(currentService: currentService),
            ServiceOverviewWidget(currentService: currentService),
          ],
        ),
      ),
    );
  }
}
