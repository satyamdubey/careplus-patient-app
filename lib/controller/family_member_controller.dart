import 'package:careplus_patient/data/model/family_member.dart';
import 'package:careplus_patient/data/repository/family_member_repository.dart';
import 'package:careplus_patient/helper/storage_helper.dart';
import 'package:get/get.dart';

class FamilyMemberController extends GetxController {
  final List<FamilyMember> _familyMembers = [];

  bool _isFamilyMembersLoaded = false;
  bool _isFamilyMemberCreated = false;
  bool _isFamilyMemberDeleted = false;

  bool get familyMembersLoaded => _isFamilyMembersLoaded;

  bool get familyMemberCreated => _isFamilyMemberCreated;

  bool get familyMemberDeleted => _isFamilyMemberDeleted;

  List<FamilyMember> get familyMembers => _familyMembers;

  Future<void> getFamilyMembers() async {
    if (_isFamilyMembersLoaded) {
      _isFamilyMembersLoaded = false;
      update();
    }
    var response = await FamilyMemberRepository.getFamilyMembers();
    if (response != null) {
      FamilyMember member = FamilyMember(
        id: StorageHelper.getUserId(),
        name: 'Myself',
      );
      _familyMembers.assignAll(response);
      _familyMembers.insert(0, member);
    }
    _isFamilyMembersLoaded = true;
    update();
  }

  Future<bool> addFamilyMember(FamilyMember familyMember) async {
    if (_isFamilyMemberCreated) {
      _isFamilyMemberCreated = false;
      update();
    }
    var response = await FamilyMemberRepository.addFamilyMember(familyMember);
    if (response != null) {
      _isFamilyMemberCreated = true;
      update();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> removeFamilyMember(FamilyMember familyMember) async {
    if (_isFamilyMemberDeleted) {
      _isFamilyMemberDeleted = false;
      update();
    }
    var response =
        await FamilyMemberRepository.removeFamilyMember(familyMember);
    if (response != null) {
      _familyMembers.remove(familyMember);
      _isFamilyMemberDeleted = true;
      update();
      return true;
    } else {
      return false;
    }
  }
}
