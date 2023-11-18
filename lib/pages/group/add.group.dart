import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pfa_2023_iit/pages/widget/input_field.dart';
import 'package:pfa_2023_iit/utils/dimensions/dimensions.dart';
import 'package:pfa_2023_iit/utils/global.colors.dart';

class AddGroup extends StatefulWidget {
  final String idSpec;
  final String idLevel;
  final int number;
  const AddGroup(
      {super.key,
      required this.number,
      required this.idLevel,
      required this.idSpec});

  @override
  State<AddGroup> createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  String id = DateTime.now().millisecondsSinceEpoch.toString();

  /* -- Controllers Initialisation -- */
  final nameController = TextEditingController();
  // Variable pour stocker la valeur sélectionnée
  /* --------------------------------- */

  /* -- Firebase Instance to "groups" collection -- */
  /* ----------------------- */

  /* -- Function that creates the user in the Firebase Firestore -- */
  Future<void> createGroup() async {
    await FirebaseFirestore.instance
        .collection('speciality')
        .doc(widget.idSpec)
        .collection("levels")
        .doc(widget.idLevel)
        .collection("groups")
        .doc(id)
        .set({"name": nameController.text, "id": id});
    await FirebaseFirestore.instance
        .collection("settings")
        .doc('first')
        .update({"groups": widget.number + 1});

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have successfully added a group')));
  }

  /* --------------------------------------------------------------- */
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          //width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Ajouter groupe",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 4 / 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Form(
                        key: _formKey,
                        child: InputField(
                            hintText: 'Nom',
                            height: Constants.screenHeight * 0.06,
                            width: 200,
                            controller: nameController)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Center(
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(globalcolors.mainColor),
                        fixedSize:
                            MaterialStateProperty.all(const Size(200, 40)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          createGroup();
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Créer un groupe')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
