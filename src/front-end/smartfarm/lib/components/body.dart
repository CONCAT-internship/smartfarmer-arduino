import 'package:flutter/material.dart';
import 'package:smartfarm/constants/smartfarmer_color.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: size.height * 0.71,
            child: Stack(
              children: <Widget>[
                Container(
                  height: size.height * 0.3,
                  decoration: BoxDecoration(
                    color: smartfarmer_primarycolor,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(36),
                      bottomLeft: Radius.circular(36),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.06,
                      vertical: size.height * 0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '김태훈님',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            '당신의 농장은 제껍니다',
                            style:
                            TextStyle(color: Colors.white, fontSize: 14.0),
                          ),
                        ],
                      ), //사용자 이름 출력


                      Row(
                        children: [
                          Material(
                            elevation: 0,
                            borderRadius: BorderRadius.circular(100.0),
                            color: Colors.redAccent,
                            child: MaterialButton(
                              onPressed: () {},
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 30.0),
                              child: Text(
                                "밸브",
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Material(
                            elevation: 0,
                            borderRadius: BorderRadius.circular(100.0),
                            color: Colors.redAccent,
                            child: MaterialButton(
                              onPressed: () {},
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 30.0),
                              child: Text(
                                "FAN",
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ), //밸브, 팬 on/off Btn
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 25),
                    height: 370,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0.0, 3.0),
                          blurRadius: 15.0,
                          color: smartfarmer_primarycolor.withOpacity(0.23),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 30.0),
            child: Text(
              '스마트팜 실시간 정보',
              style: TextStyle(
                color: Colors.black.withOpacity(0.7),
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 35.0, bottom: 25.0),
            child: Container(
              height: 150.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[],
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
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        ),
      ),
    );
  }
}
