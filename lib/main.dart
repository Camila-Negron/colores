import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Asegúrate de haber añadido get en tus dependencias
import 'home.dart'; // Asegúrate de que el archivo home.dart esté en el directorio correcto

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Camera App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(), // Home es el widget que definimos para manejar la cámara y la detección de colores
    );
  }
}
