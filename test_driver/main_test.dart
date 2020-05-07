// This is a basic Flutter Driver test for the application. A Flutter Driver
// test is an end-to-end test that "drives" your application from another
// process or even from another computer. If you are familiar with
// Selenium/WebDriver for web, Espresso for Android or UI Automation for iOS,
// this is simply Flutter's version of that.

import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('screenshots', () {
    FlutterDriver driver;

    setUpAll(() async {
      // Connect to a running Flutter application instance.
      driver = await FlutterDriver.connect();
      await sleep(Duration(seconds: 5));
    });

    tearDownAll(() async {
      if (driver != null) await driver.close();
    });

    test('make screenshots', () async {
      await driver.waitFor(find.byValueKey('add'));
      await _makeScreenshot(driver, 0);

      // // Tap on the fab
      // print(addButton);

      // await driver.waitFor(find.text(''));
      // await driver.enterText('Aspirin');

      // await _makeScreenshot(driver, 1);

      // // Wait for text to change to the desired value
      // await driver.waitFor(find.text('1'));

      // // take screenshot after number is incremented
      // await screenshot(driver, config, '1');

      // // increase timeout from 30 seconds for testing
      // // on slow running emulators in cloud
    }, timeout: Timeout(Duration(seconds: 120)));
  });
}

void _makeScreenshot(FlutterDriver driver, int index) async {
  final pixels = await driver.screenshot();
  final file = await File('tmp/screenshot$index.png').create(recursive: true);
  await file.writeAsBytes(pixels);
}
