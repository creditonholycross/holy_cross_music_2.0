import 'package:flutter/material.dart';
import 'package:holy_cross_music/app_state.dart';
import 'package:holy_cross_music/models/music.dart';
import 'package:holy_cross_music/screens/month_overview.dart';
import 'package:holy_cross_music/screens/service_music.dart';
import 'package:provider/provider.dart';

class TruroPage extends StatefulWidget {
  const TruroPage({super.key});

  @override
  State<TruroPage> createState() => _TruroPageState();
}

class _TruroPageState extends State<TruroPage> {
  var currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();
    var truroMusic = appState.truroMusic;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appState.serviceColour,
        iconTheme: IconThemeData(color: appState.onPrimaryColor),
        title: Text('Truro', style: TextStyle(color: appState.onPrimaryColor)),
      ),
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
      body: SingleChildScrollView(child: Column()),
    );
  }
}
