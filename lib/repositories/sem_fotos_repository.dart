import 'dart:collection';

import 'package:flutter/material.dart';

import '../models/carro.dart';

class SemFotosRepository extends ChangeNotifier {
  List<Carro> _lista = [];

  UnmodifiableListView<Carro> get lista => UnmodifiableListView(_lista);

  attLista(List<Carro> carros) {
    carros.forEach((carro) {
      if (carro.foto.compareTo('images/default.jpg') == 0 &&
          !_lista.contains(carro)) {
        _lista.add(carro);
        print('adicionou carro');
      }
    });
    notifyListeners();
  }

  remove(Carro carro) {
    _lista.remove(carro);
    notifyListeners();
  }
}
