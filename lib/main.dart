import 'package:ag_custo/repositories/custo_repository.dart';
import 'package:ag_custo/repositories/sem_fotos_repository.dart';
import 'package:ag_custo/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ag_custo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => SemFotosRepository()),
        ChangeNotifierProvider(
            create: (context) =>
                CustoRepository(auth: context.read<AuthService>())),
      ],
      child: const AgCusto(),
    ),
  );
}
