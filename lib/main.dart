import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _file = File("zz");
  Uint8List webImage = Uint8List(10);

  uploadImage() async {
    var permissionStatus = Permission.mediaLibrary;

    // MOBILE
    if (!kIsWeb && await permissionStatus.isGranted) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        var selected = File(image.path);

        setState(() {
          _file = selected;
        });
      } else {
        Text("No file selected");
      }
    }
    // WEB
    else if (kIsWeb) {
      print('tuh');
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          _file = File("a");
          webImage = f;
        });
      } else {
        Text("No file selected");
      }
    } else {
      Text("Permission not granted");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Image"),
      ),
      body: Column(
        children: [
          (_file.path == "zz")
              ? const CircleAvatar(
                  backgroundImage: AssetImage("assets/img/playstore.png"),
                  radius: 60,
                )
              : (kIsWeb)
                  ? CircleAvatar(
                      //child: Image.memory(webImage),
                      backgroundImage: Image.memory(webImage).image,
                      radius: 60,
                    )
                  : CircleAvatar(
                      backgroundImage: Image.file(_file).image,
                      // child: Image.file(_file),
                      radius: 60,
                    ),
          SizedBox(
            height: 20,
            width: double.infinity,
          ),
          ElevatedButton(
            onPressed: () => uploadImage(),
            child: Text("Upload"),
          )
        ],
      ),
    );
  }
}
