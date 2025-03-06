class APIEndPoints {

 // static const baseUrl = "https://raw-bertie-wittyplex.koyeb.app";
 // static const baseUrl = "https://cgp-rider-api.onrender.com";
  static const baseUrl = "https://rider-api.tradebar.com.au";
  static const baseUrlMessaging="https://laravel-api.tradebar.com.au";


  static const login = "/auth/login";
  static const registration="/auth/registration";
  static const emailVerification="/auth/email-verification";
  static const setPassword="/auth/set-password";
  static const reSetPassword="/auth/reset-password";
  static const loginVerification="/auth/login-verification";
  static const forgotPassword="/auth/forget-password";
  static const reSendOTP="/auth/resent-otp";
  static const getVehicles="/rider/vehicle/all";
  static const updateUser="/rider/profile/edit";
  static const getVehicleType="/vehicle-type/all";
  static const addNewVehicle="/rider/vehicle";

  static const updateVehicle="/rider/vehicle/{vehicle_id}";
  static const getDeliveryRequestByID="/delivery-requests/{id}";
  static const markAsReadNotification="/notifications/mark-as-read/{notificationId}";

  static const getNotifications="/notifications/all";

  static const acceptRequest="/delivery-requests/accept/{id}/{vehicleId}";

  static const changeTripStatus="/delivery-requests/status/{id}";

  static const getTripHistory="/deliveries";

  static const tripDetails="/deliveries/{id}";

  static const updateRiderLocation="/locations/rider/update-location";

  static const updateOnlineStatus="/locations/rider/update-online-status";
  static const logOut="/auth/logout";

  static const createNewBankRecord="/rider-bank-info";
  static const getBankInfoRecord="/rider-bank-info";
  static const addNewBank="/rider-bank-info";
  static const updateBankInfo="/rider-bank-info/{id}";
  static const getUserData="/rider/profile";
  static const addReview="/reviews";
  static const getPaymentHistory="/payments/history";
  static const earnedToday="/payments/earned-today";

  static const faqEndPoint="/api/v1/messaging/ajax/faq-list";

  static const getTermsAndCondition="/api/v1/messaging/ajax/get-terms-condition";

  static const createSupportEndPoint="/api/v1/messaging/ajax/create-support";
  static const getSupportList="/api/v1/messaging/ajax/customer-support-list";
  static const getIssueSubjectList="/api/v1/messaging/ajax/issue-subject-list";
  static const removeAccount="/rider/remove-account";

  static const appVersionEndpoint="/app/version";




}
