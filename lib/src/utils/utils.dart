// Enum for log types
import 'package:ansicolor/ansicolor.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

/// local writing default file name
const defaultFileName = "app_logs";

/// DEFAULT_LOG_TAG for ui click event. Icon: 🖱️
const String click = "CLICK";

/// DEFAULT_LOG_TAG for error. Icon: 🚨
const String error = "ERROR";

/// DEFAULT_LOG_TAG for warning. Icon: 🚧
const String warning = "WARNING";

/// DEFAULT_LOG_TAG for debug. Icon: 🐞
const String debug = "DEBUG";

/// DEFAULT_LOG_TAG for api or public method request event. Icon: 📤
const String request = "REQUEST";

/// DEFAULT_LOG_TAG for api or public method response event. Icon: 📥
const String response = "RESPONSE";

/// Package internal methode to determine emoji from log tag
String icon(tag) {
  switch (tag) {
    case click:
      return "🖱️";

    case error:
      return "🚨";

    case warning:
      return "🚧";

    case debug:
      return "🐞";

    case request:
      return "📤";

    case response:
      return "📥";

    default:
      return "🐛";
  }
}

/// DEFAULT_AnsiPen color (white) for console style
AnsiPen penClick = AnsiPen()..white();

/// DEFAULT_AnsiPen color (white) for console style
AnsiPen penAPIResponse = AnsiPen()..white();

/// DEFAULT_AnsiPen color (white) for console style
AnsiPen penAPIRequest = AnsiPen()..white();

/// DEFAULT_AnsiPen color (white) for console style
AnsiPen penInfo = AnsiPen()..white();

/// DEFAULT_AnsiPen color (red) for console style
AnsiPen penError = AnsiPen()..red();

/// DEFAULT_AnsiPen color (green) for console style
AnsiPen penFine = AnsiPen()..green();

/// DEFAULT_AnsiPen color (yellow) console style
AnsiPen penWarning = AnsiPen()..yellow();

/// Package internal method to create a default [customId] even there are
/// [null] on [Spotter().initializeEngine()]
Future<String> provideDefaultId() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  if (kIsWeb) {
    WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
    return webBrowserInfo.browserName.name;
  }
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.model;
    case TargetPlatform.iOS:
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.model;
    case TargetPlatform.macOS:
      MacOsDeviceInfo macOsInfo = await deviceInfo.macOsInfo;
      return macOsInfo.model;
    case TargetPlatform.windows:
      WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
      return windowsInfo.deviceId;
    case TargetPlatform.linux:
      LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
      return linuxInfo.name;
    default:
      throw UnsupportedError(
        'DefaultFirebaseOptions are not supported for this platform.',
      );
  }
}
