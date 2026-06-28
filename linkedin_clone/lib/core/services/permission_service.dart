// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:permission_handler/permission_handler.dart';

// class PermissionService {
//   static Future<bool> requestCameraPermission() async {
//     if (Platform.isWindows) {
//       // Windows doesn't require permission for camera access at OS level
//       // Applications handle this internally
//       return true;
//     }

//     var status = await Permission.camera.status;
//     if (status.isDenied) {
//       status = await Permission.camera.request();
//     }
//     return status.isGranted;
//   }

//   static Future<bool> requestStoragePermission() async {
//     if (Platform.isWindows) {
//       // Windows handles file access permissions via file picker dialog
//       return true;
//     }

//     var status = await Permission.storage.status;
//     if (status.isDenied) {
//       status = await Permission.storage.request();
//     }
//     return status.isGranted;
//   }

//   static Future<bool> openAppSettings() async {
//     if (Platform.isWindows) {
//       debugPrint('App settings not applicable on Windows');
//       return false;
//     }
//     return await openAppSettings();
//   }

//   // Check if platform is mobile (requires explicit permissions)
//   static bool get isMobilePlatform =>
//       !kIsWeb && (Platform.isAndroid || Platform.isIOS);

//   // Check if platform is desktop
//   static bool get isDesktopPlatform =>
//       !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
// }
