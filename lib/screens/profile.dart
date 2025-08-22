import 'dart:io';

import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:holy_cross_music/app_state.dart';
import 'package:image_picker/image_picker.dart';

import 'package:holy_cross_music/screens/auth_gate.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _onImageButtonPressed(
    BuildContext context,
    ApplicationState appState,
  ) async {
    if (context.mounted) {
      try {
        final XFile? pickedFile = await _picker.pickImage(
          source: ImageSource.gallery,
        );
        if (pickedFile != null) {
          uploadPhoto(pickedFile);
          setState(() {
            appState.profilePhotoPath = pickedFile.path;
          });
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> uploadPhoto(XFile file) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('profilePhotoPath', file.path);
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();
    return ProfileScreen(
      appBar: AppBar(title: const Text('User Profile')),
      avatar: Center(
        child: Stack(
          children: [
            showUserImage(appState.profilePhotoPath),
            // if (onPressed != null && !vieweOnly)
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () => _onImageButtonPressed(context, appState),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Icon(Icons.camera_alt, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        SignedOutAction((context) {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => const AuthGate()));
        }),
      ],
      children: [const Divider()],
    );
  }

  UserAvatar showUserImage(String? imageUrl) {
    return UserAvatar(photoPath: imageUrl);
  }
}

class UserAvatar extends StatefulWidget {
  final double? size;
  final ShapeBorder? shape;
  final Color? placeholderColor;
  final String? photoPath;
  const UserAvatar({
    super.key,
    this.size,
    this.shape,
    this.placeholderColor,
    this.photoPath,
  });

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  ShapeBorder get shape => widget.shape ?? const CircleBorder();
  Color get placeholderColor => widget.placeholderColor ?? Colors.grey;
  double get size => widget.size ?? 120;
  String? get photoPath => widget.photoPath;

  Widget _imageFrameBuilder(
    BuildContext context,
    Widget? child,
    int? frame,
    bool? _,
  ) {
    if (frame == null) {
      return Container(color: placeholderColor);
    }

    return child!;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: ClipPath(
        clipper: ShapeBorderClipper(shape: shape),
        clipBehavior: Clip.hardEdge,
        child: photoPath != null
            ? Image.file(
                File(photoPath!),
                width: size,
                // height: size,
                cacheWidth: size.toInt(),
                // cacheHeight: size.toInt(),
                fit: BoxFit.cover,
                frameBuilder: _imageFrameBuilder,
              )
            : Center(
                child: Icon(
                  Icons.account_circle,
                  size: size,
                  color: placeholderColor,
                ),
              ),
      ),
    );
  }
}
