import 'package:flutter/material.dart';
import 'package:holy_cross_music/models/music.dart';
import 'package:holy_cross_music/models/service.dart';
import 'package:holy_cross_music/screens/widgets.dart';
import 'package:holy_cross_music/utils/string_extension.dart';

enum SampleItem {
  hymn,
  psalm,
  introit,
  magnificat,
  nuncDimittis,
  anthem,
  benedictionProper,
}

class CreateServiceScreen extends StatefulWidget {
  const CreateServiceScreen({super.key});

  @override
  State<CreateServiceScreen> createState() => _CreateServiceScreenState();
}

class _CreateServiceScreenState extends State<CreateServiceScreen> {
  List<CreateMusicItem> _musicItems = <CreateMusicItem>[
    CreateMusicItem(musicType: 'Hymn', title: '100', editing: false),
  ];
  SampleItem? selectedItem;
  int editStateIndex = -1;

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

  List<PopupMenuItem<SampleItem>> evensongItems = [
    const PopupMenuItem(value: SampleItem.hymn, child: Text('Hymn')),
    const PopupMenuItem(value: SampleItem.psalm, child: Text('Psalm')),
    const PopupMenuItem(value: SampleItem.introit, child: Text('Introit')),
    const PopupMenuItem(
      value: SampleItem.magnificat,
      child: Text('Magnificat'),
    ),
    const PopupMenuItem(
      value: SampleItem.nuncDimittis,
      child: Text('Nunc Dimittis'),
    ),
    const PopupMenuItem(value: SampleItem.anthem, child: Text('Anthem')),
    const PopupMenuItem(
      value: SampleItem.benedictionProper,
      child: Text('Benediction Proper'),
    ),
  ];

  Service createService() {
    List<Music> serviceMusic = [];
  }

  @override
  Widget build(BuildContext context) {
    final _controller = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final double old = _controller.position.pixels;
      final double oldMax = _controller.position.maxScrollExtent;
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
    String serviceTitle = '';
    String serviceDate = '';

    return Scaffold(
      floatingActionButton: PopupMenuButton<SampleItem>(
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
        onSelected: (SampleItem item) {
          setState(() {
            selectedItem = item;
            _musicItems.add(
              CreateMusicItem(musicType: item.name.capitalize(), editing: true),
            );
            editStateIndex = _musicItems.length - 1;
          });
        },
        itemBuilder: (context) => evensongItems,
        offset: Offset(-70, -150),
      ),
      body: SingleChildScrollView(
        controller: _controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      'Evensong',
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
                          createService();
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
                        labelText: 'Service Title',
                      ),
                      validator: (value) {
                        return null;
                      },
                      onSaved: (value) {
                        serviceTitle = value!;
                      },
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
                        labelText: 'Service Date',
                      ),
                      validator: (value) {
                        return null;
                      },
                      onSaved: (value) {
                        serviceDate = value!;
                      },
                    ),
                  ),
                ],
              ),
            ),
            ReorderableListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final CreateMusicItem item = _musicItems.removeAt(oldIndex);
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
                    if (_musicItems[index].musicType == 'Psalm')
                      PsalmFormWidget(
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
                    if (_musicItems[index].musicType == 'Psalm')
                      PsalmWidget(
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
