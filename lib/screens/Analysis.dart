import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}

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
  var color5 =  Color(0xFFF4592F);
  bool valuefirst = false;
  bool valuesecond = false;







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
      body: SingleChildScrollView(
        child: Padding(
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
                                  SalesData('${user["Timings"][0]}', 35),
                                  SalesData("10:30AM", 45),
                                  SalesData("11:30AM", 55),
                                  SalesData("12:30PM", 75),
                                  SalesData("1:30PM", 15),
                                  SalesData("2:30PM", 95),
                                  SalesData("3:30PM", 105),
                                  SalesData("4:30PM", 125),
                                  SalesData("5:30PM", 25),
                                  SalesData('${user["Timings"][1]}', 130),

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
              SizedBox(height: 15,),
              Text("Best time to visit:",style: TextStyle(fontWeight: FontWeight.bold,color: color3,fontSize: 25),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("keeping your safety in mind and to ensure their is no compromise in your experience we have estimated that the ideal time for you to shop with us is 11:00 AM"),
              ),
              Text("Would you like to visit us today?",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 25),),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.height*0.35,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Get notfied for the timing that suits you the best and create a custom schedule with us'),
                        ),
                      ),
                      Transform.scale(
                        scale: 1.25,
                        child: Checkbox(

                          checkColor: Colors.black,
                          activeColor: color5,
                          value: this.valuefirst,
                          onChanged: (bool value) {
                            setState(() {
                              this.valuefirst = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Text("item is removed from schedule",style: TextStyle(color: color5,fontSize: 10),)
                ],
              ),


            ],
          ),
        ),
      ),
    );



  }
}
