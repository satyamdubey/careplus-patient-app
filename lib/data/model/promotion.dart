import 'dart:convert';

PromotionData promotionDataFromJson(String str) => PromotionData.fromJson(json.decode(str));

String promotionDataToJson(PromotionData data) => json.encode(data.toJson());

class PromotionData {
  PromotionData({
    this.status,
    this.message,
    required this.promotionList,
  });

  dynamic status;
  dynamic message;
  List<Promotion> promotionList;

  factory PromotionData.fromJson(Map<String, dynamic> json) => PromotionData(
    status: json["status"],
    message: json["message"],
    promotionList: List<Promotion>.from(json["promotionList"].map((x) => Promotion.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "promotionList": List<dynamic>.from(promotionList.map((x) => x.toJson())),
  };
}

class Promotion {
  Promotion({
    required this.id,
    required this.title,
    required this.banner,
  });

  String id;
  String title;
  String banner;

  factory Promotion.fromJson(Map<String, dynamic> json) => Promotion(
    id: json["_id"],
    title: json["title"],
    banner: json["banner"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "banner": banner,
  };
}
