import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iadaf/app.dart';
import 'package:iadaf/features/home/presentation/home_screen.dart';

void main() {
  testWidgets('the application starts on the home screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: IadafApp()));
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
