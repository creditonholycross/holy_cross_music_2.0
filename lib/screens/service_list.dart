import 'dart:async';

import 'package:flutter/material.dart';
import 'package:holy_cross_music/app_state.dart';
import 'package:holy_cross_music/database/db_functions.dart';
import 'package:holy_cross_music/helper/fetchMusic.dart';
import 'package:holy_cross_music/models/catalogue.dart';
import 'package:holy_cross_music/models/event.dart';
import 'package:holy_cross_music/models/month.dart';
import 'package:holy_cross_music/models/music.dart';
import 'package:holy_cross_music/models/service.dart';
import 'package:holy_cross_music/screens/service_music.dart';
import 'package:holy_cross_music/themes/themes.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceListPage extends StatefulWidget {
  const ServiceListPage({super.key});

  @override
  State<ServiceListPage> createState() => _ServiceListPageState();
}

class _ServiceListPageState extends State<ServiceListPage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();
    var serviceList = appState.serviceList;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appState.serviceColour,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        title: Text(
          'Upcoming Services',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        actions: <Widget>[
          // IconButton(
          //   icon: const Icon(Icons.refresh),
          // onPressed: appState.refreshDisabled
          //     ? null
          //     : () async {
          //         appState.disableRefresh();
          //         print('Music lists updating');
          //         if (!kIsWeb) {
          //           Fluttertoast.showToast(msg: 'Music lists updating');
          //         }
          //         () {
          //           setState(() {
          //             updateMusicDb().then(
          //               (data) => {
          //                 DbFunctions().getServiceList().then(
          //                   (data) => setState(() {
          //                     context.read<ServiceState>().serviceList = data;
          //                     serviceList = data;
          //                     DbFunctions().getNextService().then(
          //                       (data) => setState(() {
          //                         context.read<ServiceState>().nextService =
          //                             data;
          //                         context
          //                                 .read<ServiceState>()
          //                                 .initMusicSpinner =
          //                             false;
          //                         wearOsSync(data);
          //                       }),
          //                     );
          //                   }),
          //                 ),
          //               },
          //             );
          //           });
          //         };
          //         Timer(const Duration(seconds: 4), appState.enableRefresh);
          // },
          // ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: () {
            if (serviceList != null) {
              return Column(
                children: [
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: serviceList!.length,
                    itemBuilder: (c, i) {
                      var month = serviceList![i].monthName;
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    month,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                              ),
                              // Expanded(
                              // child: OutlinedButton(
                              //   onPressed: () {
                              //     Navigator.of(context).push(
                              //       MaterialPageRoute(
                              //         builder: (context) => MonthOverviewPage(
                              //           monthlyMusic: serviceList![i],
                              //         ),
                              //       ),
                              //     );
                              //   },
                              //   style: ElevatedButton.styleFrom(
                              //     foregroundColor: Theme.of(
                              //       context,
                              //     ).colorScheme.onSurface,
                              //     elevation: 2,
                              //   ),
                              //   child: const Text(
                              //     'Overview',
                              //     style: TextStyle(
                              //       fontWeight: FontWeight.bold,
                              //       fontSize: 24,
                              //     ),
                              //   ),
                              // ),
                              // ),
                            ],
                          ),
                          ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: serviceList![i].services.length,
                            itemBuilder: (context, index) {
                              var service = serviceList![i].services;
                              var date = Music.parseDate(service[index].date);
                              return ListTile(
                                title: Text(
                                  date,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: service[index].serviceType,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      TextSpan(
                                        text:
                                            ' \nRehearsal - ${Music.formatTime(service[index].rehearsalTime)}\nService - ${Music.formatTime(service[index].time)}',
                                        style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                trailing: const Icon(Icons.info_outline),
                                isThreeLine: true,
                                onTap: () {
                                  appState.setCurrentService(service[index]);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ServiceMusicPage(),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              );
            } else {
              return const Text('No upcoming services');
            }
          }(),
        ),
      ),
    );
  }
}
