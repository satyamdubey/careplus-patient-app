import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/controller/review_controller.dart';
import 'package:careplus_patient/data/model/clinic.dart';
import 'package:careplus_patient/data/model/review.dart';
import 'package:careplus_patient/helper/responsive_helper.dart';
import 'package:careplus_patient/view/widgets/custom_app_bar.dart';
import 'package:careplus_patient/view/widgets/rating_stars.dart';
import 'package:careplus_patient/view/widgets/status_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ClinicReviewsScreen extends StatefulWidget {
  final Clinic clinic;

  const ClinicReviewsScreen({Key? key, required this.clinic}) : super(key: key);

  @override
  State<ClinicReviewsScreen> createState() => _ClinicReviewsScreenState();
}

class _ClinicReviewsScreenState extends State<ClinicReviewsScreen> {
  final ReviewController reviewController = Get.find();

  @override
  void initState() {
    super.initState();
    reviewController.getClinicReviewsFromRepository(widget.clinic.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: StatusBar(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(
            title: "Reviews",
            context: context,
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 5,
          ),
          _ratingTitle(),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 5,
          ),
          GetBuilder<ReviewController>(
            builder: (_) {
              return reviewController.isClinicReviewsLoaded
                  ? _ratingList(reviewController.clinicReviews)
                  : const Center(child: CircularProgressIndicator());
            },
          )
        ],
      ),
    );
  }

  Widget _ratingTitle() {
    return Padding(
      padding: EdgeInsets.only(left: HORIZONTAL_PADDING_LARGE),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rating and Reviews',
            style: nunitoBold.copyWith(
              fontSize: FONT_SIZE_LARGE,
            ),
          ),
          Row(
            children: [
              RatingStar(
                rating: (widget.clinic.averageRating).round(),
                iconSize: ICON_SIZE_LARGE,
              ),
              Text(
                '(${widget.clinic.reviewsCount})',
                style: nunitoBold.copyWith(
                  fontSize: FONT_SIZE_MEDIUM,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Expanded _ratingList(List<Review> reviews) {
    return Expanded(
      child: ListView.separated(
        itemCount: reviews.length,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(vertical: VERTICAL_PADDING_DEFAULT),
        separatorBuilder: (_, __) => const Divider(height: 8, thickness: 1.5),
        itemBuilder: (context, index) {
          return ListTile(
              dense: true,
              minLeadingWidth: 0,
              horizontalTitleGap: 8,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    reviews[index].patient.fullName,
                    style: robotoBold.copyWith(
                      fontSize: FONT_SIZE_DEFAULT,
                    ),
                  ),
                  SizedBox(width: HORIZONTAL_MARGIN_SMALL),
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: ICON_SIZE_DEFAULT,
                  ),
                  Text(
                    '${reviews[index].rating}',
                    style: robotoRegular.copyWith(
                      fontSize: FONT_SIZE_DEFAULT,
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                reviews[index].review,
                style: robotoBold.copyWith(
                  color: Colors.black54,
                  fontSize: FONT_SIZE_SMALL,
                ),
              ),
              trailing: PopupMenuButton(
                child: const Icon(Icons.more_vert),
                itemBuilder: (context) {
                  return List.generate(1, (index) {
                    return PopupMenuItem(
                      child: const Text('Flag as abusive'),
                      onTap: () {
                        reviewController
                          .reportClinic(reviews[index].id)
                          .then((value) {
                            if (value) {
                              EasyLoading.showToast('Flagged as abusive');
                            } else {
                              EasyLoading.showToast('Some error');
                            }
                        });
                      },
                    );
                  });
                },
              ),
            );
        },
      ),
    );
  }
}
