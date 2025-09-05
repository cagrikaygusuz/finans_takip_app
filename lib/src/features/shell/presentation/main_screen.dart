import 'package:finans_takip_app/src/features/accounts/presentation/accounts_screen.dart';
import 'package:finans_takip_app/src/features/dashboard/presentation/widgets/asset_liability_pie_chart.dart';
import 'package:finans_takip_app/src/features/dashboard/presentation/widgets/category_expense_pie_chart.dart';
import 'package:finans_takip_app/src/features/dashboard/presentation/widgets/net_worth_card.dart';
import 'package:finans_takip_app/src/features/dashboard/presentation/widgets/recent_transactions_list.dart';
import 'package:finans_takip_app/src/features/settings/presentation/settings_screen.dart';
import 'package:finans_takip_app/src/features/transactions/presentation/transactions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    TransactionsScreen(),
    AccountsScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Her bir widget'ı .animate() ile sarmalayarak animasyon ekliyoruz.
            // Her birinin gecikmesini (delay) artırarak sıralı bir şekilde gelmelerini sağlıyoruz.
            const NetWorthCard().animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.2),
            const CategoryExpensePieChart().animate().fadeIn(delay: 300.ms, duration: 400.ms).slideY(begin: 0.2),
            const AssetLiabilityPieChart().animate().fadeIn(delay: 400.ms, duration: 400.ms).slideY(begin: 0.2),
            const RecentTransactionsList().animate().fadeIn(delay: 500.ms, duration: 400.ms).slideY(begin: 0.2),
          ],
        ),
      ),
    );
  }
}