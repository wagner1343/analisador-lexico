import 'dart:io';

void main(List<String> args) async{
  if(args.length < 1){
    print("Utilize dart main.dart caminhoEntrada");
    return;
  }

  String caminhoEntrada = args[0];
  String entrada = await lerArquivo(caminhoEntrada);

  List<Regra> regrasCalculadora = [Regra(exp: RegExp(r"^[0-9]+[.][0-9]+"), nome: "numero real"),
   Regra(exp: RegExp(r"^[0-9]+"), nome: "numero"),
   Regra(exp: RegExp(r"^[+]"), nome: "operador de adição"),
   Regra(exp: RegExp(r"^[-]"), nome: "operador de subtração"),
   Regra(exp: RegExp(r"^[*]"), nome: "operador de multiplicação"),
   Regra(exp: RegExp(r"^[/]"), nome: "operador de divisão"),
   Regra(exp: RegExp(r"^[ ]"), nome: "espaço em branco"),
   Regra(exp: RegExp(r"^[)]"), nome: "fecha parenteses"),
   Regra(exp: RegExp(r"^[(]"), nome: "abre parenteses"),
   ];
   
  Tokenizador t = Tokenizador(regras: regrasCalculadora);
  var result = t.analisar(entrada);

  for(var k in result.keys){
    print("${k?.nome ?? "erro"}: ${result[k].fold("", (p, n) => p + n.valor + ", ")}");
  }

}

class Tokenizador {
  List<Regra> regras;
  
  Tokenizador({this.regras});

  Map<Regra, List<Token>> analisar(String entrada,{ bool imprimirDados = false}) {
    Map<Regra, List<Token>> tokens = Map();

    for(Regra r in regras){
      tokens[r] = <Token>[];
    }
    tokens[null] = <Token>[];

    while(!entrada.isEmpty){
      if(imprimirDados) ("Analisando $entrada");
      Token atual;
      for(Regra r in regras){
        var match = r.exp.firstMatch(entrada);
        if(imprimirDados) print("Match para regra ${r.nome}: ${match?.pattern}");
        if(match != null && (atual == null || atual.inicio > match.start)){
          atual = Token(regra: r, valor: match.group(0), inicio: match.start, fim: match.end);
        }
      }

      if(atual == null){
        tokens[null].add(Token(valor: entrada.substring(0, 1)));
        entrada = entrada.substring(1, entrada.length);
      }
      else {
        tokens[atual.regra].add(atual);
        if(atual.inicio != 0){
          tokens[null].add(Token(valor: entrada.substring(0, atual.inicio)));
        }
        entrada = entrada.substring(atual.fim, entrada.length);
      }
    }
    return tokens;
  }
}

class Token {
  int inicio;
  int fim;
  final String valor;
  final Regra regra;
  Token({this.valor, this.regra, this.inicio, this.fim});
  String toString(){
    return "$regra -> $valor";
  }
}

class Regra {
  final RegExp exp;
  final String nome;
  bool seAplica(String alvo){
    return exp.hasMatch(alvo);
  }
  const Regra({this.exp, this.nome});

  String toString(){
    return "$nome : ${exp.pattern}";
  }
} 

Future<String> lerArquivo(String caminho) {
  return new File(caminho).readAsString();
}