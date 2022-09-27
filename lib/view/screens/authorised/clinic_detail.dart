import 'package:careplus_patient/constant/app_localization.dart';
import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/controller/appointment_controller.dart';
import 'package:careplus_patient/controller/clinic_controller.dart';
import 'package:careplus_patient/data/model/clinic.dart';
import 'package:careplus_patient/helper/responsive_helper.dart';
import 'package:careplus_patient/view/widgets/clinic_profile.dart';
import 'package:careplus_patient/view/widgets/custom_divider.dart';
import 'package:careplus_patient/view/widgets/custom_text_section.dart';
import 'package:careplus_patient/view/widgets/horizontal_item_list.dart';
import 'package:careplus_patient/view/widgets/navigate_buttons.dart';
import 'package:careplus_patient/view/widgets/status_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'select_appointment_date.dart';

class ClinicDetailScreen extends StatefulWidget {
  final String clinicId;

  const ClinicDetailScreen({Key? key, required this.clinicId}) : super(key: key);

  @override
  State<ClinicDetailScreen> createState() => _ClinicDetailScreenState();
}

class _ClinicDetailScreenState extends State<ClinicDetailScreen> {

  final clinicController = Get.find<ClinicController>();
  final appointmentController = Get.find<AppointmentController>();

  @override
  void initState() {
    super.initState();
    clinicController.getClinicFromRepository(widget.clinicId);
  }

  int _selectedSlot = 0;

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

  getWorkingTimeOfClinic(Clinic clinic) {
    int day = DateTime.now().weekday;
    String workingTime = '';
    switch (day) {
      case 1:
        workingTime=_selectedSlot == 0
            ? _clinicTime(clinic.clinicTiming.mon.morningTime.from, clinic.clinicTiming.mon.morningTime.till)
            : _clinicTime(clinic.clinicTiming.mon.eveningTime.from, clinic.clinicTiming.mon.eveningTime.till);
        break;
      case 2:
        workingTime=_selectedSlot == 0
            ? _clinicTime(clinic.clinicTiming.tue.morningTime.from, clinic.clinicTiming.tue.morningTime.till)
            : _clinicTime(clinic.clinicTiming.tue.eveningTime.from, clinic.clinicTiming.tue.eveningTime.till);
        break;
      case 3:
        workingTime=_selectedSlot == 0
            ? _clinicTime(clinic.clinicTiming.wed.morningTime.from, clinic.clinicTiming.wed.morningTime.till)
            : _clinicTime(clinic.clinicTiming.wed.eveningTime.from, clinic.clinicTiming.wed.eveningTime.till);
        break;
      case 4:
        workingTime=_selectedSlot == 0
            ? _clinicTime(clinic.clinicTiming.thr.morningTime.from, clinic.clinicTiming.thr.morningTime.till)
            : _clinicTime(clinic.clinicTiming.thr.eveningTime.from, clinic.clinicTiming.thr.eveningTime.till);
        break;
      case 5:
        workingTime=_selectedSlot == 0
            ? _clinicTime(clinic.clinicTiming.fri.morningTime.from, clinic.clinicTiming.fri.morningTime.till)
            : _clinicTime(clinic.clinicTiming.fri.eveningTime.from, clinic.clinicTiming.fri.eveningTime.till);
        break;
      case 6:
        workingTime=_selectedSlot == 0
            ? _clinicTime(clinic.clinicTiming.sat.morningTime.from, clinic.clinicTiming.sat.morningTime.till)
            : _clinicTime(clinic.clinicTiming.sat.eveningTime.from, clinic.clinicTiming.sat.eveningTime.till);
        break;
      case 7:
        workingTime=_selectedSlot == 0
            ? _clinicTime(clinic.clinicTiming.sun.morningTime.from, clinic.clinicTiming.sun.morningTime.till)
            : _clinicTime(clinic.clinicTiming.sun.eveningTime.from, clinic.clinicTiming.sun.eveningTime.till);
        break;
      default:
        break;
    }
    return workingTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: StatusBar(),
      ),
      body: GetBuilder<ClinicController>(builder: (_){
        return clinicController.isClinicLoaded
            ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _screenBody(clinicController.clinic),
                _screenBottomButtons(),
              ])
            : const Center(child: CircularProgressIndicator());
      }),
    );
  }

  Widget _screenBody(Clinic clinic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: SizeConfig.blockSizeVertical * 24,
          child: ClinicProfile(clinic: clinic),
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 10,
          child: CustomTextSection(
            title: 'About Clinic',
            text: clinic.about,
          ),
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 10,
          child: CustomTextSection(
            title: 'Address',
            text: clinic.address,
          ),
        ),
        CustomDivider(
          text: "Working Time",
          height: SizeConfig.blockSizeVertical * 4,
        ),
        _timeSlotButtons(clinic),
        CustomDivider(
          text: AppLocalization.doctorAvailable,
          height: SizeConfig.blockSizeVertical * 4,
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 25,
          child: DoctorsAvailable(
            doctors: clinic.doctors,
          ),
        ),
      ],
    );
  }

  Widget _timeSlotButtons(Clinic clinic) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: SizeConfig.blockSizeVertical * 0.5),
          Text(getWorkingTimeOfClinic(clinic), style: nunitoRegular),
          SizedBox(height: SizeConfig.blockSizeVertical * 1),
          ActionRowButtons(
            button1Name: "Morning",
            onTapButton1: () {
              setState(() {
                _selectedSlot = 0;
              });
            },
            button1Style: _selectedSlot == 0
                ? ActionRowButtonStyle.primary
                : ActionRowButtonStyle.secondary,

            button2Name: "Evening",
            onTapButton2: () {
              setState(() {
                _selectedSlot = 1;
              });
            },
            button2Style: _selectedSlot == 1
                ? ActionRowButtonStyle.primary
                : ActionRowButtonStyle.secondary,
          ),
          SizedBox(height: SizeConfig.blockSizeVertical * 2),
        ],
      );
    });
  }

  Widget _screenBottomButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ActionRowButtons(
          onTapButton1: () => Navigator.of(context).pop(),
          button1Style: ActionRowButtonStyle.secondary,
          button2Style: ActionRowButtonStyle.secondary,
          onTapButton2: () async {
            if (appointmentController.selectedDoctor != null) {
              await appointmentController
                  .getAvailableAppointmentDates()
                  .then((value) => value
                      ? Get.to(() => const SelectAppointmentDateScreen())
                      : Get.showSnackbar(const GetSnackBar(
                          message: "No appointment dates available",
                          duration: Duration(seconds: 2),
                        )));
            } else {
              Get.showSnackbar(const GetSnackBar(
                message: "Select Any Doctor",
                duration: Duration(seconds: 2),
              ));
            }
          },
        ),
        const SizedBox(height: 4)
      ],
    );
  }
}

class DoctorsAvailable extends StatelessWidget {
  final List<dynamic> doctors;

  const DoctorsAvailable({Key? key, required this.doctors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            PRIMARY_COLOR_1,
            PRIMARY_COLOR_2,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: HorizontalDoctorList(
        bookAppointment: true,
        doctorsList: doctors,
      ),
    );
  }
}
