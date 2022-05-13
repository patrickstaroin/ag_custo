import 'package:ag_custo/databases/db_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/carro.dart';
import '../models/custo.dart';
import '../services/auth_service.dart';

class CustoRepository extends ChangeNotifier {
  List<Custo> custoList = [];
  late double custoInicial;
  late double custoTotal;
  late FirebaseFirestore db;
  late AuthService auth;

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
    if (auth.usuario != null && custoList.isEmpty) {
      final snapshot = await db
          .collection(
              'usuarios/${auth.usuario!.uid}/carros/${carro.placa}/custos')
          .get();
      snapshot.docs.forEach((doc) {
        Custo custo = Custo(
          descricao: doc.get('descricao'),
          valor: doc.get('valor'),
          formaPag: doc.get('formaPag'),
          dataPag: doc.get('dataPag'),
        );
        custoList.add(custo);
        notifyListeners();
      });
    }
  }

  addCusto(Carro carro, Custo custo) async {
    custoList.add(custo);
    await db
        .collection(
            'usuarios/${auth.usuario!.uid}/carros/${carro.placa}/custos')
        .doc()
        .set({
      'descricao': custo.descricao,
      'valor': custo.valor,
      'formaPag': custo.formaPag,
      'dataPag': custo.dataPag,
    });
  }

  removeCusto(Carro carro, Custo custo) async {}
}
