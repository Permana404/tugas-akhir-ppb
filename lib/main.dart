import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

// --- Import Providers ---
import 'package:ppb_produk_bawaan/providers/product_provider.dart';
import 'package:ppb_produk_bawaan/providers/auth_provider.dart';
import 'package:ppb_produk_bawaan/providers/cart_provider.dart';

// --- Import Models ---
import 'package:ppb_produk_bawaan/models/product_model.dart';

// --- Import Screens ---
import 'package:ppb_produk_bawaan/screens/list_product_screen.dart';
import 'package:ppb_produk_bawaan/screens/detail_product_screen.dart';
import 'package:ppb_produk_bawaan/screens/edit_product_screen.dart';
import 'package:ppb_produk_bawaan/screens/add_product_screen.dart';
import 'package:ppb_produk_bawaan/screens/login_screen.dart';
import 'package:ppb_produk_bawaan/screens/register_screen.dart';
import 'package:ppb_produk_bawaan/screens/cart_screen.dart';
import 'package:ppb_produk_bawaan/screens/checkout_screen.dart';

final GoRouter _router = GoRouter(
  initialLocation: '/login', // Set halaman pertama kali dibuka ke Login
  routes: [
    // Rute Autentikasi
    GoRoute(path: '/login', builder: (c, s) => const LoginScreen()),
    GoRoute(path: '/register', builder: (c, s) => const RegisterScreen()),

    // Rute Produk (Katalog utama)
    GoRoute(path: '/', builder: (c, s) => const ListProductScreen()),
    GoRoute(
      path: '/detail/:id',
      builder: (c, s) => DetailProductScreen(id: s.pathParameters['id']!),
    ),
    GoRoute(
      path: '/edit/:id',
      builder: (c, s) => EditProductScreen(product: s.extra as Product),
    ),
    GoRoute(path: '/add', builder: (c, s) => const AddProductScreen()),

    // Rute Keranjang & Checkout
    GoRoute(path: '/cart', builder: (c, s) => const CartScreen()),
    GoRoute(path: '/checkout', builder: (c, s) => const CheckoutScreen()),
  ],
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Daftarkan semua provider di sini
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp.router(
        title: 'PPB Produk Bawaan DummyJSON',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
