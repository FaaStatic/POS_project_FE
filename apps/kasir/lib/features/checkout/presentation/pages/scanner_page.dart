import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:ui/ui.dart';

import '../../../../l10n/app_localizations.dart';

/// Camera scan; pops with the first code read.
class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  bool _done = false;

  void _detect(BarcodeCapture capture) {
    final code = capture.barcodes.map((b) => b.rawValue).whereType<String>().firstOrNull;
    if (_done || code == null || code.isEmpty) return;
    _done = true;
    Navigator.pop(context, code);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.scan)),
      body: MobileScanner(
        onDetect: _detect,
        errorBuilder: (context, error) => ErrorState(message: error.errorDetails?.message ?? error.errorCode.name),
      ),
    );
  }
}
