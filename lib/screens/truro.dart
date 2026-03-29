import 'package:flutter/material.dart';
import 'package:holy_cross_music/app_state.dart';
import 'package:holy_cross_music/database/db_functions.dart';
import 'package:holy_cross_music/helper/fetchMusicTruro.dart';
import 'package:holy_cross_music/models/service.dart';
import 'package:holy_cross_music/screens/home.dart';
import 'package:holy_cross_music/screens/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TruroPage extends StatefulWidget {
  const TruroPage({super.key});

  @override
  State<TruroPage> createState() => _TruroPageState();
}

class _TruroPageState extends State<TruroPage> {
  var currentPageIndex = getindexForDate();

  void asyncLoadData(BuildContext context) async {
    if (context.read<ApplicationState>().truroMusic == null) {
      print('Loading Truro music');
      try {
        await updateTruroMusicDb();
      } on AdminException catch (e) {
        if ([
              'admin',
              'superadmin',
            ].contains(context.read<ApplicationState>().userLevel) &&
            !kIsWeb) {
          Fluttertoast.showToast(msg: e.toString());
        }
      }
    }

    Map<int, List<Service>> serviceList = await DbFunctions()
        .getAllTruroServices();

    setState(() {
      context.read<ApplicationState>().truroMusic = serviceList;
      context.read<ApplicationState>().initTruroSpinner = false;
    });
  }

  @override
  void initState() {
    super.initState();
    asyncLoadData(context);
    currentPageIndex = getindexForDate();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();
    var truroMusic = appState.truroMusic;

    return Scaffold(
      appBar: !['admin', 'superadmin'].contains(appState.userLevel)
          ? AppBar(
              backgroundColor: appState.serviceColour,
              iconTheme: IconThemeData(color: appState.onPrimaryColor),
              title: Text(
                'Truro',
                style: TextStyle(color: appState.onPrimaryColor),
              ),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        backgroundColor: appState.serviceColour,
        selectedIndex: currentPageIndex,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(color: appState.onPrimaryColor),
        ),

        destinations: <Widget>[
          NavigationDestination(
            icon: Text(
              'Mon',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            selectedIcon: Text(
              'Mon',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            label: '',
          ),
          NavigationDestination(
            icon: Text(
              'Tue',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            selectedIcon: Text(
              'Tue',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            label: '',
          ),
          NavigationDestination(
            icon: Text(
              'Wed',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            selectedIcon: Text(
              'Wed',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            label: '',
          ),
          NavigationDestination(
            icon: Text(
              'Thu',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            selectedIcon: Text(
              'Thu',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            label: '',
          ),
          NavigationDestination(
            icon: Text(
              'Fri',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            selectedIcon: Text(
              'Fri',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            label: '',
          ),
          NavigationDestination(
            icon: Text(
              'Sun',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            selectedIcon: Text(
              'Sun',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            label: '',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (!appState.initTruroSpinner)
              Column(
                children: [
                  TruroMusicWidget(
                    services: truroMusic?[currentPageIndex] as List<Service>,
                  ),
                ],
              )
            else
              Center(
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class TruroMusicWidget extends StatelessWidget {
  const TruroMusicWidget({super.key, required this.services});

  final List<Service> services;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: services.length,
            itemBuilder: (context, index) {
              var currentService = services.elementAt(index);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ServiceTitleWidget(currentService: currentService),
                  RehearsalTimeWidget(currentService: currentService),
                  ServiceTimeWidget(currentService: currentService),
                  if (currentService.conductor != '')
                    ServiceConductorWidget(currentService: currentService),
                  if (currentService.organist! != '')
                    ServiceOrganistWidget(currentService: currentService),
                  ServiceOverviewWidget(currentService: currentService),
                  Divider(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
