import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  final List<Map<String, dynamic>> assets = [
    {
      'symbol': 'USDC',
      'icon': Icons.account_balance_wallet,
      'amount': 3745.0,
      'usdcValue': 3745.0,
    },
    {
      'symbol': 'ETH',
      'icon': Icons.currency_bitcoin,
      'amount': 0.0002,
      'usdcValue': 250.0,
    },
    // Buraya başka coinler eklenebilir
  ];

  @override
  Widget build(BuildContext context) {
    double totalUsdc = assets.fold(0, (sum, item) => sum + (item['usdcValue'] as double));
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.blue.shade50,
                child: Icon(Icons.account_balance_wallet, size: 32, color: Colors.blue),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Toplam Bakiye', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                  SizedBox(height: 4),
                  Text(
                    '${totalUsdc.toStringAsFixed(2)} USDC',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blue[900]),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 32),
          Text('Varlıklarım', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: assets.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                final asset = assets[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey.shade200,
                    child: Icon(asset['icon'], color: Colors.blue),
                  ),
                  title: Text(
                    asset['symbol'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(
                    '${asset['amount']} ${asset['symbol']}',
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: Text(
                    '${asset['usdcValue'].toStringAsFixed(2)} USDC',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green[700]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 