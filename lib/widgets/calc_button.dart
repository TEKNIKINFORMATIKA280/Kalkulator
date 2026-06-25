import 'package:flutter/material.dart';

class CalcButton extends StatelessWidget {
  final String text;
  final Color? bg;
  final Color? fg;
  final bool isLong;
  final bool isDarkMode;
  final VoidCallback onPressed;

  const CalcButton({
    super.key,
    required this.text,
    this.bg,
    this.fg,
    this.isLong = false,
    required this.isDarkMode,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBg = isDarkMode ? const Color(0xFF22222A) : Colors.white;
    final defaultFg = isDarkMode ? Colors.white : const Color(0xFF2D2D2D);

    final isOperator = ["+", "−", "×", "÷", "="].contains(text);
    final isSpecial = ["AC", "DEL", "%", "±"].contains(text);

    return Expanded(
      flex: isLong ? 2 : 1,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        decoration: BoxDecoration(
          shape: isLong ? BoxShape.rectangle : BoxShape.circle,
          borderRadius: isLong ? BorderRadius.circular(50) : null,
          boxShadow: [
            BoxShadow(
              color: isDarkMode 
                  ? Colors.black.withOpacity(0.3) 
                  : Colors.grey.withOpacity(0.15),
              spreadRadius: 0,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: bg ?? defaultBg,
            foregroundColor: fg ?? defaultFg,
            elevation: 0,
            padding: EdgeInsets.zero,
            shape: isLong ? const StadiumBorder() : const CircleBorder(),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              fontSize: isOperator ? 20 : (isSpecial ? 15 : 18),
              fontWeight: isOperator || isSpecial ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
