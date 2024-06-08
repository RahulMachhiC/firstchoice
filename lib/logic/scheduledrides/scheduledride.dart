import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multitrip_user/app_enverionment.dart';
import 'package:multitrip_user/bottomnavigationbar.dart';
import 'package:multitrip_user/features/book_ride/schedule_ride.dart';
import 'package:multitrip_user/logic/scheduledrides/logic/schedulelogic.dart';
import 'package:multitrip_user/logic/scheduledrides/scheduledridedetail.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:multitrip_user/shared/ui/common/spacing.dart';
import 'package:multitrip_user/themes/app_text.dart';
import 'package:provider/provider.dart';

class ScheduleRideScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState>? parentScaffoldKey;

  const ScheduleRideScreen({super.key, this.parentScaffoldKey});

  @override
  State<ScheduleRideScreen> createState() => _ScheduleRideScreenState();
}

class _ScheduleRideScreenState extends State<ScheduleRideScreen> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ScheduledRideController>().getrides(context: context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 40.w,
        leading: InkWell(
          onTap: () {
            AppEnvironment.navigator.push(
              MaterialPageRoute(
                builder: (context) => PagesWidget(
                  currentTab: 0,
                ),
              ),
            );
          },
          child: Icon(
            Icons.arrow_back,
            color: AppColors.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Scheduled rides",
              style: AppText.text18w400.copyWith(
                color: AppColors.black,
              ),
            ),
            sizedBoxWithHeight(20),
            Consumer<ScheduledRideController>(
                builder: (context, controller, child) {
              if (controller.isloading) {
                Loader.show(context,
                    progressIndicator: CircularProgressIndicator(
                      color: AppColors.green,
                    ));
              } else if (controller.scheduledride != null) {
                return ListView.separated(
                  shrinkWrap: true,
                  primary: false,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ScheduledRideDetail(
                                      scheduledRides: controller
                                          .scheduledride!.bookings
                                          .elementAt(index),
                                    )));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: AppColors.greylight,
                            )),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 100.h,
                              margin: const EdgeInsets.all(5),
                              width: 120.w,
                              child: GoogleMap(
                                //         polylines: Set<Polyline>.of(polylines.values),
                                zoomGesturesEnabled: true,
                                zoomControlsEnabled: false,
                                markers: <Marker>{
                                  Marker(
                                    markerId: const MarkerId('marker_1'),
                                    draggable: false,
                                    position: LatLng(
                                      22.247517,
                                      73.188065,
                                    ),
                                    infoWindow: const InfoWindow(
                                      title: 'Marker Title',
                                      snippet: 'Marker Snippet',
                                    ),
                                    icon: BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueGreen,
                                    ),
                                  ),
                                  Marker(
                                    markerId: const MarkerId('marker_2'),
                                    draggable: false,
                                    position: LatLng(22.273440, 73.196980),
                                    infoWindow: const InfoWindow(
                                      title: 'Marker Title',
                                      snippet: 'Marker Snippet',
                                    ),
                                    icon: BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueBlue,
                                    ),
                                  ),
                                },
                                gestureRecognizers: <Factory<
                                    OneSequenceGestureRecognizer>>{
                                  Factory<OneSequenceGestureRecognizer>(
                                    () => EagerGestureRecognizer(),
                                  ),
                                },
                                onMapCreated: (mapcontroller) {
                                  mapcontroller.animateCamera(
                                    CameraUpdate.newLatLngZoom(
                                      LatLng(
                                        22.247517,
                                        73.188065,
                                      ),
                                      15,
                                    ),
                                  );
                                },
                                compassEnabled: false,
                                myLocationButtonEnabled: false,
                                myLocationEnabled: false,
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                    22.247517,
                                    73.188065,
                                  ),
                                  zoom: 15.0,
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                sizedBoxWithHeight(10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    sizedBoxWithWidth(3),
                                    Icon(
                                      Icons.circle,
                                      color: Colors.black,
                                      size: 12.sp,
                                    ),
                                    Text(
                                      "  ${controller.scheduledride!.bookings.elementAt(index).scheduleDate} at ${controller.scheduledride!.bookings.elementAt(index).scheduleTime}",
                                      style: GoogleFonts.poppins(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                                sizedBoxWithHeight(10),
                                SizedBox(
                                  width: 170.w,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.green,
                                        size: 15.sp,
                                      ),
                                      sizedBoxWithWidth(5),
                                      Flexible(
                                        child: Text(
                                          controller.scheduledride!.bookings
                                              .elementAt(index)
                                              .pickupLocation
                                              .address,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                sizedBoxWithHeight(10),
                                SizedBox(
                                  width: 170.w,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.pin_drop,
                                        color: Colors.red,
                                        size: 15.sp,
                                      ),
                                      sizedBoxWithWidth(5),
                                      Flexible(
                                        child: Text(
                                          controller.scheduledride!.bookings
                                              .elementAt(index)
                                              .dropLocation
                                              .last
                                              .address,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                sizedBoxWithHeight(10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    sizedBoxWithWidth(3),
                                    Icon(
                                      Icons.circle,
                                      color: Colors.black,
                                      size: 12.sp,
                                    ),
                                    sizedBoxWithWidth(10),
                                    Text(
                                      "  \$${controller.scheduledride!.bookings.elementAt(index).amount}",
                                      style: GoogleFonts.poppins(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                                sizedBoxWithHeight(10),
                              ],
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 600.ms)
                          .then(delay: 200.ms) // baseline=800ms
                          .scale(),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 10.h,
                    );
                  },
                  itemCount: controller.scheduledride!.bookings.length,
                );
              } else if (controller.scheduledride == null) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No Scheduled Rides Found",
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      InkWell(
                        onTap: () {
                          context
                              .read<ScheduledRideController>()
                              .getrides(context: context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 10.h,
                          ),
                          child: Text(
                            "REFRESH",
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
              return SizedBox();
            }),
          ],
        ),
      ),
    );
  }
}
