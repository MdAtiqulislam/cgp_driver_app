import 'package:get/get.dart';

import 'package:cgp_driver_app/app/modules/chatHistory/bindings/chat_history_binding.dart';
import 'package:cgp_driver_app/app/modules/chatHistory/views/chat_history_view.dart';
import 'package:cgp_driver_app/app/modules/completeTrip/bindings/complete_trip_binding.dart';
import 'package:cgp_driver_app/app/modules/completeTrip/views/complete_trip_view.dart';
import 'package:cgp_driver_app/app/modules/customNavigation/bindings/custom_navigation_binding.dart';
import 'package:cgp_driver_app/app/modules/customNavigation/views/custom_navigation_view.dart';
import 'package:cgp_driver_app/app/modules/driverInfo/bindings/driver_info_binding.dart';
import 'package:cgp_driver_app/app/modules/driverInfo/views/driver_info_view.dart';
import 'package:cgp_driver_app/app/modules/drivingLicenseInfo/bindings/driving_license_info_binding.dart';
import 'package:cgp_driver_app/app/modules/drivingLicenseInfo/views/driving_license_info_view.dart';
import 'package:cgp_driver_app/app/modules/editProfile/bindings/edit_profile_binding.dart';
import 'package:cgp_driver_app/app/modules/editProfile/views/edit_profile_view.dart';
import 'package:cgp_driver_app/app/modules/faqPage/bindings/faq_page_binding.dart';
import 'package:cgp_driver_app/app/modules/faqPage/views/faq_page_view.dart';
import 'package:cgp_driver_app/app/modules/forgotPassword/bindings/forgot_password_binding.dart';
import 'package:cgp_driver_app/app/modules/forgotPassword/views/forgot_password_view.dart';
import 'package:cgp_driver_app/app/modules/home/bindings/home_binding.dart';
import 'package:cgp_driver_app/app/modules/home/views/home_view.dart';
import 'package:cgp_driver_app/app/modules/imageVerification/bindings/image_verification_binding.dart';
import 'package:cgp_driver_app/app/modules/imageVerification/views/image_verification_view.dart';
import 'package:cgp_driver_app/app/modules/login/bindings/login_binding.dart';
import 'package:cgp_driver_app/app/modules/login/views/login_view.dart';
import 'package:cgp_driver_app/app/modules/messaging/bindings/messaging_binding.dart';
import 'package:cgp_driver_app/app/modules/messaging/views/messaging_view.dart';
import 'package:cgp_driver_app/app/modules/myWallet/bindings/my_wallet_binding.dart';
import 'package:cgp_driver_app/app/modules/myWallet/views/my_wallet_view.dart';
import 'package:cgp_driver_app/app/modules/notifications/bindings/notifications_binding.dart';
import 'package:cgp_driver_app/app/modules/notifications/views/notifications_view.dart';
import 'package:cgp_driver_app/app/modules/ongoingTrip/bindings/ongoing_trip_binding.dart';
import 'package:cgp_driver_app/app/modules/ongoingTrip/views/ongoing_trip_view.dart';
import 'package:cgp_driver_app/app/modules/password/bindings/password_binding.dart';
import 'package:cgp_driver_app/app/modules/password/views/password_view.dart';
import 'package:cgp_driver_app/app/modules/profile/bindings/profile_binding.dart';
import 'package:cgp_driver_app/app/modules/profile/views/profile_view.dart';
import 'package:cgp_driver_app/app/modules/registration/bindings/registration_binding.dart';
import 'package:cgp_driver_app/app/modules/registration/views/registration_view.dart';
import 'package:cgp_driver_app/app/modules/reviewAndRatings/bindings/review_and_ratings_binding.dart';
import 'package:cgp_driver_app/app/modules/reviewAndRatings/views/review_and_ratings_view.dart';
import 'package:cgp_driver_app/app/modules/serviceType/bindings/service_type_binding.dart';
import 'package:cgp_driver_app/app/modules/serviceType/views/service_type_view.dart';
import 'package:cgp_driver_app/app/modules/splashScreen/bindings/splash_screen_binding.dart';
import 'package:cgp_driver_app/app/modules/splashScreen/views/splash_screen_view.dart';
import 'package:cgp_driver_app/app/modules/startTrip/bindings/start_trip_binding.dart';
import 'package:cgp_driver_app/app/modules/startTrip/views/start_trip_view.dart';
import 'package:cgp_driver_app/app/modules/support/bindings/support_binding.dart';
import 'package:cgp_driver_app/app/modules/support/views/support_view.dart';
import 'package:cgp_driver_app/app/modules/termsAndCondition/bindings/terms_and_condition_binding.dart';
import 'package:cgp_driver_app/app/modules/termsAndCondition/views/terms_and_condition_view.dart';
import 'package:cgp_driver_app/app/modules/testChat/bindings/test_chat_binding.dart';
import 'package:cgp_driver_app/app/modules/testChat/views/test_chat_view.dart';
import 'package:cgp_driver_app/app/modules/tripDetails/bindings/trip_details_binding.dart';
import 'package:cgp_driver_app/app/modules/tripDetails/views/trip_details_view.dart';
import 'package:cgp_driver_app/app/modules/tripHistory/bindings/trip_history_binding.dart';
import 'package:cgp_driver_app/app/modules/tripHistory/views/trip_history_view.dart';
import 'package:cgp_driver_app/app/modules/tripRequest/bindings/trip_request_binding.dart';
import 'package:cgp_driver_app/app/modules/tripRequest/views/trip_request_view.dart';
import 'package:cgp_driver_app/app/modules/vehicleInfo/bindings/vehicle_info_binding.dart';
import 'package:cgp_driver_app/app/modules/vehicleInfo/views/vehicle_info_view.dart';
import 'package:cgp_driver_app/app/modules/verifyOTP/bindings/verify_o_t_p_binding.dart';
import 'package:cgp_driver_app/app/modules/verifyOTP/views/verify_o_t_p_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;
  // static const INITIAL = Routes.CUSTOM_NAVIGATION;
  // static const INITIAL = Routes.HOME;
//  static const INITIAL = Routes.TRIP_REQUEST;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTRATION,
      page: () => RegistrationView(),
      binding: RegistrationBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.SERVICE_TYPE,
      page: () => ServiceTypeView(),
      binding: ServiceTypeBinding(),
    ),
    GetPage(
      name: _Paths.VERIFY_O_T_P,
      page: () => VerifyOTPView(),
      binding: VerifyOTPBinding(),
    ),
    GetPage(
      name: _Paths.PASSWORD,
      page: () => PasswordView(),
      binding: PasswordBinding(),
    ),
    GetPage(
      name: _Paths.VEHICLE_INFO,
      page: () => VehicleInfoView(),
      binding: VehicleInfoBinding(),
    ),
    GetPage(
      name: _Paths.DRIVING_LICENSE_INFO,
      page: () => DrivingLicenseInfoView(),
      binding: DrivingLicenseInfoBinding(),
    ),
    GetPage(
      name: _Paths.DRIVER_INFO,
      page: () => DriverInfoView(),
      binding: DriverInfoBinding(),
    ),
    GetPage(
      name: _Paths.IMAGE_VERIFICATION,
      page: () => ImageVerificationView(),
      binding: ImageVerificationBinding(),
    ),
    GetPage(
      name: _Paths.TRIP_REQUEST,
      page: () => TripRequestView(),
      binding: TripRequestBinding(),
    ),
    GetPage(
      name: _Paths.START_TRIP,
      page: () => StartTripView(),
      binding: StartTripBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: _Paths.COMPLETE_TRIP,
      page: () => CompleteTripView(),
      binding: CompleteTripBinding(),
    ),
    GetPage(
      name: _Paths.TRIP_HISTORY,
      page: () => TripHistoryView(),
      binding: TripHistoryBinding(),
    ),
    GetPage(
      name: _Paths.TRIP_DETAILS,
      page: () => TripDetailsView(),
      binding: TripDetailsBinding(),
    ),
    GetPage(
      name: _Paths.TERMS_AND_CONDITION,
      page: () => TermsAndConditionView(),
      binding: TermsAndConditionBinding(),
    ),
    GetPage(
      name: _Paths.SUPPORT,
      page: () => SupportView(),
      binding: SupportBinding(),
    ),
    GetPage(
      name: _Paths.ONGOING_TRIP,
      page: () => OngoingTripView(),
      binding: OngoingTripBinding(),
    ),
    GetPage(
      name: _Paths.TEST_CHAT,
      page: () => TestChatView(),
      binding: TestChatBinding(),
    ),
    GetPage(
      name: _Paths.REVIEW_AND_RATINGS,
      page: () => ReviewAndRatingsView(),
      binding: ReviewAndRatingsBinding(),
    ),
    GetPage(
      name: _Paths.MY_WALLET,
      page: () => MyWalletView(),
      binding: MyWalletBinding(),
    ),
    GetPage(
      name: _Paths.CUSTOM_NAVIGATION,
      page: () => CustomNavigationView(),
      binding: CustomNavigationBinding(),
    ),
    GetPage(
      name: _Paths.MESSAGING,
      page: () => MessagingView(),
      binding: MessagingBinding(),
    ),
    GetPage(
      name: _Paths.CHAT_HISTORY,
      page: () => ChatHistoryView(),
      binding: ChatHistoryBinding(),
    ),
    GetPage(
      name: _Paths.FAQ_PAGE,
      page: () => FaqPageView(),
      binding: FaqPageBinding(),
    ),
  ];
}
