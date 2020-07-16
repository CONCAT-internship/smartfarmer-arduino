Padding(
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
padding: EdgeInsets.all(20.0),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: <Widget>[
Column(
children: <Widget>[
//                                  Material(
//                                    borderRadius: BorderRadius.circular(100.0),
//                                    color: Colors.purple.withOpacity(0.1),
//                                    child: IconButton(
//                                      padding: EdgeInsets.all(15.0),
//                                      icon: Icon(Icons.send),
//                                      color: Colors.purple,
//                                      iconSize: 30.0,
//                                      onPressed: () {},
//                                    ),
//                                  ),
],
)
],
),
)
],
),
),
)