import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper{

  static late SharedPreferences _preferences;


  // initialize in main function
  static Future<void> initialize() async =>
      _preferences = await SharedPreferences.getInstance();


  // clear all data stored in shared preferences
  static Future<void> clear() async{
    await _preferences.clear();
  }

  // reference keys
  static const String _keyUserId = "token";
  static const String _keyUserName = "userName";
  static const String _keyUserPhotoPath = "userPhoto";
  static const String _keyUserPhotoId = "userPhotoId";
  static const String _keyUserAge = "age";
  static const String _keyUserGender = "gender";
  static const String _keyUserPhone = "phone";
  static const String _keyUserAddress = "address";
  static const String _keyUserLocationCoordinates = "locationCoordinates";
  static const String _keyUserLocationName = "locationName";



  static Future<void> setUserId(String userId) async =>
      await _preferences.setString(_keyUserId, userId);

  static dynamic getUserId() =>
      _preferences.getString(_keyUserId);


  static Future<void> setUserName(String userName) async =>
      await _preferences.setString(_keyUserName, userName);

  static dynamic getUserName() =>
      _preferences.getString(_keyUserName);


  static Future<void> setUserPhotoId(dynamic userPhotoId) async{
    if(userPhotoId!=null){
      await _preferences.setString(_keyUserPhotoId, userPhotoId);
    }
  }

  static dynamic getUserPhotoId() =>
      _preferences.getString(_keyUserPhotoId);


  static Future<void> setUserAge(int userAge) async =>
      await _preferences.setInt(_keyUserAge, userAge);

  static dynamic getUserAge() =>
      _preferences.getInt(_keyUserAge);


  static Future<void> setUserGender(String userGender) async =>
      await _preferences.setString(_keyUserGender, userGender);

  static dynamic getUserGender() =>
      _preferences.getString(_keyUserGender);


  static Future<void> setUserPhone(String userPhone) async =>
      await _preferences.setString(_keyUserPhone, userPhone);

  static dynamic getUserPhone() =>
      _preferences.getString(_keyUserPhone);


  static Future<void> setUserAddress(String userAddress) async =>
      await _preferences.setString(_keyUserAddress, userAddress);

  static dynamic getUserAddress() =>
      _preferences.getString(_keyUserAddress);


  static Future<void> setUserLocationCoordinates(List<String> userLocation) async =>
      await _preferences.setStringList(_keyUserLocationCoordinates, userLocation);

  static dynamic getUserLocationCoordinates() =>
      _preferences.getStringList(_keyUserLocationCoordinates);


  static Future<void> setUserLocationName(String userLocation) async =>
      await _preferences.setString(_keyUserLocationName, userLocation);

  static dynamic getUserLocationName() =>
      _preferences.getString(_keyUserLocationName);


}