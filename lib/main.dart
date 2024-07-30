import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

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

