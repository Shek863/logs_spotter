import 'package:flutter_test/flutter_test.dart';

import 'package:logs_spotter/logs_spotter.dart';

void main() {
  test('log message', () {
    Spotter().initializeEngine(writeToFirebase: false);

    expect( "Log this message".f.spot(tag: "_testFINE"),
        "");
    expect( "Log this message".i.spot(tag: "_testINFO"),
        "");
    expect( "Log this message".w.spot(tag: "_testWARNING"),
        "");
    expect( "Log this message".e.spot(tag: "_testERROR"),
        "");
  });
}
