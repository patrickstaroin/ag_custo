import 'dart:convert';

import 'package:ag_custo/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  late FirebaseStorage storage;

  CarroRepository({required this.auth}) {
    _setupDatabase();
    setupDadosTableCarro();
  }

  _startFirestore() {
    dbFirestore = DBFirestore.get();
  }

  _startStorage() {
    storage = FirebaseStorage.instance;
  }

/* INICA BANCOS DE DADOS */
  _setupDatabase() async {
    await _startFirestore();
    await _startStorage();
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
      //print(_token);
      return true;
    } else {
      //print("erro ao requisitar token!");
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
          marca: doc.get('marca'),
          modelo: doc.get('modelo'),
          versao: doc.get('versao'),
          anofab: doc.get('anofab'),
          anomod: doc.get('anomod'),
          placa: doc.get('placa'),
          valor: doc.get('valor'),
        );
        _tabela.add(carro); // adiciona carro com a foto padrão
      });
      notifyListeners();

      await _getFotoFromAPI(); // recupera fotos via API e salva no Firebase Storage
      getFotoFromStorage(); // recupera fotos do Firebase Storage para mostrar na tela
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
        if (_tabelaID.contains(int.parse(doc.id)) == false &&
            int.parse(doc.id) > 10000) {
          // não exclui carros adicionados pelo próprio aplicativo
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
        marca: detalhes['marca_nome'],
        modelo: detalhes['modelo_nome'],
        versao: detalhes['versao'],
        anofab: detalhes['ano_de_fabricacao'],
        anomod: detalhes['ano_de_modelo'],
        placa: detalhes['placa'],
        valor: double.parse(detalhes['preco'].toString()),
      );
      atualizaEstoque(carro);

      // print(carro.marca + " " + carro.modelo + " adicionado ao firebase");
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

/* RECUPERA FOTOS DE TODOS OS CARROS VIA API */
  _getFotoFromAPI() async {
    _tabelaID.forEach((id) async {
      final storageRef = storage.ref("carros/${id}/");

      final listResultado = await storageRef.listAll();
      if (listResultado.items.isEmpty) {
        // verifica se já possui as fotos do carro armazenadas
        //print("nao tem foto");
        String uri = 'https://agintegracao.com/api/v1/veiculos/${id}/fotos';

        final response = await http.get(
          Uri.parse(uri),
          headers: {
            "X-AutoGestor-Token": _token,
            "X-AutoGestor-Cliente": "1476",
          },
        );

        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);
          final List<dynamic> fotos = json['fotos'];
          if (fotos.isNotEmpty) {
            // verifica se o carro possui fotos na API
            fotos.forEach((foto) async {
              await storageRef
                  .child('${foto['ordem']}')
                  .putString(foto['base64'], format: PutStringFormat.base64);
              //print("adicionou foto ao Firebase Storage");
            });
          }
        }
      }
    });
  }

  /* RECUPERA FOTO DE TODOS OS CARROS DO FIREBASE STORAGE */
  getFotoFromStorage() async {
    _tabela.forEach((carro) async {
      if (carro.foto ==
          'https://firebasestorage.googleapis.com/v0/b/agcusto.appspot.com/o/carros%2Fdefault.jpg?alt=media&token=e0574d70-eaeb-4614-ae17-61a05db3fbba') {
        final storageRef = storage.ref("carros/${carro.id}/");
        String fotoUrl = '';

        final listResultado = await storageRef.listAll();
        if (listResultado.items.isNotEmpty) {
          try {
            fotoUrl = await storageRef.child('0').getDownloadURL();
            carro.foto = fotoUrl;
          } catch (error) {
            try {
              fotoUrl = await storageRef.child('1').getDownloadURL();
              carro.foto = fotoUrl;
            } catch (error) {
              // print("nao tem foto");
            }
          }
        }
      }

      notifyListeners();
    });
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
