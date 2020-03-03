import 'dart:convert' as convert;
void main() {
}

class Tokenizer {
  Stream<Token> analyze(Stream<List<int>> input) async*{
    Stream decoded = input.transform(convert.utf8.decoder);
  }
}

class Token {
  int startOffset;
  int endOffset;
  final String value;
  final TokenType type;
  Token({this.value, this.type});
}
 
enum TokenType {
  realNumber, number, plusOperator, multiplierOperator
}
