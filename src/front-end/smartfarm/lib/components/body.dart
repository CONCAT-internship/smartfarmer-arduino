import 'package:flutter/material.dart';
import 'package:smartfarm/constants/smartfarmer_constants.dart';
import 'header.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          HeaderWithGraph(size: size),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 30.0),
            child: Stack(
              children: [
                Text(
                  '스마트팜 실시간 정보',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.7),
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 7,
                    color: smartfarmer_primarycolor.withOpacity(0.2),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 35.0, bottom: 25.0),
            child: Container(
              height: 150.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  FarmInfo_Card(
                    title: '온도',
                    value: 30.0,
                    color: Colors.orange,
                  ),
                  FarmInfo_Card(
                    title: '습도',
                    value: 40.0,
                    color: Colors.pinkAccent,
                  ),
                  FarmInfo_Card(
                    title: '내수',
                    value: 80.0,
                    color: Colors.blue,
                  ),
                  FarmInfo_Card(
                    title: '내수',
                    value: 80.0,
                    color: Colors.purple,
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

class FarmInfo_Card extends StatelessWidget {
  final String title;
  final double value;
  final Color color;

  FarmInfo_Card({this.title, this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 15),
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 30,
              ),
              Text('$value',
                  style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
