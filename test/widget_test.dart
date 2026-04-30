import 'package:flutter_test/flutter_test.dart';
import 'package:checalo_app/main.dart';

void main() {
  testWidgets('Prueba inicial de Chécalo', (WidgetTester tester) async {
    await tester.pumpWidget(const CheckaloApp());
    expect(find.text('Chécalo'), findsOneWidget);
  });
}