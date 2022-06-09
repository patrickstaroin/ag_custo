import 'dart:convert';

import 'package:ag_custo/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../databases/db_firestore.dart';
import '../models/carro.dart';
import 'package:http/http.dart' as http;

class CarroRepository extends ChangeNotifier {
  bool isSorted = false;
  List<Carro> _tabela = [];
  List<Carro> get tabela => _tabela;
  String _token = '';
  List _tabelaID = [];
  late FirebaseFirestore dbFirestore;
  late AuthService auth;
  List _tabelaIDnovos = [];

  CarroRepository({required this.auth}) {
    _setupCarrosTable();
    setupDadosTableCarro();
  }

  _startFirestore() {
    dbFirestore = DBFirestore.get();
  }

/* INICA BANCOS DE DADOS */
  _setupCarrosTable() async {
    await _startFirestore();
    final String table = '''
      CREATE TABLE IF NOT EXISTS carros (
        marca TEXT
        modelo TEXT
        anofab INTEGER
        anomod INTEGER
        placa TEXT
        valor TEXT
      );
    ''';
    //Database db = DB.instance.database;
    //await db.execute(table);
  }

/* RECUPERA TOKEN DO CLIENTE VIA API */
  _getClientToken() async {
    String uri = 'https://agintegracao.com/api/v1/clientes/login';

    final response = await http.post(Uri.parse(uri),
        headers: {"X-AutoGestor-Cliente": "1476"},
        body: json
            .encode({"login": "${auth.usuario!.email}", "senha": "palio2014"}));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      _token = json['token'];
      print(_token);
      return true;
    } else {
      print("erro ao requisitar token!");
      return false;
    }
  }

/* RECUPERA LISTA DE CARROS VIA API */
  _getTabelaID() async {
    String uri = 'https://agintegracao.com/api/v1/veiculos';

    final response = await http.get(
      Uri.parse(uri),
      headers: {
        "X-AutoGestor-Token": _token,
        "X-AutoGestor-Cliente": "1476",
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      _tabelaID = json['veiculos'];
    } else if (response.statusCode == 401) {
      final json = jsonDecode(response.body);
      String erro = json['erro'];
      if (erro == "Token incompatível com o cliente") {
        await _getClientToken();
      }
    } else {
      print("erro ao buscar carros");
    }
  }

/* INICIALIZA COMPARAÇÃO ENTRE API E BASES DE DADOS, RECUPERA DADOS APENAS DO FIRESTORE */
  setupDadosTableCarro() async {
    _tabela = [];
    if (_token == '') {
      await _getClientToken();
    }

    await _getTabelaID();

    await _comparaEstoque();

    if (auth.usuario != null) {
      final snapshot = await dbFirestore
          .collection('usuarios/${auth.usuario!.email}/carros')
          .get();
      snapshot.docs.forEach((doc) {
        Carro carro = Carro(
          id: int.parse(doc.id),
          foto: 'images/default.jpg',
          marca: doc.get('marca'),
          modelo: doc.get('modelo'),
          versao: doc.get('versao'),
          anofab: doc.get('anofab'),
          anomod: doc.get('anomod'),
          placa: doc.get('placa'),
          valor: doc.get('valor'),
        );
        _tabela.add(carro);
      });
      notifyListeners();
    }
  }

/* SALVA VEÍCULOS NO FIRESTORE, CASO AINDA NÃO EXISTAM E EXCLUI VEÍCULOS QUE NÃO ESTÃO NA LISTA DA API */
  _comparaEstoque() async {
    if (auth.usuario != null) {
      final snapshot = await dbFirestore
          .collection('usuarios/${auth.usuario!.email}/carros')
          .get();

      List carrosFirestore = [];

      /* PERCORRE OS DOCUMENTOS E EXCLUI OS QUE NÃO CONSTAM NA LISTA DA API */
      snapshot.docs.forEach((doc) {
        if (_tabelaID.contains(int.parse(doc.id)) == false) {
          dbFirestore
              .collection('usuarios/${auth.usuario!.email}/carros')
              .doc(doc.id)
              .delete();
        }
        carrosFirestore.add(int.parse(
            doc.id)); // CRIA UMA LISTA COM VEÍCULOS PRESENTES NO FIRESTORE
      });

      /* USA A LISTA DE VEÍCULOS DO FIRESTORE PARA ADICIONAR OS CARROS FALTANTES */
      _tabelaID.forEach((id) {
        if (carrosFirestore.contains(id) == false) {
          _getCarroFromAPI(id);
        }
      });
    }
  }

  /* RECUPERA DETALHES DE 1 CARRO VIA API */
  _getCarroFromAPI(int id) async {
    String uri = 'https://agintegracao.com/api/v1/veiculos/${id}/detalhes';

    final response = await http.get(
      Uri.parse(uri),
      headers: {
        "X-AutoGestor-Token": _token,
        "X-AutoGestor-Cliente": "1476",
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final Map<dynamic, dynamic> detalhes = json['detalhes'];
      Carro carro = Carro(
        id: id,
        foto: 'images/default.jpg',
        marca: detalhes['marca_nome'],
        modelo: detalhes['modelo_nome'],
        versao: detalhes['versao'],
        anofab: detalhes['ano_de_fabricacao'],
        anomod: detalhes['ano_de_modelo'],
        placa: detalhes['placa'],
        valor: double.parse(detalhes['preco'].toString()),
      );
      atualizaEstoque(carro);
      print(carro.marca + " " + carro.modelo + " adicionado ao firebase");
    }
  }

  /* ADICIONA 1 NOVO CARRO AO FIRESTORE */
  atualizaEstoque(Carro carro) async {
    await dbFirestore
        .doc('usuarios/${auth.usuario!.email}/carros/${carro.id}')
        .set({
      'marca': carro.marca,
      'modelo': carro.modelo,
      'versao': carro.versao,
      'anofab': carro.anofab,
      'anomod': carro.anomod,
      'placa': carro.placa,
      'valor': carro.valor,
    });
    tabela.add(carro);
  }

  _carrosTableIsEmpty() async {
    //Database db = await DB.instance.database;
    //List resultados = await db.query('carros');
    //return resultados.isEmpty;
    return true;
  }

  ordena() {
    if (!isSorted) {
      _tabela.sort((Carro a, Carro b) => a.marca.compareTo(b.marca));
      isSorted = true;
    } else {
      _tabela = _tabela.reversed.toList();
    }
    notifyListeners();
  }

  /* adicionaCarro(String addCarro) {
    _tabela.add(Carro(
      foto: 'images/default.jpg',
      marca: '',
      modelo: '',
      anofab: 0,
      anomod: 0,
      placa: addCarro,
      valor: 0.0,
    ));
  }*/
}
