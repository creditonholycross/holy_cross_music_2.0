import 'package:flutter/material.dart';
import 'package:holy_cross_music/models/music.dart';
import 'package:holy_cross_music/models/service.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceTitleWidget extends StatelessWidget {
  const ServiceTitleWidget({super.key, required this.currentService});

  final Service currentService;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8),
          child: Text(
            currentService.serviceType,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        if (currentService.feast != null && currentService.feast != '') ...[
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Text(
              currentService.feast!,
              style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 22),
            ),
          ),
        ],
      ],
    );
  }
}

class ServiceConductorWidget extends StatelessWidget {
  const ServiceConductorWidget({super.key, required this.currentService});

  final Service currentService;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Text(
          'Conductor: ${currentService.conductor!}',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class ServiceOrganistWidget extends StatelessWidget {
  const ServiceOrganistWidget({super.key, required this.currentService});

  final Service currentService;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          'Organist: ${currentService.organist!}',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class ServiceOverviewWidget extends StatelessWidget {
  const ServiceOverviewWidget({super.key, required this.currentService});

  final Service currentService;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: currentService.music.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: currentService.music[index].musicType != ''
                  ? Text(
                      currentService.music[index].musicType,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )
                  : null,
            ),
            MusicElementWidget(music: currentService.music[index]),
          ],
        );
      },
    );
  }
}

class MusicElementWidget extends StatelessWidget {
  const MusicElementWidget({super.key, required this.music});

  final Music? music;

  @override
  Widget build(BuildContext context) {
    if (music!.title == '') {
      return ListTile(
        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
        title: Text(
          music!.composer as String,
          style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
        ),
        trailing: music!.link != '' ? PlayLinkWidget(music: music) : null,
      );
    }
    if (music!.composer != '') {
      return ListTile(
        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
        title: Text(music!.title, style: const TextStyle(fontSize: 18)),
        subtitle: Text(
          music!.composer as String,
          style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
        ),
        trailing: music!.link != '' ? PlayLinkWidget(music: music) : null,
      );
    }

    return TitleFormatting(music: music);
  }
}

class TitleFormatting extends StatelessWidget {
  TitleFormatting({super.key, required this.music});

  final Music? music;

  final psalmRegex = RegExp(r'v\d{1,2}');

  @override
  Widget build(BuildContext context) {
    var titleItalics = '';
    var musicTitle = music!.title;

    if (psalmRegex.hasMatch(music!.title)) {
      var psalmSplit = music!.title.split('v');
      titleItalics = ' v${psalmSplit[1]}';
      musicTitle = psalmSplit[0].trim();
    }

    if (music!.title.contains('#')) {
      var hymnSplit = music!.title.split('#');
      titleItalics = ' ${hymnSplit.sublist(1).join(' ').trim()}';
      musicTitle = hymnSplit[0];
    }

    return ListTile(
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: musicTitle, style: const TextStyle(fontSize: 18)),
            if (titleItalics != '')
              TextSpan(
                text: titleItalics,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 16,
                ),
              ),
          ],
        ),
      ),
      trailing: music!.link != '' ? PlayLinkWidget(music: music) : null,
    );
  }
}

class PlayLinkWidget extends StatelessWidget {
  const PlayLinkWidget({super.key, required this.music});

  final Music? music;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.play_arrow),
      onPressed: () {
        final snackBar = SnackBar(
          content: const Text('Open link in YouTube?'),
          action: SnackBarAction(
            label: 'Yes',
            onPressed: () async {
              await launchUrl(Uri.parse(music!.link as String));
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    );
  }
}

class RehearsalTimeWidget extends StatelessWidget {
  const RehearsalTimeWidget({super.key, required this.currentService});

  final Service currentService;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
      child: Text(
        'Rehearsal: ${Music.formatTime(currentService.rehearsalTime)}',
        style: const TextStyle(fontSize: 22),
      ),
    );
  }
}

class ServiceTimeWidget extends StatelessWidget {
  const ServiceTimeWidget({super.key, required this.currentService});

  final Service currentService;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
      child: Text(
        'Service: ${Music.formatTime(currentService.time)}',
        style: const TextStyle(fontSize: 22),
      ),
    );
  }
}
