import 'package:flutter/material.dart';

class Whychooseuswidget extends StatelessWidget {
  const Whychooseuswidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      color: Colors.blue.shade100,
      elevation: 2,
      child:Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Why choose Us?',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Icon(Icons.currency_rupee_sharp,size: 40,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('pay after service',style: TextStyle(fontSize: 10),),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.calendar_month_sharp,size: 40,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('pay after service',style: TextStyle(fontSize: 10)),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.security,size: 40,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Data Security',style: TextStyle(fontSize: 10)),
                      )
                    ],
                  ),

                ],
              ),
            )
          ],
        ),
      ) ,
    );
  }
}
