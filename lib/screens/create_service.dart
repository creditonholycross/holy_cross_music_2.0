import 'package:flutter/material.dart';
import 'package:holy_cross_music/models/music.dart';
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
    CreateMusicItem(musicType: 'Hymn', title: '100'),
    CreateMusicItem(musicType: 'Hymn', title: '101'),
    CreateMusicItem(musicType: 'Hymn', title: '102'),
  ];
  SampleItem? selectedItem;

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
              CreateMusicItem(
                musicType: item.name.capitalize(),
                title: 'title',
              ),
            );
          });
        },
        itemBuilder: (context) => [
          const PopupMenuItem(value: SampleItem.hymn, child: Text('Hymn')),
          const PopupMenuItem(value: SampleItem.psalm, child: Text('Psalm')),
          const PopupMenuItem(
            value: SampleItem.introit,
            child: Text('Introit'),
          ),
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
        ],
        offset: Offset(-70, -150),
      ),
      body: SingleChildScrollView(
        controller: _controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 16.0),
              child: Text(
                'Evensong',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            Form(
              key: _formKey,
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

                        border: OutlineInputBorder(),
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

                        border: OutlineInputBorder(),
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
                  Card(
                    key: Key('$index'),
                    child: ListTile(
                      title: Text(_musicItems[index].musicType),
                      subtitle: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: _musicItems[index].title,
                              style: const TextStyle(fontSize: 18),
                            ),
                            // TextSpan(
                            //   text: ' title',
                            //   style: const TextStyle(
                            //     fontStyle: FontStyle.italic,
                            //     fontSize: 16,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      trailing: Icon(Icons.menu),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
