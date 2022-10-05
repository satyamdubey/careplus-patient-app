import 'package:careplus_patient/constant/api_constants.dart';
import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/image_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/data/model/appointment.dart';
import 'package:careplus_patient/data/model/clinic.dart';
import 'package:careplus_patient/helper/responsive_helper.dart';
import 'package:careplus_patient/view/widgets/primary_button.dart';
import 'package:careplus_patient/view/widgets/status_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final Appointment appointment;

  const BookingConfirmationScreen({Key? key, required this.appointment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: StatusBar(),
      ),
      body: Column(
        children: [
          _topContainer(),
          SizedBox(height: 10),
          _appointmentDetails(),
          SizedBox(height: 30),
          PrimaryButton(
            height: 40,
            width: 120,
            radius: 16,
            text: 'Done',
            onTap: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          )
        ],
      ),
    );
  }

  Widget _topContainer() {
    return Container(
      height: SizeConfig.blockSizeVertical * 30,
      width: double.infinity,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(bookingConfirm),
          const SizedBox(height: 20),
          Text(
            'Booking Confirmation',
            style: nunitoBold.copyWith(
              color: Colors.white,
              fontSize: FONT_SIZE_EXTRA_LARGE,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'ID #${appointment.appointmentId}',
            style: nunitoBold.copyWith(
              color: Colors.white,
              fontSize: FONT_SIZE_MEDIUM,
            ),
          )
        ],
      ),
    );
  }

  Widget _appointmentDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appointment Details',
              style: nunitoBold.copyWith(color: Colors.grey),
            ),
            SizedBox(height: 30),
            _doctorProfile(),
            SizedBox(height: 15),
            _slot(),
            SizedBox(height: 15),
            _appointmentDateTime(),
            SizedBox(height: 15),
            _clinicDetails(appointment.clinic),
          ],
        ),
      ),
    );
  }

  Row _doctorProfile() {
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
        )
      ],
    );
  }

  Widget _slot() {
    return Container(
      height: 50,
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
            '${appointment.slotNo??'No data'}',
            style: nunitoBold.copyWith(
              color: Colors.black54,
              fontSize: FONT_SIZE_SMALL,
            ),
          ),
        ],
      ),
    );
  }


  _appointmentDateTime() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_month_outlined,
            color: Colors.blue,
          ),
          const SizedBox(width: 20),
          Text('Date & Time', style: nunitoBold),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                DateFormat('dd-MM-yyyy').format(DateFormat('yyyy-MM-dd').parse(appointment.bookingDate)),
                style: nunitoBold.copyWith(
                  color: Colors.grey,
                  fontSize: FONT_SIZE_SMALL,
                ),
              ),
              Text(
                _doctorTime(appointment.meetHours, appointment.meetMinutes),
                style: nunitoBold.copyWith(
                  fontSize: FONT_SIZE_DEFAULT,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _clinicDetails(clinic) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Clinic Name: ',
                  style: nunitoBold.copyWith(
                    color: Colors.grey,
                    fontSize: FONT_SIZE_SMALL,
                  ),
                ),
              ),
              Spacer(),
              Expanded(
                flex: 5,
                child: Text(
                  appointment.clinic.name,
                  style: nunitoBold.copyWith(
                    fontSize: FONT_SIZE_DEFAULT,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Clinic Address: ',
                  style: nunitoBold.copyWith(
                    color: Colors.grey,
                    fontSize: FONT_SIZE_SMALL,
                  ),
                ),
              ),
              const Spacer(),
              Expanded(
                flex: 5,
                child: Text(
                  appointment.clinic.address,
                  style: nunitoBold.copyWith(
                    fontSize: FONT_SIZE_DEFAULT,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Morning Timing: ',
                  style: nunitoBold.copyWith(
                    color: Colors.grey,
                    fontSize: FONT_SIZE_SMALL,
                  ),
                ),
              ),
              Spacer(),
              Expanded(
                flex: 5,
                child: Text(
                  getWorkingTimeOfClinic(clinic)[0],
                  style: nunitoBold.copyWith(
                    fontSize: FONT_SIZE_DEFAULT,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Evening Timing: ',
                  style: nunitoBold.copyWith(
                    color: Colors.grey,
                    fontSize: FONT_SIZE_SMALL,
                  ),
                ),
              ),
              Spacer(),
              Expanded(
                flex: 5,
                child: Text(
                  getWorkingTimeOfClinic(clinic)[1],
                  style: nunitoBold.copyWith(
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

  String timeFromHour(int startTime, int endTime) {
    String consultTime = '';
    String _startTime = '';
    String _endTime = '';
    String startTimeFormat = 'AM';
    String endTimeFormat = 'AM';
    if (startTime >= 12) {
      startTimeFormat = "PM";
      startTime = startTime == 12 ? 12 : startTime - 12;
    }
    if (startTime < 10) {
      _startTime = '0$startTime:00';
    } else {
      _startTime = '$startTime:00';
    }
    if (endTime >= 12) {
      endTimeFormat = "PM";
      endTime = endTime == 12 ? 12 : endTime - 12;
    }
    if (endTime < 10) {
      _endTime = '0$endTime:00';
    } else {
      _endTime = '$endTime:00';
    }
    consultTime = _startTime +
        ' ' +
        startTimeFormat +
        " - " +
        _endTime +
        ' ' +
        endTimeFormat;
    return consultTime;
  }

  List<String> getWorkingTimeOfClinic(Clinic clinic) {
    int day = DateTime.now().weekday;
    String morningTime = '';
    String eveningTime = '';
    switch (day) {
      case 1:
        morningTime = timeFromHour(clinic.clinicTiming.mon.morningTime.from,
            clinic.clinicTiming.mon.morningTime.till);
        eveningTime = timeFromHour(clinic.clinicTiming.mon.eveningTime.from,
            clinic.clinicTiming.mon.eveningTime.till);
        break;
      case 2:
        morningTime = timeFromHour(clinic.clinicTiming.mon.morningTime.from,
            clinic.clinicTiming.mon.morningTime.till);
        eveningTime = timeFromHour(clinic.clinicTiming.mon.eveningTime.from,
            clinic.clinicTiming.mon.eveningTime.till);
        break;
      case 3:
        morningTime = timeFromHour(clinic.clinicTiming.mon.morningTime.from,
            clinic.clinicTiming.mon.morningTime.till);
        eveningTime = timeFromHour(clinic.clinicTiming.mon.eveningTime.from,
            clinic.clinicTiming.mon.eveningTime.till);
        break;
      case 4:
        morningTime = timeFromHour(clinic.clinicTiming.mon.morningTime.from,
            clinic.clinicTiming.mon.morningTime.till);
        eveningTime = timeFromHour(clinic.clinicTiming.mon.eveningTime.from,
            clinic.clinicTiming.mon.eveningTime.till);
        break;
      case 5:
        morningTime = timeFromHour(clinic.clinicTiming.mon.morningTime.from,
            clinic.clinicTiming.mon.morningTime.till);
        eveningTime = timeFromHour(clinic.clinicTiming.mon.eveningTime.from,
            clinic.clinicTiming.mon.eveningTime.till);
        break;
      case 6:
        morningTime = timeFromHour(clinic.clinicTiming.mon.morningTime.from,
            clinic.clinicTiming.mon.morningTime.till);
        eveningTime = timeFromHour(clinic.clinicTiming.mon.eveningTime.from,
            clinic.clinicTiming.mon.eveningTime.till);
        break;
      case 7:
        morningTime = timeFromHour(clinic.clinicTiming.mon.morningTime.from,
            clinic.clinicTiming.mon.morningTime.till);
        eveningTime = timeFromHour(clinic.clinicTiming.mon.eveningTime.from,
            clinic.clinicTiming.mon.eveningTime.till);
        break;
      default:
        break;
    }
    return [morningTime, eveningTime];
  }
}

String _doctorTime(int meetHrs, int meetMin) {
    String meetTime = '';
    String a = '';
    if (meetHrs >= 12) {
      meetTime = '${meetHrs - 12 == 0 ? 12 : '0${meetHrs - 12}'}';
      a = 'PM';
    }
    if (meetHrs >= 10 && meetHrs < 12) {
      meetTime = '$meetHrs';
      a = 'AM';
    }
    if (meetHrs < 10) {
      meetTime = '0$meetHrs';
      a = 'AM';
    }
    if (meetMin < 10) {
      meetTime = '$meetTime:0$meetMin $a';
    }
    if (meetMin >= 10) {
      meetTime = '$meetTime:$meetMin $a';
    }
    return meetTime;
  }