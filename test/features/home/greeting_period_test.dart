import 'package:flutter_test/flutter_test.dart';
import 'package:smart_tani_mobile/features/home/presentation/greeting_period.dart';

void main() {
  test('greetingFor boundary hours', () {
    String at(int h) =>
        greetingFor(DateTime(2026, 1, 1, h));
    expect(at(0), 'pagi');
    expect(at(10), 'pagi');
    expect(at(11), 'siang');
    expect(at(14), 'siang');
    expect(at(15), 'sore');
    expect(at(17), 'sore');
    expect(at(18), 'malam');
    expect(at(23), 'malam');
  });
}
