import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/style_constants.dart';
import 'package:careplus_patient/controller/user_location_controller.dart';
import 'package:careplus_patient/helper/responsive_helper.dart';
import 'package:careplus_patient/view/widgets/navigate_buttons.dart';
import 'package:careplus_patient/view/widgets/status_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_place/google_place.dart';

class GooglePlaceScreen extends StatefulWidget {
  const GooglePlaceScreen({Key? key}) : super(key: key);

  @override
  State<GooglePlaceScreen> createState() => _GooglePlaceScreenState();
}

class _GooglePlaceScreenState extends State<GooglePlaceScreen> {
  final UserLocationController userLocationController = Get.find();

  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];

  int _selectedTile = -1;
  String _selectedLocationName = 'select location';
  List<String> _selectedLocationCoordinates = List.filled(2, '');

  @override
  void initState() {
    googlePlace = GooglePlace('AIzaSyCVqXDtDy3g-LxgA54tQKeoZbfb-2vc9as');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: StatusBar(),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                      labelText: "Search your location",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2.0,
                          color: GRADIENT_COLOR,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2.0,
                          color: GRADIENT_COLOR,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2.0,
                          color: GRADIENT_COLOR,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2.0,
                          color: GRADIENT_COLOR,
                        ),
                      )),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      autoCompleteSearch(value);
                    } else {
                      if (predictions.length > 0 && mounted) {
                        setState(() {
                          predictions = [];
                        });
                      }
                    }
                  },
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 75,
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: predictions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          _selectedTile = index;
                          debugPrint(predictions[index].placeId);
                          getDetails(predictions[index].placeId);
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: _selectedTile == index
                                ? Colors.blue
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 5),
                              CircleAvatar(
                                backgroundColor: _selectedTile == index
                                    ? Colors.white
                                    : Colors.blue,
                                child: Icon(
                                  Icons.pin_drop,
                                  color: _selectedTile == index
                                      ? Colors.blue
                                      : Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  predictions[index].description ?? '',
                                  style: nunitoRegular.copyWith(
                                    color: _selectedTile == index
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                ActionRowButtons(
                  button1Name: 'Back',
                  button2Name: 'Confirm',
                  button1Style: ActionRowButtonStyle.secondary,
                  button2Style: ActionRowButtonStyle.secondary,
                  onTapButton1: () {
                    Navigator.of(context).pop();
                  },
                  onTapButton2: () async {
                    EasyLoading.show(status: 'updating location');
                    bool value = await userLocationController.updateUserLocation(_selectedLocationName, _selectedLocationCoordinates);
                    if(value){
                      EasyLoading.showToast('location updated');
                      await userLocationController.setUserLocation(
                          _selectedLocationName, _selectedLocationCoordinates);
                      Navigator.of(context).pop();
                    }else{
                      EasyLoading.showToast('some error in updating your location');
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions ?? [];
      });
    }
  }

  Future<void> getDetails(String? placeId) async {
    if (placeId != null) {
      var result = await googlePlace.details.get(placeId);
      if (result != null && result.result != null && mounted) {
        setState(() {
          DetailsResult detailsResult = result.result!;
          _selectedLocationCoordinates[0] =
              '${detailsResult.geometry!.location!.lat}';
          _selectedLocationCoordinates[1] =
              '${detailsResult.geometry!.location!.lng}';
          _selectedLocationName = detailsResult.addressComponents![0].longName!;
        });
      }
    }
  }
}
