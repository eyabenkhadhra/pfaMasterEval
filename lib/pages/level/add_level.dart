import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pfa_2023_iit/models/speciality.model.dart';
import 'package:pfa_2023_iit/pages/widget/input_field.dart';
import 'package:pfa_2023_iit/utils/dimensions/dimensions.dart';
import 'package:pfa_2023_iit/utils/global.colors.dart';

class AddLevel extends StatefulWidget {
  final int number;
  final String specId;
  const AddLevel({super.key, required this.specId, required this.number});

  @override
  State<AddLevel> createState() => _AddLevelState();
}

class _AddLevelState extends State<AddLevel> {
  Speciality? speciality;
  String id = DateTime.now().millisecondsSinceEpoch.toString();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /* -- Controllers Initialisation -- */
  final nameController = TextEditingController();
  // Variable pour stocker la valeur sélectionnée
  /* --------------------------------- */

  /* -- Function that creates the user in the Firebase Firestore -- */
  Future<void> createLevel() async {
    await FirebaseFirestore.instance
        .collection('speciality')
        .doc(widget.specId)
        .collection("levels")
        .doc(id)
        .set({"name": nameController.text, "id": id});
    await FirebaseFirestore.instance
        .collection("settings")
        .doc('first')
        .update({"levels": widget.number + 1});

    final snackBar = SnackBar(
      content: Text("Vous aves ajouté le niveau ${nameController.text}"),
      backgroundColor: (Colors.red),
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
      margin: EdgeInsets.all(52),
      closeIconColor: Colors.white,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

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
                "Ajouter niveau",
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
                          createLevel();
                          Navigator.pop(context);
                        } // Missing Conditions
                      },
                      child: Text('Créer un niveau')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
