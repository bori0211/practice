import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File _imageFile;

  @override
  Widget build(BuildContext context) {
    final buttonColor = Theme.of(context).primaryColor;
    return Column(
      children: <Widget>[
        OutlineButton(
          borderSide: BorderSide(
            color: buttonColor,
            width: 2.0,
          ),
          onPressed: () {
            _openImagePicker(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.camera_alt,
                color: buttonColor,
              ),
              SizedBox(
                width: 5.0,
              ),
              Text(
                '이미지 추가',
                style: TextStyle(
                  color: buttonColor,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        _imageFile == null
            ? Text('Please pick an image')
            : Image.file(
                _imageFile,
                fit: BoxFit.cover,
                height: 300.0,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.topCenter,
              )
      ],
    );
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200.0,
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Text(
                '이미지 선택',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                child: Text('Use Camara'),
                onPressed: () {
                  _getImage(context, ImageSource.camera);
                },
              ),
              SizedBox(height: 10.0),
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                child: Text('Use Gallery'),
                onPressed: () {
                  _getImage(context, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // iOS 별도 세팅 필요
  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 400.0).then((File image) {
      setState(() {
        _imageFile = image;
      });
      Navigator.pop(context);
    });
  }
}
