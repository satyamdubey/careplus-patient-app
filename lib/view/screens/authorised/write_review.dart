import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/controller/review_controller.dart';
import 'package:careplus_patient/data/model/review.dart';
import 'package:careplus_patient/helper/storage_helper.dart';
import 'package:careplus_patient/view/widgets/custom_app_bar.dart';
import 'package:careplus_patient/view/widgets/primary_button.dart';
import 'package:careplus_patient/view/widgets/status_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class WriteReviewScreen extends StatefulWidget {
  final String doctorId;
  final String clinicId;

  const WriteReviewScreen({
    Key? key,
    required this.doctorId,
    required this.clinicId,
  }) : super(key: key);

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  int _doctorRating = -1;
  int _clinicRating = -1;
  final ReviewController reviewController = Get.find();

  final _clinicReviewController = TextEditingController();
  final _doctorReviewController = TextEditingController();

  Future<void> _submitReview() async {
    if (_doctorRating == -1 || _doctorReviewController.text.isEmpty) {
      EasyLoading.showToast('Please give rating to doctor and review');
      return;
    }
    if (_clinicRating == -1 || _clinicReviewController.text.isEmpty) {
      EasyLoading.showToast('Please give rating to clinic and review');
      return;
    }
    DoctorRating doctorRating = DoctorRating(
      doctorId: widget.doctorId,
      patientId: StorageHelper.getUserId(),
      rating: _doctorRating,
      review: _doctorReviewController.text,
    );
    ClinicRating clinicRating = ClinicRating(
      clinicId: widget.clinicId,
      patientId: StorageHelper.getUserId(),
      rating: _clinicRating,
      review: _clinicReviewController.text,
    );
    EasyLoading.show(status: "Submitting your review");
    List values = await Future.wait([
      reviewController.createDoctorReview(doctorRating),
      reviewController.createClinicReview(clinicRating),
    ]);
    print(values[0]);
    print(values[1]);
    EasyLoading.dismiss();
    EasyLoading.showToast('Review Submitted');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: StatusBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomAppBar(context: context, title: 'Review'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Review your experience with doctor',
                    style: nunitoBold.copyWith(fontSize: FONT_SIZE_MEDIUM),
                  ),
                  const SizedBox(height: 10),
                  _doctorRatings(),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _doctorReviewController,
                    maxLength: 100,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2.0,
                          color: GRADIENT_COLOR,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2.0,
                          color: GRADIENT_COLOR,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Review your experience with clinic',
                    style: nunitoBold.copyWith(fontSize: FONT_SIZE_MEDIUM),
                  ),
                  const SizedBox(height: 10),
                  _clinicRatings(),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _clinicReviewController,
                    maxLength: 100,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2.0,
                          color: GRADIENT_COLOR,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2.0,
                          color: GRADIENT_COLOR,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  PrimaryButton(
                    height: 40,
                    width: 120,
                    radius: 16,
                    text: 'Submit',
                    onTap: _submitReview,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _doctorRatings() {
    return SizedBox(
      height: 30,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: 5,
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (_, __) => const SizedBox(width: 1),
        itemBuilder: (_, index) {
          return GestureDetector(
            onTap: () => setState(() {
              _doctorRating = index;
            }),
            child: Icon(
              index > -1 && index <= _doctorRating
                  ? Icons.star
                  : Icons.star_outline,
              color: Colors.amber,
            ),
          );
        },
      ),
    );
  }

  _clinicRatings() {
    return SizedBox(
      height: 20,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: 5,
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (_, __) => const SizedBox(width: 1),
        itemBuilder: (_, index) {
          return GestureDetector(
            onTap: () => setState(() {
              _clinicRating = index;
            }),
            child: Icon(
              index > -1 && index <= _clinicRating
                  ? Icons.star
                  : Icons.star_outline,
              color: Colors.amber,
            ),
          );
        },
      ),
    );
  }
}
