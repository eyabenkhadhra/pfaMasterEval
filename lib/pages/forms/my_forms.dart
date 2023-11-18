import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfa_2023_iit/models/form.dart';
import 'package:pfa_2023_iit/pages/forms/add_form.dart';
import 'package:pfa_2023_iit/pages/forms/edit_form.dart';
import 'package:pfa_2023_iit/utils/dimensions/dimensions.dart';
import 'package:pfa_2023_iit/utils/global.colors.dart';

class MyForms extends StatefulWidget {
  static const String id = 'form';
  const MyForms({Key? key}) : super(key: key);

  @override
  State<MyForms> createState() => _MyFormsState();
}

class _MyFormsState extends State<MyForms> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(10),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('forms')
              .orderBy("date", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong! ${snapshot.error}');
            } else if (!snapshot.hasData &&
                snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              List<Forms> forms = [];

              if (snapshot.hasData) {
                var data = snapshot.data;

                if (data is QuerySnapshot) {
                  for (var doc in data.docs) {
                    final dataMap = doc.data() as Map<String, dynamic>?;
                    if (dataMap != null) {
                      final speciality = Forms.fromJson(dataMap);
                      forms.add(speciality);
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
                            'Liste des formulaires',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w800),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.to(AddForm());
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
                                  Text(
                                    "Libellé",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    "Action",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            forms.isEmpty
                                ? Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 100),
                                    child: Text(
                                        "Pas de formulaire pour le moment"),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: forms.length,
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
                                                  Get.to(EditForms(
                                                      formId: forms[index].id));
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
                                                      Text(
                                                        "${forms[index].label}",
                                                        style: TextStyle(
                                                            color: globalcolors
                                                                .mainColor),
                                                      ),
                                                      InkWell(
                                                        onTap: () async {
                                                          snapshot
                                                              .data!
                                                              .docs[index]
                                                              .reference
                                                              .delete();
                                                        },
                                                        child: Icon(
                                                          Icons.delete,
                                                          color: Colors.red,
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
