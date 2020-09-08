class Image1 {
  Image1({
    this.id,
    this.image,
  });

  int id;
  String image;

  factory Image1.fromJson(Map<String, dynamic> json) => Image1(
        id: json["id"],
        image: json["hinhanh"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "hinhanh": image,
      };
}
