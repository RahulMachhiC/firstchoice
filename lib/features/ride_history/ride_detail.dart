import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multitrip_user/models/booking_history.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:multitrip_user/shared/ui/common/icon_map.dart';
import 'package:multitrip_user/themes/app_text.dart';
import 'package:timelines/timelines.dart';

class RideDetailScreen extends StatefulWidget {
  final Booking history;

  const RideDetailScreen({
    super.key,
    required this.history,
  });

  @override
  State<RideDetailScreen> createState() => _RideDetailScreenState();
}

class _RideDetailScreenState extends State<RideDetailScreen> {
  final _controller = Completer<GoogleMapController>();
  var polyLinesSet = <Polyline>{};
  Set<Marker> markers = {};
  List<PickupLocation> timeLine = [];

  @override
  void initState() {
    polyLinesSet = <Polyline>{};
    makePolylinesAndMarker(
      startPoint: PointLatLng(
        double.parse(widget.history.pickupLocation.lat!),
        double.parse(widget.history.pickupLocation.long!),
      ),
      endPoint: PointLatLng(
        double.parse(widget.history.dropLocation.last.lat!),
        double.parse(widget.history.dropLocation.last.long!),
      ),
    );
    timeLine.add(widget.history.pickupLocation);
    for (var element in widget.history.dropLocation) {
      timeLine.add(element);
    }
    super.initState();
  }

  Future<void> makePolylinesAndMarker({
    required PointLatLng startPoint,
    required PointLatLng endPoint,
  }) async {
    final polylinePoints = PolylinePoints();

    final resultant = await polylinePoints
        .getRouteBetweenCoordinates(
      "AIzaSyD6MRqmdjtnIHn7tyDLX-qsjreaTkuzSCY",
      startPoint,
      endPoint,
      travelMode: TravelMode.driving,
    )
        .catchError((E) {
      print(E);
      return PolylineResult();
    });

    final polylineCoordinates = <LatLng>[];

    resultant.points.forEach((PointLatLng point) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    });

    final id = const PolylineId("poly");

    final polyline = Polyline(
      width: 2,
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
    );

    markers.add(
      Marker(
        draggable: false,
        markerId: const MarkerId('driver_marker'),
        position: polylineCoordinates.tryFirst ??
            LatLng(startPoint.latitude, startPoint.longitude),
        infoWindow: const InfoWindow(
          title: 'Driver location',
          snippet: 'Marker Snippet',
        ),
        icon: await dropIcon,
      ),
    );
    polyLinesSet = {polyline};

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  bottomNavigationBar: CommonBottomBar(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 20.sp,
          ),
        ),
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(90.h),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Thanks for helping ${widget.history.driverName}",
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text("we hope you had a great ride",
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        )),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      "Ride Details",
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ),
            )),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 400.h,
            width: double.infinity,
            color: Colors.black,
            child: Stack(
              children: [
                GoogleMap(
                  polylines: polyLinesSet,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  markers: markers,
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                    Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer(),
                    ),
                  },
                  onMapCreated: (mapcontroller) {
                    if (_controller.isCompleted == false) {
                      _controller.complete(mapcontroller);
                    }

                    mapcontroller.animateCamera(
                      CameraUpdate.newLatLngZoom(
                        LatLng(double.parse(widget.history.pickupLocation.lat!),
                            double.parse(widget.history.pickupLocation.long!)),
                        15,
                      ),
                    );
                  },
                  compassEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                        double.parse(widget.history.pickupLocation.lat!),
                        double.parse(widget.history.pickupLocation.long!)),
                    zoom: 15.0,
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 10.h, top: 20.h) +
                      EdgeInsets.symmetric(horizontal: 20.w),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 15,
                  ),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.green,
                          AppColors.yellow,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.history.bookingDate,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        widget.history.timing,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          // Text(
          //   "Booking ID : ${widget.history.bookingId}",
          //   style: GoogleFonts.inter(
          //     color: Colors.black,
          //     fontSize: 15.sp,
          //     fontWeight: FontWeight.w400,
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Timeline.tileBuilder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              theme: TimelineThemeData(
                  indicatorTheme:
                      IndicatorThemeData(size: 15.r, color: Colors.green),
                  connectorTheme: ConnectorThemeData(color: AppColors.greydark),
                  indicatorPosition: 0,
                  nodePosition: 0),
              builder: TimelineTileBuilder.connectedFromStyle(
                contentsAlign: ContentsAlign.basic,
                indicatorStyleBuilder: (_, __) =>
                    __ == 0 ? IndicatorStyle.outlined : IndicatorStyle.dot,
                lastConnectorStyle: ConnectorStyle.transparent,
                connectorStyleBuilder: (__, v) => v == ((timeLine.length) - 1)
                    ? ConnectorStyle.transparent
                    : ConnectorStyle.solidLine,
                contentsBuilder: (context, _index) => Padding(
                  padding: EdgeInsets.only(left: 4.w, bottom: 10.h),
                  child: Text(
                    timeLine[_index].address ?? 'NA',
                    style: AppText.text14w400.copyWith(fontSize: 12.sp),
                  ),
                ),
                itemCount: timeLine.length,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                  bottom: 10.h,
                ) +
                EdgeInsets.symmetric(horizontal: 20.w),
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.green,
                    AppColors.yellow,
                  ],
                ),
                borderRadius: BorderRadius.circular(0)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("How was your ride with ${widget.history.driverName}",
                    style: AppText.text18w400.copyWith(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500)),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: RatingBar.builder(
                    updateOnDrag: true,
                    initialRating: double.parse(
                        widget.history.driverRating.isEmpty
                            ? "0"
                            : widget.history.driverRating),
                    minRating: 1,
                    direction: Axis.horizontal,
                    ignoreGestures: true,
                    allowHalfRating: true,
                    unratedColor: Colors.white,
                    itemCount: 5,
                    itemSize: 20.sp,
                    itemPadding: const EdgeInsets.symmetric(
                      horizontal: 0,
                    ),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 20,
                    ),
                    onRatingUpdate: (rating) {},
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
