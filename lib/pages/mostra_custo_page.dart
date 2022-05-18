import 'package:ag_custo/models/custo.dart';
import 'package:ag_custo/repositories/custo_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/carro.dart';
import '../services/auth_service.dart';
import 'add_custo_page.dart';

class MostraCustoPage extends StatefulWidget {
  Carro carro;
  MostraCustoPage({Key? key, required this.carro}) : super(key: key);

  @override
  State<MostraCustoPage> createState() => _MostraCustoPageState();
}

class _MostraCustoPageState extends State<MostraCustoPage> {
  late CustoRepository custoRepo;
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  late List<Custo> custosList;

  addCusto(Carro carro) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddCustoPage(carro: carro),
      ),
    ).then((value) => Navigator.pop(context));
  }

  deleteCusto(Custo custo) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text('Você tem certeza que deseja remover o custo ' +
              custo.descricao +
              '?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancelar',
              ),
            ),
            TextButton(
              onPressed: () {
                custoRepo.removeCusto(widget.carro, custo);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Custo removido com sucesso!'),
                  ),
                );
              },
              child: const Text(
                'Remover',
              ),
            ),
          ]),
    );
  }

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
        leading: BackButton(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.cyan.shade700,
        title: const Text(
          'CUSTOS',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding:
            EdgeInsets.only(top: 24.0, bottom: 48.0, left: 24.0, right: 24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: Image.asset(widget.carro.foto),
                      width: 200,
                    ),
                    Container(width: 20),
                    Flexible(
                      child: Text(
                        'MARCA: ' +
                            widget.carro.marca +
                            '\nMODELO: ' +
                            widget.carro.modelo +
                            '\nANO: ' +
                            widget.carro.anofab.toString() +
                            '/' +
                            widget.carro.anomod.toString() +
                            '\nPLACA: ' +
                            widget.carro.placa +
                            '\nVALOR: ' +
                            real.format(widget.carro.valor),
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontSize: 18,
                          wordSpacing: 1,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade800,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.green.shade200,
                child: AnimatedBuilder(
                    animation: custoRepo,
                    builder: (context, child) {
                      if (custoRepo.custoTotal == 0) {
                        return const ListTile(
                          leading: Icon(Icons.monetization_on),
                          title: Text('CUSTO TOTAL ',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 3.5,
                              )),
                          trailing: Text('0,00',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold)),
                        );
                      } else {
                        return ListTile(
                          leading: Icon(Icons.monetization_on),
                          title: const Text('CUSTO TOTAL ',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 3.5,
                              )),
                          trailing: Text(real.format(custoRepo.custoTotal),
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold)),
                        );
                      }
                    }),
              ),
              AnimatedBuilder(
                animation: custoRepo,
                builder: (context, child) {
                  final tabela = custoRepo.custoList;
                  return (tabela.isEmpty)
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: tabela.length,
                          itemBuilder: (context, int custo) => ListTile(
                            leading: IconButton(
                                onPressed: () => deleteCusto(tabela[custo]),
                                icon: Icon(Icons.delete)),
                            title: Text(
                              tabela[custo].descricao,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              tabela[custo].dataPag +
                                  '     ' +
                                  tabela[custo].formaPag,
                            ),
                            trailing: Text(real.format(tabela[custo].valor)),
                            //onTap: () => editarCusto(tabela[custo]),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          separatorBuilder: (_, __) => const Divider(),
                        );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => addCusto(widget.carro),
        backgroundColor: Colors.cyan.shade700,
        label: const Text(
          'NOVO CUSTO',
          style: TextStyle(
            fontSize: 16,
            letterSpacing: 1,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
