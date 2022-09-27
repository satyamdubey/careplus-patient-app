import 'dart:async';

import 'package:careplus_patient/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectLocation extends StatefulWidget {
  @override
  State<SelectLocation> createState() => SelectLocationState();
}

class SelectLocationState extends State<SelectLocation> {
  Completer<GoogleMapController> _controller = Completer();


  static final CameraPosition _currentLocationPosition = CameraPosition(
    target: LatLng(LocationService.locationData.latitude!, LocationService.locationData.longitude!),
    zoom: 14.4746,
  );


  Set<Marker> _createMarker() {
    return <Marker>[
      Marker(
          markerId: MarkerId('home'),
          position: LatLng(LocationService.locationData.latitude!, LocationService.locationData.longitude!),
          icon: BitmapDescriptor.defaultMarker,
          draggable: true,
          infoWindow: InfoWindow(title: 'Current Location'),
      )
    ].toSet();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        markers: _createMarker(),
        initialCameraPosition: _currentLocationPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
