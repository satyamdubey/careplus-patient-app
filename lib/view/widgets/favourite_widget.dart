import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/controller/favourite_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ClinicFavouriteWidget extends StatefulWidget {
  final bool isFavourite;
  final String clinicId;
  final int? position;


  const ClinicFavouriteWidget({
    Key? key,
    this.position,
    required this.clinicId,
    required this.isFavourite,
  }) : super(key: key);

  @override
  State<ClinicFavouriteWidget> createState() => _ClinicFavouriteWidgetState();
}

class _ClinicFavouriteWidgetState extends State<ClinicFavouriteWidget> {
  late bool filled = widget.isFavourite;

  FavouriteController favouriteController = Get.find();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if(!filled){
          EasyLoading.showToast('adding to favourite');
        }else{
          EasyLoading.showToast('removing from favourite');
        }
        bool response = await favouriteController.toggleFavouriteWidget(widget.clinicId);
        if (response) {
          setState(() {
            filled = !filled;
          });
          if(!filled && widget.position!=null){
            favouriteController.removeFromFavouriteList(widget.position!);
          }
        } else {
          EasyLoading.showToast('Some error');
        }
      },
      child: Icon(
        filled ? Icons.star : Icons.star_border,
        size: ICON_SIZE_DEFAULT,
      ),
    );
  }
}

class DoctorFavouriteWidget extends StatefulWidget {
  final bool filled;
  final String doctorId;

  const DoctorFavouriteWidget({
    Key? key,
    this.filled = false,
    required this.doctorId,
  }) : super(key: key);

  @override
  State<DoctorFavouriteWidget> createState() => _DoctorFavouriteWidgetState();
}

class _DoctorFavouriteWidgetState extends State<DoctorFavouriteWidget> {
  late bool filled = widget.filled;

  FavouriteController favouriteController = Get.find();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        bool response = await favouriteController.toggleFavouriteWidget(widget.doctorId);
        if (response) {
          setState(() {
            filled = !filled;
          });
        } else {
          EasyLoading.showToast('Some error');
        }
      },
      child: Icon(
        filled ? Icons.star : Icons.star_border,
        size: ICON_SIZE_DEFAULT,
      ),
    );
  }
}
