import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibranium/screens/HomePage.dart';
import 'package:vibranium/screens/Myschedule.dart';


class Schedule extends StatefulWidget {
  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  var color4 =  Color(0xFF0050F5);
  var color1 =  Color(0xFFD50000);
  var color5 =  Color(0xFFF4592F);
  var color2 =  Color(0xFFFDDED5);
  Color final_color;
  String URL1;
  List check =[];
  @override
  void initState() {

    getshopdata();

    super.initState();
  }
  getshopdata(){
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
                if(result["Added"]=="True"){
                  check.add(result["StoreName"]);
                }


              });
            });
          });
        }

      });
    });
  }
  getshopdata1(){
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
              if(result["Added"]=="True"){
                check.add(result["StoreName"]);
              }
            });
          });
        }

      });
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40,),
            Text("My Schedule",style: TextStyle(fontWeight: FontWeight.bold,color: color4,fontSize: 34),),
            StreamBuilder(
                stream:FirebaseFirestore.instance.collection("Vendors").doc("SRMT").collection("SRMT").snapshots(),
                builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
                  if(snapshot.data.docs[0]["Added"]== "True"){
                    check.add(snapshot.data.docs[0]["StoreName"]);
                  }
                  if(snapshot.data.docs[1]["Added"]== "True"){
                    check.add(snapshot.data.docs[1]["StoreName"]);
                  }
                  if(snapshot.data.docs[2]["Added"]== "True"){
                    check.add(snapshot.data.docs[2]["StoreName"]);
                  }
                  print("No:of Shops = ${snapshot.data.docs.length}");
                  if (snapshot.data.docs.isEmpty || snapshot.hasError || snapshot.hasData==false) {
                    print("HELLLLO");
                    print(snapshot.hasError);
                    print(snapshot.hasData);
                    return Center(child: Text("No such shop found",
                      style: TextStyle(fontStyle: FontStyle.italic,
                          fontSize: 15),));
                  }
                  else if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                    );
                  }
                  else if (snapshot.hasData && snapshot.data != null) {

                    if(check.length!=0){
                       return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot user = snapshot.data.docs[index];
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
                          if(user["Added"]=="True"){
                            print("THERE");
                          }



                          if(user["Added"]=="True"){
                            return  Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.height*0.25,
                                      child: Row(
                                        children: [
                                          Text("${user["Safest_time"]}"),
                                          SizedBox(width: 15,),
                                          Text(user["StoreName"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 25,
                                      width: 25,
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))
                                      ),
                                    ),


                                  ],
                                ),
                                SizedBox(height: 15,)
                              ],
                            );
                          }
                          else if(user["Added"]=="false" ){
                            return SizedBox(height:0,width:0);
                          }
                          else{
                            return Text("Oops, dont have a schedule yet? Lets build you a custom itenary tailored especially for you. To get started search for the places you would like to visit today.",style: TextStyle(color: Colors.black),);
                          }




                        },


                      );
                    }
                    else{
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                            Text("Oops, dont have a schedule yet? Lets build you a custom itenary tailored especially for you. To get started search for the places you would like to visit today.",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),),
                          ],
                        ),
                      );
                    }

                  }
                  else {
                    return Center(
                      child: Text('Something is wrong'),
                    );
                  }
                }
            ),
            SizedBox(height:MediaQuery.of(context).size.height*0.25 ,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset("images/image 89.png"),
              ],
            ),
            SizedBox(height:MediaQuery.of(context).size.height*0.015 ,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.height*0.15,
                  height: 3,
                  color: color5,
                ),
                SizedBox(width: MediaQuery.of(context).size.height*0.02,),
                Text("OR",style: TextStyle(color: color5,fontSize: 30),),
                SizedBox(width: MediaQuery.of(context).size.height*0.02,),
                Container(
                  width: MediaQuery.of(context).size.height*0.15,
                  height: 3,
                  color: color5,
                ),
              ],
            ),
            SizedBox(height:MediaQuery.of(context).size.height*0.015 ,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.height*0.35,
                  height: MediaQuery.of(context).size.height*0.05,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: color2,
                        shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(12.0),
                      ),),
                      onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));

                      },
                      child: Text("Search for a shop near you",style:TextStyle(color: Colors.white,fontSize: 20))),
                ),
              ],
            )


          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
