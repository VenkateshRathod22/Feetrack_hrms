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

  String? get currentAddress => _currentAddress;

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
        final Geocoding geocoding = Geocoding();

        List<Placemark> placemarks = await geocoding.placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;

          _currentAddress = [
            place.street,
            place.subLocality,
          ].where((e) => e != null && e.trim().isNotEmpty).join(", ");
        } else {
          _currentAddress = "Unknown Location";
        }
      } catch (e) {
        log("Address Error: $e");
        _currentAddress = "Unable to fetch address";
      }

      log("Latitude : $_latitude");
      log("Longitude: $_longitude");

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
