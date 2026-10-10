
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/permission_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/base/custom_image.dart';

class AttendanceCameraSection extends StatefulWidget {
  const AttendanceCameraSection({
    super.key,
  });

  @override
  State<AttendanceCameraSection> createState() =>
      _AttendanceCameraSectionState();
}

class _AttendanceCameraSectionState
    extends State<AttendanceCameraSection> {
  CameraController? _cameraController;

  bool _isOpeningCamera = false;
  bool _isCapturingSelfie = false;
  String? _cameraError;

  // -------------------- START CAMERA --------------------

  Future<void> _startCamera(
    PermissionController permissionController,
  ) async {
    if (_isOpeningCamera || _isCapturingSelfie) return;

    final bool isGranted =
        await permissionController.requestCameraPermission(context);

    if (!mounted || !isGranted) return;

    setState(() {
      _isOpeningCamera = true;
      _cameraError = null;
    });

    CameraController? newController;

    try {
      final List<CameraDescription> cameras =
          await availableCameras();

      if (cameras.isEmpty) {
        throw Exception("No camera found on this device.");
      }

      final CameraDescription selectedCamera =
          cameras.firstWhere(
        (camera) =>
            camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      newController = CameraController(
        selectedCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await newController.initialize();

      if (!mounted) {
        await newController.dispose();
        return;
      }

      final oldController = _cameraController;

      setState(() {
        _cameraController = newController;
      });

      await _disposeCameraSafely(oldController);

      debugPrint("Camera initialized successfully");
    } on CameraException catch (e) {
      await _disposeCameraSafely(newController);

      if (!mounted) return;

      setState(() {
        _cameraError = e.description ?? e.code;
      });

      debugPrint("Camera error: ${e.code} - ${e.description}");
    } catch (e) {
      await _disposeCameraSafely(newController);

      if (!mounted) return;

      setState(() {
        _cameraError = e.toString();
      });

      debugPrint("Camera initialization error: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isOpeningCamera = false;
        });
      }
    }
  }

  // -------------------- CAPTURE SELFIE --------------------

  Future<void> _captureSelfie(
    PermissionController permissionController,
  ) async {
    final controller = _cameraController;

    if (_isCapturingSelfie ||
        controller == null ||
        !controller.value.isInitialized ||
        controller.value.isTakingPicture) {
      return;
    }

    setState(() {
      _isCapturingSelfie = true;
      _cameraError = null;
    });

    try {
      final XFile capturedImage =
          await controller.takePicture();

      if (!mounted) return;

      // Save the captured selfie in your existing controller.
      await permissionController.setSelfie(
        File(capturedImage.path),
      );

      // Stop the camera after capturing the selfie.
      if (identical(_cameraController, controller)) {
        _cameraController = null;
      }

      await _disposeCameraSafely(controller);
    } on CameraException catch (e) {
      if (mounted) {
        setState(() {
          _cameraError =
              e.description ?? e.code;
        });
      }

      debugPrint("Selfie capture error: ${e.code}");
    } catch (e) {
      if (mounted) {
        setState(() {
          _cameraError = e.toString();
        });
      }

      debugPrint("Selfie error: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isCapturingSelfie = false;
        });
      }
    }
  }

  // -------------------- DISPOSE CAMERA --------------------

  Future<void> _disposeCameraSafely(
    CameraController? controller,
  ) async {
    try {
      await controller?.dispose();
    } catch (e) {
      debugPrint("Camera disposal error: $e");
    }
  }

  // -------------------- CAMERA PREVIEW --------------------

  Widget _buildCameraPreview() {
    if (_isOpeningCamera || _isCapturingSelfie) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }

    if (_cameraError != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: CustomText(
            _cameraError!,
            textAlign: TextAlign.center,
            style: Helper(context)
                .textTheme
                .bodyMedium
                ?.copyWith(
                  color: Colors.white,
                  fontSize: 12.sp,
                ),
          ),
        ),
      );
    }

    if (_cameraController != null &&
        _cameraController!.value.isInitialized) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: CameraPreview(_cameraController!),
      );
    }

    return Center(
      child: Icon(
        Icons.camera_alt_outlined,
        color: Colors.white54,
        size: 40.sp,
      ),
    );
  }

  // -------------------- BUILD --------------------

  @override
  void dispose() {
    final controller = _cameraController;
    _cameraController = null;

    _disposeCameraSafely(controller);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PermissionController>(
      builder: (permissionController) {
        final File? selfie = permissionController.selfie;

        final double cameraBoxSize =
            MediaQuery.of(context).size.height / 3;

        // Show the GIF while camera is off and no selfie exists.
        if (!permissionController.isCameraOn &&
            selfie == null) {
          return CustomImage(
            path: Assets.gifScanFace,
            height: 128.h,
            width: 112.w,
            radius: 12.r,
            fit: BoxFit.cover,
          );
        }

        return Column(
          children: [
            // -------------------- CAMERA / SELFIE BOX --------------------

            Container(
              height: cameraBoxSize,
              width: cameraBoxSize,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: black,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: selfie != null
                  ? Image.file(
                      selfie,
                      width: cameraBoxSize,
                      height: cameraBoxSize,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            color: Colors.white,
                          ),
                        );
                      },
                    )
                  : _buildCameraPreview(),
            ),

            sizedBoxHeight(height: 12.h),

            // -------------------- CAMERA BUTTON --------------------

            SizedBox(
              width: cameraBoxSize,
              child: CustomButton(
                onTap: () {
                  if (_isOpeningCamera ||
                      _isCapturingSelfie) {
                    return;
                  }

                  if (selfie != null) {
                    // Clear the old selfie and reopen camera.
                    permissionController.clearSelfie();

                    _startCamera(permissionController);
                  } else if (_cameraController != null &&
                      _cameraController!.value.isInitialized) {
                    // Capture selfie from live camera.
                    _captureSelfie(permissionController);
                  } else {
                    // Open camera for the first time.
                    _startCamera(permissionController);
                  }
                },
                type: ButtonType.secondary,
                radius: 12.r,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      selfie != null
                          ? Icons.refresh
                          : _cameraController != null &&
                                  _cameraController!
                                      .value.isInitialized
                              ? Icons.camera_alt_outlined
                              : Icons.camera_alt_outlined,
                      size: 18.sp,
                      color: primaryColor,
                    ),
                    sizedBoxWidth(width: 12.w),
                    CustomText(
                      _isOpeningCamera
                          ? "Opening Camera..."
                          : _isCapturingSelfie
                              ? "Capturing..."
                              : selfie != null
                                  ? "Retake"
                                  : _cameraController != null &&
                                          _cameraController!
                                              .value.isInitialized
                                      ? "Capture Selfie"
                                      : "Start Camera",
                      style: Helper(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                            fontSize: 16.sp,
                            color: primaryColor,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
