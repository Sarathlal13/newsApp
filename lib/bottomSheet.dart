import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_app/image_controler.dart';

class BottomSheetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: <Widget>[
          new ListTile(
            leading: new Icon(Icons.camera),
            title: new Text('Open Camera'),
            onTap: () async {
              Navigator.pop(context);
              ImagePicker _picker = new ImagePicker();
              // _image = ImagePicker.pickImage(source: source, imageQuality: 75);
              PickedFile pickedFile = await _picker.getImage(
                source: ImageSource.camera,
                imageQuality: 75,
                maxHeight: 100,
              );

              ImagePickerController.image =
                  File(pickedFile.path).copy("newPath");
            },
          ),
          new ListTile(
              leading: new Icon(Icons.photo_album),
              title: new Text('Open Gallery'),
              onTap: () async {
                Navigator.pop(context);
                ImagePicker _picker = new ImagePicker();
                // _image = ImagePicker.pickImage(source: source, imageQuality: 75);
                PickedFile pickedFile = await _picker.getImage(
                    source: ImageSource.gallery,
                    imageQuality: 75,
                    maxHeight: 100);
                ImagePickerController.image =
                    File(pickedFile.path).copy("newPath");
              })
        ],
      ),
    );
  }
}
