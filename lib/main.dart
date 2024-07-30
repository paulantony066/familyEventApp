import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  DateTime _focusedDay = DateTime.now();
  late DateTime _selectedDate ;
  late final ValueNotifier<List<Event>> _selectedEvent;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedDate=_focusedDay;
    _selectedEvent = ValueNotifier(_getEventsForDay(_selectedDate));
  }
  Map<DateTime, List<Event>> events={};

  List<Event> _getEventsForDay(DateTime day){
    //get events from selected date
      return events[day]?? [];
  }
  TextEditingController eventController = TextEditingController();
  void _onDaySelected(DateTime selectedDay,DateTime focusedDay){
    if(!isSameDay(_selectedDate, selectedDay)) {
      setState(() {
        _selectedDate=selectedDay;
        _focusedDay = focusedDay;
        _selectedEvent.value=_getEventsForDay(selectedDay);
      });
    }
  }

  CalendarFormat _calendarFormat = CalendarFormat.month;

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
                        if(eventController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.grey[300],
                                content: Text("Field is empty",
                                  style: TextStyle(color: Colors.black,
                                      fontWeight: FontWeight.bold),),
                                duration: Duration(seconds: 2),
                              ));
                        }

                          //adds event to list map
                          events.addAll({_selectedDate!: [Event(eventController.text)]});
                          Navigator.of(context).pop();
                          _selectedEvent.value = _getEventsForDay(_selectedDate!);

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
        body: Column(
          children: [
          Text("selected day : "+_focusedDay.toString().split(" ")[0]),
              TableCalendar(
              headerStyle: HeaderStyle( titleCentered: true,),
              availableGestures: AvailableGestures.all,
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              firstDay: DateTime.utc(2000,01,01),
              lastDay: DateTime.utc(2050,12,12),
              onDaySelected: _onDaySelected,
              selectedDayPredicate: (day)=>isSameDay(_selectedDate, day),
              onFormatChanged: (format){
                if(_calendarFormat!=format)
                {
                  setState(() {
                    _calendarFormat=format;
                  });
                }
              },
              onPageChanged: (focusedDay){
                _focusedDay=focusedDay;
              },
            ),


          Expanded(
            child: ValueListenableBuilder<List<Event>>(
                valueListenable: _selectedEvent, builder: (context, value,_){
              return ListView.builder(itemCount: value.length,itemBuilder: (context,index){
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                  decoration: BoxDecoration(border: Border.all(),borderRadius: BorderRadius.circular(12.00)),
                  child: ListTile(
                    onTap: ()=>print(""),
                    title: Text('${value[index]}'),) ,
                );
              });
            }),
          )



          ],
        ),
      );
  }


}

