import 'package:careplus_patient/constant/api_constants.dart';
import 'package:careplus_patient/data/api/api_client.dart';
import 'package:careplus_patient/data/model/review.dart';
import 'package:http/http.dart' as http;


class ReviewRepository {
  static Future<dynamic> createClinicReview(ClinicRating clinicRating) async {
    var response = await ApiClient().postData(
      ApiConstant.clinicRating,
      clinicRatingToJson(clinicRating),
    );
    if(response is http.Response && response.statusCode==200){
      ClinicReviewData clinicReviewData = clinicReviewDataFromJson(response.body);
      ClinicRating clinicRating = clinicReviewData.clinicRating;
      return clinicRating;;
    }else{
      return null;
    }
  }

  static Future<dynamic> createDoctorReview(DoctorRating doctorRating) async {
    var response = await ApiClient().postData(
      ApiConstant.doctorRating,
      doctorRatingToJson(doctorRating),
    );
    if(response is http.Response && response.statusCode==200){
      DoctorReviewData doctorReviewData = doctorReviewDataFromJson(response.body);
      DoctorRating doctorRating = doctorReviewData.doctorRating;
      return doctorRating;
    }else{
      return null;
    }
  }

  static Future<dynamic> getClinicReviews(String clinicId) async {
    var response = await ApiClient()
        .getData(ApiConstant.getClinicRatings + clinicId);
    if (response.statusCode == 200) {
      ReviewListData clinicReviewsData = reviewsDataFromJson(response.body);
      List<Review> clinicReviews = clinicReviewsData.reviews;
      return clinicReviews;
    } else {
      return null;
    }
  }

  static Future<dynamic> getDoctorReviews(String doctorId) async {
    var response = await ApiClient()
        .getData(ApiConstant.getDoctorRatings + doctorId);
    if (response.statusCode == 200) {
      ReviewListData doctorReviewData = reviewsDataFromJson(response.body);
      List<Review> doctorReviews = doctorReviewData.reviews;
      return doctorReviews;
    } else {
      return null;
    }
  }
}
