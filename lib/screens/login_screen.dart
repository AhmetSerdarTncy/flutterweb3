import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_screen.dart';
import 'profile_screen.dart';
import 'dart:math';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  String _status = '';
  bool _loading = false;

  String _generateRandomIdentity() {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    return List.generate(16, (index) => chars[rand.nextInt(chars.length)]).join();
  }

  Future<void> _loginWithBiometrics() async {
    setState(() { _loading = true; _status = ''; });
    
    // Önce kullanıcının kayıtlı olup olmadığını kontrol et
    final prefs = await SharedPreferences.getInstance();
    final hasUser = prefs.containsKey('username');
    
    if (!hasUser) {
      setState(() { _loading = false; });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => RegisterScreen()),
      );
      return;
    }

    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Giriş için parmak izinizi okutun',
        options: const AuthenticationOptions(biometricOnly: true, stickyAuth: true),
      );
    } catch (e) {
      setState(() { _status = 'Hata: $e'; _loading = false; });
      return;
    }
    
    if (authenticated) {
      // Başarılı giriş - yeni kimlik oluştur ve kaydet
      final identity = _generateRandomIdentity();
      await prefs.setString('identity', identity);
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ProfileScreen()),
      );
    } else {
      setState(() { _status = 'Doğrulama başarısız'; _loading = false; });
      // Başarısızsa otomatik olarak kayıt ekranına yönlendir
      await Future.delayed(Duration(milliseconds: 500));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => RegisterScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 64, color: Colors.deepPurple),
              SizedBox(height: 24),
              Text('Giriş Yap', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              SizedBox(height: 32),
              ElevatedButton.icon(
                icon: Icon(Icons.fingerprint, size: 32),
                label: Text('Parmak İzi ile Giriş'),
                onPressed: _loading ? null : _loginWithBiometrics,
                style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 56)),
              ),
              SizedBox(height: 16),
              if (_status.isNotEmpty) Text(_status, style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
} 