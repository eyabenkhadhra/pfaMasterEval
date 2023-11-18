import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pfa_2023_iit/models/evaluation.dart';
import 'package:pfa_2023_iit/pages/analyse/analyse_details.dart';
import 'package:pfa_2023_iit/utils/dimensions/dimensions.dart';
import 'package:pfa_2023_iit/utils/global.colors.dart';

class AnalyseScreen extends StatefulWidget {
  static const String id = 'analyse';

  const AnalyseScreen({Key? key}) : super(key: key);

  @override
  State<AnalyseScreen> createState() => _AnalyseScreenState();
}

class _AnalyseScreenState extends State<AnalyseScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(10),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('evaluations')
              .orderBy("date", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong! ${snapshot.error}');
            } else if (!snapshot.hasData &&
                snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              List<Evaluation> eval = [];

              if (snapshot.hasData) {
                var data = snapshot.data;

                if (data is QuerySnapshot) {
                  for (var doc in data.docs) {
                    final dataMap = doc.data() as Map<String, dynamic>?;
                    if (dataMap != null) {
                      final speciality = Evaluation.fromJson(dataMap);
                      eval.add(speciality);
                    }
                  }
                }
              }
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Liste des évaluations à analyser',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: globalcolors.mainColor,
                                  borderRadius: BorderRadius.circular(20)),
                              height: Constants.screenHeight * 0.04,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Libellé",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Date",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Hote",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            eval.isEmpty
                                ? Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 100),
                                    child: Text(
                                        "Pas d'evaluation pour l'analyser"),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: eval.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Material(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                splashColor: Colors.grey,
                                                onTap: () {
                                                  Get.to(AnalyseDetails(
                                                    id: eval[index].id,
                                                  ));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: globalcolors
                                                          .mainColor
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  height:
                                                      Constants.screenHeight *
                                                          0.04,
                                                  width: double.infinity,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            "${eval[index].label}",
                                                            style: TextStyle(
                                                                color: globalcolors
                                                                    .mainColor),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            "${DateFormat("yyyy/MM/dd").format(eval[index].date)}",
                                                            style: TextStyle(
                                                                color: globalcolors
                                                                    .mainColor),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: StreamBuilder(
                                                            stream: FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "speciality")
                                                                .doc(eval[index]
                                                                    .specId)
                                                                .collection(
                                                                    "levels")
                                                                .doc(eval[index]
                                                                    .levelId)
                                                                .collection(
                                                                    "groups")
                                                                .doc(eval[index]
                                                                    .grpId)
                                                                .collection(
                                                                    "subjects")
                                                                .doc(eval[index]
                                                                    .subjectId)
                                                                .snapshots(),
                                                            builder: (context,
                                                                AsyncSnapshot<
                                                                        DocumentSnapshot<
                                                                            Map<String,
                                                                                dynamic>>>
                                                                    snapshot) {
                                                              if (snapshot
                                                                  .hasData) {
                                                                return Text(
                                                                  "${snapshot.data!.get("name")}",
                                                                  style: TextStyle(
                                                                      color: globalcolors
                                                                          .mainColor),
                                                                );
                                                              } else {
                                                                return Container();
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  )
                          ],
                        )),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
