
// Student Name:Chathura Fernando
// Student Number :IM/2021/042
// Year:2
// Module:Mobile Application Development

import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatefulWidget {
  @override
  _CalculatorAppState createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  String _displayText = "0"; // Shows the current number or result
  String _workings = ""; // Shows the complete expression
  String _operator = "";
  double _currentResult = 0;
  bool _isOperatorPressed = false;

  List<String> _calculationHistory = []; // Stores the calculations

  /// Perform the operation and update the current result.
  void _performCalculation(double operand) {
    switch (_operator) {
      case "+":
        _currentResult += operand;
        break;
      case "-":
        _currentResult -= operand;
        break;
      case "×":
        _currentResult *= operand;
        break;
      case "÷":
        if (_currentResult == 0 && operand == 0) {
          _displayText = "Invalid Format"; // Handle 0/0 case
          _workings = "";
          _currentResult = 0;
          _operator = "";
          _isOperatorPressed = false;
          return;
        } else if (operand == 0) {
          _displayText = "Cannot divide by zero"; // Handle x/0 case
          _workings = "";
          _currentResult = 0;
          _operator = "";
          _isOperatorPressed = false;
          return;
        } else {
          _currentResult /= operand;
        }
        break;
    }
    _displayText = _currentResult.toString();
  }

  /// Handle button press actions.
  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        // Reset calculator
        _displayText = "0";
        _workings = "";
        _operator = "";
        _currentResult = 0;
        _isOperatorPressed = false;
        _calculationHistory.clear(); // Clear calculation history
      } else if (buttonText == "=") {
        // Perform the final calculation
        if (_operator.isNotEmpty) {
          _performCalculation(double.parse(_displayText));
          _calculationHistory.add("$_workings = $_currentResult"); // Store the calculation
          _workings = "$_currentResult"; // Reset workings to the result
          _operator = "";
          _isOperatorPressed = false;
        }
      } else if (["+", "-", "×", "÷"].contains(buttonText)) {
        // Handle operator
        if (_isOperatorPressed) {
          _operator = buttonText; // Update operator without recalculating
          _workings = _workings.substring(0, _workings.length - 1) + buttonText;
        } else {
          if (_operator.isNotEmpty) {
            _performCalculation(double.parse(_displayText));
          } else {
            _currentResult = double.parse(_displayText);
          }
          _operator = buttonText;
          _isOperatorPressed = true;

          // Append the operator to workings
          _workings += " $buttonText";
        }
      } else if (buttonText == "+/-") {
        if (_displayText != "0") {
          _displayText = _displayText.startsWith("-")
              ? _displayText.substring(1)
              : "-$_displayText";
        }
      } else if (buttonText == "%") {
        _displayText = (double.parse(_displayText) / 100).toString();
        _workings += "%";
      } else if (buttonText == "√") {
        double value = double.parse(_displayText);
        if (value < 0) {
          _displayText = "Error";
        } else {
          _displayText = sqrt(value).toString();
          _workings += "√($value)";
        }
      } else if (buttonText == ".") {
        if (!_displayText.contains(".")) {
          _displayText += ".";
          _workings += ".";
        }
      } else if (buttonText == "⌫") {
        if (_displayText.length > 1) {
          _displayText = _displayText.substring(0, _displayText.length - 1);
        } else {
          _displayText = "0";
        }
        if (_workings.isNotEmpty) {
          _workings = _workings.substring(0, _workings.length - 1);
        }
      } else {
        // Handle numeric input
        if (_isOperatorPressed) {
          _displayText = buttonText; // Start a new number
          _isOperatorPressed = false;
        } else {
          _displayText = (_displayText == "0") ? buttonText : _displayText + buttonText;
        }
        _workings += buttonText;
      }
    });
  }

  Widget _buildButton(String text,
      {Color textColor = Colors.black, Color bgColor = Colors.white}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        backgroundColor: bgColor,
        padding: EdgeInsets.all(20),
        shadowColor: Colors.transparent,
      ),
      onPressed: () {
        _onButtonPressed(text);
      },
      child: Text(
        text,
        style: TextStyle(fontSize: 24, color: textColor, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Calculation History
            Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: _calculationHistory.map((calculation) {
                  return Text(
                    calculation,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  );
                }).toList(),
              ),
            ),
            // Workings Area
            Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                _workings,
                style: TextStyle(fontSize: 24, color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Display Area
            Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                _displayText,
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            // Buttons Grid
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildButton("C", textColor: Colors.red),
                      _buildButton("√", textColor: Colors.green),
                      _buildButton("%", textColor: Colors.green),
                      _buildButton("÷", textColor: Colors.green),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildButton("7"),
                      _buildButton("8"),
                      _buildButton("9"),
                      _buildButton("×", textColor: Colors.green),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildButton("4"),
                      _buildButton("5"),
                      _buildButton("6"),
                      _buildButton("-", textColor: Colors.green),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildButton("1"),
                      _buildButton("2"),
                      _buildButton("3"),
                      _buildButton("+", textColor: Colors.green),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildButton("⌫", textColor: Colors.red),
                      _buildButton("0"),
                      _buildButton("."),
                      _buildButton("=", textColor: Colors.white, bgColor: Colors.green),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
