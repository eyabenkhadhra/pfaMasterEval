import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:pfa_2023_iit/pages/analyse/analyse.dart';
import 'package:pfa_2023_iit/pages/auth/login.view.dart';
import 'package:pfa_2023_iit/pages/evaluations/all_evaluations.dart';
import 'package:pfa_2023_iit/pages/forms/my_forms.dart';
import 'package:pfa_2023_iit/pages/screen/dashbord_screen.dart';
import '../../utils/global.colors.dart';
import '../speciality/speciality.page.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "screen-home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _selectedScreen = DashboardScreen();

  currentScreen(item) async {
    switch (item.route) {
      case DashboardScreen.id:
        setState(() {
          _selectedScreen = DashboardScreen();
        });
        break;

      case Specialities.id:
        setState(() {
          _selectedScreen = Specialities();
        });
        break;
      case MyForms.id:
        setState(() {
          _selectedScreen = MyForms();
        });
        break;
      case AllEvaluations.id:
        setState(() {
          _selectedScreen = AllEvaluations();
        });
        break;
      case AnalyseScreen.id:
        setState(() {
          _selectedScreen = AnalyseScreen();
        });
        break;
      case "logout":
        await FirebaseAuth.instance.signOut();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: globalcolors.mainColor,
        title: Center(child: const Text('Tableau de bord')),
      ),
      sideBar: SideBar(
        items: const [
          AdminMenuItem(
            title: 'Tableau de bord',
            route: 'dashboard-screen',
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
              title: 'Parametrage',
              route: '/settings',
              icon: Icons.settings,
              children: [
                AdminMenuItem(
                  title: 'Gestion de parcours',
                  route: Specialities.id,
                  icon: Icons.school,
                ),
                AdminMenuItem(
                  title: 'Gestion de formulaires',
                  route: 'form',
                  icon: Icons.forum,
                ),
              ]),
          AdminMenuItem(
            title: 'Evaluations',
            route: 'evaluations',
            icon: Icons.done_all,
          ),
          AdminMenuItem(
            title: 'Analyse',
            route: 'analyse',
            icon: Icons.pie_chart,
          ),
          AdminMenuItem(
            title: 'Deconnexion',
            route: 'logout',
            icon: Icons.logout,
          ),
        ],
        selectedRoute: HomeScreen.id,
        onSelected: (item) {
          currentScreen(item);
        },
      ),
      body: SingleChildScrollView(
        child: _selectedScreen,
      ),
    );
  }
}
