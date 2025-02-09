import 'dart:developer' as out;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:logs_spotter/src/utils.dart';
import 'package:path_provider/path_provider.dart';

class Spotter {
  static final Spotter _instance = Spotter._internal();

  Spotter._internal();

  factory Spotter() {
    return _instance;
  }

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
    /// @Params: enable remote writing [Firebase]
    /// Ex : true
    bool writeToFirebase = true,
  }) async {
    /// local initialisation [File]
    _enableWriteToFile = writeToFile;
    if (writeToFile) _initFile(fileName);

    /// remote initialisation [Firebase]
    _enableWriteToFirebase = writeToFirebase;
    if (writeToFirebase) _initFirebase();

    String defaultId = await provideDefaultId();
    _startSession(customId: customId ?? defaultId );
  }

  SpotterSession? _currentSession;
  void _startSession({String? customId}) {
    final newSession = SpotterSession(
        sessionId: DateTime.timestamp().millisecondsSinceEpoch,
        customId: "$customId");
    _currentSession = newSession;

    // Write session header to the file
    _writeToFile(newSession.formatSession());
  }


  /// local
  late File _logFile;
  bool _enableWriteToFile = true;
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
  void _writeToFile(String content) {
    if (kIsWeb) return;
    if (!_enableWriteToFile) return;
    _logFile.writeAsStringSync('$content\n', mode: FileMode.append);
  }


  /// remote
  bool _enableWriteToFirebase = true;
  final _dbInstanceDevices = FirebaseFirestore.instance.collection("spotter")
      .doc("data").collection('devices');
  void _initFirebase() async {
    await Firebase.initializeApp();
  }
  void _writeToFirebase(SpotEntry spotEntry) async {
    if (!_enableWriteToFirebase) return;
    await _dbInstanceDevices.doc(_currentSession?.customId).collection('spots')
        .doc(spotEntry.dateTime.millisecondsSinceEpoch.toString()).set(
        spotEntry.toJson(),
        SetOptions(merge: true));
  }


  void log(SpotEntry spotEntry) async {
    _currentSession?.addEntry(spotEntry);

    /// show on console
    out.log(spotEntry.toString());
    /// save in file
    _writeToFile(spotEntry.toString());
    /// save in firebase
    _writeToFirebase(spotEntry);
  }
  /// Helper method. Do not use for file-based logs
  void displaySession() {
    out.log(_currentSession!.formatSession());
  }
}
