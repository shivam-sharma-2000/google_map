# Flutter Google Maps with BLoC Pattern

A Flutter application that demonstrates the integration of Google Maps with BLoC pattern for state management, featuring location services, marker management, and local data persistence using Hive.

## Features

- Interactive Google Maps integration
- Current location tracking
- Add, view, and manage custom markers on the map
- Search for locations using the search bar
- Save and load markers using Hive local storage
- Clean architecture with BLoC pattern
- Responsive UI with Material Design 3

## Prerequisites

- Flutter SDK (latest stable version)
- Android Studio / Xcode (for running on emulator/device)
- Google Maps API key (for Google Maps integration)

## Getting Started

### 1. Clone the repository

```bash
git clone <repository-url>
cd google_map
```

### 2. Add Google Maps API Key

1. Get an API key from the [Google Cloud Console](https://console.cloud.google.com/)
2. For Android, add the following to `android/app/src/main/AndroidManifest.xml` inside the `<application>` tag:
   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_API_KEY_HERE"/>
   ```

3. For iOS, add the following to `ios/Runner/AppDelegate.swift`:
   ```swift
   GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
   ```
   And add this import at the top of the file:
   ```swift
   import GoogleMaps
   ```

### 3. Install Dependencies

Run the following command to install all the required dependencies:

```bash
flutter pub get
```

### 4. Generate Hive Adapters

Run the build runner to generate the necessary Hive adapters:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 5. Run the Application

Connect a device or start an emulator, then run:

```bash
flutter run
```

## Project Structure

```
lib/
├── BLoc/
│   └── Marker/           # BLoC related files for marker management
├── Models/               # Data models
├── Services/             # Service classes (Hive, Location, etc.)
├── UI/                   # All UI components
│   ├── google_map.dart   # Main map screen
│   └── list_of_markers.dart # List of saved markers
└── Utils/                # Utility classes and helpers
```

## Dependencies

- `flutter_bloc`: State management using BLoC pattern
- `google_maps_flutter`: Google Maps integration
- `geolocator`: For accessing device location
- `geocoding`: For geocoding and reverse geocoding
- `hive` & `hive_flutter`: For local data persistence
- `permission_handler`: For handling runtime permissions

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Screenshots

<img width="300" height="600" alt="Screenshot_20250717_004317" src="https://github.com/user-attachments/assets/1b201ac6-8e98-417a-ab40-d446743bd7d2" />
<img width="1080" height="2400" alt="Screenshot_20250717_004653" src="https://github.com/user-attachments/assets/76598d2f-f1b9-4ec2-a8dd-78ba52bade17" />
<img width="300" height="600" alt="Screenshot_20250717_004341" src="https://github.com/user-attachments/assets/d49575a5-d1f8-4567-a0ca-801d79cb3e42" />

## Support

If you encounter any issues or have questions, please open an issue on the repository.
