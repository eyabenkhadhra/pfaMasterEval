import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pfa_2023_iit/pages/widget/input_field.dart';
import 'package:pfa_2023_iit/utils/global.colors.dart';

class EditSubject extends StatefulWidget {
  // Attribute which hold the information of the selected ressource
  //final DocumentSnapshot documentSnapshot;
  final DocumentSnapshot subject;

  /* -- Constructor -- */
  EditSubject({required this.subject});
  /* ----------------- */

  @override
  State<EditSubject> createState() => _EditSubjectState();
}

class _EditSubjectState extends State<EditSubject> {
  /* -- Controllers Initialisation -- */
  final nameController = TextEditingController();

  /* --------------------------------- */

  Future<void> updatesubject() async {
    await widget.subject.reference.update({
      "name": nameController.text,
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully edited the subject')));
  }

  @override
  void initState() {
    super.initState();
    nameController.text = widget.subject.get("name");
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Modification Matiéres",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 4 / 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InputField(
                        hintText: 'Nom',
                        height: 100,
                        width: 200,
                        controller: nameController),
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
                        // Missing Conditions
                        final String name = nameController.text;
                        updatesubject();
                        nameController.text = '';
                        Navigator.pop(context);
                      },
                      child: Text('Modifier ')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
