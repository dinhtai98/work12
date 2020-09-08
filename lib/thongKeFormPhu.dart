import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:postgres/postgres.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wrok111/connect.dart';
import 'package:wrok111/formTile.dart';

class ChangFormPhu extends StatefulWidget {
  FormTile f;
  ChangFormPhu({Key key, @required this.f}) : super(key: key);
  @override
  _ChangFormPhuState createState() => _ChangFormPhuState();
}

class _ChangFormPhuState extends State<ChangFormPhu> {
  SlidableController slidableController;
  TextEditingController _textNameFormController;
  TextEditingController _textLinkFormController;
  GlobalKey<ScaffoldState> _scaffoldKey;
  Formphu _formphu;

  List<Formphu> _listFormPhu;

  bool _checkEditForm;
  @override
  void initState() {
    _scaffoldKey = GlobalKey();
    _textNameFormController = TextEditingController();
    _textLinkFormController = TextEditingController();
    slidableController = SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );
    _formphu = Formphu();
    _listFormPhu = [];
    _checkEditForm = false;
    _getData();
    super.initState();
  }

  _getData() {
    Data.fetchFP(widget.f.id).then((value) {
      setState(() {
        _listFormPhu = value;
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
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("${widget.f.ten} attack form "),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.lightGreenAccent,
          child: Column(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(top: 10, left: 20),
                  child: Column(children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 150,
                      child: Column(
                        children: <Widget>[
                          TextField(
                            controller: _textNameFormController,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
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
                                    borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.all(10),
                                hintText:
                                    "Typing link form..."), // link form chính
                          ),
                          RaisedButton(
                            child: Text("SAVE"),
                            color: Colors.blue,
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if (_checkEditForm == true) {
                                _showSnackBar(
                                    context, "You have successfully changed");
                                updateFormphu(
                                    _formphu,
                                    _textNameFormController.text,
                                    _textLinkFormController.text);
                                _textNameFormController.text = "";
                                _textLinkFormController.text = "";
                              } else {
                                if (_textNameFormController.text != "" &&
                                    _textLinkFormController.text != "") {
                                  _showSnackBar(
                                      context, "You have successfully added");
                                  insertFormPhu(
                                      _textNameFormController.text,
                                      _textLinkFormController.text,
                                      widget.f.id);
                                  _textNameFormController.text = "";
                                  _textLinkFormController.text = "";
                                } else {
                                  _showSnackBar(context,
                                      "You have not entered the information");
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ])),
              Container(
                  height: MediaQuery.of(context).size.height - 230,
                  child: Center(
                    child: OrientationBuilder(
                      builder: (context, orientation) => _buildList(
                          context,
                          // orientation == Orientation.portrait
                          //     ?
                          Axis.vertical
                          //     : Axis.horizontal
                          ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  insertFormPhu(String ten, String link, int idFormchinh) async {
    var connection = new PostgreSQLConnection(ipv4, 5432, "Tai_Totnghiep",
        username: "postgres", password: "CsiTeamAns@0719");
    await connection.open();
    await connection.query(
        "insert into formphu(ten,link,id_formtile) values ('$ten','$link','$idFormchinh')");
    await connection.close();
    _getData();
    return;
  }

  updateFormphu(Formphu f, String ten, String link) async {
    var connection = new PostgreSQLConnection(ipv4, 5432, "Tai_Totnghiep",
        username: "postgres", password: "CsiTeamAns@0719");
    await connection.open();
    await connection.query(
        "update formphu set ten = '$ten',link ='$link' where id = '${f.formphuid}'");
    await connection.close();
    _getData();
    return;
  }

  deleteFormphu(Formphu f) async {
    var connection = new PostgreSQLConnection(ipv4, 5432, "Tai_Totnghiep",
        username: "postgres", password: "CsiTeamAns@0719");
    await connection.open();
    await connection.query("delete from formphu where id = '${f.formphuid}'");
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
        return _getSlidableWithDelegates(
            context, index, slidableDirection, _listFormPhu);
      },
      itemCount: _listFormPhu.length,
    );
  }

  Widget _getSlidableWithDelegates(
      BuildContext context, int index, Axis direction, List<Formphu> ft) {
    final Formphu item = ft[index];
    return item != null
        ? Card(
            color: index % 2 == 0 ? Colors.indigoAccent : Colors.cyan,
            elevation: 10,
            child: Column(
              children: <Widget>[
                Slidable.builder(
                  key: Key(item.formphuten),
                  controller: slidableController,
                  direction: direction,
                  actionPane: SlidableStrechActionPane(),
                  actionExtentRatio: 0.25,
                  child:
                      //  direction == Axis.horizontal
                      //     ? HorizontalListItem(ft[index])
                      //     :
                      VerticalListItem(ft[index]),
                  actionDelegate: SlideActionBuilderDelegate(
                      actionCount: 1,
                      builder: (context, index, animation, renderingMode) {
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
                              _formphu = item;
                              _textNameFormController.text =
                                  _formphu.formphuten;
                              _textLinkFormController.text =
                                  _formphu.formphulink;
                            });
                          },
                        );
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
                              deleteFormphu(item);
                              // xóa dữ liệu trong database có id của form chính và id form phụ
                              _showSnackBar(
                                  context, "You have successfully deleted");
                              _textNameFormController.text = "";
                              _textLinkFormController.text = "";
                            });
                          },
                        );
                      }),
                ),
              ],
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}

class HorizontalListItem extends StatelessWidget {
  HorizontalListItem(this.item);
  final Formphu item;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 160.0,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            "Name form: ${item.formphuten}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
            textAlign: TextAlign.center,
          ),
          FlatButton(
            onPressed: () {
              _launched = _launchInBrowser(item.formphulink);
            },
            child: RichText(
              text: TextSpan(
                text: 'Link form: ', // link form chính
                style: TextStyle(fontSize: 20, color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text: item.formphulink,
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
}

class VerticalListItem extends StatelessWidget {
  VerticalListItem(
    this.item,
  );
  final Formphu item;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Slidable.of(context)?.renderingMode == SlidableRenderingMode.none
              ? Slidable.of(context)?.open()
              : Slidable.of(context)?.close(),
      child: ListTile(
        title: Text(
          "Name form: ${item.formphuten}",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
          textAlign: TextAlign.center,
        ),
        subtitle: FlatButton(
          onPressed: () {
            _launched = _launchInBrowser(item.formphulink);
          },
          child: RichText(
            text: TextSpan(
              text: 'Link form: ', // link form chính
              style: TextStyle(fontSize: 20, color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                    text: item.formphulink,
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.black,
                        fontSize: 20)),
              ],
            ),
          ),
        ),
      ),
    );
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
}
