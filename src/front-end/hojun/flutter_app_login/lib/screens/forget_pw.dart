import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPw extends StatefulWidget {
  @override
  _ForgetPwState createState() => _ForgetPwState();
}

class _ForgetPwState extends State<ForgetPw> {

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('비번 잊어버'),
      ),
      body: Form(
        key: _formkey,
        child: Column(

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
            FlatButton(onPressed: ()async{
             await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);

               final snackBar=SnackBar(content: Text('이메일확인해보세요 비번초기화를 위하여'),);
              Scaffold.of(_formkey.currentContext).showSnackBar(snackBar);

            }, child: Text('비번 초기화'))
          ],
        ),
      ),
    );
  }
}
