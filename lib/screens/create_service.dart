import 'package:flutter/material.dart';
import 'package:holy_cross_music/app_state.dart';
import 'package:holy_cross_music/models/music.dart';
import 'package:holy_cross_music/models/service.dart';
import 'package:holy_cross_music/screens/widgets.dart';
import 'package:holy_cross_music/utils/string_extension.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

enum TemplateItem {
  hymn,
  psalm,
  gradual_psalm,
  gradual_proper,
  introit,
  magnificat,
  nunc_dimittis,
  anthem,
  motet,
  benediction_proper,
  te_deum,
  benedictus,
  jubilate,
  benedicite,
  mass_setting,
}

List<PopupMenuItem<TemplateItem>> eucharistItems = [
  const PopupMenuItem(value: TemplateItem.hymn, child: Text('Hymn')),
  const PopupMenuItem(
    value: TemplateItem.gradual_psalm,
    child: Text('Gradual Psalm'),
  ),
  // const PopupMenuItem(
  //   value: TemplateItem.gradual_proper,
  //   child: Text('Gradual Proper'),
  // ),
  const PopupMenuItem(
    value: TemplateItem.mass_setting,
    child: Text('Mass Setting'),
  ),
  const PopupMenuItem(value: TemplateItem.anthem, child: Text('Anthem')),
  const PopupMenuItem(value: TemplateItem.motet, child: Text('Motet')),
];

List<PopupMenuItem<TemplateItem>> mattinsItems = [
  const PopupMenuItem(value: TemplateItem.hymn, child: Text('Hymn')),
  const PopupMenuItem(value: TemplateItem.psalm, child: Text('Psalm')),
  const PopupMenuItem(value: TemplateItem.introit, child: Text('Introit')),
  // const PopupMenuItem(value: TemplateItem.te_deum, child: Text('Te Deum')),
  // const PopupMenuItem(
  //   value: TemplateItem.benedictus,
  //   child: Text('Benedictus'),
  // ),
  // const PopupMenuItem(value: TemplateItem.jubilate, child: Text('Jubilate')),
  // const PopupMenuItem(
  //   value: TemplateItem.benedicite,
  //   child: Text('Benedicite'),
  // ),
  const PopupMenuItem(value: TemplateItem.anthem, child: Text('Anthem')),
];

List<PopupMenuItem<TemplateItem>> evensongItems = [
  const PopupMenuItem(value: TemplateItem.hymn, child: Text('Hymn')),
  const PopupMenuItem(value: TemplateItem.psalm, child: Text('Psalm')),
  const PopupMenuItem(value: TemplateItem.introit, child: Text('Introit')),
  const PopupMenuItem(value: TemplateItem.anthem, child: Text('Anthem')),
  const PopupMenuItem(value: TemplateItem.motet, child: Text('Motet')),
  const PopupMenuItem(
    value: TemplateItem.magnificat,
    child: Text('Magnificat'),
  ),
  const PopupMenuItem(
    value: TemplateItem.nunc_dimittis,
    child: Text('Nunc Dimittis'),
  ),

  // const PopupMenuItem(
  //   value: TemplateItem.benediction_proper,
  //   child: Text('Benediction Proper'),
  // ),
];

class CreateServiceScreen extends StatefulWidget {
  const CreateServiceScreen({
    super.key,
    required this.templateName,
    required this.serviceIndex,
  });

  final ServiceTemplate templateName;
  final int serviceIndex;

  @override
  State<CreateServiceScreen> createState() => _CreateServiceScreenState();
}

class _CreateServiceScreenState extends State<CreateServiceScreen> {
  List<CreateMusicItem> _musicItems = <CreateMusicItem>[
    // CreateMusicItem(musicType: 'Hymn', title: '100', editing: false),
  ];
  TemplateItem? selectedItem;
  int editStateIndex = -1;
  late CreateServiceItem serviceItem;

  void _setEditStateIndex(int newValue) {
    setState(() {
      editStateIndex = newValue;
    });
  }

  void _setMusicItems(List<CreateMusicItem> musicItems) {
    setState(() {
      _musicItems = musicItems;
    });
  }

  void _setExistingMusicItems(List<Music> musicItems) {
    setState(() {
      _musicItems = musicItems.map((item) {
        return CreateMusicItem.fromMusic(item);
      }).toList();
    });
  }

  Service createService(
    String? serviceTitle,
    String serviceDate,
    String serviceTime,
    String? rehearsalTime,
    String? organist,
    ServiceTemplate serviceTemplate,
  ) {
    if (serviceTitle == '') {
      serviceTitle = serviceTemplate.name.replaceAll('_', ' ').capitalizeAll();
    }

    List<Music> serviceMusic = _musicItems
        .map(
          (e) => Music.fromCreateMusicItem(
            e,
            serviceTitle as String,
            serviceDate,
            serviceTime,
            rehearsalTime,
            organist,
          ),
        )
        .toList();

    return Service.createService(serviceDate, serviceMusic, serviceTemplate);
  }

  Map<ServiceTemplate, dynamic> serviceTypeMap = {
    ServiceTemplate.evensong: evensongItems,
    ServiceTemplate.eucharist: eucharistItems,
    ServiceTemplate.mattins: mattinsItems,
  };

  var dateMaskFormatter = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.eager,
  );

  var timeMaskFormatter = MaskTextInputFormatter(
    mask: '##:##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.eager,
  );

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();

    final _controller = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final double old = _controller.position.pixels;
      if (_controller.hasClients &&
          _controller.position.maxScrollExtent - old != 0) {
        _controller.animateTo(
          _controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 10),
          curve: Curves.easeOut,
        );
      }
    });

    final _formKey = GlobalKey<FormState>();
    final _cardFormKey = GlobalKey<FormState>();

    serviceItem = CreateServiceItem.fromService(
      appState.currentBuildService,
      widget.templateName,
    );

    if (serviceItem.music != null) {
      _setExistingMusicItems(serviceItem.music as List<Music>);
    }

    ServiceTemplate serviceTemplate = widget.templateName;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appState.serviceColour,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        title: Text(
          'Create Services',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      floatingActionButton: PopupMenuButton<TemplateItem>(
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
        onSelected: (TemplateItem item) {
          if (editStateIndex != -1) {
            final snackBar = SnackBar(
              content: const Text(
                'Please finish editing the current music item',
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            setState(() {
              selectedItem = item;
              _musicItems.add(
                CreateMusicItem(
                  musicType: item.name.replaceAll('_', ' ').capitalizeAll(),
                  editing: true,
                ),
              );
              editStateIndex = _musicItems.length - 1;
            });
          }
        },
        itemBuilder: (context) => serviceTypeMap[widget.templateName],
        offset: Offset(-70, -150),
      ),
      body: SingleChildScrollView(
        controller: _controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpansionTile(
              title: Text('Service information'),
              controlAffinity: ListTileControlAffinity.leading,
              initiallyExpanded: true,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          serviceTemplate.name.capitalize(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              _formKey.currentState!.reset();
                              Service service = createService(
                                serviceItem.serviceType,
                                serviceItem.date as String,
                                serviceItem.time as String,
                                serviceItem.rehearsalTime,
                                serviceItem.organist,
                                serviceTemplate,
                              );
                              setState(() {
                                appState.addBuiltService(
                                  service,
                                  widget.serviceIndex,
                                );
                              });
                              Navigator.of(context).pop();
                            }
                          },
                          style: ButtonStyle(
                            shadowColor: WidgetStatePropertyAll(
                              Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          child: Text(
                            'Save',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            labelText: 'Service Title',
                          ),
                          initialValue: serviceItem.serviceType,
                          validator: (value) {
                            return null;
                          },
                          // onEditingComplete: () {
                          //   _formKey.currentState!._fields
                          // },
                          onSaved: (value) {
                            setState(() {
                              serviceItem.serviceType = value!;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: TextFormField(
                          inputFormatters: [dateMaskFormatter],
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            labelText: 'Service Date *',
                            hintText: 'dd/mm/yyyy',
                          ),
                          keyboardType: TextInputType.datetime,
                          initialValue: serviceItem.date,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a date.';
                            }
                            try {
                              DateFormat('dd/MM/yyyy').parseStrict(value);
                            } catch (e) {
                              return 'Please enter a valid date.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            var dateSplit = value?.split('/');
                            serviceItem.date =
                                '${dateSplit?[2]}${dateSplit?[1]}${dateSplit?[0]}';
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: TextFormField(
                          inputFormatters: [timeMaskFormatter],
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            labelText: 'Service Time *',
                            hintText: 'hh:mm',
                          ),
                          keyboardType: TextInputType.datetime,
                          initialValue: serviceItem.time,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a time.';
                            }
                            try {
                              DateFormat('hh:mm').parseStrict(value);
                            } catch (e) {
                              return 'Please enter a valid time.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            serviceItem.time =
                                '${value?.replaceAll(':', '')}00';
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: TextFormField(
                          inputFormatters: [timeMaskFormatter],
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            labelText: 'Rehearsal Time',
                            hintText: 'hh:mm',
                          ),
                          keyboardType: TextInputType.datetime,
                          initialValue: serviceItem.rehearsalTime,
                          validator: (value) {
                            if (value != null && value != '') {
                              try {
                                DateFormat('hh:mm').parseStrict(value);
                              } catch (e) {
                                return 'Please enter a valid time.';
                              }
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value != null && value != '') {
                              serviceItem.rehearsalTime =
                                  '${value.replaceAll(':', '')}00';
                            } else {
                              serviceItem.rehearsalTime = '';
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            labelText: 'Organist',
                          ),
                          initialValue: serviceItem.organist,
                          validator: (value) {
                            return null;
                          },
                          onSaved: (value) {
                            serviceItem.organist = value!;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            labelText: 'Service Colour',
                          ),
                          initialValue: serviceItem.organist,
                          validator: (value) {
                            return null;
                          },
                          onSaved: (value) {
                            serviceItem.colour = value!;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Music'),
              controlAffinity: ListTileControlAffinity.leading,
              initiallyExpanded: true,
              children: [
                ReorderableListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  onReorder: (int oldIndex, int newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final CreateMusicItem item = _musicItems.removeAt(
                        oldIndex,
                      );
                      _musicItems.insert(newIndex, item);
                    });
                  },
                  children: [
                    for (int index = 0; index < _musicItems.length; index += 1)
                      if (index == editStateIndex) ...[
                        if (_musicItems[index].musicType == 'Hymn')
                          HymnFormWidget(
                            key: Key('$index'),
                            index: index,
                            cardFormKey: _cardFormKey,
                            musicItems: _musicItems,
                            setEditState: _setEditStateIndex,
                            setMusicItems: _setMusicItems,
                          ),
                        if ([
                          'Psalm',
                          'Gradual Psalm',
                        ].contains(_musicItems[index].musicType))
                          PsalmFormWidget(
                            key: Key('$index'),
                            index: index,
                            cardFormKey: _cardFormKey,
                            musicItems: _musicItems,
                            setEditState: _setEditStateIndex,
                            setMusicItems: _setMusicItems,
                          ),
                        if ([
                          'Introit',
                          'Magnificat',
                          'Nunc Dimittis',
                          'Anthem',
                          'Motet',
                          'Mass Setting',
                        ].contains(_musicItems[index].musicType))
                          GenericMusicFormWidget(
                            key: Key('$index'),
                            index: index,
                            cardFormKey: _cardFormKey,
                            musicItems: _musicItems,
                            setEditState: _setEditStateIndex,
                            setMusicItems: _setMusicItems,
                          ),
                      ] else ...[
                        if (_musicItems[index].musicType == 'Hymn')
                          HymnWidget(
                            key: Key('$index'),
                            index: index,
                            musicItem: _musicItems[index],
                            setEditState: _setEditStateIndex,
                          ),
                        if ([
                          'Psalm',
                          'Gradual Psalm',
                        ].contains(_musicItems[index].musicType))
                          PsalmWidget(
                            key: Key('$index'),
                            index: index,
                            musicItem: _musicItems[index],
                            setEditState: _setEditStateIndex,
                          ),
                        if ([
                          'Introit',
                          'Magnificat',
                          'Nunc Dimittis',
                          'Anthem',
                          'Motet',
                          'Mass Setting',
                        ].contains(_musicItems[index].musicType))
                          GenericMusicWidget(
                            key: Key('$index'),
                            index: index,
                            musicItem: _musicItems[index],
                            setEditState: _setEditStateIndex,
                          ),
                      ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HymnWidget extends StatelessWidget {
  const HymnWidget({
    super.key,
    required this.index,
    required this.musicItem,
    required this.setEditState,
  });

  final int index;
  final CreateMusicItem musicItem;
  final ValueChanged<int> setEditState;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key('$index'),
      child: ListTile(
        title: Text(musicItem.musicType),
        subtitle: HymnTitleFormatting(title: musicItem.title as String),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setEditState(index);
              },
            ),
            Icon(Icons.menu),
          ],
        ),
      ),
    );
  }
}

class PsalmWidget extends StatelessWidget {
  const PsalmWidget({
    super.key,
    required this.index,
    required this.musicItem,
    required this.setEditState,
  });

  final int index;
  final CreateMusicItem musicItem;
  final ValueChanged<int> setEditState;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key('$index'),
      child: ListTile(
        title: Text(musicItem.musicType),
        subtitle: PsalmTitleFormatting(title: musicItem.title as String),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setEditState(index);
              },
            ),
            Icon(Icons.menu),
          ],
        ),
      ),
    );
  }
}

class GenericMusicWidget extends StatelessWidget {
  const GenericMusicWidget({
    super.key,
    required this.index,
    required this.musicItem,
    required this.setEditState,
  });

  final int index;
  final CreateMusicItem musicItem;
  final ValueChanged<int> setEditState;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key('$index'),
      child: ListTile(
        title: Text(musicItem.musicType),
        subtitle: Padding(
          padding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
          child: Text.rich(
            TextSpan(
              children: [
                if (musicItem.title != '')
                  TextSpan(
                    text: musicItem.title,
                    style: const TextStyle(fontSize: 18),
                  ),
                if (musicItem.title != '' && musicItem.composer != '')
                  TextSpan(text: '\n'),
                if (musicItem.composer != '')
                  TextSpan(
                    text: musicItem.composer as String,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 16,
                    ),
                  ),
              ],
            ),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (musicItem.link != '' && musicItem.link != null)
              PlayLinkWidget(musicLink: musicItem.link),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setEditState(index);
              },
            ),
            Icon(Icons.menu),
          ],
        ),
      ),
    );
  }
}

class HymnFormWidget extends StatelessWidget {
  const HymnFormWidget({
    super.key,
    required this.index,
    required GlobalKey<FormState> cardFormKey,
    required this.musicItems,
    required this.setEditState,
    required this.setMusicItems,
  }) : _cardFormKey = cardFormKey;

  final int index;
  final GlobalKey<FormState> _cardFormKey;
  final List<CreateMusicItem> musicItems;
  final ValueChanged<int> setEditState;
  final ValueChanged<List<CreateMusicItem>> setMusicItems;

  @override
  Widget build(BuildContext context) {
    CreateMusicItem updatedMusicItem = musicItems[index];
    HymnItem hymnItem = HymnItem.fromCreateMusicItem(updatedMusicItem);
    bool deleteOnCancel = hymnItem.number == null;
    return Card(
      key: Key('$index'),
      child: Form(
        key: _cardFormKey,
        child: Column(
          children: [
            ListTile(
              title: Text(
                hymnItem.musicType,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 0.0,
                horizontal: 16.0,
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  labelText: 'Hymn Number *',
                ),
                initialValue: hymnItem.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Hymn number.';
                  }
                  return null;
                },
                onSaved: (value) {
                  hymnItem.number = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  labelText: 'Hymn Title',
                ),
                initialValue: hymnItem.title,
                validator: (value) {
                  return null;
                },
                onSaved: (value) {
                  hymnItem.title = value!;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 16.0,
              ),
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_cardFormKey.currentState!.validate()) {
                          _cardFormKey.currentState!.save();
                          _cardFormKey.currentState!.reset();
                          updatedMusicItem.title =
                              '${hymnItem.number}#${hymnItem.title}';
                          musicItems[index] = updatedMusicItem;
                          setMusicItems(musicItems);
                          setEditState(-1);
                        }
                      },
                      style: ButtonStyle(
                        shadowColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _cardFormKey.currentState!.reset();
                        if (deleteOnCancel) {
                          musicItems.removeAt(index);
                          setMusicItems(musicItems);
                        }
                        setEditState(-1);
                      },
                      style: ButtonStyle(
                        shadowColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: IconButton(
                      onPressed: () {
                        _cardFormKey.currentState!.reset();
                        musicItems.removeAt(index);
                        setMusicItems(musicItems);
                        setEditState(-1);
                      },
                      style: ButtonStyle(
                        shadowColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      icon: Icon(Icons.delete, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PsalmFormWidget extends StatelessWidget {
  const PsalmFormWidget({
    super.key,
    required this.index,
    required GlobalKey<FormState> cardFormKey,
    required this.musicItems,
    required this.setEditState,
    required this.setMusicItems,
  }) : _cardFormKey = cardFormKey;

  final int index;
  final GlobalKey<FormState> _cardFormKey;
  final List<CreateMusicItem> musicItems;
  final ValueChanged<int> setEditState;
  final ValueChanged<List<CreateMusicItem>> setMusicItems;

  @override
  Widget build(BuildContext context) {
    CreateMusicItem updatedMusicItem = musicItems[index];
    PsalmItem psalmItem = PsalmItem.fromCreateMusicItem(updatedMusicItem);
    bool deleteOnCancel = psalmItem.number == null;
    return Card(
      key: Key('$index'),
      child: Form(
        key: _cardFormKey,
        child: Column(
          children: [
            ListTile(
              title: Text(
                psalmItem.musicType,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 16.0,
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  labelText: 'Psalm Number *',
                ),
                keyboardType: TextInputType.number,
                initialValue: psalmItem.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Psalm number.';
                  }
                  return null;
                },
                onSaved: (value) {
                  psalmItem.number = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  labelText: 'Psalm Verses',
                ),
                initialValue: psalmItem.verses,
                validator: (value) {
                  return null;
                },
                onSaved: (value) {
                  if (value != '' && value![0] != 'v') {
                    value = 'v$value';
                  }
                  psalmItem.verses = value!;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_cardFormKey.currentState!.validate()) {
                          _cardFormKey.currentState!.save();
                          _cardFormKey.currentState!.reset();
                          updatedMusicItem.title =
                              '${psalmItem.number} ${psalmItem.verses}';
                          musicItems[index] = updatedMusicItem;
                          setMusicItems(musicItems);
                          setEditState(-1);
                        }
                      },
                      style: ButtonStyle(
                        shadowColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _cardFormKey.currentState!.reset();
                        if (deleteOnCancel) {
                          musicItems.removeAt(index);
                          setMusicItems(musicItems);
                        }
                        setEditState(-1);
                      },
                      style: ButtonStyle(
                        shadowColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: IconButton(
                      onPressed: () {
                        _cardFormKey.currentState!.reset();
                        musicItems.removeAt(index);
                        setMusicItems(musicItems);
                        setEditState(-1);
                      },
                      style: ButtonStyle(
                        shadowColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      icon: Icon(Icons.delete, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GenericMusicFormWidget extends StatelessWidget {
  const GenericMusicFormWidget({
    super.key,
    required this.index,
    required GlobalKey<FormState> cardFormKey,
    required this.musicItems,
    required this.setEditState,
    required this.setMusicItems,
  }) : _cardFormKey = cardFormKey;

  final int index;
  final GlobalKey<FormState> _cardFormKey;
  final List<CreateMusicItem> musicItems;
  final ValueChanged<int> setEditState;
  final ValueChanged<List<CreateMusicItem>> setMusicItems;

  @override
  Widget build(BuildContext context) {
    CreateMusicItem updatedMusicItem = musicItems[index];
    GenericMusicItem musicItem = GenericMusicItem.fromCreateMusicItem(
      updatedMusicItem,
    );
    bool deleteOnCancel = musicItem.title == null && musicItem.composer == null;
    return Card(
      key: Key('$index'),
      child: Form(
        key: _cardFormKey,
        child: Column(
          children: [
            ListTile(
              title: Text(
                musicItem.musicType,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  labelText: 'Title',
                ),
                initialValue: musicItem.title,
                validator: (value) {
                  return null;
                },
                onSaved: (value) {
                  musicItem.title = value!;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  labelText: 'Composer',
                ),
                initialValue: musicItem.composer,
                validator: (value) {
                  return null;
                },
                onSaved: (value) {
                  musicItem.composer = value!;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 16.0,
              ),
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_cardFormKey.currentState!.validate()) {
                          _cardFormKey.currentState!.save();
                          _cardFormKey.currentState!.reset();
                          updatedMusicItem.title = musicItem.title;
                          updatedMusicItem.composer = musicItem.composer;
                          musicItems[index] = updatedMusicItem;
                          setMusicItems(musicItems);
                          setEditState(-1);
                        }
                      },
                      style: ButtonStyle(
                        shadowColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _cardFormKey.currentState!.reset();
                        if (deleteOnCancel) {
                          musicItems.removeAt(index);
                          setMusicItems(musicItems);
                        }
                        setEditState(-1);
                      },
                      style: ButtonStyle(
                        shadowColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: IconButton(
                      onPressed: () {
                        _cardFormKey.currentState!.reset();
                        musicItems.removeAt(index);
                        setMusicItems(musicItems);
                        setEditState(-1);
                      },
                      style: ButtonStyle(
                        shadowColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      icon: Icon(Icons.delete, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
