import 'package:careplus_patient/constant/api_constants.dart';
import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/controller/appointment_controller.dart';
import 'package:careplus_patient/data/model/appointment.dart';
import 'package:careplus_patient/data/model/clinic.dart';
import 'package:careplus_patient/view/screens/authorised/write_review.dart';
import 'package:careplus_patient/view/widgets/custom_app_bar.dart';
import 'package:careplus_patient/view/widgets/primary_button.dart';
import 'package:careplus_patient/view/widgets/secondary_button.dart';
import 'package:careplus_patient/view/widgets/status_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AppointmentDetailScreen extends StatefulWidget {
  final String appointmentId;
  final String status;

  const AppointmentDetailScreen({
    Key? key,
    required this.appointmentId,
    this.status = "booked",
  }) : super(key: key);

  @override
  State<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  final appointmentController = Get.find<AppointmentController>();
  late Appointment appointment = appointmentController.appointmentDetail;

  // cancel appointment at least before 1 day
  Future<void> _cancelAppointment() async {
    if (DateTime.now().compareTo(DateFormat('yyyy-MM-dd').parse(appointment.bookingDate)) < 0) {
      EasyLoading.show(status: 'Cancelling your appointment');
      if (await appointmentController.cancelAppointment(appointment.id)) {
        EasyLoading.dismiss();
        await EasyLoading.show(status: 'Updating your appointments');
        await appointmentController.getUpcomingAppointments();
        EasyLoading.dismiss();
        EasyLoading.showToast('Appointment Canceled');
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        EasyLoading.dismiss();
        EasyLoading.showToast('Some Error In Canceling The Appointment');
      }
    } else {
      EasyLoading.showToast('You can only cancel the appointment before 1 day');
    }
  }

  @override
  void initState() {
    super.initState();
    appointmentController.getAppointmentDetail(widget.appointmentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: StatusBar(),
      ),
      body: GetBuilder<AppointmentController>(
        builder: (_) {
          return !appointmentController.isAppointmentDetailLoaded
              ? const Center(child: CircularProgressIndicator())
              : appointmentController.appointmentDetail == null
                  ? const Center(child: Text('Error in loading appointment details'))
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          CustomAppBar(context: context, title: 'Appointment Detail'),
                          const SizedBox(height: 20),
                          _appointmentDetails(),
                          const SizedBox(height: 20),
                          PrimaryButton(
                            height: 40,
                            width: 120,
                            radius: 16,
                            text: widget.status=="booked"
                                ?"Cancel"
                                :"Back",
                            onTap: widget.status=="booked"
                                ? _cancelAppointment
                                : () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    );
        },
      ),
    );
  }

  Widget _appointmentDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Appointment Details',
            style: nunitoBold.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 10),
          _doctorProfile(),
          const SizedBox(height: 15),
          _bookingId(),
          const SizedBox(height: 15),
          _bookedFor(),
          const SizedBox(height: 15),
          _bookingStatus(),
          const SizedBox(height: 15),
          _appointmentDateTime(),
          const SizedBox(height: 15),
          _slot(),
          const SizedBox(height: 15),
          _meetupTime(),
          const SizedBox(height: 30),
          Text(
            'Clinic Details',
            style: nunitoBold.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 10),
          _clinicDetails(),
          const SizedBox(height: 30),
          Text(
            'Transaction Details',
            style: nunitoBold.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 10),
          _transactionDetails(),
        ],
      ),
    );
  }

  Widget _doctorProfile() {
    return Row(
      children: [
        Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            color: ITEM_BACKGOUND_COLOR,
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: Image.network(ApiConstant.getImage + appointment.doctor.photo).image,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              appointment.doctor.fullName,
              style: nunitoBold.copyWith(
                fontSize: FONT_SIZE_MEDIUM,
              ),
            ),
            Text(
              appointment.doctor.department,
              style: nunitoRegular.copyWith(
                fontSize: FONT_SIZE_SMALL,
              ),
            ),
          ],
        ),
        const Spacer(),
        Visibility(
          visible: widget.status=="completed" || appointment.completed,
          child: SecondaryButton(
            height: 35,
            width: 90,
            radius: 16,
            text: "Review",
            onTap: ()=>Get.to(()=>WriteReviewScreen(
              doctorId: appointment.doctor.id,
              clinicId: appointment.clinic.id,
            )),
          ),
        )
      ],
    );
  }

  Widget _bookingId() {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.book_sharp,
            color: Colors.blue,
          ),
          const SizedBox(width: 10),
          Text(
            'Booking Id',
            style: nunitoBold.copyWith(fontSize: FONT_SIZE_SMALL),
          ),
          const Spacer(),
          Text(
            appointment.id,
            style: nunitoBold.copyWith(
              color: Colors.black54,
              fontSize: FONT_SIZE_SMALL,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bookedFor() {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.person,
            color: Colors.blue,
          ),
          const SizedBox(width: 10),
          Text(
            'Booked For',
            style: nunitoBold.copyWith(fontSize: FONT_SIZE_SMALL),
          ),
          const Spacer(),
          Text(
            appointment.bookingFor,
            style: nunitoBold.copyWith(
              color: Colors.black54,
              fontSize: FONT_SIZE_DEFAULT,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bookingStatus() {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.ballot_outlined,
            color: Colors.blue,
          ),
          const SizedBox(width: 10),
          Text(
            'Booking Status',
            style: nunitoBold.copyWith(fontSize: FONT_SIZE_SMALL),
          ),
          const Spacer(),
          Text(
            appointment.status,
            style: nunitoBold.copyWith(
              color: Colors.black54,
              fontSize: FONT_SIZE_DEFAULT,
            ),
          ),
        ],
      ),
    );
  }

  Widget _appointmentDateTime() {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_month_outlined,
            color: Colors.blue,
          ),
          const SizedBox(width: 10),
          Text(
            'Appointment Date & Time',
            style: nunitoBold.copyWith(fontSize: FONT_SIZE_SMALL),
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                appointmentController.appointmentDetail.bookingDate,
                style: nunitoBold.copyWith(
                  color: Colors.black54,
                  fontSize: FONT_SIZE_SMALL,
                ),
              ),
              Text(
                _doctorTime(appointment.meetHours, appointment.meetMinutes),
                style: nunitoBold.copyWith(
                  color: Colors.black54,
                  fontSize: FONT_SIZE_DEFAULT,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _slot() {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.book_sharp,
            color: Colors.blue,
          ),
          const SizedBox(width: 10),
          Text(
            'Slot number',
            style: nunitoBold.copyWith(fontSize: FONT_SIZE_SMALL),
          ),
          const Spacer(),
          Text(
            '${appointment.slot??'No data'}',
            style: nunitoBold.copyWith(
              color: Colors.black54,
              fontSize: FONT_SIZE_SMALL,
            ),
          ),
        ],
      ),
    );
  }


  Widget _meetupTime() {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.book_sharp,
            color: Colors.blue,
          ),
          const SizedBox(width: 10),
          Text(
            'Doctor meet-up time\n(approximately)',
            style: nunitoBold.copyWith(fontSize: FONT_SIZE_SMALL),
          ),
          const Spacer(),
          Text(
            'No data',
            style: nunitoBold.copyWith(
              color: Colors.black54,
              fontSize: FONT_SIZE_SMALL,
            ),
          ),
        ],
      ),
    );
  }


  Widget _clinicDetails() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(Icons.apartment, color: SECONDARY_COLOR, size: 20),
              const SizedBox(width: 10),
              Expanded(
                flex: 4,
                child: Text(
                  'Clinic Name :',
                  style: nunitoBold.copyWith(
                    fontSize: FONT_SIZE_SMALL,
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Text(
                  appointment.clinic.name,
                  style: nunitoBold.copyWith(
                    color: Colors.black54,
                    fontSize: FONT_SIZE_DEFAULT,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(
                Icons.watch_later_outlined,
                color: SECONDARY_COLOR,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 4,
                child: Text(
                  'Morning Time :',
                  style: nunitoBold.copyWith(
                    fontSize: FONT_SIZE_SMALL,
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Text(
                  getWorkingTimeOfClinic(appointment.clinic)[0],
                  style: nunitoBold.copyWith(
                    color: Colors.black54,
                    fontSize: FONT_SIZE_DEFAULT,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(
                Icons.watch_later_outlined,
                color: SECONDARY_COLOR,
                size: 20,
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 4,
                child: Text(
                  'Evening Time :',
                  style: nunitoBold.copyWith(
                    fontSize: FONT_SIZE_SMALL,
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Text(
                  getWorkingTimeOfClinic(appointment.clinic)[1],
                  style: nunitoBold.copyWith(
                    color: Colors.black54,
                    fontSize: FONT_SIZE_DEFAULT,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, color: SECONDARY_COLOR, size: 20),
              const SizedBox(width: 10),
              Expanded(
                flex: 4,
                child: Text(
                  'Clinic Address :',
                  style: nunitoBold.copyWith(
                    fontSize: FONT_SIZE_SMALL,
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Text(
                  appointment.clinic.address,
                  style: nunitoBold.copyWith(
                    color: Colors.black54,
                    fontSize: FONT_SIZE_DEFAULT,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _transactionDetails() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.apartment, color: SECONDARY_COLOR, size: 20),
              const SizedBox(width: 10),
              Expanded(
                flex: 5,
                child: Text(
                  'Transaction Id :',
                  style: nunitoBold.copyWith(
                    fontSize: FONT_SIZE_SMALL,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  appointment.transactionId??'',
                  style: nunitoBold.copyWith(
                    color: Colors.black54,
                    fontSize: FONT_SIZE_SMALL,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(
                Icons.watch_later_outlined,
                color: SECONDARY_COLOR,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 5,
                child: Text(
                  'Transaction Status :',
                  style: nunitoBold.copyWith(
                    fontSize: FONT_SIZE_SMALL,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  appointment.trxStatus??'',
                  style: nunitoBold.copyWith(
                    color: Colors.black54,
                    fontSize: FONT_SIZE_DEFAULT,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<String> getWorkingTimeOfClinic(Clinic clinic) {
    int day = DateTime.now().weekday;
    String morningTime = '';
    String eveningTime = '';
    switch (day) {
      case 1:
        morningTime = _clinicTime(clinic.clinicTiming.mon.morningTime.from,
            clinic.clinicTiming.mon.morningTime.till);
        eveningTime = _clinicTime(clinic.clinicTiming.mon.eveningTime.from,
            clinic.clinicTiming.mon.eveningTime.till);
        break;
      case 2:
        morningTime = _clinicTime(clinic.clinicTiming.mon.morningTime.from,
            clinic.clinicTiming.mon.morningTime.till);
        eveningTime = _clinicTime(clinic.clinicTiming.mon.eveningTime.from,
            clinic.clinicTiming.mon.eveningTime.till);
        break;
      case 3:
        morningTime = _clinicTime(clinic.clinicTiming.mon.morningTime.from,
            clinic.clinicTiming.mon.morningTime.till);
        eveningTime = _clinicTime(clinic.clinicTiming.mon.eveningTime.from,
            clinic.clinicTiming.mon.eveningTime.till);
        break;
      case 4:
        morningTime = _clinicTime(clinic.clinicTiming.mon.morningTime.from,
            clinic.clinicTiming.mon.morningTime.till);
        eveningTime = _clinicTime(clinic.clinicTiming.mon.eveningTime.from,
            clinic.clinicTiming.mon.eveningTime.till);
        break;
      case 5:
        morningTime = _clinicTime(clinic.clinicTiming.mon.morningTime.from,
            clinic.clinicTiming.mon.morningTime.till);
        eveningTime = _clinicTime(clinic.clinicTiming.mon.eveningTime.from,
            clinic.clinicTiming.mon.eveningTime.till);
        break;
      case 6:
        morningTime = _clinicTime(clinic.clinicTiming.mon.morningTime.from,
            clinic.clinicTiming.mon.morningTime.till);
        eveningTime = _clinicTime(clinic.clinicTiming.mon.eveningTime.from,
            clinic.clinicTiming.mon.eveningTime.till);
        break;
      case 7:
        morningTime = _clinicTime(clinic.clinicTiming.mon.morningTime.from,
            clinic.clinicTiming.mon.morningTime.till);
        eveningTime = _clinicTime(clinic.clinicTiming.mon.eveningTime.from,
            clinic.clinicTiming.mon.eveningTime.till);
        break;
      default:
        break;
    }
    return [morningTime, eveningTime];
  }

  String _clinicTime(int startTime, int endTime) {
    String consultTime = '';
    String _startTime = '';
    String _endTime = '';
    String s_t_a = 'AM';
    String e_t_a = 'AM';
    if (startTime>=12) {
      s_t_a = "PM";
      startTime = startTime == 12 ? 12 : startTime - 12;
    }
    if (startTime>=10 && startTime<12) {
      _startTime = '$startTime:00';
    }
    if(startTime<10){
      _startTime = '0$startTime:00';
    }
    if (endTime>=12) {
      e_t_a = "PM";
      endTime = endTime == 12 ? 12 : endTime - 12;
    }
    if (endTime>=10 && endTime<12) {
      _endTime = '$endTime:00';
    }
    if(endTime<10){
      _endTime = '0$endTime:00';
    }
    consultTime = _startTime + ' ' + s_t_a + ' - '  + _endTime + ' ' + e_t_a;
    return consultTime;
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
