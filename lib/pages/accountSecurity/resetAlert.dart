import 'package:flutter/material.dart';
import 'package:nsb/pages/accountSecurity/resetPassword.dart';

class ResetAlert extends StatefulWidget {
  @override
  _ResetAlertState createState() => _ResetAlertState();
}

class _ResetAlertState extends State<ResetAlert> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(40, 103, 178, 1),
        centerTitle: true,
        title: Text("Reset Password"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 200.0, 0.0, 0.0),
              child: Center(
                child: Text(
                  "Are you sure to reset your password ? \n \nOne-Time Password(OTP) will be sent to your phone number.",
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w300,
                      fontSize: 22.0),
                ),
              ),
            )),
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
                child: RaisedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResetPassword()));
                  },
                  color: Color.fromRGBO(40, 103, 178, 1),
                  textColor: Colors.white,
                  child: Container(
                    width: 200.0,
                    height: 43.0,
                    child: Center(
                        child: Text('Reset',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ))),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
