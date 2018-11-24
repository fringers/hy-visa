# Flutter NFC Reader

A new flutter plugin to help developers looking to use internal hardware inside iOS or Android devices for reading NFC tags.

The system activate a pooling reading session that stops automatically once a tag has been recognised.
You can also trigger the stop event manually using a dedicated function.

## How to use

### Android setup

Add those two lines to your `AndroidManifest.xml` on the top

```xml
<uses-permission android:name="android.permission.NFC" />
<uses-feature
        android:name="android.hardware.nfc"
        android:required="true" />
```

and add this in your _.MainActivity_ just below the other **intent-filter**:

```xml
<intent-filter>
  <action android:name="android.nfc.action.NDEF_DISCOVERED"/>
  <category android:name="android.intent.category.DEFAULT"/>
  <data android:mimeType="text/plain" />
</intent-filter>
```

**Attention** the _mimeType_ should be the right one for the [expected type](https://developer.android.com/guide/topics/connectivity/nfc/nfc) of NFC you are going to read.

### iOS Setup

Atm only `Swift` based Flutter project are supported.

- Enable Capabilities / Near Field Communication Tag Reading. 
- Info.plist file, add Privacy - NFC Scan Usage Description with string value NFC Tag.


### Read NFC

This function will return a promise when a read occurs, till that very moment the reading session is open.
The promise will return a map with `<String, dynamic>`.
The map will have inside `status` or `data` key.
In order to stop a reading session you need to use `stop` function.

```dart
Future<void> startNFC() async {
    String response;
    bool reading = true;

    try {
      response = await FlutterNfcReader.read;
    } on PlatformException {
      response = '';
      reading = false;
    }
    setState(() {
      _nfcReading = reading;
      _nfcData = response;
    });
  }
```

### Stop NFC
```dart

  Future<void> stopNFC() async {
    bool response;
    try {
      final bool result = await FlutterNfcReader.stop;
      response = result;
    } on PlatformException {
      response = false;
    }
    setState(() {
      _nfcReading = response;
    });
  }
```

For better details look at the demo app.

## Extra

`FlutterNfcReader.read()` has an optional parameter, only for **iOS**, called `instruction`.
You can pass a _String_ that contains information to be shown in the modal screen.

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

For help on editing plugin code, view the [documentation](https://flutter.io/developing-packages/#edit-plugin-package).
