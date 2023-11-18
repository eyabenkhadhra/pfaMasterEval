import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../utils/global.colors.dart';

class DashboardScreen extends StatelessWidget {
  static const String id = "dashboard-screen";
  Widget analyticWidget({required String title, required String topic}) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(
        height: 100,
        width: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey),
          borderRadius: BorderRadius.circular(10),
          color: globalcolors.mainColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("settings")
                          .doc("first")
                          .snapshots(),
                      builder: (builder, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            "${snapshot.data!.get(topic)}",
                            style: TextStyle(color: Colors.white),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                        }
                      }),
                  Icon(
                    Icons.show_chart,
                    color: Colors.white,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            analyticWidget(title: "Totale de Specialités", topic: "spec"),
            analyticWidget(title: "Totale de niveaux", topic: "levels"),
            analyticWidget(title: "Totale de Groupes", topic: "groups"),
            analyticWidget(title: "Totale de Matiéres", topic: "subs"),
          ],
        ),
      ],
    );
  }
}
