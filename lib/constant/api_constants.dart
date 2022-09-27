class ApiConstant{
  static const String baseUrl = "https://care-plus.herokuapp.com/";


  static const String getImage =  "https://careplusmedia.sgp1.cdn.digitaloceanspaces.com/";

  // auth apis
  static const String signUp = "api/v1/patient/signup/";
  static const String login = "api/v1/patient/login/";

  // location apis
  static const String updateLocation = "api/v1/patient/update/location/";

  // patient apis
  static const String updatePhoto = "api/v1/patient/photo/";
  static const String updateProfile = "api/v1/patient/update/profile/";

  // notification apis
  static const String getNotifications = "api/v1/patient/notification/";

  // promotion apis
  static const String topPromotion = "api/v1/patient/promotions/topPromotions/";
  static const String bottomPromotion = "api/v1/patient/promotions/bottomPromotions/";

  // clinic apis
  static const String getClinic = "api/v1/patient/get/clinic/";
  static const String topClinics = "api/v1/patient/clinics/top/";
  static const String nearByClinics = "api/v1/patient/clinics/near/";

  // doctor apis
  static const String getDoctor = "api/v1/patient/get/doctor/";
  static const String topDoctors = "api/v1/patient/doctors/top/";
  static const String getDepartmentDoctors = "api/v1/patient/get/department/doctors/";

  // department apis
  static const String getDepartments = "api/v1/patient/departments/";

  // favourite apis
  static const String toggleFavouriteClinic = "api/v1/patient/favouriteClinic/";
  static const String getFavouriteClinics = "api/v1/patient/clinics/favourites/";

  // rating apis
  static const String getDoctorRatings = "api/v1/patient/doctor/ratings/";
  static const String getClinicRatings = "api/v1/patient/clinic/ratings/";
  static const String doctorRating = "api/v1/patient/doctor/rating/";
  static const String clinicRating = "api/v1/patient/clinic/rating/";

  // family member apis
  static const String addFamilyMember = "api/v1/patient/family/addMember/";
  static const String getFamilyMembers = "api/v1/patient/family/getMemberList/";
  static const String removeFamilyMember = "api/v1/patient/family/removeMember/";

  // appointment apis
  static const String checkAppointmentAvailability = "api/v1/patient/check/appointment/availability/";
  static const String createSelfAppointment = "api/v1/patient/create/appointment/self/";
  static const String createFamilyMemberAppointment = "api/v1/patient/create/appointment/familyMember/";
  static const String getAppointmentDetail = "api/v1/patient/get/appointment/";
  static const String getAppointments = "api/v1/patient/get/appointments/";
  static const String getUpcomingAppointments = "api/v1/patient/get/appointments/upcoming/";
  static const String cancelAppointment = "api/v1/patient/cancel/appointment/";


}