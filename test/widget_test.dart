import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:teacher_app/main.dart';
import 'package:teacher_app/services/api_service.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // ✅ إنشاء `ApiService`


    // ✅ تمرير `apiService` عند إنشاء `MyApp`
    await tester.pumpWidget(MyApp());

    // ✅ تحقق من أن العداد يبدأ من 0
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // ✅ اضغط على زر الإضافة
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // ✅ تحقق من أن العداد أصبح 1
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
