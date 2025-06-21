import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'home_screen.dart';
import 'wallet_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  String _authStatus = '';
  int _currentIndex = 2;
  String? _identity;

  final List<Widget> _screens = [
    HomeScreen(),
    WalletScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadIdentity();
  }

  Future<void> _loadIdentity() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIdentity = prefs.getString('identity');
    if (savedIdentity != null) {
      setState(() {
        _identity = savedIdentity;
      });
    }
  }

  String _generateRandomIdentity() {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    return List.generate(16, (index) => chars[rand.nextInt(chars.length)]).join();
  }

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
        _identity = _generateRandomIdentity();
        _authStatus = 'Kimlik başarıyla oluşturuldu!';
      } else {
        _authStatus = 'Tanımsız parmak izi veya doğrulama başarısız';
      }
    });
  }

  Widget _buildProfileContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                radius: 56,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 64, color: Colors.grey[600]),
              ),
            ),
            SizedBox(height: 24),
            Text('Profil', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                child: Column(
                  children: [
                    Text('Kimlik Numarası', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                    SizedBox(height: 8),
                    Text(_identity ?? 'Henüz kimlik oluşturulmadı',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton.icon(
              icon: Icon(Icons.fingerprint, size: 32),
              label: Text('Parmak İzi ile Kimlik Oluştur'),
              onPressed: _authenticate,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 56),
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            SizedBox(height: 16),
            if (_authStatus.isNotEmpty)
              Text(_authStatus, style: TextStyle(fontSize: 16, color: _authStatus.startsWith('Hata') ? Colors.red : Colors.green)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 2 ? _buildProfileContent() : _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
} 