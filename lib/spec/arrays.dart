enum RidePlaceFields { pickUp, whereTo, stopOvers }

enum RideMapNextAction {
  selectRide,
  addAddress,
  deliverySendItem,
  deliveryReceiveItem,
  //////stating on going ride//////
  searchingDriver,
  driverFound,
  bookingSuccess,
  driverArrived,
  drivingToDestination,
  arrivedDestination,
  trackDriver,
}

enum ServicePurpose {
  ride,
  personalShopper,
  deliveryRunnerSingle,
  deliveryRunnerMultiple,
}

enum DeliveryType { send, receive }

enum DeliveryAccessLocation { pickUpLocation, whereToLocation }

enum WorkerMapNextAction {
  accept,
  arrived,
  onTrip,
  endTrip,
}

enum LoginType { email, phone }

enum AuthNextAction {
  loginEmailVerify,
  loginPhoneVerifyUserExit,
  loginPhoneVerifyUserNotExit,
  forgotPasswordVerify,
  signUpPhoneVerify,
}

class Arrays {
  Arrays._();

  static const List<String> vehicleType = [
    "car",
    "truck",
    "van",
  ];
}
