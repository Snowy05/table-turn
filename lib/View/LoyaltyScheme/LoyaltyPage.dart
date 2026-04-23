import 'package:flutter/material.dart';
import 'package:tableturn_project0/GlobalWidgets/BottomNav.dart';
import 'package:tableturn_project0/View/LoyaltyScheme/QRScannerPage.dart';
import 'BankCardUser.dart';
import 'RewardWidget.dart';
import 'MyRewardWidget.dart';
import 'OpenRewardCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Controller/LoyaltyService.dart';
import '../../Controller/ShopItemsService.dart';
import '../../Model/shopItemModel.dart';

class LoyaltyPage extends StatelessWidget {
  const LoyaltyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final loyaltyService = LoyaltyService();
    final shopItemsService = ShopItemsService();
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Loyalty Scheme'),
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: const [
              Tab(text: 'Shop'),
              Tab(text: 'My Rewards'),
              Tab(text: 'Scan QR'),
            ],
          ),
        ),
        body: user == null
            ? const Center(child: Text('Not logged in'))
            : StreamBuilder<Map<String, dynamic>?>(
                stream: loyaltyService.userStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final data = snapshot.data;
                  if (data == null) {
                    return const Center(child: Text('User data not found'));
                  }
                  final name = data['name'] ?? 'User';
                  final points = data['loyaltyPoints'] ?? 0;
                  return TabBarView(
                    children: [
                      // --- Shop Slide ---
                      ListView(
                        children: [
                          const SizedBox(height: 8),
                          BankCardUser(userName: name, points: points),
                          const SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Text(
                              'Shop Rewards',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: StreamBuilder<List<ShopItem>>(
                              stream: shopItemsService.shopItemsStream(),
                              builder: (context, shopSnapshot) {
                                if (shopSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                final items = shopSnapshot.data ?? [];
                                if (items.isEmpty) {
                                  return const Center(
                                    child: Text('No rewards available.'),
                                  );
                                }
                                return GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 12,
                                        crossAxisSpacing: 12,
                                        childAspectRatio: 1,
                                      ),
                                  itemCount: items.length,
                                  itemBuilder: (context, index) {
                                    final item = items[index];
                                    final canAfford = points >= item.price;
                                    return RewardWidget(
                                      item: item,
                                      isDisabled: !canAfford,
                                      onBuy: canAfford
                                          ? () async {
                                              try {
                                                await loyaltyService.takePoints(
                                                  item.price,
                                                );
                                                //could simplify this method later on
                                                await loyaltyService
                                                    .addRewardToUser(item.id);
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Purchase Successful!',
                                                      ),
                                                    ),
                                                  );
                                                }
                                              } catch (e) {
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Error: \\${e.toString()}',
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }
                                            }
                                          : null,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                      // --- My Rewards Slide ---
                      Builder(
                        builder: (context) {
                          final List<String> rewardIds = List<String>.from(
                            data['rewards'] ?? [],
                          );
                          if (rewardIds.isEmpty) {
                            return const Center(
                              child: Text(
                                'You have not purchased any rewards yet.',
                              ),
                            );
                          }
                          return StreamBuilder<List<ShopItem>>(
                            stream: shopItemsService.shopItemsStream(),
                            builder: (context, shopSnapshot) {
                              if (shopSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              final allItems = shopSnapshot.data ?? [];
                              final myItems = allItems
                                  .where((item) => rewardIds.contains(item.id))
                                  .toList();
                              if (myItems.isEmpty) {
                                return const Center(
                                  child: Text('No matching rewards found.'),
                                );
                              }
                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 12,
                                      crossAxisSpacing: 12,
                                      childAspectRatio: 1,
                                    ),
                                itemCount: myItems.length,
                                itemBuilder: (context, index) {
                                  final item = myItems[index];
                                  return MyRewardWidget(
                                    item: item,
                                    onOpen: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            OpenRewardCard(item: item),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                      // --- Scan QR Slide ---
                      Builder(
                        builder: (context) {
                          return Navigator(
                            onGenerateRoute: (settings) => MaterialPageRoute(
                              builder: (context) => const QRScannerPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
        //DO NOT REMOVE YET
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () async {
        //     // Add a sample reward for development
        //     final sample = ShopItem(
        //       id: '',
        //       name: 'Sample Reward',
        //       assetPath:
        //           'lib/Assets/sample_reward.png', // Update to a real asset path
        //       price: 100,
        //       description: 'A test reward for development.',
        //     );
        //     await shopItemsService.addShopItem(sample);
        //   },
        //   child: const Icon(Icons.add),
        //   tooltip: 'Add sample reward',
        // ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: 3,
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/bookings');
                break;
              case 1:
                Navigator.pushReplacementNamed(context, '/dashboard');
                break;
              case 2:
                Navigator.pushReplacementNamed(context, '/profile');
                break;
              case 3:
                // Already on loyalty page, do nothing
                break;
            }
          },
        ),
      ),
    );
  }
}
