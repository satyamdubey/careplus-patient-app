import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/controller/appointment_controller.dart';
import 'package:careplus_patient/data/model/appointment_availability.dart';
import 'package:careplus_patient/helper/responsive_helper.dart';
import 'package:careplus_patient/view/screens/authorised/book_appointment.dart';
import 'package:careplus_patient/view/widgets/custom_container.dart';
import 'package:careplus_patient/view/widgets/custom_divider.dart';
import 'package:careplus_patient/view/widgets/custom_text_section.dart';
import 'package:careplus_patient/view/widgets/doctor_profile.dart';
import 'package:careplus_patient/view/widgets/navigate_buttons.dart';
import 'package:careplus_patient/view/widgets/status_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorAppointmentScreen extends StatefulWidget {
  final dynamic doctor;
  final dynamic clinic;
  final AppointmentDate appointmentData;

  const DoctorAppointmentScreen({
    Key? key,
    required this.doctor,
    required this.clinic,
    required this.appointmentData,
  }) : super(key: key);

  @override
  State<DoctorAppointmentScreen> createState() =>
      _DoctorAppointmentScreenState();
}

class _DoctorAppointmentScreenState extends State<DoctorAppointmentScreen> {

  final _appointmentController = Get.find<AppointmentController>();

  int _selectedSlot = 0;

  String _shiftTime(int startTime, int endTime) {
    String consultTime = '';
    String _startTime = '';
    String _endTime = '';
    String s_t_a = 'AM';
    String e_t_a = 'AM';

    if (startTime>=12) {
      s_t_a = "PM";
      startTime = startTime-12==0?12:startTime-12;
    }
    if (startTime>=10) {
      _startTime = '$startTime:00';
    }
    if(startTime<10){
      _startTime = '0$startTime:00';
    }
    if (endTime>=12) {
      e_t_a = "PM";
      endTime = endTime-12==0?12:endTime-12;
    }
    if (endTime>=10) {
      _endTime = '$endTime:00';
    }
    if(endTime<10){
      _endTime = '0$endTime:00';
    }
    consultTime = _startTime + ' ' + s_t_a + ' - '  + _endTime + ' ' + e_t_a;
    return consultTime;
  }

  @override
  void initState() {
    super.initState();
    _selectedSlot=0;
    _appointmentController.selectAppointmentShift("morning");
    _appointmentController.selectAppointmentShiftTime(_shiftTime(widget.appointmentData.morning.startTime, widget.appointmentData.morning.endTime));

    if(widget.appointmentData.morning.close){
      _selectedSlot=1;
      _appointmentController.selectAppointmentShift("evening");
      _appointmentController.selectAppointmentShiftTime(_shiftTime(widget.appointmentData.evening.startTime, widget.appointmentData.evening.endTime));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: StatusBar(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _screenBody(),
          _screenBottomButtons(),
        ],
      ),
    );
  }

  Column _screenBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: SizeConfig.blockSizeVertical * 25,
          child: DoctorProfile(doctor: widget.doctor),
        ),
        const Divider(height: 1, thickness: 1.5),
        SizedBox(
          height: VERTICAL_MARGIN_EXTRA_SMALL,
        ),
        Text(
          widget.clinic.name,
          style: nunitoBold.copyWith(
            color: SECONDARY_COLOR,
            fontSize: FONT_SIZE_LARGE,
          ),
        ),
        SizedBox(
          height: VERTICAL_MARGIN_SMALL,
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 10,
          child: CustomTextSection(
            title: 'Address',
            text: widget.clinic.address,
          ),
        ),
        CustomDivider(
          text: 'Consult Time',
          height: SizeConfig.blockSizeVertical * 5,
        ),
        PrimaryContainer(
          height: SizeConfig.blockSizeVertical * 4,
          width: SizeConfig.blockSizeHorizontal * 45,
          radius: RADIUS_DEFAULT,
          text: _selectedSlot==0
              ?_shiftTime(widget.appointmentData.morning.startTime, widget.appointmentData.morning.endTime)
              :_shiftTime(widget.appointmentData.evening.startTime, widget.appointmentData.evening.endTime),
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 2,
        ),
        const Divider(height: 1, thickness: 1.5),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 2,
        ),
        const Text(
          'Check Availability of morning and evening slots',
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 2,
        ),
        ActionRowButtons(
          button1Name: "Morning",
          onTapButton1: () {
            setState(() {
              _selectedSlot = 0;
              _appointmentController.selectAppointmentShift("morning");
              _appointmentController.selectAppointmentShiftTime(_shiftTime(widget.appointmentData.morning.startTime, widget.appointmentData.morning.endTime));
            });
          },
          button1Style: widget.appointmentData.morning.close
              ? ActionRowButtonStyle.disabled
              : _selectedSlot == 0
              ? ActionRowButtonStyle.primary
              : ActionRowButtonStyle.secondary,
          button2Name: "Evening",
          onTapButton2: () {
            setState(() {
              _selectedSlot = 1;
              _appointmentController.selectAppointmentShift("evening");
              _appointmentController.selectAppointmentShiftTime(_shiftTime(widget.appointmentData.evening.startTime, widget.appointmentData.evening.endTime));
            });
          },
          button2Style: widget.appointmentData.evening.close
              ? ActionRowButtonStyle.disabled
              : _selectedSlot == 1
              ? ActionRowButtonStyle.primary
              : ActionRowButtonStyle.secondary,
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 4,
        ),
        _slots(),
      ],
    );
  }

  Widget _screenBottomButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ActionRowButtons(
          onTapButton1: ()=>Navigator.of(context).pop(),
          button1Style: ActionRowButtonStyle.secondary,
          onTapButton2: () => Get.to(() => const BookAppointmentScreen()),
          button2Name: "Book Now",
          button2Style: ActionRowButtonStyle.secondary,
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  Widget _slots() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: VERTICAL_PADDING_DEFAULT,
        horizontal: HORIZONTAL_PADDING_DEFAULT,
      ),
      margin: EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING_LARGE),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(RADIUS_SMALL),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _slot(
            'Available slot',
            Colors.greenAccent.shade700,
            _selectedSlot == 0
                ? widget.appointmentData.morning.availableSlots
                : widget.appointmentData.evening.availableSlots,
          ),
          _slot(
            'Booked slot',
            Colors.redAccent.shade700,
            _selectedSlot == 0
                ? widget.appointmentData.morning.totalSlots-widget.appointmentData.morning.availableSlots
                : widget.appointmentData.evening.totalSlots-widget.appointmentData.evening.availableSlots
          ),
          _slot(
            'Total slot',
            Colors.blue.shade500,
            _selectedSlot == 0
                ? widget.appointmentData.morning.totalSlots
                : widget.appointmentData.evening.totalSlots,
          ),
        ],
      ),
    );
  }

  Widget _slot(slotName, color, slotNumber) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(slotName, style: nunitoMedium),
          const SizedBox(height: 10),
          Container(
            height: 35,
            width: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                RADIUS_EXTRA_SMALL,
              ),
              border: Border.all(
                color: color,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                '$slotNumber',
                style: nunitoBold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
