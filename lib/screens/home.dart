import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:holy_cross_music/database/db_functions.dart';
import 'package:holy_cross_music/helper/fetchMusic.dart';
import 'package:holy_cross_music/models/month.dart';
import 'package:holy_cross_music/screens/user_management.dart';
import 'package:holy_cross_music/app_state.dart';
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

    setState(() {
      context.read<ApplicationState>().serviceList = serviceList;
    });
  }

  @override
  void initState() {
    asyncLoadData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(['Holy Cross Music', 'Manage Users'][currentPageIndex]),
        leading: currentPageIndex != 0
            ? BackButton(
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
              // color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () async {
              Fluttertoast.showToast(msg: 'Updating');
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<ProfileScreen>(
                  builder: (context) => ProfileScreen(
                    appBar: AppBar(title: const Text('User Profile')),
                    actions: [
                      SignedOutAction((context) {
                        Navigator.of(context).pop();
                      }),
                    ],
                    children: [const Divider()],
                  ),
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
              selectedIndex: currentPageIndex,
              destinations: const <Widget>[
                NavigationDestination(
                  selectedIcon: Icon(Icons.home),
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.manage_accounts),
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
              Column(
                children: [
                  const ListTile(
                    title: Text(
                      'Next service:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('No upcoming services'),
                  ),
                ],
              ),
              Card(
                child: ListTile(
                  title: const Text(
                    'View upcoming choir events',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  onTap: () async {
                    Fluttertoast.showToast(msg: 'Events');
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //       builder: (context) => const EventsPage()),
                    // );
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
