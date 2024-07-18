import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void showPermissionDeniedDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Location Permission Required"),
        content: const Text("Please grant location permission in app settings to continue using this app."),
        actions: <Widget>[
          TextButton(
            child: const Text("Open Settings"),
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showLocationFetchErrorDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Location Fetch Error'),
        content: const Text('Unable to fetch current location. Please try again.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss dialog
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}