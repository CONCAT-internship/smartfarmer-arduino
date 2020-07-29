import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.black12,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Positioned(
            top: 50,
            left: 30,
            right: 30,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          FlatButton(
                            color: Colors.redAccent,
                            shape: CircleBorder(),
                            onPressed: (){},
                            child: Icon(Icons.send, color: Colors.white,),
                          ),
                          Text('ddd')
                        ],
                      ),
                      Column(
                        children: [
                          FlatButton(
                            color: Colors.redAccent,
                            shape: CircleBorder(),
                            onPressed: (){},
                            child: Icon(Icons.send, color: Colors.white,),
                          ),
                          Text('ddd')
                        ],
                      ),
                      Column(
                        children: [
                          FlatButton(
                            color: Colors.redAccent,
                            shape: CircleBorder(),
                            onPressed: (){},
                            child: Icon(Icons.send, color: Colors.white,),
                          ),
                          Text('ddd')
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          FlatButton(
                            color: Colors.redAccent,
                            shape: CircleBorder(),
                            onPressed: (){},
                            child: Icon(Icons.send, color: Colors.white,),
                          ),
                          Text('ddd')
                        ],
                      ),
                      Column(
                        children: [
                          FlatButton(
                            color: Colors.redAccent,
                            shape: CircleBorder(),
                            onPressed: (){},
                            child: Icon(Icons.send, color: Colors.white,),
                          ),
                          Text('ddd')
                        ],
                      ),
                      Column(
                        children: [
                          FlatButton(
                            color: Colors.redAccent,
                            shape: CircleBorder(),
                            onPressed: (){},
                            child: Icon(Icons.send, color: Colors.white,),
                          ),
                          Text('ddd')
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}