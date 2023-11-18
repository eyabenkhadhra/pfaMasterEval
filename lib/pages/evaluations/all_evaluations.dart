import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pfa_2023_iit/models/evaluation.dart';
import 'package:pfa_2023_iit/pages/evaluations/add_evaluation.dart';
import 'package:pfa_2023_iit/services/AuthServices.dart';
import 'package:pfa_2023_iit/utils/dimensions/dimensions.dart';
import 'package:pfa_2023_iit/utils/global.colors.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AllEvaluations extends StatefulWidget {
  static const String id = 'evaluations';
  const AllEvaluations({Key? key}) : super(key: key);

  @override
  State<AllEvaluations> createState() => _MyFormsState();
}

class _MyFormsState extends State<AllEvaluations> {
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
                            'Liste des evaluations',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w800),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.to(AddEvaluation());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: globalcolors.mainColor,
                              fixedSize: const Size(250, 50),
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            child: Text('Ajouter'),
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
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Action",
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
                                    child:
                                        Text("Pas d'evaluation pour le moment"),
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
                                                  //  Get.to(EditForms(formId: forms[index].id));
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
                                                      Expanded(
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              InkWell(
                                                                onTap:
                                                                    () async {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return AlertDialog(
                                                                        title:
                                                                            Text(
                                                                          "Scanner le  Qr code",
                                                                          style:
                                                                              TextStyle(color: Colors.indigo),
                                                                        ),
                                                                        content:
                                                                            Container(
                                                                          height:
                                                                              200,
                                                                          alignment:
                                                                              Alignment.center,
                                                                          width:
                                                                              200,
                                                                          child:
                                                                              QrImage(
                                                                            data:
                                                                                "http://172.20.10.6:8000/#/form/${eval[index].id}",
                                                                            version:
                                                                                QrVersions.auto,
                                                                            size:
                                                                                200.0,
                                                                          ),
                                                                        ),
                                                                        actions: <
                                                                            Widget>[
                                                                          TextButton(
                                                                            child:
                                                                                Text(
                                                                              'Fermer',
                                                                              style: TextStyle(color: Colors.indigo),
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child: Icon(
                                                                  Icons.qr_code,
                                                                  color: Colors
                                                                      .green,
                                                                ),
                                                              ),
                                                              InkWell(
                                                                onTap:
                                                                    () async {
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                      .reference
                                                                      .delete();
                                                                },
                                                                child: Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              ),
                                                            ],
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
