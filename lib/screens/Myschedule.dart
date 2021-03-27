import 'package:flutter/cupertino.dart';

class Myschedule extends ChangeNotifier{
  List _tasks =[];
  List get tasks => _tasks;


  void add(String shopname){
    _tasks.add(shopname);
    notifyListeners();
  }
  void delete(String shopname){
    _tasks.remove(shopname);
    notifyListeners();

  }
}