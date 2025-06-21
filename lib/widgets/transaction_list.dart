import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final List<Map<String, dynamic>> transactions = [
    {'icon': Icons.call_made, 'title': 'Sent Bitcoin', 'amount': '-0.01 BTC', 'subtitle': 'To 1A2b3C...', 'color': Colors.redAccent},
    {'icon': Icons.call_received, 'title': 'Received Ethereum', 'amount': '+0.5 ETH', 'subtitle': 'From 4D5e6F...', 'color': Colors.green},
    {'icon': Icons.call_made, 'title': 'Sent USDT', 'amount': '-100 USDT', 'subtitle': 'To 7G8h9I...', 'color': Colors.redAccent},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: transactions.map((tx) => Card(
        child: ListTile(
          leading: Icon(tx['icon'], color: tx['color']),
          title: Text(tx['title']),
          subtitle: Text(tx['subtitle']),
          trailing: Text(tx['amount'], style: TextStyle(color: tx['color'], fontWeight: FontWeight.bold)),
        ),
      )).toList(),
    );
  }
} 