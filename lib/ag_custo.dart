import 'package:flutter/material.dart';

import 'widgets/auth_check.dart';

class AgCusto extends StatelessWidget {
  const AgCusto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AG Custo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: AuthCheck(),
    );
  }
}
