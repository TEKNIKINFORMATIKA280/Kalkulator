import 'package:math_expressions/math_expressions.dart';

class CalculatorLogic {
  static double factorial(int n) {
    if (n < 0) return double.nan;
    if (n == 0 || n == 1) return 1;
    double res = 1;
    for (int i = 2; i <= n; i++) {
      res *= i;
    }
    return res;
  }

  static String formatResult(double val) {
    if (val.isNaN) return "Error";
    if (val.isInfinite) return "Infinity";
    
    if (val == val.toInt()) {
      return val.toInt().toString();
    }
    
    String str = val.toStringAsFixed(8);
    while (str.contains('.') && (str.endsWith('0') || str.endsWith('.'))) {
      if (str.endsWith('.')) {
        str = str.substring(0, str.length - 1);
        break;
      }
      str = str.substring(0, str.length - 1);
    }
    return str.replaceAll('.', ',');
  }

  static String evaluate(String equation) {
    if (equation.isEmpty) return "0";

    try {
      String expString = equation;
      expString = expString.replaceAll(',', '.'); // Handle comma as dot internally
      expString = expString.replaceAll('×', '*');
      expString = expString.replaceAll('÷', '/');
      expString = expString.replaceAll('−', '-');
      expString = expString.replaceAll('√(', 'sqrt(');
      expString = expString.replaceAll('π', 'pi');
      expString = expString.replaceAll('%', '/100');

      expString = expString.replaceAllMapped(RegExp(r'(\d+)!'), (match) {
        int val = int.parse(match.group(1)!);
        return factorial(val).toString();
      });

      Parser p = Parser();
      Expression exp = p.parse(expString);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      return formatResult(eval);
    } catch (e) {
      return "Error";
    }
  }
}
