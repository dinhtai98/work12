import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:postgres/postgres.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wrok111/chageSHRIMP.dart';
import 'package:wrok111/changeImages.dart';
import 'package:wrok111/changePassword.dart';
import 'package:wrok111/connect.dart';
import 'package:wrok111/formTile.dart';
import 'package:wrok111/login.dart';
import 'package:wrok111/thongKeFormPhu.dart';
import 'package:wrok111/user.dart';

class ThongKeForm extends StatefulWidget {
  User user;
  ThongKeForm({Key key, @required this.user}) : super(key: key);
  @override
  _ThongKeFormState createState() => _ThongKeFormState();
}

class _ThongKeFormState extends State<ThongKeForm> {
  SlidableController slidableController;
  GlobalKey<ScaffoldState> _scaffoldKey;

  TextEditingController _textNameFormController;
  TextEditingController _textLinkFormController;
  bool _checkEditForm;
  List<FormTile> _listFormTile;
  FormTile _f;
  FormTile _shrimp;
  @override
  void initState() {
    slidableController = SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );
    _scaffoldKey = GlobalKey();
    _checkEditForm = false;
    _f = FormTile();
    _textNameFormController = TextEditingController();
    _textLinkFormController = TextEditingController();
    _listFormTile = [];
    _shrimp = FormTile();
    _getData();
    super.initState();
  }

  _getData() {
    Data.fetch().then((value) {
      setState(() {
        _listFormTile = [];
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

  Animation<double> _rotationAnimation;
  Color _fabColor = Colors.blue;

  void handleSlideAnimationChanged(Animation<double> slideAnimation) {
    setState(() {
      _rotationAnimation = slideAnimation;
    });
  }

  void handleSlideIsOpenChanged(bool isOpen) {
    setState(() {
      _fabColor = isOpen ? Colors.green : Colors.blue;
    });
  }

  _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 1),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("ADMIN"),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.power_settings_new),
              onPressed: () {
                setState(() {
                  // Navigator.pop(context);
                  // Navigator.pop(context);

                  var route = new MaterialPageRoute(
                      builder: (BuildContext context) => ScreenLogin());

                  Navigator.of(context).pushAndRemoveUntil(route,
                      (Route<dynamic> route) {
                    print(route);
                    return route.isFirst;
                  });
                });
              },
            ),
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
            IconButton(
                icon: Icon(Icons.local_offer),
                onPressed: () {
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ChangeSHKIMP(
                                  f: _shrimp,
                                )));
                  });
                }),
            IconButton(
                icon: Icon(Icons.image),
                onPressed: () {
                  setState(() {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ChangeImages()));
                  });
                }),
          ]),
      body: _listFormTile != null
          ? SingleChildScrollView(
              child: Container(
                color: Colors.lightGreenAccent,
                child: Column(
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.only(top: 10, left: 20),
                        child: Column(
                          children: <Widget>[
                            Container(
                                width: MediaQuery.of(context).size.width - 150,
                                child: Column(
                                  children: <Widget>[
                                    TextField(
                                      controller: _textNameFormController,
                                      decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding: EdgeInsets.all(10),
                                          hintText:
                                              "Typing name form..."), // tên form chính
                                    ),
                                    SizedBox(height: 10),
                                    TextField(
                                      controller: _textLinkFormController,
                                      decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding: EdgeInsets.all(10),
                                          hintText:
                                              "Typing link form..."), // link form chính
                                    ),
                                  ],
                                )),
                            SizedBox(width: 20),
                            RaisedButton(
                              child: Text("SAVE"),
                              color: Colors.blueAccent,
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                if (_checkEditForm == true) {
                                  for (var i = 0; i < _listFormTile.length; i++)
                                    if (_f.id == _listFormTile[i].id) {
                                      _listFormTile[i].ten =
                                          _textNameFormController.text;
                                      _listFormTile[i].link =
                                          _textLinkFormController.text;
                                      setState(() {
                                        _checkEditForm = false;
                                      });
                                      updateFormChinh(
                                          _f,
                                          _textNameFormController.text,
                                          _textLinkFormController.text);
                                      _textLinkFormController.text = "";
                                      _textNameFormController.text = "";
                                    }
                                } else {
                                  if (_textNameFormController.text != "" &&
                                      _textLinkFormController.text != "") {
                                    setState(() {});
                                    insertFormChinh(
                                        _textNameFormController.text,
                                        _textLinkFormController.text);
                                    _textLinkFormController.text = "";
                                    _textNameFormController.text = "";
                                  } else {
                                    _showSnackBar(context,
                                        "You have not entered the information");
                                  }
                                }
                              },
                            )
                          ],
                        )),
                    SizedBox(height: 20),
                    Container(
                        height: MediaQuery.of(context).size.height - 265,
                        child: Center(
                          child: OrientationBuilder(
                            builder: (context, orientation) => _buildList(
                                context,
                                // orientation == Orientation.portrait
                                //     ? 
                                Axis.vertical
                                    // : Axis.horizontal
                                    ),
                          ),
                        ))
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  insertFormChinh(String ten, String link) async {
    var connection = new PostgreSQLConnection(ipv4, 5432, "Tai_Totnghiep",
        username: "postgres", password: "CsiTeamAns@0719");
    await connection.open();
    await connection
        .query("insert into formtile(ten,link) values ('$ten','$link')");
    await connection.close();
    _getData();
    return;
  }

  updateFormChinh(FormTile f, String ten, String link) async {
    var connection = new PostgreSQLConnection(ipv4, 5432, "Tai_Totnghiep",
        username: "postgres", password: "CsiTeamAns@0719");
    await connection.open();
    await connection.query(
        "UPDATE formtile SET ten = '$ten' , link ='$link' WHERE id = '${f.id}'");
    await connection.close();
    _getData();
    return;
  }

  deleteFormChinh(FormTile f) async {
    var connection = new PostgreSQLConnection(ipv4, 5432, "Tai_Totnghiep",
        username: "postgres", password: "CsiTeamAns@0719");
    await connection.open();
    await connection.query("delete from formphu where id_formtile = '${f.id}'");
    await connection.query("delete from formtile where id = '${f.id}'");
    await connection.close();
    _getData();
    return;
  }

  Widget _buildList(BuildContext context, Axis direction) {
    return ListView.builder(
      scrollDirection: direction,
      itemBuilder: (context, index) {
        final Axis slidableDirection =
            direction == Axis.horizontal ? Axis.vertical : Axis.horizontal;
        return _getSlidableWithDelegates(context, index, slidableDirection);
      },
      itemCount: _listFormTile.length,
    );
  }

  Widget _getSlidableWithDelegates(
      BuildContext context, int index, Axis direction) {
    final FormTile item = _listFormTile[index];
    return Card(
      color: index % 2 == 0 ? Colors.indigoAccent : Colors.cyan,
      elevation: 10,
      child: Column(
        children: <Widget>[
          Slidable.builder(
            key: Key(item.ten),
            controller: slidableController,
            direction: direction,
            actionPane: SlidableStrechActionPane(),
            actionExtentRatio: 0.25,
            child: 
            // direction == Axis.horizontal
            //     ? HorizontalListItem(_listFormTile[index])
            //     :
             VerticalListItem(_listFormTile[index]),
            actionDelegate: SlideActionBuilderDelegate(
                actionCount: 2,
                builder: (context, index, animation, renderingMode) {
                  if (index == 0) {
                    return IconSlideAction(
                      caption: 'Edit',
                      color: renderingMode == SlidableRenderingMode.slide
                          ? Colors.blue.withOpacity(animation.value)
                          : (renderingMode == SlidableRenderingMode.dismiss
                              ? Colors.blue
                              : Colors.green),
                      icon: Icons.edit,
                      onTap: () {
                        setState(() {
                          _checkEditForm = true;
                          _f = item;
                          _textNameFormController.text = _f.ten;
                          _textLinkFormController.text = _f.link;
                        });
                      },
                    );
                  } else {
                    return IconSlideAction(
                      caption: 'ADD',
                      color: renderingMode == SlidableRenderingMode.slide
                          ? Colors.indigo.withOpacity(animation.value)
                          : Colors.indigo,
                      icon: Icons.add,
                      onTap: () {
                        _textNameFormController.text = "";
                        _textLinkFormController.text = "";
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ChangFormPhu(f: item)));
                      },
                    );
                  }
                }),
            secondaryActionDelegate: SlideActionBuilderDelegate(
                actionCount: 1,
                builder: (context, index, animation, renderingMode) {
                  return IconSlideAction(
                    caption: 'Delete',
                    color: renderingMode == SlidableRenderingMode.slide
                        ? Colors.red.withOpacity(animation.value)
                        : Colors.red,
                    icon: Icons.delete,
                    onTap: () {
                      setState(() {
                        deleteFormChinh(item);
                      });
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class VerticalListItem extends StatelessWidget {
  VerticalListItem(this.item);
  final FormTile item;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Slidable.of(context)?.renderingMode == SlidableRenderingMode.none
              ? Slidable.of(context)?.open()
              : Slidable.of(context)?.close(),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          title: Text(
            "Name form: ${item.ten}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
            textAlign: TextAlign.center,
          ),
          subtitle: FlatButton(
            onPressed: () {
              launched = _launchInBrowser(item.link);
            },
            child: RichText(
              text: TextSpan(
                text: 'Link form: ', // link form chính
                style: TextStyle(fontSize: 20, color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text: item.link,
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                          fontSize: 20)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> launched;
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
}

// ignore: must_be_immutable
class HorizontalListItem extends StatelessWidget {
  HorizontalListItem(this.item);
  final FormTile item;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 160.0,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            "Name form: ${item.ten}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
            textAlign: TextAlign.center,
          ),
          FlatButton(
            onPressed: () {
              launched = _launchInBrowser(item.link);
            },
            child: RichText(
              text: TextSpan(
                text: 'Link form: ', // link form chính
                style: TextStyle(fontSize: 20, color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text: item.link,
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                          fontSize: 20)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> launched;
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
}
