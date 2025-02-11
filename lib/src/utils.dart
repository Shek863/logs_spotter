// Enum for log types
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:logs_spotter/logs_spotter.dart';
import 'package:logs_spotter/src/spotter.dart';

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

/// Model for a log entry
class SpotEntry {
  /// log content
  final String message;
  /// log time
  late DateTime dateTime;
  /// log TAG
  late String? tag;

  /// Model constructor
  SpotEntry(this.message, {this.tag}) {
    tag = tag ?? debug;
    dateTime = DateTime.now();
  }

  @override
  String toString() {
    return '::: spot ::: $dateTime ::: ${icon(tag)} :::'
        '\n$message'
        '\n::::::::::::::::::::::::::::::::::::::::::::::::::::::::';
  }

  /// Convert Model [SpotEntry] object to Map<String, dynamic>
  Map<String, dynamic> toJson() {
    return {'message': message, 'tag': tag, 'dateTime': dateTime.toString()};
  }
}

/// Model for a session, containing multiple log entries
class SpotterSession {
  /// Session identifier
  final int sessionId;
  ///
  final String customId;
  /// log entry list
  final List<SpotEntry> entries = [];

  /// Model constructor
  SpotterSession({required this.sessionId, required this.customId});

  /// Add entry to list [entries]
  void addEntry(SpotEntry entry) {
    entries.add(entry);
  }

  /// Print all session to [String]
  String formatSession() {
    final loginTimeFormatted = DateFormat('yyyy-MM-dd HH:mm:ss.SSS')
        .format(DateTime.fromMillisecondsSinceEpoch(sessionId));
    final sessionHeader = '\n\n'
        '┌────────────── New Session ────────────────┐\n│ '
        'Session ID: $sessionId\n│ '
        'User: $customId\n│ '
        'Login Time: $loginTimeFormatted\n'
        '└───────────────────────────────────────────┘';

    final eventLogs = entries.map((e) => e.toString()).join('\n\n');

    return '$sessionHeader$eventLogs';
  }
}


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

/// [String] Extension to log
/// Note: [SpotEntry.message] equal ;
extension Logger on String {

  /// Log Action method
  void spot({String? tag}) {
    Spotter().log(SpotEntry(this, tag: tag));
  }
}
