import 'package:flutter/material.dart';
import 'package:nsb/routes.dart' as router;
import 'package:nsb/constants/rout_path.dart' as routes;

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: router.generateRoute,
      initialRoute: routes.NewLoginPageRoute,
    );
  }
}

