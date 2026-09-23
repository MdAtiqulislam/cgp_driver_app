# Trade Bar Driver (cgp_driver_app)

The driver-side Flutter app for the TradeBar delivery platform — trips, navigation, earnings and driver verification.

[![Google Play](https://img.shields.io/badge/Google_Play-Download-414141?style=for-the-badge&logo=google-play&logoColor=white)](https://play.google.com/store/apps/details?id=com.revinr.cgp_driver_app) [![App Store](https://img.shields.io/badge/App_Store-Download-0D96F2?style=for-the-badge&logo=app-store&logoColor=white)](https://apps.apple.com/app/id6670425187)


## Features

- Trip flow: accept, navigate and complete trips
- Live map view (`generalMap`) for pickup/drop-off navigation
- Driver onboarding: driver info, driving-license info and image verification
- Auth: login, forgot password
- Chat history with customers/support
- Home dashboard, edit profile, FAQ page
- Custom navigation and themed UI

## Tech Stack

- Flutter (Dart)
- GetX for state management and routing
- Firebase (`firebase_options.dart` present — configure with your own project)
- REST API backend, Google Maps integration

## Getting Started

```bash
flutter pub get
flutter run
```

> Configure Firebase with `flutterfire configure` and add your own
> `google-services.json` / `GoogleService-Info.plist` — these files are
> intentionally not committed.

## Project Structure

```
lib/
├── app/modules/      # Trips, map, auth, chat, profile, FAQ
├── models/           # Data models
├── services/         # API, location and platform services
├── theme/            # App theme
└── main.dart         # App entry point
```

## Notes

- App label: "Trade Bar Driver" (Android)
- No secrets, keystores or Firebase configs are committed to this repository.
