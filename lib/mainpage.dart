import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wrok111/changePassword.dart';
import 'package:wrok111/connect.dart';
import 'package:wrok111/formTile.dart';
import 'package:wrok111/mainPageFormPhu.dart';
import 'package:wrok111/user.dart';
import 'package:intl/intl.dart';

class MainPage extends StatefulWidget {
  User user;
  MainPage({Key key, @required this.user}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  GlobalKey<ScaffoldState> _scaffoldKey;
  List<FormTile> _listFormTile;
  FormTile _shrimp;
  @override
  void initState() {
    _scaffoldKey = GlobalKey();
    _listFormTile = [];
    _getData();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  var formatter = new DateFormat('dd-MM-yyyy');

  _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 1),
    ));
  }

  _getData() {
    Data.fetch().then((value) {
      setState(() {
        for (var i = 0; i < value.length; i++) {
          if (value[i].id == 0) {
            _shrimp = value[i];
          } else {
            _listFormTile.add(value[i]);
          }
        }
      });
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text("Form Management"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.restore_page),
              onPressed: () {
                setState(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ChangePass(
                                u: widget.user,
                              )));
                });
              }),
        ],
      ),
      body: _listFormTile != null
          ? _shrimp != null
              ? Container(
                  color: Colors.grey[300],
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          color: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 10,
                          child: Container(
                            width: MediaQuery.of(context).size.width - 10,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FlatButton(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "${_shrimp.ten}",
                                      style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text("${formatter.format(DateTime.now())}")
                                  ],
                                ),
                                onPressed: () {
                                  _launched = _launchInBrowser(_shrimp.link);
                                  // print(link);
                                },
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
                              _listFormTile.length, _listFormTile, context),
                        ),
                      )
                    ],
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  List<Widget> _buildListView(
      numberOfTiles, List<FormTile> td, BuildContext context) {
    List<Padding> padding = new List<Padding>.generate(
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
                      "${td[index].ten}",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ScreenFormPhu(
                              linkFormChinh: td[index].link,
                              nameForm: td[index].ten,
                              listFormPhu: td[index].formphu,
                            ))),
              ),
            ),
          ),
        );
      },
    );
    return padding;
  }
}
