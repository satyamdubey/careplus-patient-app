import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/image_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/controller/appointment_controller.dart';
import 'package:careplus_patient/controller/family_member_controller.dart';
import 'package:careplus_patient/data/model/appointment.dart';
import 'package:careplus_patient/data/model/family_member.dart';
import 'package:careplus_patient/helper/responsive_helper.dart';
import 'package:careplus_patient/services/payment_service.dart';
import 'package:careplus_patient/view/screens/authorised/boooking_confirm.dart';
import 'package:careplus_patient/view/widgets/primary_button.dart';
import 'package:careplus_patient/view/widgets/status_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SelectPaymentModeScreen extends StatefulWidget {
  final int selectedMember;

  const SelectPaymentModeScreen({Key? key, required this.selectedMember})
      : super(key: key);

  @override
  State<SelectPaymentModeScreen> createState() =>
      _SelectPaymentModeScreenState();
}

class _SelectPaymentModeScreenState extends State<SelectPaymentModeScreen> {
  final _familyMemberController = Get.find<FamilyMemberController>();
  final _appointmentController = Get.find<AppointmentController>();

  double clinicFee = 0;
  double tax = 0;
  double total = 0;

  @override
  void initState() {
    super.initState();
    clinicFee = double.parse('${_appointmentController.selectedClinic.fee}');
    tax = (clinicFee * 0.18).roundToDouble();
    total = clinicFee + tax;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(0), child: StatusBar()),
      body: Column(
        children: [
          _topContainer(),
          SizedBox(height: SizeConfig.blockSizeVertical * 20),
          Container(
            width: 100,
            padding: EdgeInsets.symmetric(
              horizontal: HORIZONTAL_PADDING_DEFAULT,
              vertical: VERTICAL_PADDING_SMALL,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: SECONDARY_COLOR),
            ),
            alignment: Alignment.center,
            child: Image.asset(paytmLogo),
          ),
          SizedBox(height: SizeConfig.blockSizeVertical * 5),
          PrimaryButton(
            height: 40,
            width: 120,
            radius: 16,
            text: 'Continue',
            onTap: () {
              _createAppointment(widget.selectedMember);
            },
          )
        ],
      ),
    );
  }

  Widget _topContainer() {
    return Container(
      height: SizeConfig.blockSizeVertical * 30,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        gradient: LinearGradient(
          colors: [
            PRIMARY_COLOR_1,
            PRIMARY_COLOR_2,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              Spacer(flex: 3),
              Text(
                'Payment Mode',
                style: nunitoBold.copyWith(
                  color: Colors.white,
                  fontSize: FONT_SIZE_EXTRA_LARGE,
                ),
              ),
              Spacer(flex: 5),
            ],
          ),
          const Spacer(flex: 2),
          Text(
            'Booking Amount',
            style: nunitoBold.copyWith(
              color: Colors.white,
              fontSize: FONT_SIZE_EXTRA_LARGE,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 20),
              Text(
                '₹ $total/-',
                style: nunitoBold.copyWith(
                  color: Colors.white,
                  fontSize: FONT_SIZE_OVER_LARGE,
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () async {
                  await _openBottomSheet(context);
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 14,
                  child: Center(
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(flex: 1),
          Text(
            'Note we dont take any consulation fees\nyou are only paying appointment fees',
            textAlign: TextAlign.center,
            style: nunitoBold.copyWith(
              color: Colors.white,
            ),
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }

  _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(32),
        ),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: HORIZONTAL_PADDING_LARGE,
            vertical: VERTICAL_PADDING_SMALL,
          ),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Information',
                style: nunitoBold.copyWith(
                  fontSize: FONT_SIZE_LARGE,
                ),
              ),
              const SizedBox(height: 20),
              _textRow(
                'Appointment fee',
                '₹ $clinicFee',
                nunitoBold.copyWith(
                  color: Colors.grey.shade500,
                ),
                nunitoBold.copyWith(
                  color: Colors.black,
                ),
              ),
              const Divider(thickness: 2, height: 12),
              _textRow(
                'GST 18%',
                '₹ $tax',
                rubikBold.copyWith(
                  color: Colors.grey.shade500,
                ),
                nunitoBold.copyWith(
                  color: Colors.black,
                ),
              ),
              const Divider(thickness: 2, height: 12),
              _textRow(
                'Total Price',
                '₹ $total',
                nunitoBold.copyWith(color: Colors.black),
                nunitoBold.copyWith(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _showOrderConfirmDialog(Appointment appointment, String txnId) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 300,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 40),
            Image.asset(paymentSuccess, height: 90, width: 90),
            const SizedBox(height: 20),
            Text(
              'Paid Successfully',
              style: nunitoBold.copyWith(
                fontSize: FONT_SIZE_MEDIUM,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Your Booking has been confirmed\nwith ${appointment.doctor.fullName}",
              textAlign: TextAlign.center,
              style: nunitoBold.copyWith(
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 40),
            _textRow(
              'Appointment ID',
              appointment.appointmentId,
              nunitoBold.copyWith(
                color: Colors.grey.shade500,
                fontSize: FONT_SIZE_SMALL,
              ),
              nunitoBold.copyWith(
                fontSize: FONT_SIZE_SMALL,
              ),
            ),
            const Divider(height: 16, thickness: 2),
            _textRow(
              'Appointment Date',
              DateFormat('dd-MM-yyyy').format(DateFormat('yyyy-MM-dd').parse(appointment.bookingDate)),
              nunitoBold.copyWith(
                color: Colors.grey.shade500,
                fontSize: FONT_SIZE_SMALL,
              ),
              nunitoBold.copyWith(
                fontSize: FONT_SIZE_SMALL,
              ),
            ),
            const Divider(height: 16, thickness: 2),
            _textRow(
              'Doctor meetup time',
              _doctorTime(appointment.meetHours, appointment.meetMinutes),
              nunitoBold.copyWith(
                color: Colors.grey.shade500,
                fontSize: FONT_SIZE_SMALL,
              ),
              nunitoBold.copyWith(
                fontSize: FONT_SIZE_SMALL,
              ),
            ),
            const Divider(height: 16, thickness: 2),
            const SizedBox(height: 30),
            PrimaryButton(
              height: 40,
              width: 100,
              radius: 16,
              text: 'continue',
              onTap: () async {
                await Get.to(() => BookingConfirmationScreen(appointment: appointment));
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Row _textRow(String text1, String text2, TextStyle style1, TextStyle style2) {
    return Row(
      children: [
        Text(
          text1,
          style: style1,
        ),
        const Spacer(),
        AutoSizeText(
          text2,
          maxLines: 1,
          style: style2,
        ),
      ],
    );
  }


  Future<void> _createAppointment(int selectedMember) async {
    FamilyMember familyMember = _familyMemberController.familyMembers[selectedMember];
    EasyLoading.show(status: 'Creating appointment for ${familyMember.name}');
    if (selectedMember == 0) {
      var response = await _appointmentController.createAppointmentForSelf();
      EasyLoading.dismiss();
      if (response != null && response is Appointment) {
        await _initiatePayment(response, total);
      }
    } else {
      var response = await _appointmentController.createAppointmentForFamilyMember(familyMember.id);
      EasyLoading.dismiss();
      if (response != null && response is Appointment) {
        await _initiatePayment(response, total);
      }
    }
  }

  // getting transaction token
  Future<void> _initiatePayment(Appointment appointment, double amount) async {
    EasyLoading.show(status: 'launching payment gateway');
    var tokenResponse = await PaymentService.getTransactionToken(appointment.id, appointment.patient, amount);
    EasyLoading.dismiss();
    if (tokenResponse is http.Response && tokenResponse.statusCode == 201) {
      if (jsonDecode(tokenResponse.body)['status'] == 'Success') {
       _processPayment(appointment, amount, tokenResponse);
      }else{
        EasyLoading.showToast('Some Error In Launching Payment Gateway');
      }
    }
  }

  // start transaction via paytm sdk
  _processPayment(Appointment appointment, double amount, tokenResponse) async{
    String orderId = jsonDecode(tokenResponse.body)['data']['orderId'];
    String txnToken = jsonDecode(tokenResponse.body)['data']['trxResponse']['body']['txnToken'];
    var txnResponse = await PaymentService.startTransaction(orderId, txnToken, amount);
    if (txnResponse != null && txnResponse['STATUS'] == 'TXN_SUCCESS') {
      EasyLoading.show(status: 'processing please wait');
      await PaymentService.sendTransactionResponse(orderId, txnResponse['TXNID']);
      EasyLoading.dismiss();
      showDialog(context: context, barrierDismissible: false, builder: (_) => _showOrderConfirmDialog(appointment, txnResponse['TXNID']));
    } else if (txnResponse != null && txnResponse['STATUS'] == 'TXN_FAILURE') {
      EasyLoading.showToast('Payment unsuccessful');
    }
  }

  String _doctorTime(int meetHrs, int meetMin){
    String meetTime = '';
    String a = '';
    if(meetHrs>=12){
      meetTime = '0${meetHrs-12==0?12:meetHrs-12}';
      a = 'PM';
    }
    if(meetHrs>=10&&meetHrs<12){
      meetTime = '$meetHrs';
      a = 'AM';
    }
    if(meetHrs<10){
      meetTime = '0$meetHrs';
      a = 'AM';
    }
    if(meetMin<10){
      meetTime = '$meetTime:0$meetMin $a' ;
    }
    if(meetMin>10){
      meetTime = '$meetTime:$meetMin $a';
    }
    return meetTime;
  }

}
