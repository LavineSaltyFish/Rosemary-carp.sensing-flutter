# CARP Communication Sampling Package

This library contains a sampling package for communication sampling to work with
the [`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) package.
This packages supports sampling of the following [`Measure`](https://pub.dev/documentation/carp_core/latest/carp_core_protocols/Measure-class.html) types:

* `dk.cachet.carp.phone_log` - the phone log.
* `dk.cachet.carp.text-message-log` - the text (sms) message log.
* `dk.cachet.carp.text-message` - incoming text (sms) messages.
* `dk.cachet.carp.calendar` - all calendar entries.

Note that collection of phone and text message data is only supported on Android.

See the [wiki](https://github.com/cph-cachet/carp.sensing-flutter/wiki) for further documentation, particularly on available [measure types](https://github.com/cph-cachet/carp.sensing-flutter/wiki/A.-Measure-Types).
See the [CARP Mobile Sensing App](https://github.com/cph-cachet/carp.sensing-flutter/tree/master/apps/carp_mobile_sensing_app) for an example of how to build a mobile sensing app in Flutter.

There is privacy protection of text messages and phone numbers in the default [Privacy Schema](https://github.com/cph-cachet/carp.sensing-flutter/wiki/3.-Using-CARP-Mobile-Sensing#privacy-schema).

For Flutter plugins for other CARP products, see [CARP Mobile Sensing in Flutter](https://github.com/cph-cachet/carp.sensing-flutter/blob/master/README.md).

If you're interested in writing you own sampling packages for CARP, see the description on
how to [extend](https://github.com/cph-cachet/carp.sensing-flutter/wiki/4.-Extending-CARP-Mobile-Sensing) CARP on the wiki.

## Installing

To use this package, add the following to you `pubspc.yaml` file. Note that
this package only works together with `carp_mobile_sensing`.

`````dart
dependencies:
  flutter:
    sdk: flutter
  carp_core: ^latest
  carp_mobile_sensing: ^latest
  carp_communication_package: ^latest
  ...
`````

### Android Integration

Add the following to your app's `manifest.xml` file located in `android/app/src/main`:

````xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
  package="<your_package_name>"
  xmlns:tools="http://schemas.android.com/tools">

  ...
   
  <!-- The following permissions are used for CARP Mobile Sensing -->
  <uses-permission android:name="android.permission.CALL_PHONE"/>
  <uses-permission android:name="android.permission.READ_PHONE_STATE"/>
  <uses-permission android:name="android.permission.READ_PHONE_NUMBERS"/>
  <uses-permission android:name="android.permission.READ_SMS"/>
  <uses-permission android:name="android.permission.RECEIVE_SMS"/>
  <uses-permission android:name="android.permission.READ_CALENDAR"/>
  <!-- Even though we only want to READ the calendar, for some unknown 
       reason we also need to add the WRITE permission. -->
  <uses-permission android:name="android.permission.WRITE_CALENDAR"/>


  <application>
   ...
   ...
    <!-- Registration of broadcast reciever to listen to SMS messages 
         when the app is in the background -->
   <receiver android:name="com.shounakmulay.telephony.sms.IncomingSmsReceiver"
     android:permission="android.permission.BROADCAST_SMS" android:exported="true">
    <intent-filter>
        <action android:name="android.provider.Telephony.SMS_RECEIVED"/>
      </intent-filter>
    </receiver>

   </application>
</manifest>
````

### iOS Integration

Add this permission in the `Info.plist` file located in `ios/Runner`:

````xml
<key>NSCalendarsUsageDescription</key>
<string>INSERT_REASON_HERE</string>
````

## Using it

To use this package, import it into your app together with the
[`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) package:

`````dart
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_communication_package/communication.dart';
`````

Before creating a study and running it, register this package in the
[SamplingPackageRegistry](https://pub.dartlang.org/documentation/carp_mobile_sensing/latest/runtime/SamplingPackageRegistry.html).

`````dart
  SamplingPackageRegistry().register(CommunicationSamplingPackage());
`````

See the `example.dart` file for a full example of how to set up a CAMS study protocol for this context sampling package.
