import 'package:ag_custo/pages/home_page.dart';
import 'package:flutter/material.dart';

import 'pages/estoque_page.dart';

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
      home: HomePage(),
    );
  }
}
