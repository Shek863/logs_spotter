// Enum for log types
import 'package:ansicolor/ansicolor.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../logs_spotter.dart';

/// Model for a log entry
class SpotEntry {
  /// log content
  final String message;

  /// log level
  late String? level;

  /// log time
  late DateTime dateTime;

  /// log TAG
  late String? tag;

  /// Model constructor
  SpotEntry(this.message, {this.tag, this.level}) {
    level = level ?? debug;
    dateTime = DateTime.now();
  }

  /// Model constructor
  SpotEntry.reload(this.message, {this.tag, this.level, String dateTime = ""}) {
    debugPrint("_exporter::spots::dateTime::$dateTime");
    var date = DateTime.parse(dateTime
            .replaceAll(" ", "T")
            .substring(0, 24)
            .replaceRange(23, 24, 'Z'))
        .toLocal();
    this.dateTime = date;
  }

  @override
  String toString() {
    return '-> spot ::: $level ::: $dateTime ::: '
        '${tag ?? StackTrace.current.toString().split("#")[4].toString().split(" ").last.replaceAll("\n", "").replaceAll("(", "").replaceAll(")", "")} \n'
        ' ::: $message';
  }

  ///
  String toAnsiPen() {
    final str = '-> spot ::: $level ::: $dateTime ::: '
        '${tag ?? StackTrace.current.toString().split("#")[4].toString().split(" ").last.replaceAll("\n", "").replaceAll("(", "").replaceAll(")", "")} \n'
        '-> ctnt ::: $message';

    String ansiPen;

    switch (level) {
      case "✅ FINE":
        ansiPen = penFine(str);
        break;
      case "📢 INFO":
        ansiPen = penInfo(str);
        break;
      case "🚧 WARNING":
        ansiPen = penWarning(str);
        break;
      case "🚨 ERROR":
        ansiPen = penError(str);
        break;

      case "🖱 CLICK":
        ansiPen = penClick(str);
        break;
      case "📤 REQUEST":
        ansiPen = penAPIRequest(str);
        break;
      case "📥 RESPONSE":
        ansiPen = penAPIResponse(str);
        break;

      default:
        ansiPen = penInfo(str);
        break;
    }

    return ansiPen;
  }

  /// Convert Model [SpotEntry] object to Map
  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'message': message,
      'tag': tag,
      'dateTime': dateTime.toString()
    };
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

    AnsiPen pen = AnsiPen()..blue();
    return pen('$sessionHeader$eventLogs');
  }
}
