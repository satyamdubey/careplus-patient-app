import 'dart:convert';

import 'package:careplus_patient/constant/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';

class PaymentService {
  static String PAYTM_MID = 'BTpIRW24503285850800';

  static Future<dynamic> getTransactionToken(
      String appointmentId, String patientId, double amount) async {
    String initiateTransactionData = jsonEncode({
      "appointmentId": appointmentId,
      "patientId": patientId,
      "amount": amount
    });
    try {
      http.Response response = await http
          .post(
            Uri.parse(ApiConstant.baseUrl+ApiConstant.getTransactionToken),
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: initiateTransactionData,
          ).timeout(const Duration(seconds: 30));
      return response;
    } on Exception catch (_) {
      return null;
    }
  }

  static Future<dynamic> startTransaction(orderId, txnToken, amount) async {
    try {
      Map<dynamic, dynamic>? response = await AllInOneSdk.startTransaction(
      PAYTM_MID,
      orderId,
      '$amount',
      txnToken,
      "https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=$orderId",
      true,
      true,
      );
      if(response!=null){
        return response;
      }else{
        return null;
      }
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  static Future<dynamic> sendTransactionResponse(orderId, txnId) async {
    print(orderId);
    try {
      http.Response response = await http.post(
        Uri.parse('https://care-plus.herokuapp.com/api/v1/patient/payment/response'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({"orderId":orderId, "txnId":txnId}),
      ).timeout(const Duration(seconds: 30));
      return response;
    } on Exception catch (_) {
      return null;
    }
  }
}
