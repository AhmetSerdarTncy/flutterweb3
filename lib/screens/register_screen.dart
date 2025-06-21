import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'dart:math';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  String _status = '';
  String? _username;
  bool _loading = false;

  String _generateRandomUsername() {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    return List.generate(16, (index) => chars[rand.nextInt(chars.length)]).join();
  }

  String _generateRandomIdentity() {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    return List.generate(16, (index) => chars[rand.nextInt(chars.length)]).join();
  }

  @override
  void initState() {
    super.initState();
    // Ekran açıldığında otomatik olarak parmak izi kaydı başlat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _autoRegister();
    });
  }

  Future<void> _autoRegister() async {
    setState(() { _loading = true; _status = 'Parmak izi kaydı başlatılıyor...'; });
    
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Kayıt için parmak izinizi okutun',
        options: const AuthenticationOptions(biometricOnly: true, stickyAuth: true),
      );
    } catch (e) {
      setState(() { _status = 'Hata: $e'; _loading = false; });
      return;
    }
    
    if (authenticated) {
      final username = _generateRandomUsername();
      final identity = _generateRandomIdentity();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);
      await prefs.setString('identity', identity);
      
      setState(() { 
        _username = username; 
        _status = 'Kayıt başarılı! Kullanıcı adınız: $username'; 
        _loading = false; 
      });
      
      await Future.delayed(Duration(seconds: 2));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    } else {
      setState(() { _status = 'Doğrulama başarısız'; _loading = false; });
    }
  }

  Future<void> _registerWithBiometrics() async {
    _autoRegister();
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
              Icon(Icons.person_add, size: 64, color: Colors.deepPurple),
              SizedBox(height: 24),
              Text('Kayıt Ol', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              SizedBox(height: 32),
              if (_loading) 
                CircularProgressIndicator()
              else
                ElevatedButton.icon(
                  icon: Icon(Icons.fingerprint, size: 32),
                  label: Text('Tekrar Parmak İzi ile Kayıt Ol'),
                  onPressed: _registerWithBiometrics,
                  style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 56)),
                ),
              SizedBox(height: 16),
              if (_status.isNotEmpty) Text(_status, style: TextStyle(color: Colors.green)),
              if (_username != null) ...[
                SizedBox(height: 8),
                Text('Kullanıcı adınız: $_username', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ],
          ),
        ),
      ),
    );
  }
} 