import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:teacher_app/utils/LogUtils.dart';

class DeviceInfoService {
  static final DeviceInfoService _instance = DeviceInfoService._internal();
  static DeviceInfoService get instance => _instance;

  DeviceInfoService._internal();

  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  // Cached device info - loaded once
  DeviceInfo? _cachedDeviceInfo;
  bool _isInitialized = false;

  /// Get device ID (Android ID for Android, identifier for iOS)
  Future<String?> getDeviceId() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfoPlugin.androidInfo;
        // Use available Android identifiers
        String? deviceId = androidInfo.id;
        if (deviceId.isEmpty) {
          // Create a pseudo-unique ID from available info
          deviceId = "${androidInfo.brand}_${androidInfo.model}_${androidInfo.device}".replaceAll(' ', '_');
        }
        appLog("DeviceInfoService: Android device ID - $deviceId");
        return deviceId;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await _deviceInfoPlugin.iosInfo;
        String? deviceId = iosInfo.identifierForVendor;
        if (deviceId == null || deviceId.isEmpty) {
          // Create a fallback ID for iOS
          deviceId = "ios_${iosInfo.model}_${iosInfo.systemName}".replaceAll(' ', '_');
        }
        appLog("DeviceInfoService: iOS device ID - $deviceId");
        return deviceId;
      }
    } catch (e) {
      appLog("DeviceInfoService: Error getting device ID - $e");
    }
    return "unknown_device";
  }

  /// Get device name/model
  Future<String?> getDeviceName() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfoPlugin.androidInfo;
        String deviceName = "${androidInfo.brand} ${androidInfo.model}";
        appLog("DeviceInfoService: Android device name - $deviceName");
        return deviceName;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await _deviceInfoPlugin.iosInfo;
        String? deviceName = iosInfo.name;
        if (deviceName == null || deviceName.isEmpty) {
          // Fallback to model if name is not available
          deviceName = iosInfo.localizedModel ?? iosInfo.model;
        }
        appLog("DeviceInfoService: iOS device name - $deviceName");
        return deviceName;
      }
    } catch (e) {
      appLog("DeviceInfoService: Error getting device name - $e");
    }
    return "Unknown Device";
  }

  /// Get platform (android or ios)
  String getPlatform() {
    if (Platform.isAndroid) {
      return 'android';
    } else if (Platform.isIOS) {
      return 'ios';
    } else {
      return 'unknown';
    }
  }

  /// Initialize device info once (call during app startup)
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      appLog("DeviceInfoService: Initializing device info...");
      final deviceId = await getDeviceId();
      final deviceName = await getDeviceName();
      final platform = getPlatform();

      _cachedDeviceInfo = DeviceInfo(
        deviceId: deviceId,
        deviceName: deviceName,
        platform: platform,
      );

      _isInitialized = true;
      appLog("DeviceInfoService: Device info initialized - $_cachedDeviceInfo");
    } catch (e) {
      appLog("DeviceInfoService: Error initializing device info - $e");
      // Provide fallback values
      _cachedDeviceInfo = DeviceInfo(
        deviceId: "unknown_device",
        deviceName: "Unknown Device",
        platform: getPlatform(),
      );
      _isInitialized = true;
    }
  }

  /// Get device information with automatic initialization
  Future<DeviceInfo> getDeviceInfo() async {
    if (!_isInitialized) {
      await initialize();
    }
    return _cachedDeviceInfo!;
  }

  /// Get cached device information (synchronous) - only use if you're sure it's initialized
  DeviceInfo getCachedDeviceInfo() {
    if (!_isInitialized || _cachedDeviceInfo == null) {
      appLog("DeviceInfoService: Device info not initialized, returning default values");
      return DeviceInfo(
        deviceId: "unknown_device",
        deviceName: "Unknown Device",
        platform: getPlatform(),
      );
    }
    return _cachedDeviceInfo!;
  }

  /// Get detailed device information for debugging
  Future<Map<String, dynamic>> getDetailedDeviceInfo() async {
    Map<String, dynamic> deviceData = {};

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfoPlugin.androidInfo;
        deviceData = {
          'platform': 'android',
          'id': androidInfo.id,
          'brand': androidInfo.brand,
          'model': androidInfo.model,
          'manufacturer': androidInfo.manufacturer,
          'device': androidInfo.device,
          'product': androidInfo.product,
          'androidId': androidInfo.id,
          'sdkInt': androidInfo.version.sdkInt,
          'release': androidInfo.version.release,
        };
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await _deviceInfoPlugin.iosInfo;
        deviceData = {
          'platform': 'ios',
          'name': iosInfo.name,
          'systemName': iosInfo.systemName,
          'systemVersion': iosInfo.systemVersion,
          'model': iosInfo.model,
          'localizedModel': iosInfo.localizedModel,
          'identifierForVendor': iosInfo.identifierForVendor,
          'isPhysicalDevice': iosInfo.isPhysicalDevice,
        };
      }
    } catch (e) {
      appLog("DeviceInfoService: Error getting detailed device info - $e");
      deviceData['error'] = e.toString();
    }

    return deviceData;
  }
}

class DeviceInfo {
  final String? deviceId;
  final String? deviceName;
  final String platform;

  DeviceInfo({
    required this.deviceId,
    required this.deviceName,
    required this.platform,
  });

  @override
  String toString() {
    return 'DeviceInfo(deviceId: $deviceId, deviceName: $deviceName, platform: $platform)';
  }
}