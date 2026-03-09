// import 'package:flutter/material.dart';
// import '../services/paymob_client.dart';
// import '../services/paymob_native_service.dart';
//
// /// Example widget demonstrating Paymob native SDK integration
// class PaymobPaymentWidget extends StatefulWidget {
//   const PaymobPaymentWidget({Key? key}) : super(key: key);
//
//   @override
//   State<PaymobPaymentWidget> createState() => _PaymobPaymentWidgetState();
// }
//
// class _PaymobPaymentWidgetState extends State<PaymobPaymentWidget> {
//   bool _isLoading = false;
//   String _result = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _initializePaymob();
//   }
//
//   void _initializePaymob() {
//     // Initialize Paymob client with your credentials
//     PaymobClient.instance.initialize(
//       apiKey: 'YOUR_API_KEY', // Replace with your actual API key
//       integrationId: 123456, // Replace with your actual integration ID
//       walletIntegrationId: 654321, // Replace with your actual wallet integration ID
//       iframeId: 789012, // Replace with your actual iframe ID
//     );
//   }
//
//   Future<void> _payWithCard() async {
//     setState(() {
//       _isLoading = true;
//       _result = '';
//     });
//
//     try {
//       final billingData = PaymobBillingData(
//         firstName: 'John',
//         lastName: 'Doe',
//         email: 'john.doe@example.com',
//         phone: '+201234567890',
//         city: 'Cairo',
//         country: 'Egypt',
//       );
//
//       final result = await PaymobClient.instance.payWithCard(
//         amountCents: 10000, // 100 EGP
//         billingData: billingData,
//         items: [
//           const PaymobOrderItem(
//             name: 'Test Product',
//             description: 'Test product description',
//             amountCents: 10000,
//             quantity: 1,
//           ),
//         ],
//         saveCard: true, // Enable save card option
//       );
//
//       setState(() {
//         _result = result.success
//             ? 'Payment successful!\n'
//                 'Transaction ID: ${result.transactionId}\n'
//                 'Paymob Transaction ID: ${result.paymobTransactionId}\n'
//                 'Card Type: ${result.cardSubtype}\n'
//                 'Masked PAN: ${result.maskedPan}\n'
//                 'Order ID: ${result.orderId}'
//                 '${result.cardToken != null ? '\nCard Token: ${result.cardToken}' : ''}'
//             : 'Payment failed: ${result.error}';
//       });
//     } catch (e) {
//       setState(() {
//         _result = 'Error: $e';
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _payWithWallet() async {
//     setState(() {
//       _isLoading = true;
//       _result = '';
//     });
//
//     try {
//       final billingData = PaymobBillingData(
//         firstName: 'John',
//         lastName: 'Doe',
//         email: 'john.doe@example.com',
//         phone: '+201234567890',
//         city: 'Cairo',
//         country: 'Egypt',
//       );
//
//       final result = await PaymobClient.instance.payWithWallet(
//         amountCents: 10000, // 100 EGP
//         billingData: billingData,
//         redirectUrl: 'https://your-app.com/payment/callback',
//         items: [
//           const PaymobOrderItem(
//             name: 'Test Product',
//             description: 'Test product description',
//             amountCents: 10000,
//             quantity: 1,
//           ),
//         ],
//       );
//
//       setState(() {
//         _result = result.success
//             ? 'Wallet payment successful!\n'
//                 'Transaction ID: ${result.transactionId}\n'
//                 'Paymob Transaction ID: ${result.paymobTransactionId}\n'
//                 'Order ID: ${result.orderId}'
//             : 'Wallet payment failed: ${result.error}';
//       });
//     } catch (e) {
//       setState(() {
//         _result = 'Error: $e';
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _saveCard() async {
//     setState(() {
//       _isLoading = true;
//       _result = '';
//     });
//
//     try {
//       final billingData = PaymobBillingData(
//         firstName: 'John',
//         lastName: 'Doe',
//         email: 'john.doe@example.com',
//         phone: '+201234567890',
//         city: 'Cairo',
//         country: 'Egypt',
//       );
//
//       final result = await PaymobClient.instance.saveCard(
//         billingData: billingData,
//       );
//
//       setState(() {
//         _result = result.success
//             ? 'Card saved successfully!\n'
//                 'Card Token: ${result.cardToken}\n'
//                 'Masked PAN: ${result.cardMaskedPan}\n'
//                 'Card Type: ${result.cardSubtype}'
//             : 'Card save failed: ${result.error}';
//       });
//     } catch (e) {
//       setState(() {
//         _result = 'Error: $e';
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Paymob Payment Demo'),
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         foregroundColor: Theme.of(context).colorScheme.onPrimary,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Paymob Native SDK Integration',
//                       style: Theme.of(context).textTheme.headlineSmall,
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'This demo shows how to integrate Paymob native Android and iOS SDKs with Flutter.',
//                       style: Theme.of(context).textTheme.bodyMedium,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             _buildPaymentButton(
//               'Pay with Card (100 EGP)',
//               Icons.credit_card,
//               _payWithCard,
//               Colors.blue,
//             ),
//             const SizedBox(height: 12),
//             _buildPaymentButton(
//               'Pay with Wallet (100 EGP)',
//               Icons.account_balance_wallet,
//               _payWithWallet,
//               Colors.green,
//             ),
//             const SizedBox(height: 12),
//             _buildPaymentButton(
//               'Save Card (No Payment)',
//               Icons.save,
//               _saveCard,
//               Colors.orange,
//             ),
//             const SizedBox(height: 24),
//             if (_isLoading)
//               const Center(
//                 child: CircularProgressIndicator(),
//               )
//             else if (_result.isNotEmpty)
//               Expanded(
//                 child: Card(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Icon(
//                               _result.startsWith('Payment successful') ||
//                                       _result.startsWith('Wallet payment successful') ||
//                                       _result.startsWith('Card saved successfully')
//                                   ? Icons.check_circle
//                                   : Icons.error,
//                               color: _result.startsWith('Payment successful') ||
//                                       _result.startsWith('Wallet payment successful') ||
//                                       _result.startsWith('Card saved successfully')
//                                   ? Colors.green
//                                   : Colors.red,
//                             ),
//                             const SizedBox(width: 8),
//                             Text(
//                               'Payment Result',
//                               style: Theme.of(context).textTheme.titleMedium,
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 12),
//                         Expanded(
//                           child: SingleChildScrollView(
//                             child: Text(
//                               _result,
//                               style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                                     fontFamily: 'monospace',
//                                   ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPaymentButton(
//     String text,
//     IconData icon,
//     VoidCallback onPressed,
//     Color color,
//   ) {
//     return ElevatedButton.icon(
//       onPressed: _isLoading ? null : onPressed,
//       icon: Icon(icon),
//       label: Text(text),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: color,
//         foregroundColor: Colors.white,
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//       ),
//     );
//   }
// }