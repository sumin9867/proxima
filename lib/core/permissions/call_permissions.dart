import 'package:permission_handler/permission_handler.dart';

/// Requests the runtime permissions a call needs.
abstract final class CallPermissions {
  /// Requests microphone, and camera when [video] is true. Returns true only if
  /// every required permission was granted.
  static Future<bool> requestForCall({required bool video}) async {
    final needed = <Permission>[
      Permission.microphone,
      if (video) Permission.camera,
    ];
    final results = await needed.request();
    return results.values.every((status) => status.isGranted);
  }
}
