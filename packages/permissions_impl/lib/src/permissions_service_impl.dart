import 'package:permission_handler/permission_handler.dart' as lib;
import 'package:permissions/permissions.dart';

extension _AppPermissionX on Permission {
  lib.Permission toNative() {
    switch (this) {
      case Permission.contacts:
        return lib.Permission.contacts;
    }
  }
}

extension _PermissionStatusNativeX on lib.PermissionStatus {
  PermissionAccess toApp() {
    switch (this) {
      case lib.PermissionStatus.granted:
        return PermissionAccess.granted;
      case lib.PermissionStatus.restricted:
      case lib.PermissionStatus.limited:
      case lib.PermissionStatus.denied:
        return PermissionAccess.denied;
      case lib.PermissionStatus.permanentlyDenied:
        return PermissionAccess.permanentlyDenied;
    }
  }
}

class PermissionsServiceImpl implements PermissionsService {
  @override
  Future<PermissionAccess> hasPermission(Permission permission) async {
    return (await permission.toNative().status).toApp();
  }

  @override
  Future<PermissionAccess> requestPermission(Permission permission) async {
    return (await permission.toNative().request()).toApp();
  }

  @override
  Future<bool> openAppSettings() {
    return lib.openAppSettings();
  }
}
