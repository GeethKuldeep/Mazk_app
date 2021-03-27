import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Analysis extends StatefulWidget {
  @override
  _AnalysisState createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  var user;
  String URL1;
  Color final_color;
  var color1 =  Color(0xFFD50000);
  var color2 =  Color(0xFFFDDED5);
  var color3 =  Color(0xFFF4592F);
  var color4 =  Color(0xFF0050F5);




  @override
  void initState() {

  getshopdata();

    super.initState();
  }
  getshopdata()async{
    //user = await FirebaseFirestore.instance.collection("Vendors").doc("SRMT").collection("SRMT").where("StoreName",isEqualTo:"Nike").get();
    FirebaseFirestore.instance.collection("Vendors").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        if(result.id == "SRMT"){
          FirebaseFirestore.instance
              .collection("Vendors")
              .doc("SRMT")
              .collection("SRMT")
              .get()
              .then((querySnapshot) {
            querySnapshot.docs.forEach((result) {
              setState(() {
                if(result["StoreName"]=="Nike"){
                  user = result.data();
                  print(user);
                }

              });
            });
          });
        }

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user["Current_strength"] <=
        user["Total_strength"] * 0.25) {
      final_color = Colors.lightGreenAccent;
    }
    else if (user["Total_strength"] * 0.25 <
        user["Current_strength"] &&
        user["Current_strength"] <=
            user["Total_strength"] * 0.75) {
      final_color = Colors.orange;
    }
    else if (user["Total_strength"] * 0.75 <
        user["Current_strength"] &&
        user["Current_strength"] <=
            user["Total_strength"]) {
      final_color = color1;
    }
    if(user["StoreName"]=="KFC")
      URL1 ="images/kfc.png";
    else if(user["StoreName"]=="Nike")
      URL1 ="images/nike1.png";

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 35,),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(URL1),
                    radius: 40,
                  ),
                  Text(user["StoreName"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45),),
                  Column(
                    children: [
                      Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                            color: final_color,
                            borderRadius: BorderRadius.all(
                                Radius.circular(20))
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                          "${user["Current_strength"]}/${user["Total_strength"]}")
                    ],
                  )


                ],
              ),
            ),
            Text("Instructions:",style: TextStyle(fontWeight: FontWeight.bold,color: color3,fontSize: 25),),
            SizedBox(height: 15,),
            Container(
              height: MediaQuery.of(context).size.height*0.11,
              width: MediaQuery.of(context).size.height*0.4,
              decoration: BoxDecoration(
                  color: color2,
                borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              child:Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("-${user["Instruction1"]}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                    SizedBox(height: 5,),
                    Text("-${user["Instruction2"]}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15,),
            Text("Our timings:",style: TextStyle(fontWeight: FontWeight.bold,color: color4,fontSize: 25),),


          ],
        ),
      ),
    );



  }
}
