// To parse this JSON data, do
//
//     final scheduledRides = scheduledRidesFromJson(jsonString);

import 'dart:convert';

ScheduledRides scheduledRidesFromJson(String str) =>
    ScheduledRides.fromJson(json.decode(str));

String scheduledRidesToJson(ScheduledRides data) => json.encode(data.toJson());

class ScheduledRides {
  int code;
  String message;
  List<Booking> bookings;

  ScheduledRides({
    required this.code,
    required this.message,
    required this.bookings,
  });

  factory ScheduledRides.fromJson(Map<String, dynamic> json) => ScheduledRides(
        code: json["code"],
        message: json["message"],
        bookings: List<Booking>.from(
            json["bookings"].map((x) => Booking.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "bookings": List<dynamic>.from(bookings.map((x) => x.toJson())),
      };
}

class Booking {
  String bookingId;
  String bookingDate;
  String scheduleDate;
  String scheduleTime;
  String amount;
  String status;
  String vehicleId;
  String driverName;
  String driverEmail;
  String driverMobileNumber;
  String driverProfilePhoto;
  String driverRating;
  PLocation pickupLocation;
  List<PLocation> dropLocation;

  Booking({
    required this.bookingId,
    required this.bookingDate,
    required this.scheduleDate,
    required this.scheduleTime,
    required this.amount,
    required this.status,
    required this.vehicleId,
    required this.driverName,
    required this.driverEmail,
    required this.driverMobileNumber,
    required this.driverProfilePhoto,
    required this.driverRating,
    required this.pickupLocation,
    required this.dropLocation,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        bookingId: json["booking_id"],
        bookingDate: json["booking_date"],
        scheduleDate: json["schedule_date"],
        scheduleTime: json["schedule_time"],
        amount: json["amount"],
        status: json["status"],
        vehicleId: json["vehicle_id"],
        driverName: json["driver_name"],
        driverEmail: json["driver_email"],
        driverMobileNumber: json["driver_mobile_number"],
        driverProfilePhoto: json["driver_profile_photo"],
        driverRating: json["driver_rating"],
        pickupLocation: PLocation.fromJson(json["pickup_location"]),
        dropLocation: List<PLocation>.from(
            json["drop_location"].map((x) => PLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "booking_id": bookingId,
        "booking_date": bookingDate,
        "schedule_date": scheduleDate,
        "schedule_time": scheduleTime,
        "amount": amount,
        "status": status,
        "vehicle_id": vehicleId,
        "driver_name": driverName,
        "driver_email": driverEmail,
        "driver_mobile_number": driverMobileNumber,
        "driver_profile_photo": driverProfilePhoto,
        "driver_rating": driverRating,
        "pickup_location": pickupLocation.toJson(),
        "drop_location":
            List<dynamic>.from(dropLocation.map((x) => x.toJson())),
      };
}

class PLocation {
  String lat;
  String long;
  String address;

  PLocation({
    required this.lat,
    required this.long,
    required this.address,
  });

  factory PLocation.fromJson(Map<String, dynamic> json) => PLocation(
        lat: json["lat"],
        long: json["long"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "long": long,
        "address": address,
      };
}
