import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Persona Builder',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Persona Builder - Build'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({
    Key? key,
    required this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          PersonaBanner(
            bannerHeight: 300,
            photoHeight: 320,
            photoMargin: 25
          ),
        ]
      )
    );
  }
}

class PersonaBanner extends StatelessWidget {
  const PersonaBanner({
    Key? key,
    required this.bannerHeight,
    required this.photoHeight,
    required this.photoMargin
  }) : super(key: key);

  final double bannerHeight;
  final double photoHeight;
  final double photoMargin;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    const photoRatio = 4 / 3;

    const primaryColourStop = 0.60;
    const secondaryColourStop = 0.8;

    return Row(
      children: [
        Container(
          width: mediaQuery.size.width,
          height: bannerHeight,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [primaryColourStop, primaryColourStop, secondaryColourStop, secondaryColourStop, 1],
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.secondary,
                  Colors.transparent,
                  Colors.transparent
                ]
              )
          ),
          child: Row(
            children: [
              Column(
                children: [
                  PersonaProfilePicture(
                    height: photoHeight,
                    photoRatio: photoRatio,
                    photoMargin: photoMargin,
                    uploadButton: (onPressed) =>
                      MaterialButton (
                        minWidth: double.infinity,
                        color: Colors.black.withOpacity(0.1),
                        child: const Icon(
                          Icons.file_upload_outlined,
                          size: 50,
                          color: Colors.white,
                        ),
                        onPressed: onPressed
                      )
                  )
                ]
              ),
              Column(
                children: const [

                ],
              )
            ]
          )
        )
      ],
    );
  }
}

class PersonaProfilePicture extends StatefulWidget {
  final double height;
  final double photoRatio;
  final double photoMargin;
  final Widget Function(void Function()) uploadButton;
  final int imageQuality;
  final Widget placeholder;

  const PersonaProfilePicture({
    Key? key,
    required this.height,
    required this.photoRatio,
    required this.photoMargin,
    required this.uploadButton,
    this.imageQuality = 50,
    this.placeholder = const Placeholder()
  }) : super(key: key);

  @override
  State<PersonaProfilePicture> createState() => _PersonaProfilePictureState();
}

class _PersonaProfilePictureState extends State<PersonaProfilePicture> {
  File? _image;
  ImagePicker? imagePicker;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  _pickImage(ImageSource sourceType) async {
    XFile? image = await imagePicker?.pickImage(
        source: sourceType,
        imageQuality: widget.imageQuality,
        preferredCameraDevice: CameraDevice.rear
    );
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.height,
      height: widget.height / widget.photoRatio,
      alignment: Alignment.bottomLeft,
      margin: EdgeInsets.only(
        left: widget.photoMargin,
        top: widget.photoMargin
      ),
      color: Theme.of(context).colorScheme.secondary,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          getProfilePicture(),
          widget.uploadButton(
            () {_pickImage(ImageSource.gallery);})
        ],
      ),
    );
  }

  Widget getProfilePicture() {
    return _image != null ?
      getImage(_image!, double.infinity, double.infinity) :
      widget.placeholder;
  }

  Image getImage(File file, double width, double height) {
    return kIsWeb ?
      getImageFromWeb(file, width, height) :
      getImageFromMobile(file, width, height);
  }

  Image getImageFromMobile(File file, double width, double height) {
    return Image.file(
      file,
      width: width,
      height: height,
      fit: BoxFit.fitHeight
    );
  }

  Image getImageFromWeb(File file, double width, double height) {
    return Image.network(
      file.path,
      width: width,
      height: height,
      fit: BoxFit.fitHeight
    );
  }
}