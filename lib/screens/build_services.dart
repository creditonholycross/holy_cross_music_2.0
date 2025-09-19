import 'package:flutter/material.dart';
import 'package:holy_cross_music/app_state.dart';
import 'package:holy_cross_music/models/music.dart';
import 'package:holy_cross_music/screens/create_service.dart';
import 'package:provider/provider.dart';

enum ServiceItem { eucharist, mattins, evensong }

class ServiceBuilderScreen extends StatefulWidget {
  const ServiceBuilderScreen({super.key});

  @override
  State<ServiceBuilderScreen> createState() => _ServiceBuilderScreenState();
}

class _ServiceBuilderScreenState extends State<ServiceBuilderScreen> {
  List<PopupMenuItem<ServiceItem>> serviceItems = [
    const PopupMenuItem(value: ServiceItem.eucharist, child: Text('Eucharist')),
    const PopupMenuItem(value: ServiceItem.mattins, child: Text('Mattins')),
    const PopupMenuItem(value: ServiceItem.evensong, child: Text('Evensong')),
  ];

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();
    var serviceList = appState.builtServices;
    ServiceItem? selectedItem;

    return Scaffold(
      floatingActionButton: PopupMenuButton<ServiceItem>(
        icon: Container(
          height: 50,
          width: 50,
          decoration: ShapeDecoration(
            color: Theme.of(context).colorScheme.surface,
            shape: StadiumBorder(
              side: BorderSide(
                color: Theme.of(context).colorScheme.onPrimary,
                width: 2,
              ),
            ),
          ),
          child: Icon(Icons.add),
        ),
        initialValue: selectedItem,
        onSelected: (ServiceItem item) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreateServiceScreen(serviceName: item.name),
            ),
          );
        },
        itemBuilder: (context) => serviceItems,
        offset: Offset(-70, -150),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: () {
            if (serviceList.isNotEmpty) {
              return Column(
                children: [
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: serviceList.length,
                    itemBuilder: (context, index) {
                      var service = serviceList[index];
                      var date = Music.parseDate(service.date);
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
                                text: service.serviceType,
                                style: const TextStyle(fontSize: 18),
                              ),
                              TextSpan(
                                text:
                                    ' \nRehearsal - ${Music.formatTime(service.rehearsalTime)}\nService - ${Music.formatTime(service.time)}',
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: const Icon(Icons.edit),
                        isThreeLine: true,
                        onTap: () {
                          appState.setCurrentBuildService(service);
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => CreateServiceScreen(
                          //       serviceName: service.serviceType,
                          //     ),
                          //   ),
                          // );
                        },
                      );
                    },
                  ),
                ],
              );
            } else {
              return const Text('No services added');
            }
          }(),
        ),
      ),
    );
  }
}
