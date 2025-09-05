import 'package:finans_takip_app/src/features/accounts/presentation/accounts_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finans_takip_app/src/features/transactions/presentation/transactions_screen.dart';
import 'package:finans_takip_app/src/features/dashboard/presentation/widgets/net_worth_card.dart';
import 'package:finans_takip_app/src/features/dashboard/presentation/widgets/asset_liability_pie_chart.dart';
import 'package:finans_takip_app/src/features/settings/presentation/settings_screen.dart';
import 'package:finans_takip_app/src/features/dashboard/presentation/widgets/category_expense_pie_chart.dart';
import 'package:finans_takip_app/src/features/dashboard/presentation/widgets/recent_transactions_list.dart';



class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0; // Başlangıçta seçili olan sekme indeksi

  // Navigasyon barında görünecek olan sayfaların listesi
  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),   // Index 0
    TransactionsScreen(),// Index 1
    AccountsScreen(),    // Index 2
    SettingsScreen(),   // Index 3
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack, sekmeler arasında geçiş yaparken sayfaların durumunu
      // (scroll pozisyonu vb.) korur. Bu, daha iyi bir kullanıcı deneyimi sağlar.
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'İşlemler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'Hesaplar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ayarlar',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey, // Seçili olmayan item'ların rengi
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // 3'ten fazla item olursa kullanışlıdır
      ),
    );
  }
}
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              NetWorthCard(),
              // Buraya daha sonra grafikler gelecek
              SizedBox(height: 16),
              AssetLiabilityPieChart(),
              SizedBox(height: 16),
              CategoryExpensePieChart(),
              SizedBox(height: 16),
              RecentTransactionsList()
            ],
          ),
        ),
      ),
    );
  }
}
