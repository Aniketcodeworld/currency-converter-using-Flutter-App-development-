import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}
// Types of widgets in flutter
//1.Stateless Widget: stateless widget ia a widget that does not require mutable state. It means that the widget's properties cannot change over time. Stateless widgets are immutable and are typically used for static content that does not change during the lifetime of the widget.
//2.Stateful widget: A stateful widget is a widget that can change its state over time. It means that the widget's properties can change during the lifetime of the widget. Stateful widgets are mutable and are typically used for dynamic content that can change based on user interactions or other events.

class MyApp extends StateLessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Text('Hello aniket', textDirection: TextDirection.Ltr);
  }
}
