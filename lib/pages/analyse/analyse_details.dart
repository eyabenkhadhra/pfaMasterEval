import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pfa_2023_iit/utils/global.colors.dart';
import 'package:pie_chart/pie_chart.dart';

class AnalyseDetails extends StatefulWidget {
  final String id;
  const AnalyseDetails({Key? key, required this.id}) : super(key: key);

  @override
  State<AnalyseDetails> createState() => _AnalyseDetailsState();
}

class _AnalyseDetailsState extends State<AnalyseDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globalcolors.mainColor,
        title: Text("Analyse par matiére"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("evaluations")
            .doc(widget.id)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            return PieChart(
              dataMap: {
                "A": snapshot.data!.get("A"),
                "B": snapshot.data!.get("B"),
                "C": snapshot.data!.get("C"),
                "D": snapshot.data!.get("D"),
                "E": snapshot.data!.get("E"),
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
