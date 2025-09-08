import 'dart:async';

import 'package:flutter/material.dart';
import 'package:holy_cross_music/app_state.dart';
import 'package:holy_cross_music/database/db_functions.dart';
import 'package:holy_cross_music/helper/fetchCatalogue.dart';
import 'package:holy_cross_music/helper/search.dart';
import 'package:holy_cross_music/models/catalogue.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:fluttertoast/fluttertoast.dart';

final ItemScrollController _scrollController = ItemScrollController();
final ScrollOffsetController scrollOffsetController = ScrollOffsetController();
final ItemPositionsListener itemPositionsListener =
    ItemPositionsListener.create();
final ScrollOffsetListener scrollOffsetListener = ScrollOffsetListener.create();

class CataloguePage extends StatefulWidget {
  const CataloguePage({super.key});

  @override
  State<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
  static const List<String> seasonMenuEntries = <String>[
    'Season (All)',
    'Epiphany',
    'Easter',
    'Whitsun',
    'Harvest',
    'Remem',
    'Advent',
    'Christmas',
  ];

  static const List<String> partsMenuEntries = <String>[
    'Parts (All)',
    'SATB',
    'Treble',
    'SSA',
    'Solo',
    'TTBB',
    'TB',
    'SS',
    'Upper',
  ];

  late Future<List<Catalogue>?> catalogueFuture;

  @override
  void initState() {
    super.initState();

    catalogueFuture = context.read<ApplicationState>().filterCatalogueList();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();
    var catalogue = appState.filteredCatalogueList;
    var navIndex = appState.navIndex;
    var navScrollIndexMapping = appState.navScrollIndexMapping;
    var alphabetList = appState.alphabetList;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        title: Text(
          "Catalogue",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => showSearch(
              context: context,
              delegate: CatalogueSearchDelegate(
                catalogueList: catalogue as List<Catalogue>,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: appState.catalogueRefreshDisabled
                ? null
                : () async {
                    appState.disableCatalogueRefresh();
                    if (!kIsWeb) {
                      Fluttertoast.showToast(msg: 'Music catalogue updating');
                    }
                    updateCatalogueDb().then(
                      (data) => {
                        DbFunctions().getCatalogue().then(
                          (data) => setState(() {
                            appState.setCatalogueList(data);
                          }),
                        ),
                      },
                    );
                    Timer(
                      const Duration(seconds: 4),
                      appState.enableCatalogueRefresh,
                    );
                  },
          ),
        ],
      ),
      body: FutureBuilder(
        future: catalogueFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            );
          } else {
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownMenu(
                        initialSelection: seasonMenuEntries.first,
                        onSelected: (String? value) {
                          setState(() {
                            appState.seasonMenuValue = value!;
                            appState.filterCatalogueListNotify();
                            appState.setNavIndex(0);
                            if (navScrollIndexMapping.isNotEmpty &&
                                _scrollController.isAttached) {
                              _scrollController.scrollTo(
                                index: navScrollIndexMapping.values.toList()[0],
                                duration: const Duration(milliseconds: 500),
                              );
                            }
                          });
                        },
                        dropdownMenuEntries: seasonMenuEntries
                            .map<DropdownMenuEntry<String>>((String value) {
                              return DropdownMenuEntry<String>(
                                value: value,
                                label: value,
                              );
                            })
                            .toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownMenu(
                        initialSelection: partsMenuEntries.first,
                        onSelected: (String? value) {
                          setState(() {
                            appState.partsMenuValue = value!;
                            appState.filterCatalogueListNotify();
                            appState.setNavIndex(0);
                            if (navScrollIndexMapping.isNotEmpty &&
                                _scrollController.isAttached) {
                              _scrollController.scrollTo(
                                index: navScrollIndexMapping.values.toList()[0],
                                duration: const Duration(milliseconds: 500),
                              );
                            }
                          });
                        },
                        dropdownMenuEntries: partsMenuEntries
                            .map<DropdownMenuEntry<String>>((String value) {
                              return DropdownMenuEntry<String>(
                                value: value,
                                label: value,
                              );
                            })
                            .toList(),
                      ),
                    ),
                  ],
                ),
                if (catalogue == null)
                  const ListTile(
                    title: Text(
                      'Catalogue is empty',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                if (catalogue != null)
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: CatalogueWidget(catalogue: catalogue)),
                        SafeArea(
                          child: LayoutBuilder(
                            builder: (context, constraint) {
                              if (navScrollIndexMapping.isEmpty &&
                                  _scrollController.isAttached) {
                                return const SizedBox.shrink();
                              }
                              return SingleChildScrollView(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight: constraint.maxHeight,
                                  ),
                                  child: IntrinsicHeight(
                                    child: NavigationRail(
                                      indicatorColor: Theme.of(
                                        context,
                                      ).colorScheme.tertiary,
                                      destinations: alphabetList
                                          .map<NavigationRailDestination>((
                                            String char,
                                          ) {
                                            return NavigationRailDestination(
                                              label: Text(char),
                                              icon: Text(char),
                                            );
                                          })
                                          .toList(),
                                      selectedIndex: navIndex,
                                      onDestinationSelected: (value) {
                                        setState(() {
                                          appState.setNavIndex(value);
                                          if (_scrollController.isAttached) {
                                            _scrollController.scrollTo(
                                              index: navScrollIndexMapping
                                                  .values
                                                  .toList()[value],
                                              duration: const Duration(
                                                milliseconds: 500,
                                              ),
                                            );
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          }
        },
      ),
    );
  }
}

class CatalogueWidget extends StatelessWidget {
  const CatalogueWidget({super.key, required this.catalogue});

  final List<Catalogue>? catalogue;

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
      itemScrollController: _scrollController,
      scrollOffsetController: scrollOffsetController,
      itemPositionsListener: itemPositionsListener,
      scrollOffsetListener: scrollOffsetListener,
      scrollDirection: Axis.vertical,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: catalogue!.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(catalogue![index].composer),
              subtitle: Text(
                catalogue![index].title,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
        );
      },
    );
  }
}
