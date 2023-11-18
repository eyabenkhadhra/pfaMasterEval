import 'package:flutter/material.dart';
import 'package:pfa_2023_iit/pages/auth/login.view.dart';
import 'package:pfa_2023_iit/pages/evaluations/submit_form.dart';
import 'package:pfa_2023_iit/pages/screen/home.page.dart';
import 'package:pfa_2023_iit/pages/splash_screen/splash_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    if (settings.name == "/home") {
      return MaterialPageRoute(builder: (context) => HomeScreen());
    } else if (settings.name == '/') {
      return MaterialPageRoute(builder: (context) => SplashScreeen());
    } else if (settings.name!.contains('form')) {
      print(
        settings.name!.split('/').last,
      );
      return MaterialPageRoute(
          builder: (context) => SubmitForm(
                evalId: settings.name!.split('/').last,
              ));
    } else if (settings.name == '/login') {
      return MaterialPageRoute(builder: (context) => LoginPage());
    } else {
      return MaterialPageRoute(
          builder: (_) => WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ),
              ));
    }
  }
}
