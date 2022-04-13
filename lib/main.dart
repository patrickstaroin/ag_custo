import 'package:ag_custo/repositories/sem_fotos_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ag_custo.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SemFotosRepository(),
      child: const AgCusto(),
    ),
  );
}
