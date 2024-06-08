import 'package:multitrip_user/api/api_base_helper.dart';
import 'package:multitrip_user/models/address.dart';

class AppRepository {
  ApiBaseHelper helper = ApiBaseHelper();

// Check Moblie Number
  Future<dynamic> douserlogin({
    required String devicetype,
    required String mobilenumber,
    required String countrycode,
    required String fcm,
  }) async {
    final response = await helper.post("login", {
      "mobile_number": "+" + countrycode + mobilenumber,
      "device_type": devicetype,
      "fcm_id": fcm,
    }, {});

    return response;
  }

// Verify OTP
  Future<dynamic> verifyOTP(
      {required String mobilenumber,
      required String otp,
      required String accesstoken}) async {
    final response = await helper.post(
      "verify_otp",
      {
        "mobile_number": "+" + mobilenumber,
        "otp": otp,
      },
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

// Create new User
  Future<dynamic> usersignup(
      {required String userid,
      required String email,
      required String firstname,
      required String lastName,
      required String password,
      required String accesstoken}) async {
    final response = await helper.post(
      "passenger_signup",
      {
        "user_id": userid,
        "email": email,
        "password": password,
        'first_name': firstname,
        'last_name': lastName
      },
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

// Get Member List
  Future<dynamic> getmemberslist({
    required String userid,
    required String accesstoken,
  }) async {
    final response = await helper.post(
      "members_list",
      {
        "user_id": userid,
      },
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> getHtmlData({
    required String userid,
    required String accesstoken,
    required String endpoint,
  }) async {
    final response = await helper.post(
      endpoint,
      {
        "user_id": userid,
      },
      {
        "access_token": accesstoken,
      },
    );

    return response['content'];
  }

// Add New Member
  Future<dynamic> addmember({
    required String userid,
    required String accesstoken,
    required String fname,
    required String mobile_number,
  }) async {
    final response = await helper.post(
      "add_member",
      {
        "user_id": userid,
        "fname": fname,
        "lname": "d",
        "mobile_number": mobile_number,
        "email": "d@gmail.com",
        "address": "d"
      },
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

// Get User Dashboard
  Future<dynamic> getdashboarddata({
    required String accesstoken,
    required String userid,
    required String latitude,
    required String longitude,
  }) async {
    final response = await helper.post(
      "dashboard",
      {
        "user_id": userid,
        "latitude": latitude,
        "longitude": longitude,
      },
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> saveFcmToken({
    required String accesstoken,
    required String userid,
    required String fcmToken,
  }) async {
    final response = await helper.post(
      "update_customer_token",
      {"user_id": userid, "fcm_id": fcmToken},
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

// Login By Password
  Future<dynamic> loginbypassword({
    required String mobilenumber,
    required String password,
    required String contrycode,
    required String accesstoken,
  }) async {
    final response = await helper.post(
      "login_by_password",
      {
        "mobile_number": "+" + contrycode + mobilenumber,
        "password": password,
      },
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> forgotPassword({
    required String mobilenumber,
    required String password,
  }) async {
    final response = await helper.post(
      "forgot_password",
      {
        "mobile_number": mobilenumber,
        "password": password,
      },
      {},
    );

    return response;
  }

  // Get Ride
  Future<dynamic> confirmuseride({
    required String accesstoken,
    required dynamic pickuplocation,
    required dynamic droplocation,
    required String userid,
  }) async {
    var body = {
      "user_id": userid,
      "pickup_location": pickuplocation,
      "drop_location": droplocation,
      "member_id": ""
    };
    print(body);
    final response = await helper.post(
      "confirm_ride",
      body,
      {"access_token": accesstoken, "Accept": "application/json"},
    );

    return response;
  }

  //add vehicle
  Future<dynamic> addvehicle({
    required String userid,
    required String accesstoken,
    required String vehicle_name,
    required String vehicle_type,
    required String vehicle_color,
    required String vehicle_number,
  }) async {
    final response = await helper.post(
      "add_vehicle",
      {
        "user_id": userid,
        "vehicle_name": vehicle_name,
        "vehicle_type": vehicle_type,
        "vehicle_color": vehicle_color,
        "vehicle_number": vehicle_number,
      },
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

// Get Vehicle List
  Future<dynamic> getvehicle({
    required String userid,
    required String accesstoken,
  }) async {
    final response = await helper.post(
      "vehicle_list",
      {
        "user_id": userid,
      },
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  //delete vehicle
  Future<dynamic> deletevehicle({
    required String userid,
    required String accesstoken,
    required String vehicle_id,
  }) async {
    final response = await helper.post(
      "delete_vehicle",
      {"user_id": userid, "vehicle_id": vehicle_id},
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> douserlogout({
    required String accesstoken,
    required String userid,
  }) async {
    final response = await helper.post(
      "logout",
      {
        "user_id": userid,
      },
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> fetchaddress({
    required String accesstoken,
    required String userid,
  }) async {
    print("User id is $userid");
    final response = await helper.post(
      "address_list",
      {
        "user_id": userid,
      },
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> addAddress(
      {required String accesstoken,
      required String userid,
      required AddressElement element}) async {
    print("User id is $userid");
    final response = await helper.post(
      "add_address",
      {"user_id": userid, ...element.toJson()},
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> removeAddress(
      {required String accesstoken,
      required String userid,
      required String element}) async {
    print("User id is $userid");
    final response = await helper.post(
      "remove_address",
      {"user_id": userid, 'place_id': element},
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> bookride(
      {required String accesstoken,
      required dynamic booking_number,
      required dynamic vehicle_id,
      required String notes,
      required String payment_mode,
      required String user_id}) async {
    var body = {
      "user_id": user_id,
      "booking_number": booking_number,
      "vehicle_id": vehicle_id,
      "notes": notes,
      "payment_mode": payment_mode
    };
    print(body);
    final response = await helper.post(
      "book_ride",
      body,
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  // Verify OTP
  Future<dynamic> getProfile({
    required String user_id,
    required String accesstoken,
  }) async {
    final response = await helper.post(
      "customer_profile",
      {
        "user_id": user_id,
      },
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> updateEmailProfile({
    required String user_id,
    required String accesstoken,
    required String email,
  }) async {
    final response = await helper.post(
      "update_customer_email",
      {"user_id": user_id, "email": email},
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> updateMobileProfile({
    required String user_id,
    required String accesstoken,
    required String mobile_number,
  }) async {
    final response = await helper.post(
      "update_customer_mobile",
      {"user_id": user_id, "mobile_number": mobile_number},
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> updateNameProfile({
    required String user_id,
    required String accesstoken,
    required String first_name,
    required String last_name,
  }) async {
    final response = await helper.post(
      "update_customer_name",
      {"user_id": user_id, "first_name": first_name, "last_name": last_name},
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> changePassword({
    required String user_id,
    required String accesstoken,
    required String password,
  }) async {
    final response = await helper.post(
      "change_password",
      {
        "user_id": user_id,
        "new_password": password,
      },
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> uploadImage({
    required String user_id,
    required String accesstoken,
    required String path,
  }) async {
    final response = await helper.uploadImage(
      "update_customer_image",
      {
        "user_id": user_id,
      },
      path,
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> ratingTheDriver(
      {required String user_id,
      required String accesstoken,
      required String booking_number,
      required double rating,
      String? comments}) async {
    final response = await helper.post(
      "customer_rating",
      {
        "user_id": user_id,
        "booking_number": booking_number,
        "rating": rating.toString(),
        "review": comments
      },
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> getDriverLatLng({
    required String driverId,
    required String accesstoken,
  }) async {
    final response = await helper.post(
      "get_user_lat_long",
      {
        "user_id": driverId,
      },
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> bookingHistory({
    required String userId,
    required String accesstoken,
  }) async {
    final response = await helper.post(
      "customer_booking_history",
      {
        "user_id": userId,
      },
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> checkDriverAssigningPolling({
    required String userId,
    required String accesstoken,
    String? bookingId,
  }) async {
    final response = await helper.post(
      "check_booking_driver",
      {"user_id": userId, "booking_number": bookingId},
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> checkBookingPolling({
    required String userId,
    required String accesstoken,
    String? bookingId,
  }) async {
    final response = await helper.post(
      "ride_status",
      {
        "user_id": userId,
        "booking_number": bookingId,
      },
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> cancelBooking({
    required String userId,
    required String accesstoken,
    String? bookingId,
  }) async {
    final response = await helper.post(
      "cancel_ride",
      {"user_id": userId, "booking_number": bookingId},
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> currentBooking({
    required String userId,
    required String accesstoken,
  }) async {
    final response = await helper.post(
      "current_booking",
      {"user_id": userId},
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> storeuserlatlong({
    required String user,
    required String accesstoken,
    required String lat,
    required String long,
  }) async {
    final response = await helper.post(
      "udpate_user_lat_long",
      {
        "user_id": user,
        "latitude": lat,
        "longitude": long,
      },
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> getscheduledride({
    required String user,
    required String accesstoken,
  }) async {
    final response = await helper.post(
      "customer_schedule_rides",
      {
        "user_id": user,
      },
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> scheduleride({
    required String user,
    required String accesstoken,
    required dynamic pickuplocation,
    required dynamic droplocation,
    required String vehicle_id,
    required String schedule_date,
    required String schedule_time,
  }) async {
    print("date is $schedule_date");
    final response = await helper.post(
      "schedule_ride",
      {
        "user_id": user,
        "pickup_location": pickuplocation,
        "drop_location": droplocation,
        "vehicle_id": vehicle_id,
        "schedule_date": schedule_date,
        "schedule_time": schedule_time,
      },
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> cancelScheduleride({
    required String user,
    required String accesstoken,
    required String booking_number,
  }) async {
    final response = await helper.post(
      "cancel_ride",
      {
        "user_id": user,
        "booking_number": booking_number,
      },
      {
        "access_token": accesstoken,
      },
    );

    return response;
  }

  Future<dynamic> addridetip({
    required String userId,
    required String accessToken,
    required String bookingNumber,
    required String amount,
  }) async {
    final response = await helper.post(
      "add_ride_tip",
      {
        "user_id": userId,
        "booking_number": bookingNumber,
        "tip_amount": amount,
      },
      {
        "access_token": accessToken,
      },
    );

    return response;
  }
}
