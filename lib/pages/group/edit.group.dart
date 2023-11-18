import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pfa_2023_iit/pages/widget/input_field.dart';
import 'package:pfa_2023_iit/utils/dimensions/dimensions.dart';
import 'package:pfa_2023_iit/utils/global.colors.dart';

class EditGroup extends StatefulWidget {
  // Attribute which hold the information of the selected ressource
  //final DocumentSnapshot documentSnapshot;
  final DocumentSnapshot group;

  /* -- Constructor -- */
  EditGroup({required this.group});
  /* ----------------- */

  @override
  State<EditGroup> createState() => _EditGroupState();
}

class _EditGroupState extends State<EditGroup> {
  /* -- Controllers Initialisation -- */
  final nameController = TextEditingController();

  /* --------------------------------- */

  /* -- Firebase Instance to "levels" collection -- */

  Future<void> updateGroup() async {
    await widget.group.reference.update({
      "name": nameController.text,
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully edited the group')));
  }

  @override
  void initState() {
    super.initState();
    nameController.text = widget.group.get("name");
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Modification de group",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 4 / 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InputField(
                        hintText: 'Nom',
                        height: Constants.screenHeight * 0.03,
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
                        updateGroup();
                        nameController.text = '';
                        Navigator.pop(context);
                      },
                      child: Text('Modifier')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
