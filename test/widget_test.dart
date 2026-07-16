import 'package:flutter_test/flutter_test.dart';
import 'package:nawa_flutter/main.dart';

void main() {
  testWidgets('App renders onboarding screen', (WidgetTester tester) async {
    await tester.pumpWidget(const NawahApp());
    expect(find.text('نواة'), findsOneWidget);
    expect(find.text('التالي'), findsOneWidget);
    expect(find.text('لدي حساب بالفعل'), findsOneWidget);
  });
}
