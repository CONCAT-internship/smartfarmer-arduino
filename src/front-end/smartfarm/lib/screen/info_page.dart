import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartfarm/components/body.dart';
import 'package:smartfarm/constants/smartfarmer_constants.dart';

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
        icon: SvgPicture.asset("assets/icons/menu.svg"),
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
