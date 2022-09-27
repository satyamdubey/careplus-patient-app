import 'package:careplus_patient/data/model/clinic.dart';
import 'package:careplus_patient/data/repository/favourite_repository.dart';
import 'package:get/get.dart';

class FavouriteController extends GetxController{

  List<Clinic> _favouriteClinics = [];

  List<Clinic> get favouriteClinics => _favouriteClinics;

  bool _isFavouriteClinicsLoaded = false;

  bool get isFavouriteClinicsLoaded => _isFavouriteClinicsLoaded;


  Future<bool> toggleFavouriteWidget(String clinicId) async{
    var response = await FavouriteRepository.toggleFavouriteClinic(clinicId);
    return response;
  }


  Future<void> getFavouriteClinicsFromRepository() async{
    _isFavouriteClinicsLoaded=false;
    var response = await FavouriteRepository.getFavouriteClinics();
    if(response!=null){
      _favouriteClinics.assignAll(response);
    }
    _isFavouriteClinicsLoaded = true;
    update();
  }

  removeFromFavouriteList(int position){
    _favouriteClinics.removeAt(position);
    update();
  }

}