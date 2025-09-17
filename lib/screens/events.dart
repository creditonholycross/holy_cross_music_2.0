import 'package:flutter/material.dart';
import 'package:holy_cross_music/app_state.dart';
import 'package:holy_cross_music/models/event.dart';
import 'package:holy_cross_music/models/month.dart';
import 'package:holy_cross_music/models/music.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();
    var events = appState.eventList;
    var fundraisingEvents = appState.fundraisingEventList;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        title: Text(
          ['Choir Events', 'Fundraising'][currentPageIndex],
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
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
          TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.event),
            icon: Icon(
              Icons.event,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            label: 'Events',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.savings),
            icon: Icon(
              Icons.savings_outlined,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            label: 'Fundraising',
          ),
        ],
      ),
      body: [
        EventsWidget(events: events),
        FundraisingWidget(fundraisingEvents: fundraisingEvents),
      ][currentPageIndex],
    );
  }
}

class EventsWidget extends StatelessWidget {
  const EventsWidget({super.key, required this.events});

  final Map<String, List<MonthlyEvents>>? events;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: () {
          if (events!.isNotEmpty) {
            return Column(
              children: [
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: events?.length,
                  itemBuilder: (cxt, idx) {
                    String year = events!.keys.elementAt(idx);
                    var yearEvents = events![year];
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
                                        padding: const EdgeInsets.only(top: 8),
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
                                  physics: const NeverScrollableScrollPhysics(),
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
    );
  }
}

class FundraisingWidget extends StatelessWidget {
  const FundraisingWidget({super.key, required this.fundraisingEvents});

  final Map<String, List<MonthlyFundraisingEvents>>? fundraisingEvents;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: () {
          if (fundraisingEvents!.isNotEmpty) {
            return Column(
              children: [
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: fundraisingEvents?.length,
                  itemBuilder: (cxt, idx) {
                    String year = fundraisingEvents!.keys.elementAt(idx);
                    var yearEvents = fundraisingEvents![year];
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
                                        padding: const EdgeInsets.only(top: 8),
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
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: yearEvents![i].events.length,
                                  itemBuilder: (context, index) {
                                    var event = yearEvents![i].events;
                                    var date = event[index].date;
                                    var organiser = event[index].organiser;
                                    var eventTime = event[index].time;
                                    var tickets = event[index].tickets;
                                    var ticketLink = event[index].ticketLink;
                                    var location = event[index].location;

                                    return ListTile(
                                      title: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: Music.parseDate(
                                                date,
                                              ).toUpperCase(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '\nOrganiser - $organiser',
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
                                              text: event[index].event,
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '\n$eventTime',
                                              style: const TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: 16,
                                              ),
                                            ),
                                            if (tickets != '' &&
                                                tickets != null)
                                              TextSpan(
                                                text: '\nTickets: $tickets',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            TextSpan(
                                              text: '\n$location',
                                              style: const TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: 16,
                                              ),
                                            ),
                                            if (ticketLink != '' &&
                                                ticketLink != null)
                                              TextSpan(
                                                text: '\nBuy tickets at: ',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            if (ticketLink != '' &&
                                                ticketLink != null)
                                              TextSpan(
                                                text: ticketLink,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.blue,
                                                ),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () async {
                                                        await launchUrl(
                                                          Uri.parse(ticketLink),
                                                        );
                                                      },
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
    );
  }
}
