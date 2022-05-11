import 'package:ag_custo/repositories/sem_fotos_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/carro.dart';
import '../repositories/carro_repository.dart';

class SemFotosPage extends StatefulWidget {
  SemFotosPage({Key? key}) : super(key: key);

  @override
  State<SemFotosPage> createState() => _SemFotosPageState();
}

class _SemFotosPageState extends State<SemFotosPage> {
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  late CarroRepository carroRepo;
  late final _formAddCarro = GlobalKey<FormState>();
  final _novoCarro = TextEditingController();
  String _addPlaca = '';
  late SemFotosRepository semFotos;

  void initState() {
    super.initState();
    carroRepo = CarroRepository();
  }

  @override
  Widget build(BuildContext context) {
    semFotos = Provider.of<SemFotosRepository>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan.shade700,
        title: const Text(
          'Veículos sem fotos',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Consumer<SemFotosRepository>(
        builder: (context, semFotos, child) {
          return semFotos.lista.isEmpty
              ? ListTile(
                  leading: Icon(Icons.photo_camera_back),
                  title: Text('Não há veículos sem fotos!'))
              : ListView.separated(
                  itemCount: semFotos.lista.length,
                  itemBuilder: (context, int carro) => ListTile(
                    leading: Image.asset(semFotos.lista[carro].foto),
                    title: Text(
                      semFotos.lista[carro].marca +
                          ' ' +
                          semFotos.lista[carro].modelo,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(semFotos.lista[carro].placa +
                        '     ' +
                        semFotos.lista[carro].anofab.toString() +
                        '/' +
                        semFotos.lista[carro].anomod.toString()),
                    trailing: Text(real.format(semFotos.lista[carro].valor)),
                    // onTap: () => addCusto(tabela[carro]),
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
