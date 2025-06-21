import 'package:flutter/material.dart';
import '../widgets/balance_card.dart';
import '../widgets/crypto_chart.dart';
import '../widgets/transaction_list.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome Back!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            BalanceCard(),
            SizedBox(height: 24),
            Text('Portfolio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 12),
            CryptoChart(),
            SizedBox(height: 24),
            Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 12),
            TransactionList(),
          ],
        ),
      ),
    );
  }
} 