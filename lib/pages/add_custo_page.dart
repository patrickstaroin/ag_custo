import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../models/carro.dart';

class AddCustoPage extends StatefulWidget {
  Carro carro;
  AddCustoPage({Key? key, required this.carro}) : super(key: key);

  @override
  State<AddCustoPage> createState() => _AddCustoPageState();
}

class _AddCustoPageState extends State<AddCustoPage> {
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  final _form = GlobalKey<FormState>();
  final _descricao = TextEditingController();
  final _valorCusto = TextEditingController();
  String _formaPagamento = '';
  DateTime _dataPagamento =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  adicionarCusto() {
    if (_form.currentState!.validate()) {
      //salvar custo
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Custo adicionado com sucesso!'),
        ),
      );
    }
  }

  void _selectDate() async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _dataPagamento,
      firstDate: DateTime(2015, 1),
      lastDate: DateTime(2050, 7),
      helpText: 'Selecione a data do pagamento',
    );
    if (newDate != null) {
      setState(() {
        _dataPagamento = newDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'ADICIONAR NOVO CUSTO',
          style: TextStyle(color: Colors.grey.shade900),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: SingleChildScrollView(
          reverse: true,
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
              Form(
                key: _form,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _descricao,
                      style: const TextStyle(fontSize: 22),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Descrição',
                        prefixIcon: Icon(Icons.abc),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Informe a descrição do custo';
                        }
                        return null;
                      },
                    ),
                    const Padding(padding: EdgeInsets.only(top: 24.0)),
                    TextFormField(
                      controller: _valorCusto,
                      style: const TextStyle(fontSize: 22),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Valor',
                        prefixIcon: Icon(Icons.monetization_on),
                        suffix: Text('reais', style: TextStyle(fontSize: 14)),
                      ),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'(^\d*\,?\d{0,2})'))
                      ],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Informe o valor';
                        } else if (double.parse(value.replaceAll(',', '.')) <=
                            0) {
                          return 'O valor precisa ser maior que R\$ 0,00';
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text(
                            'Forma de pagamento',
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            child: Text('Dinheiro',
                                style: TextStyle(fontSize: 22)),
                            value: 'Dinheiro',
                          ),
                          DropdownMenuItem(
                            child: Text('Cartão de crédito',
                                style: TextStyle(fontSize: 22)),
                            value: 'Cartão de crédito',
                          ),
                          DropdownMenuItem(
                            child: Text('Cartão de débito',
                                style: TextStyle(fontSize: 22)),
                            value: 'Cartão de débito',
                          ),
                          DropdownMenuItem(
                            child:
                                Text('Boleto', style: TextStyle(fontSize: 22)),
                            value: 'Boleto',
                          ),
                          DropdownMenuItem(
                            child: Text('TED/DOC/PIX',
                                style: TextStyle(fontSize: 22)),
                            value: 'TED/DOC/PIX',
                          ),
                          DropdownMenuItem(
                            child:
                                Text('Cheque', style: TextStyle(fontSize: 22)),
                            value: 'Cheque',
                          ),
                        ],
                        onChanged: (value) => _formaPagamento = value ?? '',
                        validator: (value) {
                          if (value == null) {
                            return 'Selecione a forma de pagamento';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 24.0),
                      child: TextFormField(
                        key: Key(_dataPagamento.toString()),
                        readOnly: true,
                        onTap: () {
                          setState(() {
                            _selectDate();
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text(
                            'Data do pagamento',
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                        initialValue: _dataPagamento.day.toString() +
                            '/' +
                            _dataPagamento.month.toString() +
                            '/' +
                            _dataPagamento.year.toString(),
                        style: const TextStyle(fontSize: 20),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Informe a data do pagamento';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.only(top: 24),
                child: ElevatedButton(
                  onPressed: adicionarCusto,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.check),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'ADICIONAR',
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
