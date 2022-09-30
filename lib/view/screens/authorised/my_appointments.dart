import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/controller/appointment_controller.dart';
import 'package:careplus_patient/controller/my_appointments_controller.dart';
import 'package:careplus_patient/helper/responsive_helper.dart';
import 'package:careplus_patient/view/screens/authorised/appointment_detail.dart';
import 'package:careplus_patient/view/widgets/status_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsState();
}

class _MyAppointmentsState extends State<MyAppointmentsScreen> {
  final _appointmentController = Get.find<AppointmentController>();
  final _myAppointmentController = Get.find<MyAppointmentsController>();

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _appointmentController.getAllAppointments();
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
          GetBuilder<AppointmentController>(builder: (_) {
            _myAppointmentController.myAppointments.assignAll(_appointmentController.allAppointmentList);
            return _calendarWidget();
          }),
          Expanded(
            child: _appointmentList(),
          )
        ],
      ),
    );
  }

  Widget _calendarWidget() {
    return Container(
      height: SizeConfig.blockSizeVertical*50,
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
      child: Column(
        children: [
          Text('My Appointments', style: nunitoBold.copyWith(color: Colors.white)),
          TableCalendar(
            daysOfWeekHeight: 30,
            rowHeight: 40,
            firstDay: DateTime(DateTime.now().year, DateTime.now().month, 1),
            lastDay: DateTime(DateTime.now().year, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              _myAppointmentController.selectDay(selectedDay);
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
              return _myAppointmentController.myAppointments.any((element){
                return isSameDay(date, DateFormat('yyyy-MM-dd').parse(element.bookingDate));
              }) ? Center(
                child: Container(
                  width: 26,
                  height: 26,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.amber,
                  ),
                  child: Text(
                    '${date.day}',
                    style: nunitoBold.copyWith(color: Colors.white),
                  ),
                ),
              ) : const SizedBox();
            }),
            headerStyle: HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              headerPadding: const EdgeInsets.symmetric(vertical: 16),
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
              outsideDaysVisible: false,
              isTodayHighlighted: false,
              selectedDecoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.red, width: 2)
              ),
              selectedTextStyle: nunitoBold.copyWith(
                color: Colors.white,
              ),
              defaultTextStyle: nunitoBold.copyWith(
                color: Colors.white,
              ),
              weekendTextStyle: nunitoBold.copyWith(
                color: Colors.white,
              ),
              outsideTextStyle: nunitoBold.copyWith(
                color: Colors.black,
              ),
              disabledTextStyle: nunitoRegular.copyWith(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _appointmentList() {
    return GetBuilder<MyAppointmentsController>(builder: (_){
      return _myAppointmentController.selectedDayAppointments.isEmpty
          ? const Center(child: Text('No appointments for selected day'))
          : ListView.separated(
            shrinkWrap: true,
            itemCount: _myAppointmentController.selectedDayAppointments.length,
            padding: EdgeInsets.only(
              bottom: 60,
              top: VERTICAL_PADDING_DEFAULT,
              left: HORIZONTAL_PADDING_LARGE,
              right: HORIZONTAL_PADDING_LARGE,
            ),
            separatorBuilder: (_, __) => const SizedBox(height: 20),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 75,
                padding: EdgeInsets.symmetric(
                  horizontal: HORIZONTAL_PADDING_SMALL,
                  vertical: VERTICAL_PADDING_EXTRA_SMALL,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(RADIUS_EXTRA_SMALL),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Text.rich(
                    //   TextSpan(text:'Booked for: ', style: nunitoRegular.copyWith(fontSize: FONT_SIZE_SMALL),
                    //     children: [
                    //       TextSpan(
                    //         text: _myAppointmentController.selectedDayAppointments[index].bookingFor,
                    //         style: nunitoBold.copyWith(fontSize: FONT_SIZE_SMALL),
                    //       )
                    //     ],
                    //   )
                    // ),
                    Text.rich(
                      TextSpan(text:'Booking date: ', style: nunitoRegular.copyWith(fontSize: FONT_SIZE_SMALL),
                        children: [
                          TextSpan(
                            text: DateFormat('dd-MM-yyyy').format(DateFormat('yyyy-MM-dd').parse(_myAppointmentController.selectedDayAppointments[index].bookingDate)),
                            style: nunitoBold.copyWith(fontSize: FONT_SIZE_SMALL),
                          )
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(text:'Booking status: ', style: nunitoRegular.copyWith(fontSize: FONT_SIZE_SMALL),
                        children: [
                          TextSpan(
                            text: _myAppointmentController.selectedDayAppointments[index].completed
                                ? "completed"
                                : '${_myAppointmentController.selectedDayAppointments[index].status}',
                            style: nunitoBold.copyWith(fontSize: FONT_SIZE_SMALL),
                          )
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(text:'Completed: ', style: nunitoRegular.copyWith(fontSize: FONT_SIZE_SMALL),
                            children: [
                              TextSpan(
                                text: _myAppointmentController.selectedDayAppointments[index].completed ? 'Yes' : 'No',
                                style: nunitoBold.copyWith(fontSize: FONT_SIZE_SMALL),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: ()=>Get.to(()=>AppointmentDetailScreen(
                            appointmentId: _myAppointmentController.selectedDayAppointments[index].id,
                            status: _myAppointmentController.selectedDayAppointments[index].status
                          )),
                          child: Text(
                            'More Details',
                            style: nunitoBold.copyWith(fontSize: FONT_SIZE_SMALL, color: Colors.blue),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              );
            },
          );
    });
  }
}

