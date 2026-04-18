import 'package:flutter/physics.dart';
import 'package:holy_cross_music/models/music.dart';
import 'package:holy_cross_music/models/service.dart';
import 'package:flutter_wear_os_connectivity/flutter_wear_os_connectivity.dart';
import 'package:collection/collection.dart';

class WearOs {
  final FlutterWearOsConnectivity _flutterWearOsConnectivity =
      FlutterWearOsConnectivity();
  init() {
    _flutterWearOsConnectivity.configureWearableAPI();
  }

  listDevices() async {
    List<WearOsDevice> _connectedDevices = await _flutterWearOsConnectivity
        .getConnectedDevices();
    print(_connectedDevices);
    return _connectedDevices;
  }

  localDevice() async {
    WearOsDevice _localDevice = await _flutterWearOsConnectivity
        .getLocalDevice();
    print(_localDevice);
  }

  sync(Service? nextService) async {
    if (nextService == null) {
      return;
    }

    var allHymns = nextService.music.where((x) => x.title.contains('#'));

    var splitHymnNumbers = <String>[];

    allHymns.forEach((hymn) {
      splitHymnNumbers.add(hymn.title.split('#').first);
    });

    var hymnTitle = splitHymnNumbers.join(', ');

    if (hymnTitle == '') {
      var hymns = nextService.music.firstWhereOrNull(
        (x) => x.musicType.contains("Hymn"),
      );

      hymns ??= const Music(
        date: '',
        time: '',
        rehearsalTime: '',
        serviceType: '',
        musicType: '',
        title: '-',
      );

      hymnTitle == hymns.title;
    }

    print(hymnTitle);

    var psalm = nextService.music.firstWhereOrNull(
      (x) => x.musicType.contains("Psalm"),
    );

    psalm ??= const Music(
      date: '',
      time: '',
      rehearsalTime: '',
      serviceType: '',
      musicType: '',
      title: '-',
    );

    var anthem = nextService.music.firstWhereOrNull(
      (x) => x.musicType.contains("Anthem"),
    );

    anthem ??= const Music(
      date: '',
      time: '',
      rehearsalTime: '',
      serviceType: '',
      musicType: '',
      title: '-',
    );

    var watchData = {
      "serviceType": nextService.serviceType,
      "serviceDate": nextService.date,
      "hymns": hymnTitle,
      "psalm": psalm.title,
      "anthem": anthem.title,
    };

    print(watchData);

    DataItem? dataItem = await _flutterWearOsConnectivity.syncData(
      path: "/next-service-info",
      data: watchData,
      isUrgent: true,
    );

    print(dataItem?.pathURI);
    print(dataItem?.mapData);
  }
}

Future<void> wearOsSync(Service? nextService) async {
  FlutterWearOsConnectivity flutterWearOsConnectivity =
      FlutterWearOsConnectivity();
  flutterWearOsConnectivity.configureWearableAPI();

  if (nextService == null) {
    return;
  }

  var allHymns = nextService.music.where((x) => x.title.contains('#'));

  var splitHymnNumbers = <String>[];

  allHymns.forEach((hymn) {
    splitHymnNumbers.add(hymn.title.split('#').first);
  });

  var hymnTitle = splitHymnNumbers.join(', ');

  if (hymnTitle == '') {
    var hymns = nextService.music.firstWhereOrNull(
      (x) => x.musicType.contains("Hymn"),
    );

    hymns ??= const Music(
      date: '',
      time: '',
      rehearsalTime: '',
      serviceType: '',
      musicType: '',
      title: '-',
    );

    hymnTitle == hymns.title;
  }

  print(hymnTitle);

  var psalm = nextService.music.firstWhereOrNull(
    (x) => x.musicType.contains("Psalm"),
  );

  psalm ??= const Music(
    date: '',
    time: '',
    rehearsalTime: '',
    serviceType: '',
    musicType: '',
    title: '-',
  );

  var watchData = {
    "serviceType": nextService.serviceType,
    "serviceDate": nextService.date,
    "hymns": hymnTitle,
    "psalm": psalm.title,
  };

  print(watchData);

  DataItem? dataItem = await flutterWearOsConnectivity.syncData(
    path: "/next-service-info",
    data: watchData,
    isUrgent: true,
  );

  print(dataItem?.pathURI);
  print(dataItem?.mapData);
}
