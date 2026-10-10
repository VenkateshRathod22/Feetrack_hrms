import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/attendance_controller.dart';
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

class _AttendanceCameraSectionState extends State<AttendanceCameraSection> {
  CameraController? _cameraController;

  bool _isOpeningCamera = false;
  bool _isCapturingSelfie = false;
  bool _isClosingCamera = false;

  String? _cameraError;

  // -------------------- TOGGLE CAMERA --------------------

  Future<void> _toggleCamera(
    PermissionController permissionController,
    AttendanceController attendanceController,
  ) async {
    if (attendanceController.isLoading) {
      showToast(
        message: "Please wait",
        toastType: ToastType.warning,
      );
      return;
    }

    if (_isOpeningCamera || _isCapturingSelfie || _isClosingCamera) {
      return;
    }

    // Close camera when it is open.
    if (permissionController.isCameraOn) {
      await _closeCamera(permissionController);
      return;
    }

    // Open camera.
    await _startCamera(permissionController);
  }

  // -------------------- START CAMERA --------------------

  Future<void> _startCamera(
    PermissionController permissionController,
  ) async {
    if (_isOpeningCamera || _isCapturingSelfie || _isClosingCamera) {
      return;
    }

    final bool isGranted =
        await permissionController.requestCameraPermission(context);

    if (!mounted || !isGranted) return;

    setState(() {
      _isOpeningCamera = true;
      _cameraError = null;
    });

    CameraController? newController;

    try {
      final List<CameraDescription> cameras = await availableCameras();

      if (cameras.isEmpty) {
        throw Exception("No camera found on this device.");
      }

      // Prefer front camera for attendance selfie.
      final CameraDescription selectedCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      newController = CameraController(
        selectedCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await newController.initialize();

      if (!mounted) {
        await _disposeCameraSafely(newController);
        return;
      }

      final oldController = _cameraController;

      setState(() {
        _cameraController = newController;
      });

      await _disposeCameraSafely(oldController);

      // Update the UI after successful initialization.
      permissionController.updateCamera(value: true);

      debugPrint("Camera initialized successfully");
    } on CameraException catch (e) {
      await _disposeCameraSafely(newController);

      if (!mounted) return;

      setState(() {
        _cameraController = null;
        _cameraError = e.description ?? e.code;
      });

      permissionController.updateCamera(value: false);

      debugPrint(
        "Camera error: ${e.code} - ${e.description}",
      );
    } catch (e) {
      await _disposeCameraSafely(newController);

      if (!mounted) return;

      setState(() {
        _cameraController = null;
        _cameraError = e.toString();
      });

      permissionController.updateCamera(value: false);

      debugPrint("Camera initialization error: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isOpeningCamera = false;
        });
      }
    }
  }

  // -------------------- CLOSE CAMERA --------------------

  Future<void> _closeCamera(
    PermissionController permissionController,
  ) async {
    if (_isClosingCamera) return;

    setState(() {
      _isClosingCamera = true;
      _cameraError = null;
    });

    final controller = _cameraController;
    _cameraController = null;

    await _disposeCameraSafely(controller);

    if (!mounted) return;

    permissionController.updateCamera(value: false);

    setState(() {
      _isClosingCamera = false;
    });
  }

  // -------------------- CAPTURE SELFIE --------------------

  Future<void> _captureSelfie(
    PermissionController permissionController,
  ) async {
    final controller = _cameraController;

    if (_isCapturingSelfie ||
        _isOpeningCamera ||
        _isClosingCamera ||
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
      final XFile capturedImage = await controller.takePicture();

      if (!mounted) return;

      // Save selfie in PermissionController.
      await permissionController.setSelfie(
        File(capturedImage.path),
      );

      // Release the camera after capture.
      if (identical(_cameraController, controller)) {
        _cameraController = null;
      }

      await _disposeCameraSafely(controller);

      if (!mounted) return;

      permissionController.updateCamera(value: false);

      debugPrint("Selfie captured successfully");
    } on CameraException catch (e) {
      if (mounted) {
        setState(() {
          _cameraError = e.description ?? e.code;
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

  // -------------------- RETAKE SELFIE --------------------

  Future<void> _retakeSelfie(
    PermissionController permissionController,
  ) async {
    if (_isOpeningCamera || _isCapturingSelfie || _isClosingCamera) {
      return;
    }

    permissionController.clearSelfie();

    await _startCamera(permissionController);
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

  // -------------------- CAMERA CONTENT --------------------

  Widget _buildCameraContent({
    required File? selfie,
    required double size,
  }) {
    if (_isOpeningCamera || _isCapturingSelfie || _isClosingCamera) {
      return Center(
        key: const ValueKey('camera-loading'),
        child: SizedBox(
          height: 32.h,
          width: 32.w,
          child: const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2.5,
          ),
        ),
      );
    }

    if (_cameraError != null) {
      return Center(
        key: const ValueKey('camera-error'),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: CustomText(
            _cameraError!,
            textAlign: TextAlign.center,
            style: Helper(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 12.sp,
                ),
          ),
        ),
      );
    }

    if (selfie != null) {
      return Image.file(
        selfie,
        key: const ValueKey('captured-selfie'),
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(
              Icons.broken_image_outlined,
              color: Colors.white,
            ),
          );
        },
      );
    }

    if (_cameraController != null && _cameraController!.value.isInitialized) {
      return CameraPreview(
        _cameraController!,
        key: const ValueKey('live-camera'),
      );
    }

    return GestureDetector(
      onTap: () {
        _startCamera(Get.find<PermissionController>());
      },
      child: CustomImage(
        key: const ValueKey('scan-face'),
        path: Assets.gifScanFace,
        width: 150.w,
        height: 112.5.w, // 150 × 600 / 800
        radius: 12.r,
        fit: BoxFit.contain,
      ),
    );
  }

  // -------------------- ANIMATED CAMERA BOX --------------------

  Widget _buildAnimatedCameraBox({
    required File? selfie,
    required double cameraBoxSize,
    required PermissionController permissionController,
    required AttendanceController attendanceController,
  }) {
    final bool showLargeBox = permissionController.isCameraOn ||
        selfie != null ||
        _isOpeningCamera ||
        _isCapturingSelfie ||
        _isClosingCamera ||
        _cameraError != null;

    final double gifWidth = 150.w;
    final double gifHeight = gifWidth * (600 / 800);

    final double boxHeight = showLargeBox ? cameraBoxSize : gifHeight;

    final double boxWidth = showLargeBox ? cameraBoxSize : gifWidth;

    final Widget content = _buildCameraContent(
      selfie: selfie,
      size: cameraBoxSize,
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      height: boxHeight,
width: boxWidth,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: black,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.12),
            blurRadius: 18.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // -------------------- CAMERA CONTENT --------------------

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 450),
            reverseDuration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(
                    begin: 0.92,
                    end: 1,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: SizedBox.expand(
              key: ValueKey(
                selfie != null
                    ? 'selfie'
                    : _isOpeningCamera || _isCapturingSelfie || _isClosingCamera
                        ? 'loading'
                        : _cameraError != null
                            ? 'error'
                            : permissionController.isCameraOn
                                ? 'preview'
                                : 'idle',
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: content,
              ),
            ),
          ),

          // -------------------- CLOSE CAMERA BUTTON --------------------

          if (permissionController.isCameraOn)
            Positioned(
              top: 8.h,
              right: 8.w,
              child: Material(
                color: Colors.black.withValues(alpha: 0.55),
                shape: const CircleBorder(),
                child: IconButton(
                  tooltip: 'Close camera',
                  onPressed:
                      _isClosingCamera || _isCapturingSelfie || _isOpeningCamera
                          ? null
                          : () => _closeCamera(permissionController),
                  constraints: BoxConstraints(
                    minWidth: 40.w,
                    minHeight: 40.h,
                  ),
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 23.sp,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // -------------------- DISPOSE --------------------

  @override
  void dispose() {
    final controller = _cameraController;
    _cameraController = null;

    _disposeCameraSafely(controller);

    super.dispose();
  }

  // -------------------- BUILD --------------------

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendanceController>(
      builder: (attendanceController) {
        return GetBuilder<PermissionController>(
          builder: (permissionController) {
            final File? selfie = permissionController.selfie;

            final double cameraBoxSize =
                MediaQuery.of(context).size.height / 2.3;

            final bool showButton = permissionController.isCameraOn ||
                selfie != null ||
                _isOpeningCamera ||
                _isCapturingSelfie ||
                _isClosingCamera ||
                _cameraError != null;

            return Column(
              children: [
                _buildAnimatedCameraBox(
                  selfie: selfie,
                  cameraBoxSize: cameraBoxSize,
                  permissionController: permissionController,
                  attendanceController: attendanceController,
                ),
                if (showButton) ...[
                  sizedBoxHeight(height: 12.h),
                  SizedBox(
                    width: cameraBoxSize,
                    child: CustomButton(
                      onTap: () {
                        if (_isOpeningCamera ||
                            _isCapturingSelfie ||
                            _isClosingCamera) {
                          return;
                        }

                        if (selfie != null) {
                          _retakeSelfie(permissionController);
                        } else if (_cameraController != null &&
                            _cameraController!.value.isInitialized) {
                          _captureSelfie(permissionController);
                        } else {
                          _startCamera(permissionController);
                        }
                      },
                      type: ButtonType.secondary,
                      radius: 12.r,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.15),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: Row(
                          key: ValueKey(
                            _isOpeningCamera
                                ? 'opening'
                                : _isCapturingSelfie
                                    ? 'capturing'
                                    : _isClosingCamera
                                        ? 'closing'
                                        : selfie != null
                                            ? 'retake'
                                            : permissionController.isCameraOn
                                                ? 'capture'
                                                : 'start',
                          ),
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              selfie != null
                                  ? Icons.refresh
                                  : permissionController.isCameraOn
                                      ? Icons.camera_alt_outlined
                                      : Icons.camera_alt_outlined,
                              size: 18.sp,
                              color: primaryColor,
                            ),
                            sizedBoxWidth(width: 12.w),
                            Flexible(
                              child: CustomText(
                                _isOpeningCamera
                                    ? "Opening Camera..."
                                    : _isCapturingSelfie
                                        ? "Capturing..."
                                        : _isClosingCamera
                                            ? "Closing Camera..."
                                            : selfie != null
                                                ? "Retake"
                                                : permissionController
                                                        .isCameraOn
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }
}
