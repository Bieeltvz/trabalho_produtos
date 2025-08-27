
class Produto {
  String nome;
  double _preco = 0; 


  Produto(this.nome, double preco) {
    this.preco = preco; 
  }

  double get preco => _preco;

  set preco(double valor) {
    if (valor < 0) {
      print("Preço inválido! O valor não pode ser negativo.");
      _preco = 0;
    } else {
      _preco = valor;
    }
  }
  void exibir() {
    print("Produto: $nome | Preço: R\$ ${_preco.toStringAsFixed(2)}");
  }
}

void main() {

  Produto p1 = Produto("Notebook", 3500.00);
  Produto p2 = Produto("Mouse Gamer", -150.00); 

  p1.exibir();
  p2.exibir();

  p2.preco = 120.00;
  p2.exibir();
}
