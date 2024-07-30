import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'events.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime today = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> events = {};
  late final ValueNotifier<List<Event>> _selectedEvent;
  TextEditingController eventController = TextEditingController();
  void _onDaySelected(DateTime day,DateTime focusedDay){
    setState(() {
      today = day;

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[200],
          title: Text("EVENTS",style: TextStyle(fontWeight: FontWeight.bold),),
          ),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          onPressed: (){
            //POPUP
            showDialog(context: context, builder: (context){
              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.00)),
                title: Center(
                    child: Text("ENTER EVENT NAME",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)),
                scrollable: true,
                content: Padding(padding: EdgeInsets.only(left: 8.00,top: 8.00,right: 8.00,bottom: 8.00),
                child: TextField(
                  decoration:  new InputDecoration(
                    hintText: 'Enter here'
                  ),
                  controller: eventController,
                ),
                ),
                actions: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200]
                      ),
                      onPressed: (){
                        //passing event and day into list map variable
                        events.addAll({_selectedDay!: [Event(eventController.text)]});
                        Navigator.of(context).pop();
                      },
                      child: Text("ADD EVENT",style: TextStyle(color: Colors.black),
                      ),
                      )
                ],
              );
            });
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.grey[200],
          ),
        body: content(),
      );
  }

  Widget content(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text("selected day : "+today.toString().split(" ")[0]),
          Container(
            child: TableCalendar(
                headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true,),
                availableGestures: AvailableGestures.all,
                selectedDayPredicate: (day)=>isSameDay(day, today),
                focusedDay: today,
                firstDay: DateTime.utc(2000,01,01),
                lastDay: DateTime.utc(2050,12,12),
                onDaySelected: _onDaySelected,),
          ),
        ],
      ),
    );
  }
}

