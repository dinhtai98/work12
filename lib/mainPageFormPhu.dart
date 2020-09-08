import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wrok111/formTile.dart';

class ScreenFormPhu extends StatefulWidget {
  final String linkFormChinh;
  final String nameForm;
  final List<Formphu> listFormPhu;
  ScreenFormPhu(
      {Key key,
      @required this.linkFormChinh,
      @required this.nameForm,
      @required this.listFormPhu})
      : super(key: key);
  @override
  _ScreenFormPhuState createState() => _ScreenFormPhuState();
}

Future<void> _launched;
Future<void> _launchInBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    );
  } else {
    throw 'Could not launch $url';
  }
}

List<Widget> _buildListView(
    numberOfTiles, List<Formphu> td, BuildContext context) {
  List<Padding> container = new List<Padding>.generate(
    numberOfTiles,
    (int index) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          color: index % 2 == 0 ? Colors.indigoAccent : Colors.cyan,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 10,
          child: Container(
            child: FlatButton(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "${td[index].formphuten}",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              onPressed: () {
                _launched = _launchInBrowser(td[index].formphulink);
              },
            ),
          ),
        ),
      );
    },
  );

  return container;
}

class _ScreenFormPhuState extends State<ScreenFormPhu> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attach Form"),
      ),
      body: Container(
        // color: Colors.lightGreenAccent,
        color: Colors.grey[300],
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: FlatButton(
                onPressed: () {
                  _launched = _launchInBrowser(
                      widget.linkFormChinh); // chuyển link từ app sang chrome
                },
                child: Card(
                  color: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 10,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 10,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "${widget.nameForm}",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 210,
              child: GridView.extent(
                maxCrossAxisExtent: 220,
                mainAxisSpacing: 5,
                crossAxisSpacing: 1,
                childAspectRatio: 1,
                children: _buildListView(
                    widget.listFormPhu.length, widget.listFormPhu, context),
              ),
            )
          ],
        ),
      ),
    );
  }
}
