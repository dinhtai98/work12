import 'dart:convert';

FormTile formTileFromJson(String str) => FormTile.fromJson(json.decode(str));

String formTileToJson(FormTile data) => json.encode(data.toJson());

class FormTile {
  FormTile({
    this.id,
    this.ten,
    this.link,
    this.formphu,
  });

  int id;
  String ten;
  String link;
  List<Formphu> formphu;

  factory FormTile.fromJson(Map<String, dynamic> json) => FormTile(
        id: json["id"],
        ten: json["ten"],
        link: json["link"],
        formphu: List<Formphu>.from(
            json["formphu"].map<Formphu>((x) => Formphu.fromJson(x))).toList(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ten": ten,
        "link": link,
        "formphu": List<dynamic>.from(formphu.map((x) => x.toJson())),
      };
}

class Formphu {
  Formphu({
    this.formphuid,
    this.formphuten,
    this.formphulink,
  });

  int formphuid;
  String formphuten;
  String formphulink;

  factory Formphu.fromJson(Map<String, dynamic> json) => Formphu(
        formphuid: json["formphuid"],
        formphuten: json["formphuten"],
        formphulink: json["formphulink"],
      );

  Map<String, dynamic> toJson() => {
        "formphuid": formphuid,
        "formphuten": formphuten,
        "formphulink": formphulink,
      };
}
