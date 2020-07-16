import 'package:flutter/material.dart';
import 'package:smartfarm/constants/smartfarmer_constants.dart';

import 'graph.dart';


class HeaderWithGraph extends StatelessWidget {
  const HeaderWithGraph({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.70,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              bottom: smartfarmer_padding + 45,
            ),
            height: size.height * 0.28,
            decoration: BoxDecoration(
              color: smartfarmer_primarycolor,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(36),
                bottomLeft: Radius.circular(36),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _userName(),

//                CircleAvatar(
//                  //backgroundImage: AssetImage('assets/ogu.png'),
//                  radius: 20.0,
//                  backgroundColor: Colors.blue[600],
//                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Color.fromRGBO(204, 255, 204, 1),
                  onPressed: () {},
                  child: Text(
                    "밸브",
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Color.fromRGBO(204, 255, 204, 1),
                  onPressed: () {},
                  child: Text(
                    "FAN",
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                ),
              ],
            ),
          ),
          _graphBox(),
        ],
      ),
    );
  }

  Padding _graphBox() {
    return Padding(
      padding: EdgeInsets.only(top: 120, right: 25.0, left: 25.0),
      child: Container(
        width: double.infinity,
        height: 370,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: Offset(0.0, 3.0),
                blurRadius: 15.0,
              ),
            ]),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(smartfarmer_padding),
              child: Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '30.0',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.7),
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                        ),
                      ),
                      Text(
                        '현재 온도',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Graph(),
          ],
        ),
      ),
    );
  }

  Column _userName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '김태훈님',
          style: TextStyle(
              color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 8.0,
        ),
        Text(
          '당신 농장은 제껍니다.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
          ),
        ),
      ],
    );
  }
}

