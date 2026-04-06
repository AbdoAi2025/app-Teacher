import 'package:flutter/material.dart';
import '../services/paymob_native_service.dart';

/// Simple widget demonstrating the new Paymob native SDK integration
class PaymobSimpleWidget extends StatefulWidget {

  final String clientSecret;
  const PaymobSimpleWidget({required this.clientSecret, super.key});

  @override
  State<PaymobSimpleWidget> createState() => _PaymobSimpleWidgetState();
}

class _PaymobSimpleWidgetState extends State<PaymobSimpleWidget> {
  bool _isLoading = false;
  String _result = '';

  Future<void> _payWithPaymob() async {
    setState(() {
      _isLoading = true;
      _result = '';
    });

    try {
      final result = await PaymobNativeService.payWithPaymob(
        clientSecret:  widget.clientSecret,
        appName: 'Teacher App',
        buttonBackgroundColor: 0xFF1976D2, // Blue background
        buttonTextColor: 0xFFFFFFFF, // White text
        saveCardDefault: false,
        showSaveCard: true,
      );

      setState(() {
        _result = result.success
            ? 'Payment successful!\nStatus: ${result.status}'
            : 'Payment failed!\nStatus: ${result.status}\nError: ${result.error}';
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paymob Simple Payment'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Paymob New SDK Integration',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This demo shows how to use the new Paymob SDK v1.4.6 with simplified integration.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Make sure to replace PUBLIC_KEY and CLIENT_SECRET with your actual credentials.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Colors.orange[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _payWithPaymob,
              icon: const Icon(Icons.payment),
              label: const Text('Pay with Paymob'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Processing payment...'),
                  ],
                ),
              )
            else if (_result.isNotEmpty)
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _result.contains('successful')
                                  ? Icons.check_circle
                                  : Icons.error,
                              color: _result.contains('successful')
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Payment Result',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              _result,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontFamily: 'monospace',
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}