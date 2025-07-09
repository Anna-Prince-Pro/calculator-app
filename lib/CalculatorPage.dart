import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String input = '';
  String result = '';

  Widget buildButton(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          setState(() {
            if (text == "C") {
              input = '';
              result = '';
            } else if (text == "=") {
              try {
                final expression = input
                    .replaceAll('×', '*')
                    .replaceAll('÷', '/');
                result = _evaluate(expression);
              } catch (e) {
                result = 'Error';
              }
            } else {
              input += text;
            }
          });
        },
        child: Text(text),
      ),
    );
  }

  String _evaluate(String expression) {
    try {
      expression = expression.replaceAll('×', '*');
      expression = expression.replaceAll('÷', '/');
      expression = expression.replaceAll('%', '%');
      final res = _calculateWithOperators(expression);
      return res.toStringAsFixed(2);
    } catch (e) {
      return 'Error';
    }
  }

  double _calculateWithOperators(String expr) {
    List<String> tokens = expr.split(RegExp(r'(?<=[-+*/%])|(?=[-+*/%])'));
    List<String> stack = [];

    for (String token in tokens) {
      if (token.trim().isEmpty) continue;
      stack.add(token.trim());
    }

    // Handle *, /, %
    for (int i = 0; i < stack.length; i++) {
      if (stack[i] == '*' || stack[i] == '/' || stack[i] == '%') {
        double left = double.parse(stack[i - 1]);
        double right = double.parse(stack[i + 1]);
        double res;

        if (stack[i] == '*')
          res = left * right;
        else if (stack[i] == '/')
          res = left / right;
        else
          res = left % right;

        stack.replaceRange(i - 1, i + 2, [res.toString()]);
        i = -1; // Reset loop to re-scan
      }
    }

    // Then handle + and -
    double result = double.parse(stack[0]);
    for (int i = 1; i < stack.length; i += 2) {
      String op = stack[i];
      double num = double.parse(stack[i + 1]);
      if (op == '+') result += num;
      if (op == '-') result -= num;
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    input,
                    style: const TextStyle(fontSize: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    result,
                    style: const TextStyle(
                      fontSize: 30,
                      color: Colors.greenAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GridView.count(
              crossAxisCount: 4,
              children: [
                buildButton("C"),
                buildButton("%"),
                buildButton(""),
                buildButton("÷"),
                buildButton("7"),
                buildButton("8"),
                buildButton("9"),
                buildButton("×"),
                buildButton("4"),
                buildButton("5"),
                buildButton("6"),
                buildButton("-"),
                buildButton("1"),
                buildButton("2"),
                buildButton("3"),
                buildButton("+"),
                buildButton("0"),
                buildButton("."),
                buildButton("="),
                buildButton(""),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
