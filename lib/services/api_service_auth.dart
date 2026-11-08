import 'dart:convert';

import '../models/user_model.dart';

// import 'package:http/http.dart' as http; // Buka komentar ini jika nanti pakai API sungguhan

class ApiServiceAuth {
  // Contoh baseUrl jika nanti memakai API sungguhan
  // final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<UserModel?> login(String email, String password) async {
    // Simulasi delay request ke server
    await Future.delayed(const Duration(seconds: 1));

    // Logika simulasi API
    if (email.isNotEmpty && password.isNotEmpty) {
      return UserModel(
        id: '1',
        email: email,
        name: email.split('@')[0], // Mengambil nama dari email
      );
    }
    return null; // Mengembalikan null jika gagal
  }

  Future<bool> register(String name, String email, String password) async {
    // Simulasi delay request ke server
    await Future.delayed(const Duration(seconds: 1));

    // Logika simulasi API
    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      return true; // Berhasil register
    }
    return false; // Gagal register
  }
}
