import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../LandingPage.dart';

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _auth = FirebaseAuth.instance;
  var color = Color(0xff0050F5);
  var color1 =  Color(0xFFD50000);
  var color2 =  Color(0xFFFDDED5);
  var color3 =  Color(0xFFF4592F);
  var color4 =  Color(0xFF0050F5);
  var color5 =  Color(0xFFF4592F);

  String URL1;
  Color final_color;
  int user_current_strength=0;
  String user_shopname="";
  String user_Instruction1="";
  String user_Instruction2="";
  List user_data=[];

  int user_total_strength =0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verify1();
  }
  verify1()async{
    await FirebaseFirestore.instance.collection("users").doc(_auth.currentUser.uid).get().then((user1) {
      if(user1["Type"]=="Admin"){
        FirebaseFirestore.instance.collection("Vendors").get().then((querySnapshot) {
          querySnapshot.docs.forEach((result) {
            FirebaseFirestore.instance
                .collection("Vendors")
                .doc("SRMT")
                .collection("SRMT")
                .get()
                .then((querySnapshot) {
              querySnapshot.docs.forEach((result) {
                if(result["CreatedBY"] == _auth.currentUser.uid){
                  print("PRESENT");
                  print(result["StoreName"]);
                  setState(() {
                    user_current_strength=result["Current_strength"];
                    print(user_current_strength);
                    user_shopname=result["StoreName"];
                    user_total_strength=result["Total_strength"];
                    user_Instruction1=result["Instruction1"];
                    user_Instruction2=result["Instruction2"];
                    user_data=result["Timings"];
                  });



                }

              });
            });
          });
        });
      }


    });
  }
  signout()async{
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, LandingPage.id);
  }


  @override
  Widget build(BuildContext context) {
    if (user_current_strength <= user_current_strength * 0.25) {
      final_color = Colors.lightGreenAccent;
    }
    else if (user_total_strength * 0.25 <
        user_current_strength &&
        user_current_strength <=
            user_total_strength * 0.75) {
      final_color = Colors.orange;
    }
    else if (user_total_strength * 0.75 <
        user_current_strength &&
        user_current_strength <=
            user_total_strength) {
      final_color = color1;
    }
    if(user_shopname=="KFC")
      URL1 ="images/kfc.png";
    else if(user_shopname=="Nike")
      URL1 ="images/nike1.png";
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.05,),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Text(user_shopname, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45),),
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
                            "${user_current_strength}/${user_total_strength}",style: TextStyle(fontSize: 15),)
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.025,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Track",style: TextStyle(fontWeight: FontWeight.bold,color: color3,fontSize: 25),),
                      SizedBox(height: MediaQuery.of(context).size.height*0.015,),
                      Container(
                        height: MediaQuery.of(context).size.height*0.11,
                        width: MediaQuery.of(context).size.height*0.2,
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
                              Text("${user_shopname}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),),
                              SizedBox(height: 6,),
                              Row(
                                children: [
                                  Text("Walk-ins:",style: TextStyle(fontSize: 16,color: Colors.white),),
                                  SizedBox(width: MediaQuery.of(context).size.height*0.01,),
                                  Text("${user_current_strength}/${user_total_strength}",style: TextStyle(fontWeight: FontWeight.bold,fontSize:15,color: color5),)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: MediaQuery.of(context).size.height*0.015,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("",style: TextStyle(fontWeight: FontWeight.bold,color: color3,fontSize: 25),),
                      SizedBox(height: MediaQuery.of(context).size.height*0.015,),
                      Container(
                        height: MediaQuery.of(context).size.height*0.11,
                        width: MediaQuery.of(context).size.height*0.2,
                        decoration: BoxDecoration(
                            color: color2,
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child:Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Requirements :",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.white),),
                              SizedBox(height: MediaQuery.of(context).size.height*0.005,),
                              Text("-${user_Instruction1}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.white),),
                              SizedBox(height: MediaQuery.of(context).size.height*0.005),
                              Text("- Aarogya setu",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.white),),

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.075,),
              Text("Our timings:",style: TextStyle(fontWeight: FontWeight.bold,color: color4,fontSize: 25),),
              SizedBox(height: 15,),
              Center(
                  child: Container(
                      height: 280,
                      child: SfCartesianChart(
                          backgroundColor: Colors.white,
                          primaryXAxis: CategoryAxis(),
                          // Enable legend
                          //legend: Legend(isVisible: true),
                          // Enable tooltip
                          tooltipBehavior: TooltipBehavior(
                              header: "Crowd",
                              enable: true
                          ),
                          series: <LineSeries<SalesData, String>>[
                            LineSeries<SalesData, String>(
                              color: color5,
                              width:3.5,
                              dataSource:  <SalesData>[
                                //SalesData('${user_data[0]}', 35),
                                SalesData("10:30AM", 45),
                                SalesData("11:30AM", 55),
                                SalesData("12:30PM", 75),
                                SalesData("1:30PM", 15),
                                SalesData("2:30PM", 95),
                                SalesData("3:30PM", 105),
                                SalesData("4:30PM", 125),
                                SalesData("5:30PM", 25),
                                //SalesData('${user_data[1]}', 130),

                              ],
                              xValueMapper: (SalesData sales, _) => sales.year,
                              yValueMapper: (SalesData sales, _) => sales.sales,

                              // Enable data label
                              //dataLabelSettings: DataLabelSettings(isVisible: true)
                            )
                          ]
                      )
                  )
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 35,
                    width: 125,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: color5,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),// background
                        ),

                        onPressed: (){
                      signout();
                    },
                        child: Text("Logout",style: TextStyle(color: Colors.white,fontSize: 18),)),
                  ),
                ],
              )



            ],
          ),
        ),
      ),
    );
  }
}
