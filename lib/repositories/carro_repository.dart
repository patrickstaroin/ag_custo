import 'package:flutter/material.dart';

import '../models/carro.dart';

class CarroRepository extends ChangeNotifier {
  bool isSorted = false;

  static List<Carro> tabela = [
    Carro(
      foto: 'images/astra.jpg',
      marca: 'Chevrolet',
      modelo: 'Astra 1.8 GL Manual',
      anofab: 2000,
      anomod: 2001,
      placa: 'AAA-0000',
      valor: 17900.00,
    ),
    Carro(
      foto: 'images/c3.jpg',
      marca: 'Citroen',
      modelo: 'C3 1.5 Tendance Manual',
      anofab: 2013,
      anomod: 2013,
      placa: 'AAA-0001',
      valor: 35900.00,
    ),
    Carro(
      foto: 'images/creta.jpg',
      marca: 'Hyundai',
      modelo: 'Creta 1.6 Pulse Manual',
      anofab: 2017,
      anomod: 2017,
      placa: 'AAA-0002',
      valor: 86900.00,
    ),
    Carro(
      foto: 'images/gol.jpg',
      marca: 'Volkswagen',
      modelo: 'Gol 1.6 G4 Manual',
      anofab: 2008,
      anomod: 2009,
      placa: 'AAA-0003',
      valor: 22900.00,
    ),
    Carro(
      foto: 'images/hb20s.jpg',
      marca: 'Hyundai',
      modelo: 'HB20S 1.6 Comfort Manual',
      anofab: 2015,
      anomod: 2015,
      placa: 'AAA-0004',
      valor: 53900.00,
    ),
    Carro(
      foto: 'images/idea.jpg',
      marca: 'Fiat',
      modelo: 'Idea 1.6 Essence Manual',
      anofab: 2013,
      anomod: 2014,
      placa: 'AAA-0005',
      valor: 39900.00,
    ),
    Carro(
      foto: 'images/prisma.jpg',
      marca: 'Chevrolet',
      modelo: 'Prisma 1.0 Joy Manual',
      anofab: 2018,
      anomod: 2019,
      placa: 'AAA-0006',
      valor: 56900.00,
    ),
    Carro(
      foto: 'images/sandero.jpg',
      marca: 'Renault',
      modelo: 'Sandero 1.0 Expression Manual',
      anofab: 2012,
      anomod: 2012,
      placa: 'AAA-0007',
      valor: 28900.00,
    ),
    Carro(
      foto: 'images/siena_preto.jpg',
      marca: 'Fiat',
      modelo: 'Siena 1.0 Fire Manual',
      anofab: 2009,
      anomod: 2010,
      placa: 'AAA-0008',
      valor: 21900.00,
    ),
    Carro(
      foto: 'images/siena_verm.jpg',
      marca: 'Fiat',
      modelo: 'Siena 1.0 EL Manual',
      anofab: 2011,
      anomod: 2012,
      placa: 'AAA-0009',
      valor: 30900.00,
    ),
  ];

  CarroRepository() {
    notifyListeners();
  }

  ordena() {
    if (!isSorted) {
      tabela.sort((Carro a, Carro b) => a.marca.compareTo(b.marca));
      isSorted = true;
    } else {
      tabela = tabela.reversed.toList();
    }
    notifyListeners();
  }

  adicionaCarro(String addCarro) {
    tabela.add(Carro(
      foto: 'images/default.jpg',
      marca: '',
      modelo: '',
      anofab: 0,
      anomod: 0,
      placa: addCarro,
      valor: 0.0,
    ));
  }
}
