// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Item {
  String nome;
  String preco;

  Item({required this.nome, required this.preco});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Item',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Login'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Adiciona a imagem do logo
                Image.asset(
                  'Images/lista_de_compra_logo.png',
                  height: 244, // Ajuste conforme necessário
                  width: 275, // Ajuste conforme necessário
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Usuário'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Verificar credenciais
                if (_usernameController.text == 'admin' &&
                    _passwordController.text == 'admin') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StudentListPage()),
                  );
                } else {
                  // Exibir mensagem de erro
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Credenciais inválidas')),
                  );
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StudentListPageState createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  List<Item> students = [
    Item(
      nome: 'Aspirador de Pó',
      preco: 'R\$ 199.99',
    ),
    Item(
      nome: 'Banana',
      preco: 'R\$ 8.99',
    ),
    Item(
      nome: 'Remédio',
      preco: 'R\$ 240.00',
    ),
    Item(
      nome: 'Roupas novas',
      preco: 'R\$ 599.99',
    ),
    Item(
      nome: 'Rojão',
      preco: 'R\$ 1399.89',
    ),
    Item(
      nome: 'Betoneira 400L',
      preco: 'R\$ 3.999',
    ),
    Item(
      nome: 'Tijolo baiano',
      preco: 'R\$ 0.85',
    ),
    Item(
      nome: 'Torpedo de canoa',
      preco: 'R\$ 15.00',
    ),
    Item(
      nome: 'Linguiça',
      preco: 'R\$ 19.95',
    ),
    Item(
      nome: 'Saia festa junina',
      preco: 'R\$ 68.00',
    ),
  ];

  bool _isValidPreco(String preco) {
    final precoRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return precoRegex.hasMatch(preco);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Compras'),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(students[index].nome),
            subtitle: Text(students[index].preco),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                students.removeAt(index);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Item removido')),
                );

                setState(() {});
              },
            ),
            onTap: () async {
              Item updatedStudent = await showDialog(
                context: context,
                builder: (context) {
                  TextEditingController nomeController =
                      TextEditingController(text: students[index].nome);
                  TextEditingController precoController =
                      TextEditingController(text: students[index].preco);

                  return AlertDialog(
                    title: const Text('Editar Item'),
                    content: Column(
                      children: [
                        TextField(
                          controller: nomeController,
                          decoration: const InputDecoration(labelText: 'Nome'),
                        ),
                        TextField(
                          controller: precoController,
                          decoration: const InputDecoration(labelText: 'Preço'),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          if (nomeController.text.isNotEmpty &&
                              precoController.text.isNotEmpty &&
                              _isValidPreco(precoController.text)) {
                            Navigator.pop(
                              context,
                              Item(
                                nome: nomeController.text.trim(),
                                preco: precoController.text.trim(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Preencha todos os campos corretamente')),
                            );
                          }
                        },
                        child: const Text('Salvar'),
                      ),
                    ],
                  );
                },
              );

              if (updatedStudent != null) {
                // Atualizar o item na lista
                students[index] = updatedStudent;
                // Atualizar a interface
                setState(() {});
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Adicionar novo item
          Item newStudent = await showDialog(
            context: context,
            builder: (context) {
              TextEditingController nomeController = TextEditingController();
              TextEditingController precoController = TextEditingController();
              // Adicionar novo item
              return AlertDialog(
                title: const Text('Novo Item'),
                content: Column(
                  children: [
                    TextField(
                      controller: nomeController,
                      decoration: const InputDecoration(labelText: 'Nome'),
                    ),
                    TextField(
                      controller: precoController,
                      decoration: const InputDecoration(labelText: 'Preço'),
                    ),
                  ],
                ),
                // Cancelar operação
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancelar'),
                  ),
                  // Validar e adicionar o novo item
                  TextButton(
                    onPressed: () {
                      if (nomeController.text.isNotEmpty &&
                          precoController.text.isNotEmpty &&
                          _isValidPreco(precoController.text)) {
                        Navigator.pop(
                          context,
                          Item(
                            nome: nomeController.text.trim(),
                            preco: precoController.text.trim(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Preencha todos os campos corretamente')),
                        );
                      }
                    },
                    child: const Text('Adicionar'),
                  ),
                ],
              );
            },
          );
          // Verificar espaço a ser alocado para a adição do novo item
          if (newStudent != null) {
            // Adicionar o novo item à lista
            students.add(newStudent);

            // Atualizar a tela
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
