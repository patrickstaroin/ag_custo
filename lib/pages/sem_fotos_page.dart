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

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
    );
  }
}
