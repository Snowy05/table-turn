import 'package:flutter/material.dart';
import 'dart:math';

class BankCardUser extends StatelessWidget {
  final String userName;
  final int points;

  const BankCardUser({Key? key, required this.userName, required this.points})
    : super(key: key);

  String getRandomCardNumber() {
    final rand = Random();
    return List.generate(
      4,
      (_) => (1000 + rand.nextInt(9000)).toString(),
    ).join(' ');
  }

  String getRandomExpiry() {
    final rand = Random();
    int month = rand.nextInt(12) + 1;
    int year = 28 + rand.nextInt(3); // e.g., 28, 29, 30
    return '${month.toString().padLeft(2, '0')}/$year';
  }

  @override
  Widget build(BuildContext context) {
    final cardNumber = getRandomCardNumber(); // simulate a card number
    final expiry = getRandomExpiry(); // simulate an expiry date
      return Align(
        alignment: Alignment.topCenter,
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 400,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF8D6748), 
                Color(0xFFBCA17A), 
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Optional: Logo or chip
              Icon(Icons.credit_card, color: Colors.white70, size: 32),
              Text(
                'LOYALTY CARD',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //user name and card holder text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'CARD HOLDER',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
              // Digital-style points
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  //points in digital font style, padded to 5 digits with leading zeros
                  points.toString().padLeft(5, '0'),
                  style: const TextStyle(
                    fontFamily: 'RobotoMono',
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    letterSpacing: 2,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 4,
                        offset: Offset(1, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //card number
              Text(
                cardNumber,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  letterSpacing: 2,
                  fontFamily: 'RobotoMono',
                ),
              ),
              // expiry
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'VALID THRU',
                    style: TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                  Text(
                    expiry,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'RobotoMono',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
        ),
    );
  }
}
