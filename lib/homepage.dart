import 'dart:io';
import 'package:camera/zoom.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

ValueNotifier<List> database = ValueNotifier([]);

class Gallery extends StatefulWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  @override
  void initState() {
    Directory directory =
        Directory.fromUri(Uri.parse('/data/user/0/com.example.camera'));
    getitems(directory);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Gallery'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final image =
              await ImagePicker().pickImage(source: ImageSource.camera);
          if (image == null) {
            return;
          } else {
            File imagepath = File(image.path);
            await imagepath.copy(
                '/data/user/0/com.example.camera/image_(${DateTime.now()}).jpg');
            Directory directory = Directory.fromUri(
                Uri.parse('/data/user/0/com.example.camera/'));
            getitems(directory);
            GallerySaver.saveImage(imagepath.path);
          }
        },
        child: Icon(Icons.camera),
      ),
      body: ValueListenableBuilder(
          valueListenable: database,
          builder: (context, List data, _) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.extent(
                  maxCrossAxisExtent: 150,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: List.generate(data.length, (index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => Zoom(data: data[index])));
                      },
                      child: Hero(
                          tag: data[index],
                          child: Image.file(File(data[index].toString()))),
                    );
                  })),
            );
          }),
    );
  }
}

getitems(Directory directory) async {
  final listDir = await directory.list().toList();
  database.value.clear();
  listDir.forEach((element) {
    if (element.path
            .substring((element.path.length - 4), (element.path.length)) ==
        '.jpg') {
      database.value.add(element.path);
      database.notifyListeners();
    }
  });
}
