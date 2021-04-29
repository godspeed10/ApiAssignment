import 'package:assign_project/services/api_service.dart';
import 'package:assign_project/ui/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => ApiService(),
      child: MaterialApp(title: 'Material App', home: SignIn()),
    );
  }
}
