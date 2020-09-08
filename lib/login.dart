import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:wrok111/connect.dart';
import 'package:wrok111/dangky.dart';
import 'package:wrok111/mainpage.dart';
import 'package:wrok111/slider.dart';
import 'package:wrok111/thongke.dart';
import 'dart:convert';

import 'package:wrok111/user.dart';

class ScreenLogin extends StatefulWidget {
  @override
  _ScreenLoginState createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  User user = User();
  GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController txtus, txtpw;
  bool isOffline = true;
  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey();
    txtus = TextEditingController();
    txtpw = TextEditingController();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _checkInternet();
  }

  _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    ));
  }

  _checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        isOffline = false;
      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        isOffline = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextField _txtUserName = TextField(
      controller: txtus,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: 'Enter your username',
          hintStyle: TextStyle(
              color: Colors.grey.withOpacity(.8), fontStyle: FontStyle.italic),
          contentPadding: EdgeInsets.all(10),
          border: InputBorder.none),
      autocorrect: false,
      onChanged: (text) {
        setState(() {
          this.user.username = text;
        });
      },
    );
    final TextField _txtPassWord = TextField(
      controller: txtpw,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: 'Enter your password',
          hintStyle: TextStyle(
              color: Colors.grey.withOpacity(.8), fontStyle: FontStyle.italic),
          contentPadding: EdgeInsets.all(10),
          border: InputBorder.none),
      autocorrect: false,
      obscureText: true,
      onChanged: (text) {
        setState(() {
          this.user.password = text;
        });
      },
    );
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      backgroundColor: !isOffline ? Color.fromRGBO(3, 9, 23, 1) : Colors.white,
      body: !isOffline
          ? Container(
              padding: EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Column(
                      children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.grey[300]))),
                            child: _txtUserName),
                        Container(
                          decoration: BoxDecoration(),
                          child: _txtPassWord,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      !busy
                          ? FlatButton(
                              color: Color(0xFFC767E7),
                              child: Text(
                                "Login",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                _loginAdmin(txtus.text, txtpw.text);
                              },
                            )
                          : CircularProgressIndicator(),
                      FlatButton(
                        color: Color(0xFFC767E8),
                        child: Text(
                          "Register",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => DangKy()));
                        },
                      )
                    ],
                  ),
                ],
              ),
            )
          : Center(
              child: Text(
                "You need to use wifi network or mobile data and restart the application",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
    );
  }

  _loginAdmin(String user, String pass) {
    Data.login(user, pass).then((value) {
      setState(() {
        print(value);
        User admin = value;
        if (admin != null) {
          busy = false;
          txtus.text = "";
          txtpw.text = "";
          // _showSnackBar(context, "Logged in successfully");
          FocusScope.of(context).unfocus();
          if (admin.username != "admin") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => SliderQuangCao(
                          user: admin,
                        )));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ThongKeForm(
                          user: admin,
                        )));
          }
        } else {
          setState(() {
            busy = false;
            txtus.text = "";
            txtpw.text = "";
          });
          _showSnackBar(context, "Login unsuccessful");
          FocusScope.of(context).unfocus();
        }
      });
    });
  }

  var busy = false;
}
