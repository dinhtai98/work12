import 'dart:convert';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wrok111/connect.dart';
import 'package:wrok111/hinhanh.dart';
import 'package:wrok111/mainpage.dart';
import 'package:wrok111/user.dart';

class SliderQuangCao extends StatefulWidget {
  User user;
  SliderQuangCao({Key key, @required this.user}) : super(key: key);
  @override
  _SliderQuangCaoState createState() => _SliderQuangCaoState();
}

// Container(
//                 height: 200,
//                 child: ListView.builder(
//                     itemCount: list.length,
//                     itemBuilder: (context, index) {
//                       Uint8List bytes = base64Decode(list[index].image);
//                       return Image.memory(bytes);
//                     })),
List<Image1> list;

class _SliderQuangCaoState extends State<SliderQuangCao> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    list = [];
    _getData();
  }

  _getData() {
    Data.fetchImage().then((listhinhanh) {
      setState(() {
        list = listhinhanh;
      });
    });
  }

  int _current = 0;
  @override
  Widget build(BuildContext context) {
    final CarouselSlider autoPlayDemo = CarouselSlider(
      options: CarouselOptions(
          viewportFraction: 0.8,
          aspectRatio: 3 / 4,
          autoPlayInterval: Duration(seconds: 3),
          autoPlay: true,
          enlargeCenterPage: true,
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          onPageChanged: (index, reason) {
            setState(() {
              _current = index;
              print(_current);
            });
          }),
      items: list.map(
        (url) {
          Uint8List bytes = base64Decode(url.image);
          return GestureDetector(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Image.memory(
                  bytes,
                  fit: BoxFit.fill,
                  width: 1000.0,
                ),
              ),
            ),
            onTap: () {
              var route = new MaterialPageRoute(
                  builder: (BuildContext context) => MainPage(
                        user: widget.user,
                      ));

              Navigator.of(context).pushAndRemoveUntil(route,
                  (Route<dynamic> route) {
                print(route);
                return route.isFirst;
              });
            },
          );
        },
      ).toList(),
    );
    return Center(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            autoPlayDemo,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: map<Widget>(list, (index, url) {
                return Container(
                  width: 10.0,
                  height: 10.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index ? Colors.redAccent : Colors.green,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }
}
