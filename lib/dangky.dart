import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:postgres/postgres.dart';
import 'package:wrok111/connect.dart';
import 'package:wrok111/login.dart';

class DangKy extends StatefulWidget {
  @override
  _DangKyState createState() => _DangKyState();
}

class _DangKyState extends State<DangKy> {
  TextEditingController _usernameController;
  TextEditingController _passController;
  TextEditingController _confirmPassController;
  TextEditingController _nameController;
  TextEditingController _ngaySinhController;
  TextEditingController _diaChiController;
  GlobalKey<ScaffoldState> _scaffoldKey;
  @override
  void initState() {
    _usernameController = TextEditingController();
    _passController = TextEditingController();
    _confirmPassController = TextEditingController();
    _nameController = TextEditingController();
    _ngaySinhController = TextEditingController();
    _diaChiController = TextEditingController();
    _scaffoldKey = GlobalKey();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  var formatter = new DateFormat('dd/MM/yyyy');
  var now = new DateTime.now();
  _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 1),
    ));
  }

  Future<Null> selectDate(BuildContext context) async {
    final AlertDialog _alertDialog = AlertDialog(
      title: Text(
        'Error',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.red, fontSize: 25),
      ),
      content: Text(
        'You may not enter a date after the current date ${formatter.format(DateTime.now())}!',
        style: TextStyle(fontSize: 20),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Ok'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
      elevation: 22,
    );
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(1970),
        lastDate: DateTime(2100));

    if (picked != null && picked != now) {
      if (picked.isBefore(DateTime.now())) {
        setState(() {
          now = picked;
          _ngaySinhController.text = formatter.format(now);
        });
      } else {
        showDialog(
            context: context,
            builder: (_) => _alertDialog,
            barrierDismissible: false);
        setState(() {
          now = DateTime.now();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextField _txtName = TextField(
      controller: _usernameController,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 16, color: Colors.black),
      autocorrect: false,
      decoration: InputDecoration(
          labelText: "Username",
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffced8d2), width: 1),
              borderRadius: BorderRadius.all(Radius.circular(6)))),
    );
    final TextField _txtPassword = TextField(
      controller: _passController,
      style: TextStyle(fontSize: 16, color: Colors.black),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          labelText: "Password",
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffced8d2), width: 1),
              borderRadius: BorderRadius.all(Radius.circular(6)))),
      autocorrect: false,
    );
    final TextField _txtConfirmPassword = TextField(
      controller: _confirmPassController,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 16, color: Colors.black),
      decoration: InputDecoration(
          labelText: "Confirm password",
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffced8d2), width: 1),
              borderRadius: BorderRadius.all(Radius.circular(6)))),
      autocorrect: false,
    );
    final TextField _txtNamePassword = TextField(
      controller: _nameController,
      style: TextStyle(fontSize: 16, color: Colors.black),
      decoration: InputDecoration(
          labelText: "Name",
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffced8d2), width: 1),
              borderRadius: BorderRadius.all(Radius.circular(6)))),
    );
    // final TextField _txtNgaySinhPassword = TextField(
    //   enabled: false,
    //   controller: _ngaySinhController,
    //   style: TextStyle(fontSize: 16, color: Colors.black),
    //   keyboardType: TextInputType.datetime,
    //   decoration: InputDecoration(
    //       labelText: "Date of birth",
    //       border: OutlineInputBorder(
    //           borderSide: BorderSide(color: Color(0xffced8d2), width: 1),
    //           borderRadius: BorderRadius.all(Radius.circular(6)))),
    // );
    final TextField _txtDiaChiPassword = TextField(
      controller: _diaChiController,
      style: TextStyle(fontSize: 16, color: Colors.black),
      decoration: InputDecoration(
          labelText: "Address",
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffced8d2), width: 1),
              borderRadius: BorderRadius.all(Radius.circular(6)))),
    );
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color(0xff3277d8)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
              child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Container(
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.grey[300]))),
                  child: _txtNamePassword,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey[300]))),
                      child: Text(
                        "Date of birth: ${_ngaySinhController.text}",
                        style: TextStyle(fontSize: 16, color: Colors.black45),
                      )),
                  IconButton(
                    icon: Icon(
                      Icons.date_range,
                      size: 25,
                    ),
                    onPressed: () {
                      selectDate(context);
                    },
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Container(
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.grey[300]))),
                  child: _txtDiaChiPassword,
                ),
              ),
              Container(
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.grey[300]))),
                  child: _txtName),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Container(
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.grey[300]))),
                  child: _txtPassword,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey[300]))),
                child: _txtConfirmPassword,
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
                  if (_nameController.text == "" ||
                      _passController.text == "" ||
                      _confirmPassController.text == "" ||
                      _usernameController.text == "" ||
                      _ngaySinhController.text == "" ||
                      _diaChiController.text == "") {
                    _showSnackBar(
                        context, "You have not entered the information");
                  } else {
                    if (_passController.text == _confirmPassController.text) {
                      _checkname(
                          _usernameController.text,
                          _confirmPassController.text,
                          _nameController.text,
                          _ngaySinhController.text,
                          _diaChiController.text);
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
        ),
      ),
    );
  }

  _checkname(
      String user, String pass, String ht, String ngsinh, String diachi) {
    Data.checkTaiKhoan(user).then((value) {
      if (!value) {
        insertUser(user, pass, ht, ngsinh, diachi);
        _showSnackBar(context, "You have successfully registrated");
        var route = new MaterialPageRoute(
            builder: (BuildContext context) => ScreenLogin());
        Navigator.of(context).pushAndRemoveUntil(route, (Route<dynamic> route) {
          print(route);
          return route.isFirst;
        });
      } else {
        _showSnackBar(context, "Username available");
      }
    });
  }

  insertUser(
      String ten, String pass, String ht, String ngsinh, String diachi) async {
    var connection = new PostgreSQLConnection(ipv4, 5432, "Tai_Totnghiep",
        username: "postgres", password: "CsiTeamAns@0719");
    await connection.open();
    await connection.query(
        "insert into useradmin(username,password,hovaten,ngaysinh,diachi) values ('$ten','$pass','$ht','$ngsinh','$diachi')");
    await connection.close();
    return;
  }

  _clearValues() {
    _nameController.text = "";
    _passController.text = "";
    _confirmPassController.text = "";
  }
}
