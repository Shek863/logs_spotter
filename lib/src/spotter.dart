import 'dart:developer' as out;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:logs_spotter/src/utils.dart';
import 'package:path_provider/path_provider.dart';

class Spotter {
  static final Spotter _instance = Spotter._internal();

  Spotter._internal();

  factory Spotter() {
    return _instance;
  }

  late File _logFile;
  bool _enableWriteToFile = true;
  SpotterSession? _currentSession;




  Future<void> start({
    /// @Params: custom app, device or user identifier
    /// Ex : 518739839
    String? customId,
    /// @Params: file name
    /// Ex : app_logs
    String fileName = "",
    /// @Params: enable in file writing
    /// Ex : true
    bool writeToFile = true,
  }) async {
    _enableWriteToFile = writeToFile;
    if (writeToFile) _initFile(fileName);
    _startSession(customId: customId);
  }

  void log(SpotEntry spotEntry) {
    _currentSession?.addEntry(spotEntry);
    _writeToFile(spotEntry.toString());
    out.log(spotEntry.toString());
  }


  void _initFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    out.log("Path: $directory");
    _logFile = File(
        '${directory.path}/${fileName.isEmpty?defaultFileName:fileName}.txt');
    if (!(await _logFile.exists())) {
      out.log("create");
      await _logFile.create();
    }
  }
  void _startSession({String? customId}) {
    final newSession = SpotterSession(
        sessionId: DateTime.timestamp().millisecondsSinceEpoch,
        customId: "$customId");
    _currentSession = newSession;

    // Write session header to the file
    _writeToFile(newSession.formatSession());
  }
  void _writeToFile(String content) {
    if (kIsWeb) return;
    if (!_enableWriteToFile) return;
    _logFile.writeAsStringSync('$content\n', mode: FileMode.append);
  }


  /// Helper method. Do not use for file-based logs
  void displaySession() {
    out.log(_currentSession!.formatSession());
  }
}
