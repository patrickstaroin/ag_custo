import 'package:ag_custo/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final senha = TextEditingController();
  bool loading = false;

  login() async {
    setState(() => loading = true);
    try {
      await context.read<AuthService>().login(email.text, senha.text);
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.messsage),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan.shade700,
        title: const Text(
          'AG Custo',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 100),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Bem Vindo!",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.5,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(24.0),
                  child: TextFormField(
                    controller: email,
                    style: const TextStyle(fontSize: 22),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Informe o email corretamente!';
                      } else if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return 'Informe um email válido! example@email.com';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(24.0),
                  child: TextFormField(
                    controller: senha,
                    obscureText: true,
                    style: const TextStyle(fontSize: 22),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Senha',
                      prefixIcon: Icon(Icons.password),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Informe a senha!';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(24.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        login();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.cyan.shade700,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: (loading)
                          ? [
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                      color: Colors.white),
                                ),
                              ),
                            ]
                          : [
                              Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                              Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  "Entrar",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
