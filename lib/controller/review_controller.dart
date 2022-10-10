import 'package:careplus_patient/data/model/review.dart';
import 'package:careplus_patient/data/repository/review_repository.dart';
import 'package:get/get.dart';

class ReviewController extends GetxController{

  final List<Review> _clinicReviews = [];

  List<Review> get clinicReviews => _clinicReviews;

  bool _isClinicReviewsLoaded = false;

  bool get isClinicReviewsLoaded => _isClinicReviewsLoaded;


  final List<Review> _doctorReviews = [];

  List<Review> get doctorReviews => _doctorReviews;

  bool _isDoctorReviewsLoaded = false;

  bool get isDoctorReviewsLoaded => _isDoctorReviewsLoaded;


  bool _isDoctorReviewCreated = false;

  bool get isDoctorReviewCreated => _isDoctorReviewCreated;

  bool _isClinicReviewCreated = false;

  bool get isClinicReviewCreated => _isClinicReviewCreated;


  getClinicReviewsFromRepository(String clinicId) async{
    if(_isClinicReviewsLoaded){
      _isClinicReviewsLoaded=false;
    }
    var response = await ReviewRepository.getClinicReviews(clinicId);
    if(response!=null){
      _clinicReviews.assignAll(response);
    }
    _isClinicReviewsLoaded=true;
    update();
  }


  getDoctorReviewsFromRepository(String doctorId) async{
    if(_isDoctorReviewsLoaded){
      _isDoctorReviewsLoaded=false;
    }
    var response = await ReviewRepository.getDoctorReviews(doctorId);
    if(response!=null){
      _doctorReviews.assignAll(response);
    }
    _isDoctorReviewsLoaded=true;
    update();
  }


  Future<bool> createDoctorReview(DoctorRating doctorRating) async{
    var response = await ReviewRepository.createDoctorReview(doctorRating);
    if(response!=null){
      return true;
    }else{
      return false;
    }
  }


  Future<bool> createClinicReview(ClinicRating clinicRating) async{
    var response = await ReviewRepository.createClinicReview(clinicRating);
    if(response!=null){
      return true;
    }else{
      return false;
    }
  }


  Future<bool> reportClinic(String clinicId) async{
    var response = await ReviewRepository.reportClinic(clinicId);
    if(response!=null){
      return true;
    }else{
      return false;
    }
  }


  Future<bool> reportDoctor(String doctorId) async{
    var response = await ReviewRepository.reportDoctor(doctorId);
    if(response!=null){
      return true;
    }else{
      return false;
    }
  }

}