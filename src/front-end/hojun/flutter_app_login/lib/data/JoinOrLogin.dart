import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class JoinOrLogin extends ChangeNotifier{
  bool _isJoin =false;

  bool get isJoin=>_isJoin; //get method 같은것

  void toggle(){
    _isJoin=!_isJoin;
    notifyListeners();
  }
}