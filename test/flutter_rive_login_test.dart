import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_rive_login/flutter_rive_login.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_rive_login');

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
   /// expect(await FlutterRiveLogin.platformVersion, '42');
  });
}
