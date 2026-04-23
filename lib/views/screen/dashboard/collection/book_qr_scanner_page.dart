import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:test_your_learing/constants/colors.dart';

class BookQrScannerPage extends StatefulWidget {
  const BookQrScannerPage({super.key});

  @override
  State<BookQrScannerPage> createState() => _BookQrScannerPageState();
}

class _BookQrScannerPageState extends State<BookQrScannerPage> {
  final MobileScannerController _scannerController = MobileScannerController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  String? _extractCouponCode(String rawValue) {
    final String trimmed = rawValue.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    try {
      final dynamic decoded = jsonDecode(trimmed);
      if (decoded is Map && decoded['couponCode'] is String) {
        final String code = (decoded['couponCode'] as String).trim();
        if (code.isNotEmpty) {
          return code;
        }
      }
    } catch (_) {}

    try {
      final Uri uri = Uri.parse(trimmed);
      final String? queryCoupon =
          uri.queryParameters['couponCode'] ?? uri.queryParameters['coupon'];
      if (queryCoupon != null && queryCoupon.trim().isNotEmpty) {
        return queryCoupon.trim();
      }
    } catch (_) {}

    final RegExpMatch? match = RegExp(r'CPN-[A-Za-z0-9-]+').firstMatch(trimmed);
    if (match != null) {
      return match.group(0)?.trim();
    }

    return trimmed;
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) {
      return;
    }

    final String? rawValue = capture.barcodes
        .map((barcode) => barcode.rawValue)
        .firstWhere(
          (value) => value != null && value.trim().isNotEmpty,
          orElse: () => null,
        );

    if (rawValue == null) {
      return;
    }

    final String? couponCode = _extractCouponCode(rawValue);
    if (couponCode == null || couponCode.isEmpty) {
      return;
    }

    _isProcessing = true;
    if (mounted) {
      Navigator.of(context).pop(couponCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Scan QR To Subscribe'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => _scannerController.toggleTorch(),
            icon: const Icon(Icons.flash_on),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(controller: _scannerController, onDetect: _onDetect),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: primarycolor, width: 3),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              color: Colors.black.withAlpha(180),
              child: const Text(
                'Scan the QR code in your book to subscribe.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
