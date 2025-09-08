import 'package:flutter/material.dart';
import 'package:holy_cross_music/models/service.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

class RequestDeleteUserScreen extends StatelessWidget {
  const RequestDeleteUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Service.serviceColor(
          'base',
          Theme.of(context).colorScheme.brightness,
        ),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Account Deletion', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: GptMarkdown('''
              ### To delete your account, follow these steps:
              
              1. [Login](https://crediton-holy-cross-music.web.app/) to the app
              2. Click on the profile icon in the top right corner
              3. Click on "Delete account"
              4. Re-enter your email and password and click "Delete account"

              On the account being deleted, all stored information from the account
               (email address) is deleted.
              '''),
          ),
        ],
      ),
    );
  }
}
