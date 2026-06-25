import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalkulator/main.dart';

void main() {
  testWidgets('Calculator UI smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CalculatorApp());

    // Verifikasi judul aplikasi muncul
    expect(find.text('Kalkulator Pintar'), findsOneWidget);

    // Verifikasi angka awal adalah 0
    expect(find.text('0'), findsNWidgets(2)); // Satu di equation (karena kosong), satu di result

    // Verifikasi beberapa tombol utama ada di layar
    expect(find.text('AC'), findsOneWidget);
    expect(find.text('='), findsOneWidget);
    expect(find.text('7'), findsOneWidget);
    expect(find.text('÷'), findsOneWidget);
  });

  testWidgets('Basic calculation test', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());

    // Tekan angka 7
    await tester.tap(find.text('7'));
    await tester.pump();

    // Tekan tambah (+)
    await tester.tap(find.text('+'));
    await tester.pump();

    // Tekan angka 5
    await tester.tap(find.text('5'));
    await tester.pump();

    // Verifikasi layar menampilkan "7+5"
    expect(find.text('7+5'), findsOneWidget);

    // Tekan sama dengan (=)
    await tester.tap(find.text('='));
    await tester.pump();

    // Verifikasi hasil 12 muncul (di bagian result)
    expect(find.text('12'), findsOneWidget);
  });
}
