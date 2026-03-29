import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:holy_cross_music/database/db_functions.dart';
import 'package:holy_cross_music/helper/fetchCatalogue.dart';
import 'package:holy_cross_music/helper/fetchMusic.dart';
import 'package:holy_cross_music/helper/wearOs.dart';
import 'package:holy_cross_music/models/catalogue.dart';
import 'package:holy_cross_music/models/month.dart';
import 'package:holy_cross_music/models/music.dart';
import 'package:holy_cross_music/models/service.dart';
import 'package:holy_cross_music/screens/catalogueScreen.dart';
import 'package:holy_cross_music/screens/events.dart';
import 'package:holy_cross_music/screens/profile.dart';
import 'package:holy_cross_music/screens/service_list.dart';
import 'package:holy_cross_music/screens/service_music.dart';
import 'package:holy_cross_music/screens/truro.dart';
import 'package:holy_cross_music/screens/user_management.dart';
import 'package:holy_cross_music/app_state.dart';
import 'package:holy_cross_music/themes/themes.dart';
import 'package:provider/provider.dart';

class AdminException implements Exception {
  String msg;
  AdminException(this.msg);
  String toString() => 'Error: $msg';
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;

  void asyncLoadData(BuildContext context) async {
    try {
      await updateMusicDb();
    } on AdminException catch (e) {
      if ([
            'admin',
            'superadmin',
          ].contains(context.read<ApplicationState>().userLevel) &&
          !kIsWeb) {
        Fluttertoast.showToast(msg: e.toString());
      }
    }

    List<MonthlyMusic>? serviceList = await DbFunctions().getServiceList();
    Service? nextService = serviceList?.first.services.firstOrNull;
    String serviceColour = nextService?.colour ?? 'base';

    setState(() {
      context.read<ApplicationState>().serviceList = serviceList;
      // context.read<ApplicationState>().truroMusic = serviceList;
      context.read<ApplicationState>().nextService = nextService;
      context.read<ApplicationState>().initMusicSpinner = false;
      context.read<ApplicationState>().serviceColour = Service.serviceColor(
        serviceColour,
        Brightness.dark,
        isAdmin: [
          'admin',
          'superadmin',
        ].contains(context.read<ApplicationState>().userLevel),
      );
      context.read<ApplicationState>().onPrimaryColor = serviceOnPrimaryColour(
        serviceColour,
        Brightness.dark,
      );
      onThemeChanged(serviceColour, context.read<ApplicationState>());
    });

    if (!kIsWeb) {
      var wearOs = WearOs();
      wearOs.init();
      List devices = await wearOs.listDevices();
      if (devices.isNotEmpty) {
        wearOs.sync(nextService);
      }
    }

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
          ['Holy Cross Music', 'Truro', 'Manage Users'][currentPageIndex],
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
          if (!(['admin', 'superadmin'].contains(appState.userLevel) &&
              currentPageIndex != 0))
            IconButton(
              icon: Icon(Icons.refresh, color: appState.onPrimaryColor),
              onPressed: () async {
                setState(() {
                  appState.initMusicSpinner = true;
                });
                asyncLoadData(context);
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
                  selectedIcon: Icon(Icons.add_reaction),
                  icon: Icon(
                    Icons.add_reaction,
                    color: appState.onPrimaryColor,
                  ),
                  label: 'Truro',
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
        SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('images/church.jpg', fit: BoxFit.cover),
              if (!appState.initMusicSpinner)
                Column(
                  children: [
                    if (appState.nextService == null)
                      const ListTile(
                        title: Text(
                          'Next service:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('No upcoming services'),
                      ),
                    if (appState.nextService != null)
                      ListTile(
                        title: const Text(
                          'Next service:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
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
                    if (appState.nextService != null)
                      Card(
                        child: ListTile(
                          title: const Text(
                            'View next service',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
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
                      Card(
                        child: ListTile(
                          title: const Text(
                            'View upcoming services',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          onTap: () async {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ServiceListPage(),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                )
              else
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              Card(
                child: ListTile(
                  title: const Text(
                    'View upcoming choir events and fundraising',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  onTap: () async {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const EventsPage(),
                      ),
                    );
                  },
                ),
              ),
              // if (!['admin', 'superadmin'].contains(appState.userLevel))
              //   Card(
              //     child: ListTile(
              //       title: const Text(
              //         'Truro',
              //         style: TextStyle(
              //           fontWeight: FontWeight.bold,
              //           fontSize: 18,
              //         ),
              //       ),
              //       onTap: () async {
              //         Navigator.of(context).push(
              //           MaterialPageRoute(
              //             builder: (context) => const TruroPage(),
              //           ),
              //         );
              //       },
              //     ),
              //   ),
              Card(
                child: ListTile(
                  title: const Text(
                    'View music catalogue',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  onTap: () async {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CataloguePage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        TruroPage(),
        UserManagementScreen(),
      ][currentPageIndex],
    );
  }
}
