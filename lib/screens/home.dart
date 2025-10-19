import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:holy_cross_music/database/db_functions.dart';
import 'package:holy_cross_music/helper/fetchCatalogue.dart';
import 'package:holy_cross_music/helper/fetchEvents.dart';
import 'package:holy_cross_music/helper/fetchFundraisingEvents.dart';
import 'package:holy_cross_music/helper/fetchMusic.dart';
import 'package:holy_cross_music/models/catalogue.dart';
import 'package:holy_cross_music/models/month.dart';
import 'package:holy_cross_music/models/music.dart';
import 'package:holy_cross_music/models/service.dart';
import 'package:holy_cross_music/screens/catalogueScreen.dart';
import 'package:holy_cross_music/screens/events.dart';
import 'package:holy_cross_music/screens/profile.dart';
import 'package:holy_cross_music/screens/service_list.dart';
import 'package:holy_cross_music/screens/service_music.dart';
import 'package:holy_cross_music/screens/user_management.dart';
import 'package:holy_cross_music/app_state.dart';
import 'package:holy_cross_music/themes/themes.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;

  void asyncLoadData(BuildContext context) async {
    await updateMusicDb();

    List<MonthlyMusic>? serviceList = await DbFunctions().getServiceList();
    Service? nextService = serviceList?.first.services.firstOrNull;
    String serviceColour = nextService?.colour ?? 'base';

    setState(() {
      context.read<ApplicationState>().serviceList = serviceList;
      context.read<ApplicationState>().nextService = nextService;
      context.read<ApplicationState>().initMusicSpinner = false;
      context.read<ApplicationState>().serviceColour = Service.serviceColor(
        serviceColour,
        Brightness.dark,
      );
      context.read<ApplicationState>().onPrimaryColor = serviceOnPrimaryColour(
        serviceColour,
        Brightness.dark,
      );
      onThemeChanged(serviceColour, context.read<ApplicationState>());
    });

    var catalogueCount = await DbFunctions().getCatalogueCount();
    if (catalogueCount == 0) {
      await updateCatalogueDb();
    }

    List<Catalogue>? catalogueList = await DbFunctions().getCatalogue();
    setState(() {
      context.read<ApplicationState>().catalogueList = catalogueList;
    });
  }

  @override
  void initState() {
    super.initState();
    asyncLoadData(context);
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appState.serviceColour,
        title: Text(
          ['Holy Cross Music', 'Manage Users'][currentPageIndex],
          style: TextStyle(color: appState.onPrimaryColor),
        ),
        leading: currentPageIndex != 0
            ? BackButton(
                color: appState.onPrimaryColor,
                onPressed: () {
                  setState(() {
                    currentPageIndex = 0;
                  });
                },
              )
            : null,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: appState.onPrimaryColor),
            onPressed: () async {
              Fluttertoast.showToast(msg: 'Updating');
            },
          ),
          IconButton(
            icon: Icon(Icons.person, color: appState.onPrimaryColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<ProfileScreen>(
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar:
          (['admin', 'superadmin'].contains(appState.userLevel) && !kIsWeb)
          ? NavigationBar(
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
                  selectedIcon: Icon(Icons.home),
                  icon: Icon(
                    Icons.home_outlined,
                    color: appState.onPrimaryColor,
                  ),
                  label: 'Home',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.manage_accounts),
                  icon: Icon(
                    Icons.manage_accounts,
                    color: appState.onPrimaryColor,
                  ),
                  label: 'Manage Users',
                ),
              ],
            )
          : null,
      body: [
        Column(
          children: [
            Image.asset('images/church.jpg', fit: BoxFit.cover),
            if (appState.nextService == null && !appState.initMusicSpinner)
              const ListTile(
                title: Text(
                  'Next service:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('No upcoming services'),
              ),
            if (appState.nextService != null && !appState.initMusicSpinner)
              ListTile(
                title: const Text(
                  'Next service:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                            '${Music.parseDate(appState.nextService!.date)} - ${appState.nextService!.serviceType}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      TextSpan(
                        text:
                            ' \nRehearsal - ${Music.formatTime(appState.nextService!.rehearsalTime)}\nService - ${Music.formatTime(appState.nextService!.time)}',
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  appState.setCurrentService(appState.nextService!);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ServiceMusicPage(),
                    ),
                  );
                },
              ),
            if (!appState.initMusicSpinner)
              GridView.count(
                crossAxisCount: 3,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  if (appState.nextService != null)
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: InkWell(
                        child: Card(
                          color: appState.serviceColour,
                          shadowColor: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Next\nservice',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: appState.onPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          appState.setCurrentService(appState.nextService!);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ServiceMusicPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  if (appState.nextService != null)
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: InkWell(
                        child: Card(
                          color: appState.serviceColour,
                          shadowColor: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Upcoming\nservices',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: appState.onPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ServiceListPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: InkWell(
                      child: Card(
                        color: appState.serviceColour,
                        shadowColor: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Music\ncatalogue',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: appState.onPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const CataloguePage(),
                          ),
                        );
                      },
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.all(8),
                    child: InkWell(
                      child: Card(
                        color: appState.serviceColour,
                        shadowColor: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Events and\nfundraising',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: appState.onPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () async {
                        if (appState.eventList == null ||
                            appState.fundraisingEventList == null) {
                          appState.initEventsSpinner = true;
                        }

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const EventsPage(),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: InkWell(
                      child: Card(
                        color: appState.serviceColour,
                        shadowColor: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Truro',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: appState.onPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const EventsPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            if (appState.initMusicSpinner)
              Center(
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
        UserManagementScreen(),
      ][currentPageIndex],
    );
  }
}
