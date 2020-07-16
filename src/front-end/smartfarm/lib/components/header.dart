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
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: 350.0,
              decoration: BoxDecoration(color: smartfarmer_primarycolor),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: smartfarmer_padding, vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '김태훈님',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold),
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
                ),

                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/ogu.png'),
                  radius: 20.0,
                  backgroundColor: Colors.blue[600],
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
}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, 390.0 - 200);
    path.quadraticBezierTo(size.width / 2, 280, size.width, 390.0 - 200);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
