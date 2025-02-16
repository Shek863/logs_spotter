// Enum for log types
import '../../logs_spotter.dart';
import 'models.dart';

/// [String] Extension to log
@Deprecated("Call LogLevel extension before")
extension Logger on String {
  /// Log Action method
  @Deprecated("Call LogLevel extension before")
  void spot({String? tag}) {
    Spotter().log(SpotEntry(this, tag: tag));
  }
}

///
/// [String] Extension to log
extension LogLevel on String {
  /// Log level method : Level.FINE
  SpotEntry f() {
    return SpotEntry(this, level: "✅ FINE");
  }

  /// Log level method : Level.INFO
  SpotEntry i() {
    return SpotEntry(this, level: "📢 INFO");
  }

  /// Log level method : Level.WARNING
  SpotEntry w() {
    return SpotEntry(this, level: "🚧 WARNING");
  }

  /// Log level method : Level.ERROR
  SpotEntry e() {
    return SpotEntry(this, level: "🚨 ERROR");
  }

  /// Log Action method : CLICK
  SpotEntry c() {
    return SpotEntry(this, level: "🖱 CLICK");
  }

  /// Log Action method : API REQUEST
  SpotEntry req() {
    return SpotEntry(this, level: "📤 REQUEST");
  }

  /// Log Action method : API RESPONSE
  SpotEntry res() {
    return SpotEntry(this, level: "📥 RESPONSE");
  }
}

///
/// [SpotEntry Function()] Extension to log
extension SpotterLogger on SpotEntry Function() {
  /// ```
  /// Note: Call LogLevel extension before;
  /// ```
  spot({String? tag}) {
    SpotEntry spotEntry = this.call();
    if (tag != null) {
      spotEntry.tag = tag;
    }
    Spotter().log(spotEntry);
  }
}
