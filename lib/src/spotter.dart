import 'dart:async';
import 'dart:io';
import 'package:ansicolor/ansicolor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:logs_spotter/src/utils/models.dart';
import 'package:logs_spotter/src/utils/utils.dart';
import 'package:path_provider/path_provider.dart';

/// Spotter
class Spotter {
  static final Spotter _instance = Spotter._internal();

  Spotter._internal();

  /// Get instance of Spotter
  factory Spotter() {
    return _instance;
  }

  /// This initialisation method to configure spotter attitude
  /// Call it from your main.dart
  ///
  /// [customId] : custom app, device or user identifier Ex : 518739839,
  /// [fileName] : file name Ex : app_logs,
  /// [writeToConsole] : enable in console writing defaultValue : true,
  /// [writeToFile] : enable in file writing defaultValue : false,
  /// [writeToFirebase] : enable remote writing [Firebase] defaultValue : false,
  Future<void> initializeEngine({
    String? customId,
    String fileName = "",
    bool writeToConsole = true,
    bool writeToFile = false,
    bool writeToFirebase = false,
  }) async {
    String defaultId = await provideDefaultId();
    _startSession(customId: customId ?? defaultId);

    // Console initialisation
    _enableWriteToConsole = writeToConsole;

    // local initialisation [File]
    _enableWriteToFile = writeToFile;
    if (writeToFile) _initFile(fileName);

    // remote initialisation [Firebase]
    _enableWriteToFirebase = writeToFirebase;
    if (writeToFirebase) _initFirebase();

  }

  SpotterSession? _currentSession;
  void _startSession({String? customId}) {
    final newSession = SpotterSession(
        sessionId: DateTime.timestamp().millisecondsSinceEpoch,
        customId: "$customId");
    _currentSession = newSession;
  }

  // console
  bool _enableWriteToConsole = true;
  void _writeToConsole(String content) {
    if (!_enableWriteToConsole) return;
    ansiColorDisabled = false;
    debugPrint(penInfo(content));
  }

  // local
  late File _logFile;
  bool _enableWriteToFile = true;
  void _initFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    _logFile = File(
        '${directory.path}/${fileName.isEmpty ? defaultFileName : fileName}.txt');
    if (!(await _logFile.exists())) {
      await _logFile.create();
    }

    // Write session header to the file
    _writeToFile(_currentSession!.formatSession());
  }
  void _writeToFile(String content) {
    if (kIsWeb) return;
    if (!_enableWriteToFile) return;
    _logFile.writeAsStringSync('$content\n', mode: FileMode.append);
  }

  // remote: Firebase
  bool _enableWriteToFirebase = true;
  bool _observe = false;
  dynamic _dbInstanceDevices ;
  void _initFirebase() async {
    await Firebase.initializeApp();
    _dbInstanceDevices = FirebaseFirestore.instance.collection("spotter")
        .doc("data").collection('devices');

    // listen when we are enable to observe
    // This will reduce firebase costs
    _dbInstanceDevices.doc(_currentSession?.customId)
        .snapshots().listen((snapshot){
          _observe = snapshot.data()==null? false: snapshot.data()!["observe"] ?? false;
        });

    // Write session header to firebase
    SpotEntry initialLog = SpotEntry("initial log");
    await _dbInstanceDevices
        .doc(_currentSession?.customId)
        .collection('spots')
        .doc(initialLog.dateTime.millisecondsSinceEpoch.toString())
        .set(initialLog.toJson(), SetOptions(merge: true));
    // set session observe to false (default value)
    await _dbInstanceDevices
        .doc(_currentSession?.customId)
        .set({'observe': false}, SetOptions(merge: true));
  }
  void _writeToFirebase(SpotEntry spotEntry) async {
    if (!_enableWriteToFirebase) return;
    if (!_observe) return;
    await _dbInstanceDevices
        .doc(_currentSession?.customId)
        .collection('spots')
        .doc(spotEntry.dateTime.millisecondsSinceEpoch.toString())
        .set(spotEntry.toJson(), SetOptions(merge: true));
  }




  /// Spotter log
  ///
  void log(SpotEntry spotEntry) async {
    _currentSession?.addEntry(spotEntry);

    /// show on console
    _writeToConsole(spotEntry.toAnsiPen());

    /// save in file
    _writeToFile(spotEntry.toString());

    /// save in firebase
    _writeToFirebase(spotEntry);
  }

  /// Helper method. Do not use for file-based logs
  void displaySession() {
    _writeToConsole(_currentSession!.formatSession());
  }
}
