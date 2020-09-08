import 'package:postgres/postgres.dart';
import 'package:wrok111/formTile.dart';
import 'package:wrok111/hinhanh.dart';
import 'package:wrok111/user.dart';

String ipv4 = "27.71.233.181"; // host server online;

class Data {
  static Future<List<FormTile>> fetch() async {
    var connection = new PostgreSQLConnection(ipv4, 5432, "Tai_Totnghiep",
        username: "postgres", password: "CsiTeamAns@0719");
    await connection.open();
    final List<FormTile> listFormTile = new List();
    final List<dynamic> results =
        await connection.query("SELECT * FROM formtile");

    final List<List<Formphu>> listFormPhu = new List(results.length);
    for (var i = 0; i < listFormPhu.length; i++) {
      listFormPhu[i] = List();
    }

    for (var x = 0; x < results.length; x++) {
      int f = results[x][0];
      List<dynamic> resultsFormphu = await connection
          .query("SELECT * FROM formphu WHERE id_formtile = $f ");
      for (final rowfp in resultsFormphu) {
        listFormPhu[x].add(Formphu(
            formphuid: rowfp[0], formphuten: rowfp[1], formphulink: rowfp[2]));
      }

      listFormTile.add(FormTile(
          id: results[x][0],
          ten: results[x][1],
          link: results[x][2],
          formphu: listFormPhu[x]));
    }
    await connection.close();
    return listFormTile;
  }

  static Future<List<Image1>> fetchImage() async {
    var connection = new PostgreSQLConnection(ipv4, 5432, "Tai_Totnghiep",
        username: "postgres", password: "CsiTeamAns@0719");
    await connection.open();
    final List<Image1> list = new List();
    final List<dynamic> results = await connection.query("SELECT * FROM image");

    for (final rowfp in results) {
      list.add(Image1(id: rowfp[0], image: rowfp[1]));
    }
    await connection.close();
    return list;
  }

  static Future<List<Formphu>> fetchFP(int id) async {
    var connection = new PostgreSQLConnection(ipv4, 5432, "Tai_Totnghiep",
        username: "postgres", password: "CsiTeamAns@0719");
    await connection.open();
    final List<Formphu> listFormPhu = new List();

    List<dynamic> resultsFormphu = await connection
        .query("SELECT * FROM formphu WHERE id_formtile = $id ");
    for (final rowfp in resultsFormphu) {
      listFormPhu.add(Formphu(
          formphuid: rowfp[0], formphuten: rowfp[1], formphulink: rowfp[2]));
    }
    await connection.close();
    return listFormPhu;
  }

  static Future<User> login(String user, String pass) async {
    var connection = new PostgreSQLConnection(ipv4, 5432, "Tai_Totnghiep",
        username: "postgres", password: "CsiTeamAns@0719");
    await connection.open();
    List<dynamic> results = await connection.query(
        "SELECT * FROM useradmin WHERE username = '$user' and password = '$pass'");
    for (final rowfp in results) {
      User u = User(id: rowfp[0], username: rowfp[1], password: rowfp[2]);
      return u;
    }
    return null;
  }

  static Future<bool> checkTaiKhoan(String user) async {
    var connection = new PostgreSQLConnection(ipv4, 5432, "Tai_Totnghiep",
        username: "postgres", password: "CsiTeamAns@0719");
    await connection.open();
    List<dynamic> results = await connection
        .query("SELECT * FROM useradmin WHERE username = '$user'");
    if (results.length != null && results.length >= 1) {
      return true;
    }
    return false;
  }
}

changPassword(int id, String np) async {
  var connection = new PostgreSQLConnection(ipv4, 5432, "Tai_Totnghiep",
      username: "postgres", password: "CsiTeamAns@0719");
  await connection.open();
  await connection
      .query("update useradmin set password = '$np' where id = $id");
  await connection.close();
  return;
}
