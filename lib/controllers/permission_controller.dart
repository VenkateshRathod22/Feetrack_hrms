

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:permission_handler/permission_handler.dart';

import '../views/base/dialogs/request_permission_dialog.dart';

class PermissionController extends GetxController implements GetxService {

  Future<bool> getPermission(
      Permission permission, BuildContext context) async {
    PermissionStatus? status;
    await (Future.value(
            await permission.isGranted || await permission.isLimited))
        .then((value) async {
      if (!value) {
        bool result = await showDialog(
              context: context,
              builder: (context) => RequestPermissionDialog(
                permission: permission.toString().split('.').last.toString(),
              ),
            ) ??
            false;
        if (result) {
          status = await permission.request();
        }
        log("-----$status-----", name: permission.toString());
      } else {
        log("-----Granted-----", name: permission.toString());
      }
    });

    bool isGranted = permission == Permission.photos
        ? (await permission.isLimited || await permission.isGranted)
        : await permission.isGranted;
    return Future.value(isGranted);
  }

  // -------------------- LOCATION --------------------

  double? _latitude;
  double? _longitude;
  bool _locationFetched = false;

  String? _currentAddress;
  String? _areaName; // <-- NEW VARIABLE FOR AREA NAME

  String? get currentAddress => _currentAddress;
  String? get areaName => _areaName; // <-- NEW GETTER

  double? get latitude => _latitude;
  double? get longitude => _longitude;
  bool get locationFetched => _locationFetched;

  Future<bool> requestLocationPermissionAndFetch(BuildContext context) async {
    try {
      log("========== LOCATION START ==========");

      if (_locationFetched && _latitude != null && _longitude != null) {
        log("Location already fetched: $_latitude, $_longitude");
        return true;
      }

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (context.mounted) {
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
              title: const Text("Location Disabled"),
              content: const Text(
                "Please enable GPS/Location Services.",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await Geolocator.openLocationSettings();
                  },
                  child: const Text("Settings"),
                ),
              ],
            ),
          );
        }
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Location permission denied"),
            ),
          );
        }
        return false;
      }

      if (permission == LocationPermission.deniedForever) {
        if (context.mounted) {
          await showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Permission Required"),
              content: const Text(
                "Location permission is permanently denied. Please enable it from Settings.",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await openAppSettings();
                  },
                  child: const Text("Open Settings"),
                ),
              ],
            ),
          );
        }
        return false;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      _latitude = position.latitude;
      _longitude = position.longitude;
      _locationFetched = true;

      try {
        // 1. Put back your original Geocoding initialization
        final Geocoding geocoding = Geocoding();

        // 2. Call the method using your geocoding instance
        List<Placemark> placemarks = await geocoding.placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;

          // FULL ADDRESS
          _currentAddress = [
            place.street,
            place.subLocality,
            place.locality,
            place.postalCode,
          ].where((e) => e != null && e.trim().isNotEmpty).join(", ");

          // AREA NAME ONLY
          _areaName = (place.subLocality != null && place.subLocality!.isNotEmpty) 
              ? place.subLocality 
              : place.locality;

        } else {
          _currentAddress = "Unknown Location";
          _areaName = "Unknown Area";
        }
      } catch (e) {
        log("Address Error: $e");
        _currentAddress = "Unable to fetch address";
        _areaName = "Unable to fetch area";
      }

      log("Latitude : $_latitude");
      log("Longitude: $_longitude");
      log("Full Address: $_currentAddress");
      log("Area Name: $_areaName");

      update();
      return true;
    } catch (e, st) {
      log("Location Error: $e");
      log(st.toString());
      return false;
    }
  }

  void clearLocation() {
    _latitude = null;
    _longitude = null;
    _locationFetched = false;
    _currentAddress = "Location pending...";
    _areaName = "Area pending..."; // <-- Clear area name too

    update();
  }
// -------------------- CAMERA PERMISSION --------------------

Future<bool> requestCameraPermission(BuildContext context) async {
  try {
    // Check current camera permission.
    PermissionStatus status = await Permission.camera.status;

    // Permission already granted.
    if (status.isGranted) {
      log("Camera permission already granted");
      return true;
    }

    // Permission permanently denied.
    if (status.isPermanentlyDenied) {
      if (!context.mounted) return false;

      bool openSettings = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Camera Permission Required"),
              content: const Text(
                "Camera permission is permanently denied. "
                "Please enable camera access from app settings "
                "to continue attendance verification.",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text("Open Settings"),
                ),
              ],
            ),
          ) ??
          false;

      if (openSettings) {
        await openAppSettings();
      }

      // User can tap Start Camera again after enabling permission.
      return false;
    }

    // Show your existing permission dialog.
    bool shouldRequest = await showDialog<bool>(
          context: context,
          builder: (context) => RequestPermissionDialog(
            permission: "camera",
          ),
        ) ??
        false;

    if (!shouldRequest || !context.mounted) {
      return false;
    }

    // Request camera permission from the operating system.
    status = await Permission.camera.request();

    log(
      "Camera permission status: $status",
      name: "CameraPermission",
    );

    if (status.isGranted) {
      log("Camera permission granted");
      return true;
    }

    // Handle permanent denial after the request.
    if (status.isPermanentlyDenied && context.mounted) {
      bool openSettings = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Camera Permission Required"),
              content: const Text(
                "Please enable camera access from your app settings.",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text("Open Settings"),
                ),
              ],
            ),
          ) ??
          false;

      if (openSettings) {
        await openAppSettings();
      }
    }

    return false;
  } catch (e, st) {
    log(
      "Camera permission error: $e",
      name: "CameraPermission",
    );
    log(st.toString());

    return false;
  }
}

  bool isCameraOn = false;

  void updateCamera({required bool value}){
    isCameraOn = value;
    update();
  }


  // -------------------- Camera  --------------------

  File? _selfie;

  File? get selfie => _selfie;

  Future<void> setSelfie(File file) async {
    _selfie = file;
    update();
  }

  void clearSelfie() {
    _selfie = null;
    update();
  }
}
