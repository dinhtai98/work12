import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:postgres/postgres.dart';
import 'package:wrok111/connect.dart';
import 'package:wrok111/formTile.dart';

class ChangeSHKIMP extends StatefulWidget {
  FormTile f;
  ChangeSHKIMP({Key key, @required this.f}) : super(key: key);
  @override
  _ChangeSHKIMPState createState() => _ChangeSHKIMPState();
}

class _ChangeSHKIMPState extends State<ChangeSHKIMP> {
  TextEditingController txtlink;
  GlobalKey<ScaffoldState> _scaffoldKey;
  FormTile _shrimp;
  @override
  void initState() {
    txtlink = TextEditingController();
    _scaffoldKey = GlobalKey();
    _shrimp = widget.f;
    SystemChrome.setPreferredOrientations([
     DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

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
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextField _txtLINK = TextField(
      controller: txtlink,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: 'New Link',
          hintStyle: TextStyle(
              color: Colors.grey.withOpacity(.8),
              fontStyle: FontStyle.italic,
              fontSize: 20),
          contentPadding: EdgeInsets.all(10),
          border: InputBorder.none),
      autocorrect: false,
    );
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Change link SHRIMP"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width - 40,
              child: Text(
                "Old link: ${_shrimp.link}",
                style: TextStyle(fontSize: 25),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 40,
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[300]))),
              child: _txtLINK,
            ),
            FlatButton(
              color: Color(0xFFC767E7),
              child: Text(
                "Save",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                FocusScope.of(context).unfocus();
                if (txtlink.text == "") {
                  _showSnackBar(
                      context, "You have not entered the information");
                } else {
                  updateFormChinh(txtlink.text);
                  _showSnackBar(
                      context, "You have successfully changed Shrimp");
                  txtlink.text = "";
                }
              },
            )
          ],
        ),
      ),
    );
  }

  updateFormChinh(String link) async {
    var connection = new PostgreSQLConnection(ipv4, 5432, "Tai_Totnghiep",
        username: "postgres", password: "CsiTeamAns@0719");
    await connection.open();
    await connection.query("UPDATE formtile SET link ='$link' WHERE id = 0");
    await connection.close();
    _getData();
    return;
  }
}
