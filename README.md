# E-Commerce App

A Flutter-based E-Commerce application with features like product browsing, cart management, and user profile management.

## Features

- Product listing and browsing
- Shopping cart functionality
- User profile management
- Profile image upload
- Mock payment integration
- Order history tracking
- Cross-platform support (Android & iOS)

## Project Structure

```
lib/
├── models/           # Data models
│   ├── cart.dart     # Cart model
│   ├── product.dart  # Product model
│   └── user_profile.dart # User profile model
├── screens/          # Main app screens
│   ├── cart_screen.dart
│   ├── home_screen.dart
│   └── profile_screen.dart
├── services/         # API and service classes
│   └── api_service.dart
├── widgets/          # Reusable widgets
│   ├── cart_item.dart
│   ├── product_card.dart
│   └── profile_image_picker.dart
└── main.dart         # App entry point
```

## Setup Instructions

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (latest stable version)
- Android Studio / VS Code
- For iOS development:
  - Mac computer
  - Xcode
  - CocoaPods
  - Apple Developer account

### Installation

1. Clone the repository:
```bash
git clone https://github.com/ayushd775/Fluffyn_Ecommerce_App
cd Fluffyn_Ecommerce_App/
```

2. Install dependencies:
```bash
flutter pub get
```

3. For iOS, install CocoaPods:
```bash
cd ios
pod install
cd ..
```

### Running the App

#### Android
```bash
flutter run
```

#### iOS
```bash
flutter run
```
or open in Xcode:
```bash
open ios/Runner.xcworkspace
```

### Building Release Versions

#### Android
```bash
flutter build apk --release
```
The APK will be available at: `build/app/outputs/flutter-apk/app-release.apk`

#### iOS
```bash
flutter build ios --release
```
Then open Xcode and archive the project.

## API Integration

The app uses the Fake Store API (https://fakestoreapi.com) for product data. Make sure you have an active internet connection to fetch products.
