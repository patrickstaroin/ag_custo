import 'dart:collection';

import 'package:flutter/material.dart';

import '../models/carro.dart';

class SemFotosRepository extends ChangeNotifier {
  List<Carro> _lista = [];

  UnmodifiableListView<Carro> get lista => UnmodifiableListView(_lista);

  getSemFotos(List<Carro> tabela) {
    _lista = [];
    tabela.forEach((carro) {
      if (carro.foto ==
          'https://firebasestorage.googleapis.com/v0/b/agcusto.appspot.com/o/carros%2Fdefault.jpg?alt=media&token=e0574d70-eaeb-4614-ae17-61a05db3fbba') {
        _lista.add(carro);
      }
    });
    //notifyListeners();
  }

  attLista(Carro carro) {
    _lista.add(carro);
    print("adicionou ao" + carro.placa + " sem fotos Repo");
    notifyListeners();
  }

  remove(Carro carro) {
    _lista.remove(carro);
    notifyListeners();
  }
}
