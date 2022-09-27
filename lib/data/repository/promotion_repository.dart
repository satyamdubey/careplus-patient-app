import 'package:careplus_patient/constant/api_constants.dart';
import 'package:careplus_patient/data/api/api_client.dart';
import 'package:careplus_patient/data/model/promotion.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class PromotionRepository{

  static Future<dynamic> getTopPromotions() async{
    var response  = await ApiClient().getData(ApiConstant.topPromotion);
    if(response is http.Response && response.statusCode==200){
      PromotionData promotionData = promotionDataFromJson(response.body);
      List<Promotion> topPromotions = promotionData.promotionList;
      return topPromotions;
    }else{
      if(response is http.Response){
        debugPrint('${response.body} ${response.statusCode}');
      }
      return null;
    }
  }

  static Future<dynamic> getBottomPromotions() async{
    var response  = await ApiClient().getData(ApiConstant.bottomPromotion);
    if(response is http.Response && response.statusCode==200){
      PromotionData promotionData = promotionDataFromJson(response.body);
      List<Promotion> bottomPromotions = promotionData.promotionList;
      return bottomPromotions;
    }else{
      if(response is http.Response){
        debugPrint('${response.body} ${response.statusCode}');
      }
      return null;
    }
  }

}