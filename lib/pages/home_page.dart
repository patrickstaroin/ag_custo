import 'package:ag_custo/pages/estoque_page.dart';
import 'package:ag_custo/pages/sem_fotos_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pagAtual = 0;
  late PageController pc;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: pagAtual);
  }

  setPaginaAtual(pagina) {
    setState(() {
      pagAtual = pagina;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pc,
        children: [
          EstoquePage(),
          SemFotosPage(),
        ],
        onPageChanged: setPaginaAtual,
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: pagAtual,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Estoque'),
            BottomNavigationBarItem(
                icon: Icon(Icons.photo_camera), label: 'Sem fotos'),
          ],
          onTap: (pagina) {
            pc.animateToPage(pagina,
                duration: const Duration(milliseconds: 400),
                curve: Curves.ease);
          }),
    );
  }
}
