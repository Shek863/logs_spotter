
// Enum for log types
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:logs_spotter/logs_spotter.dart';
import 'package:logs_spotter/src/spotter.dart';

///  Const
const defaultFileName = "app_logs";

///
const String click = "CLICK";
const String error = "ERROR";
const String warning = "WARNING";
const String debug = "DEBUG";
const String request = "REQUEST";
const String response = "RESPONSE";

String icon(tag) {
  switch(tag){
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


// Model for a log entry
class SpotEntry {
  final String message;
  late DateTime dateTime;
  late String? tag;

  SpotEntry(this.message,
      {this.tag}){
    tag = tag ?? debug;
    dateTime = DateTime.now();
  }



  @override
  String toString() {
    return '::: spot ::: $dateTime ::: ${ icon(tag) } :::'
        '\n$message'
        '\n::::::::::::::::::::::::::::::::::::::::::::::::::::::::';
  }

  Map<String, dynamic> toJson() {
    return { 'message': message, 'tag': tag, 'dateTime': dateTime.toString()};
  }

}

// Model for a session, containing multiple log entries
class SpotterSession {
  final int sessionId;
  final String customId;
  final List<SpotEntry> entries = [];

  SpotterSession(
      {required this.sessionId, required this.customId });

  void addEntry(SpotEntry entry) {
    entries.add(entry);
  }

  String formatSession() {
    final loginTimeFormatted =
    DateFormat('yyyy-MM-dd HH:mm:ss.SSS')
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

extension Logger on String {

  void spot({String? tag}) {
   Spotter().log(SpotEntry( this, tag: tag));
  }

}