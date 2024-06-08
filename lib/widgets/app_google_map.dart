import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multitrip_user/api/app_repository.dart';
import 'package:multitrip_user/shared/data/constants/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppGoogleMap extends StatefulWidget {
  const AppGoogleMap({this.currentLocation, super.key});
  final LatLng? currentLocation;

  @override
  State<AppGoogleMap> createState() => _AppGoogleMapState();
}

class _AppGoogleMapState extends State<AppGoogleMap> {
  LatLng? currentLocation;
  CameraPosition? currentposition;
  @override
  void initState() {
    super.initState();

    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    if (currentLocation != null) {
      currentposition = CameraPosition(
        target: currentLocation!,
        zoom: 15.0,
      );
    }
    if (currentposition == null) {
      return SizedBox();
    }
    return GoogleMap(
      zoomGesturesEnabled: true,
      zoomControlsEnabled: false,
      myLocationEnabled: true,
      markers: <Marker>{
        Marker(
          markerId: const MarkerId('marker_1'),
          draggable: true,
          onDrag: (values) {
            //    value.ondrag(values);
          },
          position: currentLocation ?? LatLng(0, 0),
          infoWindow: const InfoWindow(
              title: 'Marker Title', snippet: 'Marker Snippet'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      },
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
        Factory<OneSequenceGestureRecognizer>(
          () => EagerGestureRecognizer(),
        ),
      },
      onMapCreated: (controller) {
        // setState(() {
        //   ismapCreated = true;
        // });
      },
      myLocationButtonEnabled: true,
      initialCameraPosition:
          currentposition ?? CameraPosition(target: widget.currentLocation!),
    );
  }

  Future<void> _getCurrentLocation() async {
    currentLocation = widget.currentLocation;
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    AppRepository().storeuserlatlong(
      accesstoken: prefs.getString(
        Strings.accesstoken,
      )!,
      user: prefs.getString(
        Strings.userid,
      )!,
      lat: position.latitude.toString(),
      long: position.longitude.toString(),
    );
    currentLocation = LatLng(
      position.latitude,
      position.longitude,
    );
    if (currentLocation != null) {
      currentposition = CameraPosition(
        target: currentLocation!,
        zoom: 15.0,
      );
    }
    if (mounted) {
      setState(() {});
    }
  }
}
