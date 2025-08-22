import 'package:flutter/material.dart';
import 'package:holy_cross_music/app_state.dart';
import 'package:holy_cross_music/models/event.dart';
import 'package:holy_cross_music/models/music.dart';
import 'package:provider/provider.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();
    var events = appState.eventList;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        title: Text(
          'Choir Events',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: () {
            if (events!.isNotEmpty) {
              return Column(
                children: [
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: events.length,
                    itemBuilder: (cxt, idx) {
                      String year = events.keys.elementAt(idx);
                      var yearEvents = events[year];
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    year,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: yearEvents!.length,
                            itemBuilder: (c, i) {
                              var month = yearEvents![i].monthName;
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8,
                                          ),
                                          child: Text(
                                            month,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: yearEvents![i].events.length,
                                    itemBuilder: (context, index) {
                                      var event = yearEvents![i].events;
                                      var dateStart = event[index].dateStart;
                                      var dateEnd = event[index].dateEnd;
                                      var eventTime = event[index].time;
                                      var eventRehearsalTime =
                                          event[index].rehearsalTime;

                                      return ListTile(
                                        title: Text.rich(
                                          TextSpan(
                                            children: [
                                              if (dateStart != '' &&
                                                  dateStart != null)
                                                TextSpan(
                                                  text: Music.parseDate(
                                                    dateStart,
                                                  ),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              if (dateEnd != '' &&
                                                  dateEnd != null)
                                                TextSpan(
                                                  text:
                                                      ' - ${Music.parseDate(dateEnd)}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        subtitle: Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: event[index].name,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              if (eventTime != '' &&
                                                  eventTime != null)
                                                TextSpan(
                                                  text:
                                                      '\nStart: ${Event.formatTime(eventTime)}',
                                                  style: const TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              if (eventRehearsalTime != '' &&
                                                  eventRehearsalTime != null)
                                                TextSpan(
                                                  text:
                                                      '\nRehearsal: ${Event.formatTime(eventRehearsalTime)}',
                                                  style: const TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        isThreeLine: true,
                                      );
                                    },
                                  ),
                                ],
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
              return const Text('No upcoming events');
            }
          }(),
        ),
      ),
    );
  }
}
