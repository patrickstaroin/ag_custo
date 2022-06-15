class Carro {
  int id;
  String foto =
      'https://firebasestorage.googleapis.com/v0/b/agcusto.appspot.com/o/carros%2Fdefault.jpg?alt=media&token=e0574d70-eaeb-4614-ae17-61a05db3fbba';
  String marca;
  String modelo;
  String versao;
  int anofab;
  int anomod;
  String placa;
  double valor;

  Carro({
    required this.id,
    required this.marca,
    required this.modelo,
    required this.versao,
    required this.anofab,
    required this.anomod,
    required this.placa,
    required this.valor,
  });
}
