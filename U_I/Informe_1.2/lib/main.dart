import 'package:flutter/material.dart';
import 'view/splash_view.dart';
import 'view/menu_view.dart';
import 'view/venta_view.dart';
import 'view/banco_view.dart';
import 'view/salon_view.dart';
import 'view/caja_view.dart';
import 'view/ventas_analisis_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Laboratorio 2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashView(),
        '/menu': (context) => const MenuView(),
        '/venta': (context) => const VentaPage(),
        '/banco': (context) => const BancoPage(),
        '/salon': (context) => const SalonPage(),
        '/caja': (context) => const CajaPage(),
        '/ventas-analisis': (context) => const VentasAnalisisPage(),
      },
    );
  }
}
