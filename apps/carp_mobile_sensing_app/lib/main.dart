library mobile_sensing_app;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';

// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
// import 'package:carp_connectivity_package/connectivity.dart';
// import 'package:carp_esense_package/esense.dart';
import 'package:carp_polar_package/carp_polar_package.dart';
import 'package:carp_context_package/carp_context_package.dart';
import 'package:carp_survey_package/survey.dart';
import 'package:research_package/research_package.dart';

// import 'package:carp_audio_package/media.dart';
// import 'package:carp_communication_package/communication.dart';
// import 'package:carp_apps_package/apps.dart';
// import 'package:movisens_flutter/movisens_flutter.dart';
// import 'package:carp_movisens_package/movisens.dart';
// import 'package:carp_health_package/health_package.dart';
// import 'package:health/health.dart';

import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_services/carp_services.dart';
import 'package:carp_backend/carp_backend.dart';

import 'package:cupertino_list_tile/cupertino_list_tile.dart';
// import 'package:google_maps/google_maps_geometry.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_animarker/flutter_map_marker_animation.dart';
import 'package:rosemary_maps/rosemary_maps.dart';

part 'src/app.dart';
part 'src/app_ios.dart';
part 'src/build_settings.dart';
part 'src/sensing/sensing.dart';
part 'src/models/probe_model.dart';
part 'src/models/device_model.dart';
part 'src/models/probe_description.dart';
part 'src/models/deployment_model.dart';
part 'src/blocs/sensing_bloc.dart';
part 'src/blocs/carp_backend.dart';
part 'src/sensing/local_study_protocol_mananger.dart';

part 'src/ui/probe_list.dart';
part 'src/ui/device_list.dart';
part 'src/ui/study_viz.dart';
part 'src/ui/cachet.dart';
part 'src/ui/maps_demo.dart';
part 'src/ui/navigator.dart';
part "src/ui/google_maps_page_2.dart";
part 'src/widgets/customized_buttons.dart';
part 'src/ui/background_locator.dart';
part 'src/ui/personal_info.dart';
part 'src/ui/personal_info_survey.dart';
part 'src/ui/data_review.dart';

void main() async {
  // makes sure to have an instance of the WidgetsBinding, which is required
  // to use platform channels to call native code
  // see also >> https://stackoverflow.com/questions/63873338/what-does-widgetsflutterbinding-ensureinitialized-do/63873689
  WidgetsFlutterBinding.ensureInitialized();

  // initialize the bloc, setting the deployment mode:
  //  * LOCAL
  //  * CARP_STAGGING
  //  * CARP_PRODUCTION
  await bloc.initialize(
    deploymentMode: DeploymentMode.LOCAL,
    useCachedStudyDeployment: false,
    resumeSensingOnStartup: false,
  );

  runApp(BuildSettings.buildIOS ? App_IOS() : App());
}
