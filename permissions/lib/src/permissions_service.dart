enum Permission {
  contacts,
}

enum PermissionAccess {
  granted,
  denied,
  permanentlyDenied,
}

abstract class PermissionsService {
  Future<PermissionAccess> hasPermission(Permission permission);
  Future<PermissionAccess> requestPermission(Permission permission);
  Future<bool> openAppSettings();
}
