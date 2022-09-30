import 'package:careplus_patient/data/model/appointment.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class MyAppointmentsController extends GetxController {

  final List<Appointment> myAppointments = [];

  List<Appointment> _selectedDayAppointments = [];

  DateTime _selectedDay = DateTime.now();

  List<Appointment> get selectedDayAppointments => _selectedDayAppointments;

  void selectDay(DateTime value) {
    _selectedDay = value;
    _selectedDayAppointments = myAppointments.where((element){
      return isSameDay(_selectedDay, DateFormat('yyyy-MM-dd').parse(element.bookingDate));
    }).toList();
    update();
  }
}
