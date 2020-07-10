import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPw extends StatefulWidget {
  @override
  _ForgetPwState createState() => _ForgetPwState();
}

class _ForgetPwState extends State<ForgetPw> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('비밀번호 찾기'),
      ),
      body: Form(
        key : _formKey,
        child: Column(
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
            FlatButton(
              onPressed: () async {
                await FirebaseAuth.instance.sendPasswordResetEmail(
                    email: _emailController.text);
                final snackbar = SnackBar(
                  content: Text('이메일을 확인해주세요.'),
                );
                Scaffold.of(_formKey.currentContext).showSnackBar(snackbar);
              },
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
