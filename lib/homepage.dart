import 'dart:io';

// import 'package:custom_gallery/FullScreenImg.dart';
import 'package:camera/zoom.dart';
import 'package:flutter/material.dart';
//import 'package:image/fullscree.dart';
import 'package:image_picker/image_picker.dart';

ValueNotifier<List> database = ValueNotifier([]);

class Gallery extends StatelessWidget {
  const Gallery({Key? key}) : super(key: key);

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
            debugPrint(image.path);
            final x = await imagepath.copy(
                '/data/user/0/com.example.camera/image_(${DateTime.now()}).jpg');
            Directory directory = Directory.fromUri(
                Uri.parse('/data/user/0/com.example.camera/'));
            getitems(directory);
            //print('.................$x');
          }
        },
        child: Icon(Icons.camera),
      ),
      body: ValueListenableBuilder(
          valueListenable: database,
          builder: (context, List data, _) {
            // print(data);
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
  // print(listDir);
  database.value.clear();
  for (var i = 0; i < listDir.length; i++) {
    if (listDir[i].path.substring(
            (listDir[i].path.length - 4), (listDir[i].path.length)) ==
        '.jpg') {
      database.value.add(listDir[i].path);
      database.notifyListeners();
    }
  }
}
