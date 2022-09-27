import 'package:careplus_patient/data/model/appointment.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MyAppointmentsController extends GetxController {

  final List<Appointment> myAppointments = [];

  List<Appointment> _selectedDayAppointments = [];

  DateTime _selectedDay = DateTime.now();

  List<Appointment> get selectedDayAppointments => _selectedDayAppointments;

  set selectedDay(DateTime value) {
    _selectedDay = value;
    _selectedDayAppointments = myAppointments.where((element) =>
        DateFormat('yyyy-MM-dd').parse(element.bookingDate).day ==
            _selectedDay.day &&
        DateFormat('yyyy-MM-dd').parse(element.bookingDate).month ==
            _selectedDay.month).toList();
    update();
  }

}
