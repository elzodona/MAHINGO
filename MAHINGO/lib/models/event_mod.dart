import 'package:flutter/material.dart';

class EventModel extends ChangeNotifier {
  List<dynamic> _events = [];

  List<dynamic> get events => _events;

  void setEvents(List<dynamic> events) {
    _events = events;
    notifyListeners();
  }
  
}
