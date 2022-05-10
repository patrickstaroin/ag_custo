import 'package:ag_custo/pages/add_custo_page.dart';
import 'package:ag_custo/repositories/carro_repository.dart';
import 'package:ag_custo/repositories/sem_fotos_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/carro.dart';
import '../services/auth_service.dart';

class EstoquePage extends StatefulWidget {
  const EstoquePage({Key? key}) : super(key: key);

  @override
  State<EstoquePage> createState() => _EstoquePageState();
}

class _EstoquePageState extends State<EstoquePage> {
  late CarroRepository carroRepo;
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  late final _formAddCarro = GlobalKey<FormState>();
  final _novoCarro = TextEditingController();
  String _addPlaca = '';
  late SemFotosRepository semFotos;

  @override
  void initState() {
    super.initState();
    carroRepo = CarroRepository();
    carroRepo.ordena();
  }

  addCusto(Carro carro) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddCustoPage(carro: carro),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    semFotos = Provider.of<SemFotosRepository>(context);
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
      body: AnimatedBuilder(
        animation: carroRepo,
        builder: (context, child) {
          final tabela = CarroRepository.tabela;
          return (tabela.isEmpty)
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                  itemCount: tabela.length,
                  itemBuilder: (context, int carro) => ListTile(
                    leading: Image.asset(tabela[carro].foto),
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
                        tabela[carro].anomod.toString()),
                    trailing: Text(real.format(tabela[carro].valor)),
                    onTap: () => addCusto(tabela[carro]),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  separatorBuilder: (_, __) => const Divider(),
                );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
                title: Text('Adicionar novo veículo'),
                content: Form(
                  key: _formAddCarro,
                  child: TextFormField(
                    controller: _novoCarro,
                    style: const TextStyle(fontSize: 22),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Placa',
                      prefixIcon: Icon(Icons.abc),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Informe a placa';
                      }
                      _addPlaca = value;
                      return null;
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      _novoCarro.clear();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancelar',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_formAddCarro.currentState!.validate()) {
                        carroRepo.adicionaCarro(_addPlaca);
                        semFotos.attLista(CarroRepository.tabela);
                        _novoCarro.clear();
                        Navigator.pop(context);
                        setState(() {});

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Veículo adicionado com sucesso!'),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Ok',
                    ),
                  ),
                ]),
          );
        },
        backgroundColor: Colors.cyan.shade700,
        label: const Text(
          'NOVO CARRO',
          style: TextStyle(
            fontSize: 16,
            letterSpacing: 1,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        icon: const Icon(
          Icons.add_circle_outline_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}
