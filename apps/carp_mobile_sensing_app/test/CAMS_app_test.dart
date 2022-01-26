import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';

import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
// import 'package:carp_connectivity_package/connectivity.dart';
import 'package:carp_esense_package/esense.dart';
import 'package:carp_context_package/context.dart';
import 'package:carp_audio_package/audio.dart';
import 'package:carp_backend/carp_backend.dart';
import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_services/carp_services.dart';

import '../lib/main.dart';
import 'credentials.dart';

String _encode(Object object) =>
    const JsonEncoder.withIndent(' ').convert(object);

void main() {
  // creating an empty protocol to initialize json serialization
  StudyProtocol? protocol;
  late Smartphone phone;
  late ESenseDevice eSense;

  setUp(() async {
    // register the different sampling package since we're using measures from them
    // SamplingPackageRegistry().register(ConnectivitySamplingPackage());
    SamplingPackageRegistry().register(ContextSamplingPackage());
    SamplingPackageRegistry().register(AudioVideoSamplingPackage());
    SamplingPackageRegistry().register(ESenseSamplingPackage());

    // create a data manager in order to register the json functions
    CarpDataManager();

    // Define which devices are used for data collection.
    phone = Smartphone();
    eSense = ESenseDevice();
  });

  group("Local Study Protocol Manager", () {
    setUp(() async {
      // Create a new study protocol.
      protocol = await LocalStudyProtocolManager().getStudyProtocol('1234');
    });

    test('CAMSStudyProtocol -> JSON', () async {
      print(protocol);
      print(toJsonString(protocol!));
      expect(protocol?.ownerId, 'abc@dtu.dk');
    });

    test('StudyProtocol -> JSON -> StudyProtocol :: deep assert', () async {
      print('#1 : $protocol');
      final studyJson = toJsonString(protocol!);

      SmartphoneStudyProtocol protocolFromJson =
          SmartphoneStudyProtocol.fromJson(
              json.decode(studyJson) as Map<String, dynamic>);
      expect(toJsonString(protocolFromJson), equals(studyJson));
      print('#2 : $protocolFromJson');
    });

    test('JSON File -> StudyProtocol', () async {
      // Read the study protocol from json file
      String plainJson =
          File('test/json/cams_study_protocol.json').readAsStringSync();

      StudyProtocol protocol = StudyProtocol.fromJson(
          json.decode(plainJson) as Map<String, dynamic>);

      expect(protocol.ownerId, 'abc@dtu.dk');
      expect(protocol.masterDevices.first.roleName, phone.roleName);
      expect(protocol.connectedDevices.first.roleName, eSense.roleName);
      print(toJsonString(protocol));
    });
  });

  group("Data points", () {
    test(' -> JSON', () async {
      ESenseButtonDatum datum =
          ESenseButtonDatum(pressed: true, deviceName: 'eSense-123');

      final DataPoint data = DataPoint.fromData(datum);
      expect(data.carpHeader.dataFormat.namespace,
          ESenseSamplingPackage.ESENSE_NAMESPACE);

      print(_encode(data.toJson()));
    });
  });

  CarpApp app;
  late CarpUser user;
  CarpStudyProtocolManager manager = CarpStudyProtocolManager();

  group("CARP Study Protocol Manager", () {
    setUp(() async {
      app = new CarpApp(
        name: "Test",
        uri: Uri.parse(uri),
        oauth: OAuthEndPoint(clientID: clientID, clientSecret: clientSecret),
      );

      CarpService().configure(app);
      await manager.initialize();

      user = await CarpService().authenticate(
        username: username,
        password: password,
      );

      CarpParticipationService().configureFrom(CarpService());

      // make sure that the json functions are loaded
      DomainJsonFactory();
    });

    test('- authentication', () async {
      print('CarpService : ${CarpService().app}');
      print(" - signed in as: $user");
      // expect(user.accountId, accountId);
    });

    test('- get study protocol', () async {
      SmartphoneStudyProtocol study =
          await manager.getStudyProtocol(testDeploymentId);
      print('study: $study');
      print(_encode(study));
    }, skip: false);

    test(
      '- get invitations for $username',
      () async {
        List<ActiveParticipationInvitation> invitations =
            await CarpParticipationService()
                .getActiveParticipationInvitations();
        invitations.forEach((invitation) => print(invitation));
      },
      skip: false,
    );
  });

  group("Resource Generator Scripts", () {
    setUp(() async {});

    /// Generates and prints the local study protocol as json
    test('protocol -> JSON', () async {
      StudyProtocol? protocol =
          await LocalStudyProtocolManager().getStudyProtocol('1234');
      print(toJsonString(protocol));
    });

    /// Generates and prints the local informed consent as json
    test('informed consent -> JSON', () async {});
  });
}
