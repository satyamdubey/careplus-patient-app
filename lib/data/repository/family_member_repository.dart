import 'package:careplus_patient/constant/api_constants.dart';
import 'package:careplus_patient/data/api/api_client.dart';
import 'package:careplus_patient/data/model/family_member.dart';
import 'package:careplus_patient/helper/storage_helper.dart';
import 'package:http/http.dart' as http;


class FamilyMemberRepository {
  static Future<dynamic> getFamilyMembers() async {
    var response = await ApiClient()
        .getData(ApiConstant.getFamilyMembers + StorageHelper.getUserId());
    if (response is http.Response && response.statusCode == 200) {
      FamilyMemberListData familyMemberListData =
          familyMemberListDataFromJson(response.body);
      List<FamilyMember> familyMembers = familyMemberListData.memberList;
      return familyMembers;
    } else if (response is String) {
      print('Exception');
      return null;
    } else {
      print('${response.body}--${response.statusCode}');
      return null;
    }
  }

  static Future<dynamic> addFamilyMember(FamilyMember familyMember) async {
    var response = await ApiClient().postData(
      ApiConstant.addFamilyMember,
      addFamilyMemberToJson(familyMember),
    );
    if (response is http.Response && response.statusCode == 201) {
      return 'Created';
    } else if(response is String){
      print('Exception');
      return null;
    } else {
      print('${response.body}--${response.statusCode}');
      return null;
    }
  }

  static Future<dynamic> removeFamilyMember(FamilyMember familyMember) async {
    print(removeFamilyMemberToJson(familyMember));
    var response = await ApiClient().postData(
      ApiConstant.removeFamilyMember,
      removeFamilyMemberToJson(familyMember),
    );
    if (response is http.Response && response.statusCode == 400) {
      return 'Removed';
    } else if(response is String){
      print('Exception');
      return null;
    } else {
      print('${response.body}--${response.statusCode}');
      return null;
    }
  }
}
