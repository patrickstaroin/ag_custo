import 'package:ag_custo/repositories/custo_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/carro.dart';
import '../services/auth_service.dart';

class MostraCustoPage extends StatefulWidget {
  Carro carro;
  MostraCustoPage({Key? key, required this.carro}) : super(key: key);

  @override
  State<MostraCustoPage> createState() => _MostraCustoPageState();
}

class _MostraCustoPageState extends State<MostraCustoPage> {
  late CustoRepository custoRepo;
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');

  //late SemFotosRepository semFotos;

  @override
  void initState() {
    super.initState();
    custoRepo = CustoRepository(auth: context.read<AuthService>());
    custoRepo.getCusto(widget.carro);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan.shade700,
        title: const Text(
          'Custos',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: custoRepo,
        builder: (context, child) {
          final tabela = custoRepo.custoList;
          return (tabela.isEmpty)
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                  itemCount: tabela.length,
                  itemBuilder: (context, int custo) => ListTile(
                    title: Text(
                      tabela[custo].descricao,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      tabela[custo].dataPag + '     ' + tabela[custo].formaPag,
                    ),
                    trailing: Text(real.format(tabela[custo].valor)),
                    //onTap: () => editarCusto(tabela[custo]),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  separatorBuilder: (_, __) => const Divider(),
                );
        },
      ),
    );
  }
}
