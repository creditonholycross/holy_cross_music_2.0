import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:holy_cross_music/database/db_functions.dart';
import 'package:holy_cross_music/helper/fetchEvents.dart';
import 'package:holy_cross_music/helper/fetchMusic.dart';
import 'package:holy_cross_music/models/month.dart';
import 'package:holy_cross_music/models/music.dart';
import 'package:holy_cross_music/models/service.dart';
import 'package:holy_cross_music/screens/auth_gate.dart';
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
    var db = context.read<ApplicationState>().db;
    await updateMusicDb(db);
    List<MonthlyMusic>? serviceList = await DbFunctions().getServiceList(db);
    Service? nextService = serviceList!.first.services.firstOrNull;
    String serviceColour = nextService?.colour ?? 'base';

    setState(() {
      context.read<ApplicationState>().serviceList = serviceList;
      context.read<ApplicationState>().nextService = nextService;
      context.read<ApplicationState>().initMusicSpinner = false;
      context.read<ApplicationState>().serviceColour = Service.serviceColor(
        serviceColour,
        Brightness.dark,
      );
      onThemeChanged(serviceColour, context.read<ApplicationState>());
    });
  }

  @override
  void initState() {
    super.initState();
    asyncLoadData(context);
    fetchEvents().then(
      (data) => setState(() {
        context.read<ApplicationState>().eventList = data;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appState.serviceColour,
        title: Text(
          ['Holy Cross Music', 'Manage Users'][currentPageIndex],
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        leading: currentPageIndex != 0
            ? BackButton(
                color: Theme.of(context).colorScheme.onPrimary,
                onPressed: () {
                  setState(() {
                    currentPageIndex = 0;
                  });
                },
              )
            : null,
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () async {
              Fluttertoast.showToast(msg: 'Updating');
            },
          ),
          IconButton(
            icon: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
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
          ['admin', 'superadmin'].contains(
            appState.userLevel,
          ) // todo: also disable for web
          ? NavigationBar(
              onDestinationSelected: (int index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
              backgroundColor: appState.serviceColour,
              selectedIndex: currentPageIndex,
              labelTextStyle: WidgetStatePropertyAll(
                TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
              destinations: <Widget>[
                NavigationDestination(
                  selectedIcon: Icon(Icons.home),
                  icon: Icon(
                    Icons.home_outlined,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  label: 'Home',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.manage_accounts),
                  icon: Icon(
                    Icons.manage_accounts,
                    color: Theme.of(context).colorScheme.onPrimary,
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
                    'View upcoming choir events',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  onTap: () async {
                    // Fluttertoast.showToast(msg: 'Events');
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const EventsPage(),
                      ),
                    );
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text(
                    'View music catalogue',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  onTap: () async {
                    Fluttertoast.showToast(msg: 'Music catalogue');
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //       builder: (context) => const CataloguePage()),
                    // );
                  },
                ),
              ),
            ],
          ),
        ),
        UserManagementScreen(),
      ][currentPageIndex],
    );
  }
}
