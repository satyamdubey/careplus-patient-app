import 'package:careplus_patient/data/model/promotion.dart';
import 'package:careplus_patient/data/repository/promotion_repository.dart';
import 'package:get/get.dart';

class PromotionController extends GetxController {

  final List<Promotion> _topPromotions = [];
  List<Promotion> get topPromotions => _topPromotions;

  final List<Promotion> _bottomPromotions = [];
  List<Promotion> get bottomPromotions => _bottomPromotions;

  bool _isBottomPromotionsLoaded = false;
  bool get isTopPromotionsLoaded => _isTopPromotionsLoaded;

  bool _isTopPromotionsLoaded = false;
  bool get isBottomPromotionsLoaded => _isBottomPromotionsLoaded;


  Future<void> getTopPromotionsFromRepository() async {
    if (_isTopPromotionsLoaded) {
      _isTopPromotionsLoaded = false;
      update();
    }
    var response = await PromotionRepository.getTopPromotions();
    if (response != null) {
      _topPromotions.assignAll(response);
    }
    _isTopPromotionsLoaded = true;
    update();
  }


  Future<void> getBottomPromotionsFromRepository() async {
    if (_isBottomPromotionsLoaded) {
      _isBottomPromotionsLoaded = false;
      update();
    }
    var response = await PromotionRepository.getBottomPromotions();
    if (response != null) {
      _bottomPromotions.assignAll(response);
    }
    _isBottomPromotionsLoaded = true;
    update();
  }
}
