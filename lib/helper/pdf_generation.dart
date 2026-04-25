import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart' as http;

Future<bool> generatePdf() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final idToken = await user.getIdToken();
    final url = Uri.parse('https://music-list-pdf-319589565078.europe-west2.run.app/generate-music-list');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $idToken',
      }
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Failed to generate PDF: ${response.statusCode} - ${response.body}');
      return false;
    }
  } catch (e) {
    print('Error generating PDF: $e');
    return false;
  }
}

Future<bool> downloadPdf() async {
  try {
    final ref = FirebaseStorage.instance.ref().child('music_lists/music_list.pdf');
    final url = await ref.getDownloadURL();

    final appDocDir = Platform.isAndroid 
    ? '/storage/emulated/0/Download' 
    : (await getApplicationDocumentsDirectory()).path;

    final taskId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: appDocDir,
      fileName: "Music_List_${DateTime.now().millisecondsSinceEpoch}.pdf",
      showNotification: true,
      openFileFromNotification: true,
      saveInPublicStorage: true,
    );

    return true;
  } catch (e) {
    print("Download failed: $e");
    return false;
  }
}
