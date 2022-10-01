import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/image_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/controller/appointment_controller.dart';
import 'package:careplus_patient/data/model/appointment_availability.dart';
import 'package:careplus_patient/view/screens/authorised/doctor_appointment.dart';
import 'package:careplus_patient/view/widgets/navigate_buttons.dart';
import 'package:careplus_patient/view/widgets/status_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class SelectAppointmentDateScreen extends StatefulWidget {
  const SelectAppointmentDateScreen({Key? key}) : super(key: key);

  @override
  State<SelectAppointmentDateScreen> createState() => _SelectAppointmentDateScreenState();
}

class _SelectAppointmentDateScreenState extends State<SelectAppointmentDateScreen> {
  final appointmentController = Get.find<AppointmentController>();

  final List<AppointmentDate> _appointmentDataList = [];
  List<DateTime> _availableAppointmentDates = [];

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  final DateTime _firstDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _appointmentDataList.assignAll(appointmentController.availableAppointmentDates);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: StatusBar(),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 7,
            child: _calendarWidget(),
          ),
          const Spacer(flex: 1),
          ActionRowButtons(
            button1Style: ActionRowButtonStyle.secondary,
            button2Style: ActionRowButtonStyle.secondary,
            onTapButton1: ()=>Navigator.of(context).pop(),
            onTapButton2: () {
              if(_selectedDay==null){
                Get.showSnackbar(const GetSnackBar(
                  message: "Please select a available date to continue",
                  duration: Duration(seconds: 2),
                ));
                return;
              }
              if (_availableAppointmentDates.contains(_selectedDay)) {
                AppointmentDate appointmentData = _appointmentDataList.singleWhere(
                      (element) => isSameDay(_selectedDay, DateFormat('yyyy-MM-dd').parse(element.date)));
                appointmentController.selectAppointmentDate(DateFormat("yyyy-M-d").format(_selectedDay!));
                Get.to(()=>DoctorAppointmentScreen(
                  appointmentData: appointmentData,
                  doctor: appointmentController.selectedDoctor,
                  clinic: appointmentController.selectedClinic,
                ));
              } else {
                Get.showSnackbar(const GetSnackBar(
                  message: "No appointment available on selected day",
                  duration: Duration(seconds: 2),
                ));
              }
            },
          ),
          const Spacer(flex: 1),
          Expanded(
            flex: 3,
            child: Image.asset(
              selectDateImage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _calendarWidget() {
    return Container(
      padding: EdgeInsets.only(
        left: VERTICAL_PADDING_LARGE,
        right: VERTICAL_PADDING_LARGE,
        top: VERTICAL_PADDING_SMALL,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            PRIMARY_COLOR_1,
            PRIMARY_COLOR_2,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(RADIUS_LARGE),
          bottomRight: Radius.circular(RADIUS_LARGE),
        ),
      ),
      child: TableCalendar(
        rowHeight: 45,
        firstDay: _firstDay,
        lastDay: DateTime(DateTime.now().year, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        calendarBuilders: CalendarBuilders(markerBuilder: (context, date, _) {
          return _appointmentDataList.any((element) {
            if (DateFormat('yyyy-MM-dd').parse(element.date).day == date.day &&
                DateFormat('yyyy-MM-dd').parse(element.date).month == date.month) {
              bool available = !(element.morning.close && element.evening.close);
              if(available)_availableAppointmentDates.add(date);
              return available;
            } else {
              return false;
            }
            }) ? Center(
                child: Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green.withOpacity(0.75),
                  ),
                  child: Text(
                    '${date.day}',
                    style: nunitoBold.copyWith(color: Colors.white),
                  ),
                ),
              )
            : Center(
                child: Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration:  BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.withOpacity(0.75),
                  ),
                  child: Text(
                    '${date.day}',
                    style: nunitoBold.copyWith(color: Colors.white),
                  ),
                ),
              );
        }),
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          headerPadding: EdgeInsets.only(
            top: VERTICAL_PADDING_SMALL,
            bottom: VERTICAL_PADDING_EXTRA_LARGE,
          ),
          titleTextStyle: nunitoBold.copyWith(
            color: Colors.white,
            fontSize: FONT_SIZE_LARGE,
          ),
          leftChevronVisible: false,
          rightChevronVisible: false,
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: rubikBold.copyWith(
            color: Colors.white,
          ),
          weekendStyle: rubikBold.copyWith(
            color: Colors.white,
          ),
        ),
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3)
          ),
          selectedTextStyle: nunitoBold.copyWith(
            color: Colors.black54,
          ),
          defaultTextStyle: nunitoBold.copyWith(
            color: Colors.white,
          ),
          weekendTextStyle: nunitoBold.copyWith(
            color: Colors.white,
          ),
          outsideTextStyle: nunitoBold.copyWith(
            color: Colors.white,
          ),
          disabledTextStyle: nunitoRegular.copyWith(
            color: const Color.fromARGB(255, 230, 230, 230),
          ),
        ),
      ),
    );
  }
}
