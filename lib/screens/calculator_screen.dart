import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import '../widgets/calc_button.dart';
import '../utils/calculator_logic.dart';
import '../models/history_item.dart';
import 'settings_screen.dart';

class CalculatorScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final bool isSoundEnabled;
  final Function(bool) onToggleSound;

  const CalculatorScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.isSoundEnabled,
    required this.onToggleSound,
  });

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _equation = "";
  String _result = "0";
  bool _isScientificOpen = false;
  List<HistoryItem> _history = [];
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playSound() async {
    if (widget.isSoundEnabled) {
      try {
        await _audioPlayer.play(AssetSource('sounds/click.mp3'));
      } catch (e) {
        debugPrint("Error playing sound: $e");
      }
    }
  }

  void _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyData = prefs.getStringList('calculator_history_v2') ?? [];
    setState(() {
      _history = historyData.map((item) => HistoryItem.fromJson(item)).toList();
    });
  }

  void _saveHistory(String equation, String result) async {
    if (equation.isEmpty || result == "Error" || result == "0") return;
    final prefs = await SharedPreferences.getInstance();
    
    final newItem = HistoryItem(
      equation: equation,
      result: result,
      timestamp: DateTime.now(),
    );

    if (_history.isEmpty || _history.first.equation != equation) {
      _history.insert(0, newItem);
      if (_history.length > 50) _history.removeLast();
      
      final historyStrings = _history.map((item) => item.toJson()).toList();
      await prefs.setStringList('calculator_history_v2', historyStrings);
      setState(() {});
    }
  }

  void _clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('calculator_history_v2');
    setState(() {
      _history.clear();
    });
  }

  void _onButtonPressed(String text) {
    _playSound();
    setState(() {
      if (text == "AC") {
        _equation = "";
        _result = "0";
      } else if (text == "DEL") {
        if (_equation.isNotEmpty) {
          if (_equation.endsWith("sin(") || _equation.endsWith("cos(") || _equation.endsWith("tan(") || _equation.endsWith("log(") || _equation.endsWith("sqrt(")) {
            _equation = _equation.substring(0, _equation.length - 4);
          } else if (_equation.endsWith("ln(")) {
            _equation = _equation.substring(0, _equation.length - 3);
          } else {
            _equation = _equation.substring(0, _equation.length - 1);
          }
        }
      } else if (text == "±") {
        if (_equation.startsWith("-(") && _equation.endsWith(")")) {
          _equation = _equation.substring(2, _equation.length - 1);
        } else if (_equation.isNotEmpty) {
          _equation = "-($_equation)";
        } else {
          _equation = "-";
        }
      } else if (text == "=") {
        String res = CalculatorLogic.evaluate(_equation);
        if (res != "Error") {
          _saveHistory(_equation, res);
          _equation = res;
          _result = res;
        } else {
          _result = "Error";
        }
      } else {
        if (["sin", "cos", "tan", "log", "ln"].contains(text)) {
          _equation += "$text(";
        } else if (text == "√") {
          _equation += "√(";
        } else {
          _equation += text;
        }
      }
      // Evaluasi otomatis dihapus agar lebih manual sesuai permintaan
    });
  }

  void _showHistoryBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = widget.isDarkMode;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E24) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4), borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Riwayat",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                    ),
                  ),
                  if (_history.isNotEmpty)
                    IconButton(
                      onPressed: () { _clearHistory(); Navigator.pop(context); },
                      icon: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent),
                      tooltip: "Hapus Semua",
                    ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(),
              Expanded(
                child: _history.isEmpty
                    ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(Icons.history_toggle_off, size: 64, color: Colors.grey.withOpacity(0.5)),
                        const SizedBox(height: 12),
                        const Text("Belum ada riwayat", style: TextStyle(color: Colors.grey, fontSize: 15)),
                      ]))
                    : ListView.separated(
                        itemCount: _history.length,
                        separatorBuilder: (_, __) => Divider(color: Colors.grey.withOpacity(0.1)),
                        itemBuilder: (context, index) {
                          final item = _history[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(item.equation, style: TextStyle(fontSize: 15, color: isDark ? Colors.white70 : Colors.black54)),
                            trailing: Text("= ${item.result}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)),
                            onTap: () {
                              setState(() { _equation = item.equation; _result = item.result; });
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildButton(String text, {Color? bg, Color? fg}) {
    return CalcButton(
      text: text,
      bg: bg,
      fg: fg,
      isDarkMode: widget.isDarkMode,
      onPressed: () => _onButtonPressed(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = widget.isDarkMode;

    final scientificRows = [
      Expanded(child: Row(children: [
        _buildButton("sin", bg: isDark ? const Color(0xFF262A3B) : const Color(0xFFE8EBF5), fg: colorScheme.primary),
        _buildButton("cos", bg: isDark ? const Color(0xFF262A3B) : const Color(0xFFE8EBF5), fg: colorScheme.primary),
        _buildButton("tan", bg: isDark ? const Color(0xFF262A3B) : const Color(0xFFE8EBF5), fg: colorScheme.primary),
        _buildButton("^", bg: isDark ? const Color(0xFF262A3B) : const Color(0xFFE8EBF5), fg: colorScheme.primary),
      ])),
      Expanded(child: Row(children: [
        _buildButton("ln", bg: isDark ? const Color(0xFF262A3B) : const Color(0xFFE8EBF5), fg: colorScheme.primary),
        _buildButton("log", bg: isDark ? const Color(0xFF262A3B) : const Color(0xFFE8EBF5), fg: colorScheme.primary),
        _buildButton("√", bg: isDark ? const Color(0xFF262A3B) : const Color(0xFFE8EBF5), fg: colorScheme.primary),
        _buildButton("!", bg: isDark ? const Color(0xFF262A3B) : const Color(0xFFE8EBF5), fg: colorScheme.primary),
      ])),
      Expanded(child: Row(children: [
        _buildButton("(", bg: isDark ? const Color(0xFF23232A) : const Color(0xFFF0F0F3)),
        _buildButton(")", bg: isDark ? const Color(0xFF23232A) : const Color(0xFFF0F0F3)),
        _buildButton("π", bg: isDark ? const Color(0xFF23232A) : const Color(0xFFF0F0F3)),
        _buildButton("e", bg: isDark ? const Color(0xFF23232A) : const Color(0xFFF0F0F3)),
      ])),
    ];

    final standardRows = [
      Expanded(child: Row(children: [
        _buildButton("AC", bg: Colors.redAccent.withOpacity(0.15), fg: Colors.redAccent),
        _buildButton("DEL", bg: Colors.orangeAccent.withOpacity(0.15), fg: Colors.orange),
        _buildButton("±", bg: isDark ? const Color(0xFF23232A) : const Color(0xFFF0F0F3)),
        _buildButton("÷", bg: isDark ? const Color(0xFF322A20) : const Color(0xFFFFF4E6), fg: colorScheme.secondary),
      ])),
      Expanded(child: Row(children: [
        _buildButton("7"), _buildButton("8"), _buildButton("9"),
        _buildButton("×", bg: isDark ? const Color(0xFF322A20) : const Color(0xFFFFF4E6), fg: colorScheme.secondary),
      ])),
      Expanded(child: Row(children: [
        _buildButton("4"), _buildButton("5"), _buildButton("6"),
        _buildButton("−", bg: isDark ? const Color(0xFF322A20) : const Color(0xFFFFF4E6), fg: colorScheme.secondary),
      ])),
      Expanded(child: Row(children: [
        _buildButton("1"), _buildButton("2"), _buildButton("3"),
        _buildButton("+", bg: isDark ? const Color(0xFF322A20) : const Color(0xFFFFF4E6), fg: colorScheme.secondary),
      ])),
      Expanded(child: Row(children: [
        _buildButton("%"),
        _buildButton("0"),
        _buildButton(","),
        _buildButton("=", bg: colorScheme.secondary, fg: Colors.white),
      ])),
    ];

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            "Kalkulator Pintar",
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: isDark ? Colors.white : Colors.black87),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded, size: 22),
            color: isDark ? Colors.white70 : Colors.black54,
            onPressed: _showHistoryBottomSheet,
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, size: 22),
            color: isDark ? Colors.white70 : Colors.black54,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    isDarkMode: widget.isDarkMode,
                    onToggleTheme: widget.onToggleTheme,
                    isSoundEnabled: widget.isSoundEnabled,
                    onToggleSound: widget.onToggleSound,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: _isScientificOpen ? 3 : 4,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(12, 2, 12, 4),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF16161C) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: isDark ? Colors.black.withOpacity(0.4) : Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.bottomRight,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal, reverse: true,
                          child: Text(_equation.isEmpty ? "0" : _equation, style: TextStyle(fontSize: 28, color: isDark ? Colors.white60 : Colors.black45)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal, reverse: true,
                      child: Text(_result, style: TextStyle(fontSize: 46, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => _isScientificOpen = !_isScientificOpen),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 14),
                margin: const EdgeInsets.only(bottom: 1),
                decoration: BoxDecoration(color: isDark ? const Color(0xFF1E1E24) : Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(_isScientificOpen ? Icons.unfold_less_rounded : Icons.unfold_more_rounded, size: 14, color: colorScheme.secondary),
                  const SizedBox(width: 6),
                  Text(_isScientificOpen ? "Mode Standar" : "Mode Ilmiah", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: colorScheme.secondary)),
                ]),
              ),
            ),
            Expanded(
              flex: _isScientificOpen ? 9 : 5,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                child: Column(children: [
                  if (_isScientificOpen) Expanded(flex: 3, child: Column(children: scientificRows)),
                  Expanded(flex: 5, child: Column(children: standardRows)),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
