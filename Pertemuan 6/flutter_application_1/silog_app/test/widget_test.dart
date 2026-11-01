import 'package:flutter_test/flutter_test.dart';
import 'package:silog_app/main.dart';

void main() {
  testWidgets('SiLog menampilkan halaman daftar pengiriman',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SiLogApp());

    expect(find.text('Daftar Pengiriman'), findsOneWidget);
    expect(find.text('Semua'), findsOneWidget);
    expect(find.text('Dalam Perjalanan'), findsWidgets);
    expect(find.text('Diterima'), findsWidgets);
  });
}
