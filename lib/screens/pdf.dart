import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:holy_cross_music/helper/pdf_generation.dart';
import 'package:holy_cross_music/main.dart';
import 'package:holy_cross_music/models/month.dart';
import 'package:holy_cross_music/models/music.dart';
import 'package:holy_cross_music/screens/widgets.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui';
import 'dart:isolate';

class PdfGeneratePage extends StatefulWidget {
  const PdfGeneratePage({super.key});

  @override
  State<PdfGeneratePage> createState() => _PdfGeneratePageState();
}

class _PdfGeneratePageState extends State<PdfGeneratePage> {
  bool pdfGenerating = false;
  bool fileDownloading = false;

  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();

    // 1. Register the port name
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');

    // 2. Listen for updates (Required for the OS to stay synced)
    _port.listen((dynamic data) {
      String id = data[0];
      int status = data[1];
      int progress = data[2];
      setState(() {}); 
    });

    // 3. Register the callback we defined in main.dart
    FlutterDownloader.registerCallback(downloadCallback); 
  }

  @override
  void dispose() {
    // 4. Clean up to prevent memory leaks
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  void generate() async {
    setState(() {
      pdfGenerating = true;
    });
 
    var response = await generatePdf();

    if (response) {
      if (!kIsWeb) {
        Fluttertoast.showToast(msg: 'PDF generated successfully');
      }
    } else {
      if (!kIsWeb) {
        Fluttertoast.showToast(msg: 'Failed to generate PDF');
      }
    }

    setState(() {
      pdfGenerating = false;
    });
  }

    void download() async {
    setState(() {
      fileDownloading = true;
    });
 
    var response = await downloadPdf();

    if (response) {
      if (!kIsWeb) {
        Fluttertoast.showToast(msg: 'PDF downloaded successfully');
      }
    } else {
      if (!kIsWeb) {
        Fluttertoast.showToast(msg: 'Failed to download PDF');
      }
    }

    setState(() {
      fileDownloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 200,
            width: double.infinity,
            child: Center(
              child: pdfGenerating ? CircularProgressIndicator() : FilledButton(
                onPressed: () {
                  generate();
                },
                child: Text(
                'Generate PDF',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                ),
              ),
            ),
          ),
          SizedBox(
            height: 200,
            width: double.infinity,
            child: Center(
              child: fileDownloading ? CircularProgressIndicator() : FilledButton(
                onPressed: () {
                  download();
                },
                child: Text(
                'Download PDF',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                ),
              ),
            ),
          )
        ],
      )
    );
  }
}