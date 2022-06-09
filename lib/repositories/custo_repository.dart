import 'dart:collection';

import 'package:ag_custo/databases/db_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/carro.dart';
import '../models/custo.dart';
import '../services/auth_service.dart';

class CustoRepository extends ChangeNotifier {
  List<Custo> _custoList = [];
  double custoTotal = 0;
  late FirebaseFirestore db;
  late AuthService auth;
  late Carro carro;
  bool isSorted = false;

  CustoRepository({required this.auth}) {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
  }

  _startFirestore() {
    db = DBFirestore.get();
  }

  getCusto(Carro carro) async {
    if (auth.usuario != null && _custoList.isEmpty) {
      final snapshot = await db
          .collection(
              'usuarios/${auth.usuario!.email}/carros/${carro.placa}/custos')
          .get();
      snapshot.docs.forEach((doc) {
        Custo custo = Custo(
          descricao: doc.get('descricao'),
          valor: doc.get('valor'),
          formaPag: doc.get('formaPag'),
          dataPag: doc.get('dataPag'),
        );
        custo.docID = doc.id;
        _custoList.add(custo);
        custoTotal = custoTotal + custo.valor;
      });
      ordena();
      notifyListeners();
    }
  }

  UnmodifiableListView<Custo> get custoList => UnmodifiableListView(_custoList);

  addCusto(Carro carro, Custo custo) async {
    await db
        .collection(
            'usuarios/${auth.usuario!.email}/carros/${carro.placa}/custos')
        .doc()
        .set({
      'descricao': custo.descricao,
      'valor': custo.valor,
      'formaPag': custo.formaPag,
      'dataPag': custo.dataPag,
    });
    _custoList.add(custo);
    notifyListeners();
  }

  removeCusto(Carro carro, Custo custo) async {
    await db
        .collection(
            'usuarios/${auth.usuario!.email}/carros/${carro.placa}/custos')
        .doc(custo.docID)
        .delete();
    _custoList.remove(custo);
    custoTotal = custoTotal - custo.valor;
    notifyListeners();
  }

  ordena() {
    if (!isSorted) {
      _custoList.sort((Custo a, Custo b) => b.dataPag.compareTo(a.dataPag));
      isSorted = true;
    }
  }
}
