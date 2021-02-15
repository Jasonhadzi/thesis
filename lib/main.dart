import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wolie_mobile/models/user.dart';
import 'package:wolie_mobile/screens/home/store_point_details.dart';
import 'package:wolie_mobile/screens/home/request_points_screen.dart';
import 'package:wolie_mobile/screens/home/request_stamps_screen.dart';
import 'package:wolie_mobile/screens/services/auth.dart';
import 'package:wolie_mobile/screens/wrapper.dart';
import 'package:flutter/services.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //changed orientation only portrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
        routes: {
          RequestStampsScreen.routeName: (context) => RequestStampsScreen(),
          RequestPointsScreen.routeName: (context) => RequestPointsScreen(),
          StorePointDetails.routeName: (context) => StorePointDetails(),
        },
      ),
    );
  }
}
