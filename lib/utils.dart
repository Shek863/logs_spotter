
// Enum for log types
import 'package:intl/intl.dart';
import 'package:logs_spotter/logs_spotter.dart';

String click = "CLICK";
String error = "ERROR";
String warning = "WARNING";
String debug = "DEBUG";
String request = "REQUEST";
String response = "RESPONSE";


// Model for a log entry
class SpotEntry {
  final String message;
  late DateTime? timestamp;
  final String? tag;

  SpotEntry(this.message,
      {this.tag}){
    timestamp = DateTime.now();
  }

  @override
  String toString() {
    return
      '$timestamp ${''.padLeft(2)} : ${tag != null ? '[$tag] ' : ''}$message';
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

extension Logger on String {

  void spot({String? tag}) {
   Spotter().log(SpotEntry( this, tag: tag));
  }

}