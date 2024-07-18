---

# Weather App
#Flutter Version:- 3.22.0
#Android Studio Version:- Android Studio Jellyfish | 2023.3.1 Patch 1

## Database ScreenShot
you can find database screenshot in weather_app_poc\database_screenshot

## Overview
This Flutter application fetches weather data from OpenWeatherMap API and stores it using Firebase Firestore. It supports location-based weather fetching and manual city search.

## Features
- Fetch weather data based on current location.
- Search weather by city name.
- When Search And Fetch weather data then Store weather data in Firestore for future reference.

## Installation
To run this application locally, ensure you have Flutter SDK installed. If not, follow the [Flutter installation guide](https://flutter.dev/docs/get-started/install).

### Steps
1. Clone the repository to your local machine:
   ```Https
   git clone https://github.com/kevin6221/weather_app_poc.git
   ```

2. Navigate into the project directory:
   ```
   cd weather_app
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Ensure Firebase services are enabled:
    - Enable Firestore database in Firebase Console.

5. Obtain an API key from OpenWeatherMap:
    - Sign up at [OpenWeatherMap](https://openweathermap.org/) to get your API key.
    - Replace `UrlConst.apiKey` in `lib/const/url_const.dart` with your API key.

6. Run the app:
   ```
   flutter run
   ```

## Usage
- Grant location permissions when prompted to fetch weather based on your current location.
- Use the search icon on the app bar to search for weather by city name.
- Swipe to delete cities from the list stored in Firestore.

## Troubleshooting
- If you encounter issues with Flutter SDK or dependencies, refer to the official [Flutter documentation](https://flutter.dev/docs).
- For Firebase-related issues, check the [Firebase documentation](https://firebase.google.com/docs).
- Ensure internet connectivity as the app requires internet access to fetch weather data from OpenWeatherMap API.

## Contributing
Contributions are welcome! Please fork the repository and create a pull request with your proposed changes.

## License
This project is licensed under the MIT License - see the LICENSE file for details.

---

### Notes:
- **Dependencies:** Make sure to keep `flutter` and other packages updated (`flutter pub upgrade`).
- **Documentation:** Update the README as needed to reflect changes in setup, usage, or troubleshooting tips.
