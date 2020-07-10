import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_login/data/JoinOrLogin.dart';
import 'package:flutter_app_login/helper/login_background.dart';
import 'package:flutter_app_login/screens/forget_pw.dart';
import 'package:flutter_app_login/screens/main_page.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatelessWidget {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size; //모바일화면의 사이즈를 가져온다.
    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        CustomPaint(
          size: size,
          painter:
              LoginBackground(isJoin: Provider.of<JoinOrLogin>(context).isJoin),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            _logoimage,
            Stack(
              children: <Widget>[
                _inputForm(size),
                _authButton(size),

//                    Container(width: 100,height: 50, color: Colors.black,),
              ],
            ),
            Container(
              height: size.height * 0.1,
            ),
            Consumer<JoinOrLogin>(
              builder: (BuildContext context, JoinOrLogin value,
                      Widget child) =>
                  GestureDetector(
                      onTap: () {
                        value.toggle();
                      },
                      child: Text(value.isJoin ? '이미계정있으면 로그인해!' : '계정없으면 만들어!',
                          style: TextStyle(
                              color: value.isJoin ? Colors.red : Colors.blue))),
            ),
            Container(
              height: size.height * 0.05,
            )
          ],
        )
      ],
    ));
  }

  Widget _inputForm(Size size) {
    return Padding(
      padding: EdgeInsets.all(size.width * 0.05),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 12.0, right: 12, top: 12, bottom: 32),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      icon: Icon(Icons.account_circle), labelText: 'Email'),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "제대로 된 이메일 써요";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  obscureText: true, //**표시
                  controller: _passwordController,
                  decoration: InputDecoration(
                      icon: Icon(Icons.vpn_key), labelText: 'Password'),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "제대로된 비밀번호 써요";
                    }
                    return null;
                  },
                ),
                Container(
                  height: 8,
                ),
                Consumer<JoinOrLogin>(
                  builder: (context, value, child) => Opacity(
                      opacity: value.isJoin ? 0 : 1,
                      child: GestureDetector(
                          onTap: value.isJoin
                              ? null
                              : () {
                                  goToForgetPw(context);
                                  var  aaa = {'ASD': 'ffff'};
                                  aaa['ASD']
                                  AAA?.ASD
                                },
                          child: Text('잊어버림 비번을'))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  goToForgetPw(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ForgetPw()));
  }

  Widget _authButton(Size size) {
    return Positioned(
      left: size.width * 0.15,
      right: size.width * 0.15,
      bottom: 0,
      child: SizedBox(
        height: 50,
        child: Consumer<JoinOrLogin>(
          builder: (context, joinOrLogin, child) => RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            onPressed: () {
              if (_formkey.currentState.validate()) {
                joinOrLogin.isJoin ? _register(context) : _login(context);
              }
            },
            child: Text(joinOrLogin.isJoin ? 'Join' : 'Login',
                style: TextStyle(fontSize: 20, color: Colors.white)),
            color: joinOrLogin.isJoin ? Colors.red : Colors.blue,
          ),
        ),
      ),
    );
  }

  void _register(BuildContext context) async {
    final AuthResult result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
    final FirebaseUser user = result.user;

    if (user == null) {
      final snackBar = SnackBar(
        content: Text('다시 시도해보세요'),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
//    Navigator.push(context, MaterialPageRoute(builder:(context)=>MainPage(email: user.email,)));
  }

  void _login(BuildContext context) async {
    final AuthResult result = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
    final FirebaseUser user = result.user;

    if (user == null) {
      final snackBar = SnackBar(
        content: Text('다시 시도해보세요'),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
//    Navigator.push(context, MaterialPageRoute(builder:(context)=>MainPage(email: user.email,)));
  }

  Widget get _logoimage {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 40, left: 24, right: 24),
        child: FittedBox(
          fit: BoxFit.contain,
          child: CircleAvatar(backgroundImage: AssetImage("assets/7pv.gif")),
        ),
      ),
    );
  }
}
