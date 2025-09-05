import 'package:finans_takip_app/src/features/accounts/data/account_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccountCard extends StatelessWidget {
  final Account account;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AccountCard({
    super.key,
    required this.account,
    this.isSelected = false,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  IconData _getIconForAccountType(AccountType type) {
    switch (type) {
      case AccountType.bank:
        return Icons.account_balance_outlined;
      case AccountType.cash:
        return Icons.wallet_outlined;
      case AccountType.creditCard:
        return Icons.credit_card_outlined;
      case AccountType.investment:
        return Icons.trending_up_rounded;
      case AccountType.loan:
        return Icons.receipt_long_outlined;
      case AccountType.timeDeposit:
        return Icons.savings_outlined;
      default:
        return Icons.question_mark;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');
    
    // Koyu temada karta hafif bir gradient ve farklı bir renk verelim
    final cardColor = theme.brightness == Brightness.dark ? theme.colorScheme.surface : theme.cardTheme.color;
    final cardDecoration = theme.brightness == Brightness.dark
        ? BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.surface.withOpacity(0.9),
                theme.colorScheme.surface,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          )
        : null;


    return Card(
      // Card'ın kendi elevation'ı yerine Container'a gölge vererek daha iyi kontrol sağlayacağız
      elevation: 0, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: isSelected
            ? BorderSide(color: theme.colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: cardDecoration,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                      child: Icon(
                        _getIconForAccountType(account.type),
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        account.name,
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Menü butonu (Düzenle/Sil için)
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit' && onEdit != null) {
                          onEdit!();
                        } else if (value == 'delete' && onDelete != null) {
                          onDelete!();
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: ListTile(leading: Icon(Icons.edit), title: Text('Düzenle')),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: ListTile(leading: Icon(Icons.delete), title: Text('Sil')),
                        ),
                      ],
                      icon: Icon(Icons.more_vert, color: Colors.grey.shade500),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Bakiye',
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
                ),
                Text(
                  currencyFormat.format(account.balance),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: account.balance >= 0 ? null : Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}