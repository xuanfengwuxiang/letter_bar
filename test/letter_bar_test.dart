import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:letter_bar/letter_bar.dart';

void main() {
  const MethodChannel channel = MethodChannel('letter_bar');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await LetterBar.platformVersion, '42');
  });
}
