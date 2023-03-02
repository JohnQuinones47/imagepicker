import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const ImagePickerApp(title: 'Flutter Demo Home Page'),
    );
  }
}


class ImagePickerApp extends StatefulWidget {
  const ImagePickerApp({Key? key, required String title}) : super(key: key);


  @override
 ImagePickerAppState createState() => ImagePickerAppState();
}

class ImagePickerAppState extends State<ImagePickerApp> {
  File? _image;

  Future getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imagePermanent = await saveFilePermanently(image.path);

      setState(() {
        this._image = imagePermanent;
      });
    } on PlatformException catch(e) {
        print("Failed to pick image: $e");

    }
  }

  Future<File> saveFilePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Pick an Image"),
        ),
        body: Center(
          child: Column(children: [
            const SizedBox (height: 40,),
            _image != null ? Image.file(_image!, width: 250, height: 250, fit: BoxFit.cover): Image.network('https://picsum.photos/250?image=9'),
             SizedBox(height: 40,),
            CustomButton(
                title: "Pick from Gallery",
                icon: Icons.image_outlined,
                onClick: () => getImage(ImageSource.gallery),
                ),
            CustomButton(
                title: "Pick from Camera",
                icon: Icons.camera,
                onClick: () => getImage(ImageSource.camera)),
          ],
        ),
      ),
    );

}



Widget CustomButton({required String title, required IconData icon, required VoidCallback onClick} ) {

    return Container(
      width: 280,
      child: ElevatedButton(
          onPressed: onClick,
      child: Row(children:  [
        Icon(icon),
        const SizedBox(
          width: 20,
        ),
        Text(title),
      ],
      )
      ),
    );
}
}