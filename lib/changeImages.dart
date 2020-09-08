import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:postgres/postgres.dart';
import 'package:wrok111/connect.dart';
import 'package:wrok111/hinhanh.dart';

class ChangeImages extends StatefulWidget {
  ChangeImages() : super();

  final String title = "Upload Image Demo";

  @override
  ChangeImagesState createState() => ChangeImagesState();
}

class ChangeImagesState extends State<ChangeImages> {
  //
  static final String uploadEndPoint =
      'http://sanxuattom.000webhostapp.com/upload.php';
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';
  List<Image1> list;

  chooseImage() {
    setState(() {
      // ignore: deprecated_member_use
      file = ImagePicker.pickImage(source: ImageSource.gallery);
    });
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload(String fileName) {
    setStatus('Uploading Image...');
    if (null == tmpFile) {
      setStatus("You not choose image");
      return;
    }
    upload(fileName);
  }

  upload(String fileName) {
    http.post(uploadEndPoint, body: {
      "img": base64Image,
      "tenhinhanh": fileName,
    }).then((result) {
      if (result.statusCode == 200) {
        setStatus(result.body);
        setState(() {
          file = null;
          tmpFile = null;
        });
      } else {
        setStatus(errMessage);
      }
    }).catchError((error) {
      setStatus(error);
    });
  }

  inserthinhanh(int id) async {
    var connection = new PostgreSQLConnection(ipv4, 5432, "Tai_Totnghiep",
        username: "postgres", password: "CsiTeamAns@0719");
    await connection.open();
    await connection
        // .query("insert into image(id,hinhanh) values ('$id','$base64Image')");
         .query("update image set hinhanh = '$base64Image' where id = $id");
    await connection.close();
    setState(() {
      file = null;
      tmpFile = null;
    });
    return;
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Flexible(
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    list = [];
    _getData();
    super.initState();
  }

  _getData() {
    Data.fetchImage().then((listhinhanh) {
      setState(() {
        list = listhinhanh;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Image For Slider Gallery"),
      ),
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            OutlineButton(
              onPressed: chooseImage,
              child: Text('Choose Image'),
            ),
            SizedBox(
              height: 20.0,
            ),
            showImage(),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                OutlineButton(
                  onPressed: () {
                    // startUpload("hinh1");
                    inserthinhanh(1);
                  },
                  child: Text('Upload For Image 1'),
                ),
                OutlineButton(
                  onPressed: () {
                    // startUpload("hinh2");
                    inserthinhanh(2);
                  },
                  child: Text('Upload For Image 2'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                OutlineButton(
                  onPressed: () {
                    // startUpload("hinh3");

                    inserthinhanh(3);
                  },
                  child: Text('Upload For Image 3'),
                ),
                OutlineButton(
                  onPressed: () {
                    // startUpload("hinh4");

                    inserthinhanh(4);
                  },
                  child: Text('Upload For Image 4'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                OutlineButton(
                  onPressed: () {
                    // startUpload("hinh5");

                    inserthinhanh(5);
                  },
                  child: Text('Upload For Image 5'),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              status,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w500,
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
