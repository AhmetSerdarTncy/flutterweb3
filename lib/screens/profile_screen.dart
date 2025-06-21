import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  String _authStatus = '';

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Parmak izinizi doğrulayın',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      setState(() {
        _authStatus = 'Hata: $e';
      });
      return;
    }
    setState(() {
      if (authenticated) {
        _authStatus = 'Kayıtlı parmak izi';
      } else {
        _authStatus = 'Tanımsız parmak izi veya doğrulama başarısız';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Profile Screen', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.fingerprint, size: 32),
              label: Text('Parmak İzi ile Doğrula'),
              onPressed: _authenticate,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 56),
              ),
            ),
            SizedBox(height: 12),
            Text(_authStatus, style: TextStyle(fontSize: 16, color: Colors.blue)),
          ],
        ),
      ),
    );
  }
} 