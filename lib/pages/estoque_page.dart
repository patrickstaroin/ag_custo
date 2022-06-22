import 'package:ag_custo/pages/add_custo_page.dart';
import 'package:ag_custo/pages/mostra_custo_page.dart';
import 'package:ag_custo/repositories/carro_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/carro.dart';
import '../repositories/sem_fotos_repository.dart';
import '../services/auth_service.dart';
import 'fotos_page.dart';

class EstoquePage extends StatefulWidget {
  const EstoquePage({Key? key}) : super(key: key);

  @override
  State<EstoquePage> createState() => _EstoquePageState();
}

class _EstoquePageState extends State<EstoquePage> {
  late CarroRepository carroRepo;
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  late List<Carro> tabela;
  late SemFotosRepository semFotos;

  @override
  void initState() {
    super.initState();
  }

  addCusto(Carro carro) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddCustoPage(carro: carro),
      ),
    );
  }

  mostraCusto(Carro carro) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MostraCustoPage(carro: carro),
      ),
    );
  }

  mostraFotos(Carro carro) {
    carroRepo.buscaFotos(carro);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FotosPage(carro: carro),
            fullscreenDialog: true));
  }

  @override
  Widget build(BuildContext context) {
    semFotos = context.watch<SemFotosRepository>();
    carroRepo = context.watch<CarroRepository>();
    tabela = carroRepo.tabela;
    semFotos.getSemFotos(tabela);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan.shade700,
        title: const Text(
          'AG Custo',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => carroRepo.ordena(),
            icon: const Icon(Icons.swap_vert),
            color: Colors.white,
          ),
          IconButton(
            onPressed: () => context.read<AuthService>().logout(),
            icon: const Icon(Icons.logout),
            color: Colors.white,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => carroRepo.setupDadosTableCarro(),
        child: AnimatedBuilder(
          animation: carroRepo,
          builder: (context, child) {
            return (tabela.isEmpty)
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    itemCount: tabela.length,
                    itemBuilder: (context, int carro) => ListTile(
                      leading: Image.network(tabela[carro].foto, width: 90),
                      title: Text(
                        tabela[carro].marca + ' ' + tabela[carro].modelo,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(tabela[carro].placa +
                          '     ' +
                          tabela[carro].anofab.toString() +
                          '/' +
                          tabela[carro].anomod.toString() +
                          '     ' +
                          real.format(tabela[carro].valor)),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(child: Text('Novo custo'), value: 0),
                          PopupMenuItem(child: Text('Ver custos'), value: 1),
                          PopupMenuItem(child: Text('Ver fotos'), value: 2),
                        ],
                        onSelected: (result) {
                          if (result == 0) {
                            addCusto(tabela[carro]);
                          }
                          if (result == 1) {
                            mostraCusto(tabela[carro]);
                          }
                          if (result == 2) {
                            mostraFotos(tabela[carro]);
                          }
                        },
                      ),
                      onTap: () => mostraCusto(tabela[carro]),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    separatorBuilder: (_, __) => const Divider(),
                  );
          },
        ),
      ),
    );
  }
}
