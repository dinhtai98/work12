import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wrok111/connect.dart';
import 'package:wrok111/mainpage.dart';
import 'package:wrok111/thongke.dart';
import 'package:wrok111/user.dart';

class ChangePass extends StatefulWidget {
  User u;
  ChangePass({Key key, @required this.u}) : super(key: key);
  @override
  _ChangePassState createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController txtpwno, txtpwnew1, txtpwnew2;
  User _u;
  @override
  void initState() {
    super.initState();
    _u = widget.u;
    _scaffoldKey = GlobalKey();
    txtpwno = TextEditingController();
    txtpwnew1 = TextEditingController();
    txtpwnew2 = TextEditingController();  SystemChrome.setPreferredOrientations([
       DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
  ]);
  }

  _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 1),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final TextField _txtPasswordNow = TextField(
      controller: txtpwno,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: 'Current password',
          hintStyle: TextStyle(
              color: Colors.grey.withOpacity(.8),
              fontStyle: FontStyle.italic,
              fontSize: 20),
          contentPadding: EdgeInsets.all(10),
          border: InputBorder.none),
      autocorrect: false,
    );
    final TextField _txtPasswordNew1 = TextField(
      controller: txtpwnew1,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: 'Enter new password',
          hintStyle: TextStyle(
              color: Colors.grey.withOpacity(.8),
              fontStyle: FontStyle.italic,
              fontSize: 20),
          contentPadding: EdgeInsets.all(10),
          border: InputBorder.none),
      autocorrect: false,
    );
    final TextField _txtPasswordNew2 = TextField(
      controller: txtpwnew2,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: 'Confirm new password',
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
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[300]))),
              child: _txtPasswordNow),
          Container(
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[300]))),
            child: _txtPasswordNew1,
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[300]))),
            child: _txtPasswordNew2,
          ),
          SizedBox(
            height: 40,
          ),
          FlatButton(
            color: Color(0xFFC767E7),
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              FocusScope.of(context).unfocus();
              if (txtpwno.text == "" ||
                  txtpwnew1.text == "" ||
                  txtpwnew2.text == "") {
                _showSnackBar(context, "You have not entered the information");
              } else {
                if (txtpwno.text == _u.password &&
                    txtpwnew1.text == txtpwnew2.text) {
                  _u.password = txtpwnew2.text;
                  // cập nhập lại password ở database
                  changPassword(_u.id, txtpwnew2.text);
                  setState(() {
                    _u.password = txtpwnew2.text;
                  });
                  _showSnackBar(
                      context, "You have successfully changed your password");
                  if (_u.username == "admin") {
                    var route = new MaterialPageRoute(
                        builder: (BuildContext context) => ThongKeForm(
                              user: _u,
                            ));

                    Navigator.of(context).pushAndRemoveUntil(route,
                        (Route<dynamic> route) {
                      print(route);
                      return route.isFirst;
                    });
                  } else {
                    var route = new MaterialPageRoute(
                        builder: (BuildContext context) => MainPage(
                              user: _u,
                            ));

                    Navigator.of(context).pushAndRemoveUntil(route,
                        (Route<dynamic> route) {
                      print(route);
                      return route.isFirst;
                    });
                  }
                } else {
                  _showSnackBar(context,
                      "You have entered the wrong current or wrong confirm new password");
                }
                _clearValues();
              }
            },
          )
        ],
      ),
    );
  }

  _clearValues() {
    txtpwno.text = "";
    txtpwnew1.text = "";
    txtpwnew2.text = "";
  }
}
