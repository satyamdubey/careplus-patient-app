import 'package:careplus_patient/data/model/clinic.dart';
import 'package:careplus_patient/data/repository/clinic_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClinicController extends GetxController {

  final List<Clinic> _topClinics = [];
  final List<Clinic> _nearByClinics = [];
  dynamic _clinic;

  List<Clinic> get topClinics => _topClinics;
  List<Clinic> get nearByClinics => _nearByClinics;
  dynamic get clinic => _clinic;


  bool _isTopClinicsLoaded = false;
  bool _isNearByClinicsLoaded = false;
  bool _isClinicLoaded = false;

  bool get isTopClinicsLoaded => _isTopClinicsLoaded;
  bool get isNearByClinicsLoaded => _isNearByClinicsLoaded;
  bool get isClinicLoaded => _isClinicLoaded;


  Future<void> getTopClinicsFromRepository() async {
    _isTopClinicsLoaded = false;
    var response = await ClinicRepository.getTopClinics();
    if (response != null) {
      _topClinics.assignAll(response);
    }
    _isTopClinicsLoaded = true;
    update();
  }

  Future<void> getNearByClinicsFromRepository() async {
    _isNearByClinicsLoaded = false;
    var response = await ClinicRepository.getNearByClinics(10, 1);
    if (response != null) {
      _nearByClinics.assignAll(response);
    }
    _isNearByClinicsLoaded = true;
    update();
  }

  Future<void> getClinicFromRepository(String clinicId) async {
    _isClinicLoaded = false;
    var response = await ClinicRepository.getClinic(clinicId);
    if (response != null) {
      _clinic = response;
    }
    _isClinicLoaded = true;
    update();
  }


  // controller variables for clinic list screen

  int _page = 0;
  int _limit = 10;
  final int _incrementBy = 10;

  final ScrollController _scrollController = ScrollController();

  ScrollController get scrollController {
    return _scrollController;
  }

  void _onScrollClinicList() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _page++;
      _limit = _limit + _incrementBy;
      _isNearByClinicsForListScreenLoaded = false;
      update();
      getNearByClinicsForListScreenFromRepository();
    }
  }


  initClinicListScreen(){
    _page=0;
    _limit=10;
    _nearByClinicsForListScreenFromServer.clear();
    _nearByClinicsForListScreenToClient.clear();
    _isNearByClinicsForListScreenLoaded = false;
    _scrollController.addListener(_onScrollClinicList);
  }


  final List<Clinic> _nearByClinicsForListScreenFromServer = [];
  final List<Clinic> _nearByClinicsForListScreenToClient = [];


  List<Clinic> get nearByClinicsForListScreenFromServer => _nearByClinicsForListScreenFromServer;
  List<Clinic> get nearByClinicsForListScreenToClient => _nearByClinicsForListScreenToClient;


  set nearByClinicsForListScreenToClient(List<Clinic> value) {
    _nearByClinicsForListScreenToClient.assignAll(value);
    update();
  }


  bool _isNearByClinicsForListScreenLoaded = false;
  bool get isNearByClinicsForListScreenLoaded => _isNearByClinicsForListScreenLoaded;


  Future<void> getNearByClinicsForListScreenFromRepository() async {
    var response = await ClinicRepository.getNearByClinics(_limit, _page);
    if (response != null) {
      _nearByClinicsForListScreenFromServer.addAll(response);
      _nearByClinicsForListScreenToClient.addAll(response);
    }
    _isNearByClinicsForListScreenLoaded = true;
    update();
  }

}
