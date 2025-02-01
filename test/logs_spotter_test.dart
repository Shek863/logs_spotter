import 'package:flutter_test/flutter_test.dart';

import 'package:logs_spotter/logs_spotter.dart';

void main() {
  test('adds one to input values', () {
    final spotter = Spotter();
    expect(spotter.start(), 3);
  });
}
