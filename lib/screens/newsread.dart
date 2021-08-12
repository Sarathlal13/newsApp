import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_app/bottomSheet.dart';
import 'package:image_crop_new/image_crop_new.dart';

class NewsReadPage extends StatefulWidget {
  NewsReadPage({this.selectedNews});
  final selectedNews;
  _NewsReadPageState createState() => _NewsReadPageState();
}

class _NewsReadPageState extends State<NewsReadPage> {
  File _image;
  File _lastCropped;
  final cropKey = GlobalKey<CropState>();

  _imgFromCamera() async {
    PickedFile image = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 50);

    _image = File(image.path);
    showGeneralDialog(
        context: context, pageBuilder: (context, a1, a2) => showPopup(_image));
  }

  _imgFromGallery() async {
    PickedFile image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);

    _image = File(image.path);
    showGeneralDialog(
        context: context, pageBuilder: (context, a1, a2) => showPopup(_image));
  }

  Future<void> _cropImage(_file) async {
    File image = _file;
    final scale = cropKey.currentState.scale;
    final area = cropKey.currentState.area;
    if (area == null) {
      // cannot crop, widget is not setup
      return;
    }

    // scale up to use maximum possible number of pixels
    // this will sample image in higher resolution to make cropped image larger
    final sample = await ImageCrop.sampleImage(
        file: image,
        //preferredSize: (2000 / scale).round(),
        preferredWidth: 500,
        preferredHeight: 500);

    final file =
        await ImageCrop.cropImage(file: sample, area: area, scale: scale);

    sample.delete();

    _lastCropped?.delete();
    setState(() {
      _lastCropped = file;
    });

    // String dir = (await getApplicationDocumentsDirectory()).path;
    // String userId = Appdata.userDetails["userId"];
    // String newPath = path.join(dir, '$userId.jpg');
    var resp;
    //  Future<File> _newFile = File(file.path).copy(newPath);

    // _newFile.then((value) {
    //   debugPrint('$value');
    // });
  }

  showPopup(file) {
    print("popo");
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        insetPadding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height / 1.5,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Crop.file(
                    file,
                    key: cropKey,
                    scale: 1.0,
                    aspectRatio: 1,
                    maximumScale: 2.0,
                    alwaysShowGrid: false,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20.0),
                  alignment: AlignmentDirectional.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      ElevatedButton(
                          child: Text(
                            'Done',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _cropImage(file);
                          }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Container(
              child: Wrap(
                children: <Widget>[
                  new ListTile(
                    leading: new Icon(Icons.camera),
                    title: new Text('Open Camera'),
                    onTap: () {
                      Navigator.pop(context);
                      _imgFromCamera();
                    },
                  ),
                  new ListTile(
                      leading: new Icon(Icons.photo_album),
                      title: new Text('Open Gallery'),
                      onTap: () {
                        Navigator.pop(context);
                        _imgFromGallery();
                      })
                ],
              ),
            ),
          );
        },
        child: Icon(Icons.image),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Icon(
          Icons.menu,
          color: Colors.red,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
          child: Column(
            children: [
              Text(
                widget.selectedNews['title'],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 200,
                child: widget.selectedNews['urlToImage'] != null
                    ? Image.network(
                        widget.selectedNews['urlToImage'],
                        fit: BoxFit.fill,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace stackTrace) {
                          return Text('No Image');
                        },
                      )
                    : Image.network(
                        'https://images.news18.com/ibnlive/uploads/2021/07/1627283897_news18_logo-1600x900.jpg',
                        fit: BoxFit.fill,
                      ),
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: Text(
                  '\n${widget.selectedNews['content']}',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              _lastCropped != null
                  ? Expanded(child: Image.file(_lastCropped))
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
