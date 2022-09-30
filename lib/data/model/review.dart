import 'dart:convert';

String doctorRatingToJson(DoctorRating data) => json.encode(data.toJson());
DoctorReviewData doctorReviewDataFromJson(String str) => DoctorReviewData.fromJson(json.decode(str));

String clinicRatingToJson(ClinicRating data) => json.encode(data.toJson());
ClinicReviewData clinicReviewDataFromJson(String str) => ClinicReviewData.fromJson(json.decode(str));

ReviewListData reviewsDataFromJson(String str) => ReviewListData.fromJson(json.decode(str));


class DoctorReviewData {
  DoctorReviewData({
    this.status,
    this.message,
    this.doctorRating,
  });

  dynamic status;
  dynamic message;
  dynamic doctorRating;

  factory DoctorReviewData.fromJson(Map<String, dynamic> json) => DoctorReviewData(
    status: json["status"],
    message: json["message"],
    doctorRating: DoctorRating.fromJson(json["doctorRating"]),
  );
}


class DoctorRating {
  DoctorRating({
    this.id,
    required this.doctorId,
    required this.patientId,
    required this.rating,
    required this.review,
  });

  dynamic id;
  String doctorId;
  String patientId;
  int rating;
  String review;

  factory DoctorRating.fromJson(Map<String, dynamic> json) => DoctorRating(
    id: json["_id"],
    rating: json["rating"],
    review: json["review"],
    patientId: json["patient"],
    doctorId: json["doctor"],
  );

  Map<String, dynamic> toJson() => {
    "doctorId": doctorId,
    "patientId": patientId,
    "rating": rating,
    "review": review,
  };
}


class ClinicReviewData {
  ClinicReviewData({
    this.status,
    this.message,
    this.clinicRating,
  });

  dynamic status;
  dynamic message;
  dynamic clinicRating;

  factory ClinicReviewData.fromJson(Map<String, dynamic> json) => ClinicReviewData(
    status: json["status"],
    message: json["message"],
    clinicRating: ClinicRating.fromJson(json["clinicRating"]),
  );
}


class ClinicRating {
  ClinicRating({
    this.id,
    required this.clinicId,
    required this.patientId,
    required this.rating,
    required this.review,
  });

  dynamic id;
  String clinicId;
  String patientId;
  int rating;
  String review;

  factory ClinicRating.fromJson(Map<String, dynamic> json) => ClinicRating(
    id: json["_id"],
    rating: json["rating"],
    review: json["review"],
    patientId: json["patient"],
    clinicId: json["clinic"],
  );

  Map<String, dynamic> toJson() => {
    "clinicId": clinicId,
    "patientId": patientId,
    "rating": rating,
    "review": review,
  };
}


class ReviewListData {
  ReviewListData({
    this.status,
    this.message,
    this.reviews,
  });

  dynamic status;
  dynamic message;
  dynamic reviews;

  factory ReviewListData.fromJson(Map<String, dynamic> json) => ReviewListData(
    status: json["status"],
    message: json["message"],
    reviews: List<Review>.from(json["data"].map((x) => Review.fromJson(x))),
  );
}

class Review{
  Review({
    required this.rating,
    required this.review,
    required this.patient,
  });

  int rating;
  String review;
  Patient patient;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    rating: json["rating"]??0,
    review: json["review"]??'',
    patient: Patient.fromJson(json["patient"]),
  );
}

class Patient {
  Patient({
    this.fullName,
    this.photo,
  });

  dynamic fullName;
  dynamic photo;

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
    fullName: json["fullName"],
    photo: json["photo"],
  );
}
