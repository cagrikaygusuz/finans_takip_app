import 'package:flutter/material.dart';

// Bu fonksiyon, bir onay diyaloğu gösterir ve kullanıcının seçimine göre
// true (onayladı) veya false (iptal etti) döndürür.
Future<bool> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  String confirmText = 'Evet, Sil',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // İptal'e basılınca false döndür
            child: const Text('İptal'),
          ),
          FilledButton.tonal( // Daha vurgulu bir silme butonu
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade100,
              foregroundColor: Colors.red.shade800,
            ),
            onPressed: () => Navigator.of(context).pop(true), // Onay'a basılınca true döndür
            child: Text(confirmText),
          ),
        ],
      );
    },
  );
  // Eğer diyalog bir butona basılmadan kapanırsa null dönebilir, bu yüzden null ise false kabul ediyoruz.
  return result ?? false;
}