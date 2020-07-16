import 'package:flutter/material.dart';
import 'package:smartfarm/components/body.dart';
import 'package:smartfarm/constants/smartfarmer_color.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor: smartfarmer_bgcolor,
      body: Body(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: smartfarmer_primarycolor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.menu),
        color: Colors.white,
        onPressed: () {},
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.notifications_none),
          color: Colors.white,
          onPressed: () {},
        )
      ],
    );
  }
}
