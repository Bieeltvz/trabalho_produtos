import 'package:mysql1/mysql1.dart';


// Classe Cliente
class Cliente {
  int? id;
  String nome;
  String email;

  Cliente({this.id, required this.nome, required this.email});
}

// Classe Pedido
class Pedido {
  int? id;
  int idCliente;
  String produto;
  double valor;

  Pedido({this.id, required this.idCliente, required this.produto, required this.valor});
}

Future<void> main() async {
  // Configuração da conexão
  final conn = await MySqlConnection.connect(ConnectionSettings(
    host: 'localhost',
    port: 3306,
    user: 'gabriel',
    password: 'senha',
    db: 'loja',
  ));

  print("✅ Conectado ao MySQL!");

  // Inserir Cliente
  var cliente = Cliente(nome: "João Silva", email: "joao@email.com");
  var result = await conn.query(
      'INSERT INTO Cliente (nome, email) VALUES (?, ?)',
      [cliente.nome, cliente.email]);
  cliente.id = result.insertId;
  print("👤 Cliente inserido com ID: ${cliente.id}");

  // Inserir Pedido para o cliente
  var pedido1 = Pedido(idCliente: cliente.id!, produto: "Notebook", valor: 3500.00);
  var pedido2 = Pedido(idCliente: cliente.id!, produto: "Mouse Gamer", valor: 150.00);

  await conn.query('INSERT INTO Pedido (id_cliente, produto, valor) VALUES (?, ?, ?)',
      [pedido1.idCliente, pedido1.produto, pedido1.valor]);
  await conn.query('INSERT INTO Pedido (id_cliente, produto, valor) VALUES (?, ?, ?)',
      [pedido2.idCliente, pedido2.produto, pedido2.valor]);

  print("🛒 Pedidos inseridos com sucesso!");

  // Consulta 1: Listagem dos pedidos com dados do cliente (JOIN)
  print("\n📋 Lista de pedidos com cliente:");
  var results = await conn.query('''
    SELECT c.nome, c.email, p.produto, p.valor
    FROM Pedido p
    JOIN Cliente c ON p.id_cliente = c.id;
  ''');

  for (var row in results) {
    print("Cliente: ${row[0]} | Email: ${row[1]} | Produto: ${row[2]} | Valor: R\$ ${row[3]}");
  }

  print("\n💰 Total gasto por cliente:");
  var results2 = await conn.query('''
    SELECT c.nome, SUM(p.valor) as total
    FROM Pedido p
    JOIN Cliente c ON p.id_cliente = c.id
    GROUP BY c.id;
  ''');

  for (var row in results2) {
    print("Cliente: ${row[0]} | Total gasto: R\$ ${row[1]}");
  }

  await conn.close();
}
