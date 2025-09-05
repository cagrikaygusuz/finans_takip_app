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
        return Icons.account_balance;
      case AccountType.cash:
        return Icons.wallet;
      case AccountType.creditCard:
        return Icons.credit_card;
      case AccountType.investment:
        return Icons.trending_up;
      case AccountType.loan:
        return Icons.receipt_long;
      case AccountType.timeDeposit:
        return Icons.savings;
      default:
        return Icons.question_mark;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');
    return Card(
      elevation: isSelected ? 8.0 : 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: isSelected
            ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(_getIconForAccountType(account.type), color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      account.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (onEdit != null)
                    IconButton(
                      icon: Icon(Icons.edit, size: 20, color: Colors.grey.shade600),
                      onPressed: onEdit,
                      tooltip: 'Düzenle',
                    ),
                  if (onDelete != null)
                    IconButton(
                      icon: Icon(Icons.delete, size: 20, color: Colors.grey.shade600),
                      onPressed: onDelete,
                      tooltip: 'Sil',
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  currencyFormat.format(account.balance),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: account.balance >= 0 ? Colors.green.shade700 : Colors.red.shade700,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}