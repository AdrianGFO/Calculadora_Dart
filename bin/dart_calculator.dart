import 'dart:io';

void main() {
  while (true) {
    stdout.write(
      'Exemplo: (2 + 2 / 4) <-- com espaços entre o número e a expressão! \nDigite a expressão a ser calculada (ou "sair" para encerrar):',
    );
    String? input = stdin.readLineSync();
    if (input == null || input.toLowerCase() == 'sair') {
      print('Encerrando a calculadora.');
      break;
    }

    try {
      double result = evaluateExpression(input);
      print('Resultado: $result');
    } catch (e) {
      print('Erro ao calcular a expressão: $e');
    }
  }
}

double evaluateExpression(String expression) {
  List<String> tokens = expression.split(' ');
  List<double> values = [];
  List<String> operators = [];

  for (String token in tokens) {
    if (isOperator(token)) {
      while (operators.isNotEmpty && hasPrecedence(token, operators.last)) {
        values.add(
          applyOperator(
            operators.removeLast(),
            values.removeLast(),
            values.removeLast(),
          ),
        );
      }
      operators.add(token);
    } else {
      values.add(double.parse(token));
    }
  }

  while (operators.isNotEmpty) {
    values.add(
      applyOperator(
        operators.removeLast(),
        values.removeLast(),
        values.removeLast(),
      ),
    );
  }

  return values.last;
}

bool isOperator(String token) {
  return token == '+' || token == '-' || token == '*' || token == '/';
}

bool hasPrecedence(String op1, String op2) {
  if ((op1 == '*' || op1 == '/') && (op2 == '+' || op2 == '-')) {
    return false;
  }
  return true;
}

double applyOperator(String operator, double b, double a) {
  switch (operator) {
    case '+':
      return a + b;
    case '-':
      return a - b;
    case '*':
      return a * b;
    case '/':
      return a / b;
    default:
      throw ArgumentError('Operador desconhecido: $operator');
  }
}
