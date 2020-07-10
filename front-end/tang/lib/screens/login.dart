import 'package:concatsmartfarmproj/data/join_or_login.dart';
import 'package:concatsmartfarmproj/screens/forget_pw.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              color: Colors.white,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                //_logoImage,
                Stack(
                  children: <Widget>[
                    _inputForm(size),
                    _authButton(size),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.1,
                ),
                Consumer<JoinOrLogin>(
                  builder: (context, joinOrLogin, child) => GestureDetector(
                      onTap: () {
                        joinOrLogin.toggle();
                      },
                      child: Text(
                        joinOrLogin.isJoin
                            ? "계정이 있으신가요? 로그인해주세요."
                            : "계정이 없으신가요? 가입해주세요.",
                        style: TextStyle(
                            color:
                                joinOrLogin.isJoin ? Colors.red : Colors.blue),
                      )),
                ),

                SizedBox(
                  height: size.height * 0.05,
                ),
              ],
            ),
          ],
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
      final snackbar = SnackBar(
        content: Text('Please try again later'),
      );
      Scaffold.of(context).showSnackBar(snackbar);
    }
  }

  void _login(BuildContext context) async {
    final AuthResult result = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
    final FirebaseUser user = result.user;

    if (user == null) {
      final snackbar = SnackBar(
        content: Text('Please try again later'),
      );
      Scaffold.of(context).showSnackBar(snackbar);
    }
  }

  Widget get _logoImage => Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 24, right: 24),
          child: FittedBox(
            fit: BoxFit.contain,
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/ogu.gif'),
              backgroundColor: Colors.blueAccent,
            ),
          ),
        ),
      );

  Widget _authButton(Size size) => Positioned(
        left: size.width * 0.15,
        right: size.width * 0.15,
        bottom: 0,
        child: SizedBox(
          height: 50,
          child: Consumer<JoinOrLogin>(
            builder: (context, joinOrLogin, child) => RaisedButton(
              child: Text(
                joinOrLogin.isJoin ? "Join" : "Login",
                style: TextStyle(fontSize: 15),
              ),
              color: joinOrLogin.isJoin ? Colors.red : Colors.blue,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  joinOrLogin.isJoin ? _register(context) : _login(context);
                }
              },
            ),
          ),
        ),
      );

  Widget _inputForm(Size size) => Padding(
        padding: EdgeInsets.all(size.width * 0.05),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 12.0, right: 12.0, top: 12.0, bottom: 32.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.account_circle), labelText: "Email"),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Please input correct Email.";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.vpn_key), labelText: "Password"),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Please input correct Password.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Consumer<JoinOrLogin>(
                    builder: (context, value, child) => Opacity(
                        opacity: value.isJoin ? 0 : 1,
                        child: GestureDetector(
                            onTap: value.isJoin ? null : (){goToForgetPw(context);},
                            child: Text("Forgot Password?"))),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  goToForgetPw(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPw()));
  }
}
