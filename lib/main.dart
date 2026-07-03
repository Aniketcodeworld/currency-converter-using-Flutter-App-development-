import 'package:flutter/material.dart';

/// Entry point of the Flutter application.
/// Starts the app by loading MyApp widget.
void main() {
  runApp(const MyApp());
}

/// Root widget of the application.
/// Configures the app theme and sets the home screen.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes debug banner
      title: 'Currency Calculator',

      // Defines the overall theme of the application
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
        useMaterial3: true,
      ),

      // First screen displayed after launching the app
      home: const CurrencyCalculatorPage(),
    );
  }
}

/// Stateful widget because currency values
/// change whenever user enters amount or selects currencies.
class CurrencyCalculatorPage extends StatefulWidget {
  const CurrencyCalculatorPage({super.key});

  @override
  State<CurrencyCalculatorPage> createState() => _CurrencyCalculatorPageState();
}

class _CurrencyCalculatorPageState extends State<CurrencyCalculatorPage> {
  /// Stores exchange rates with INR as the base currency.
  /// Used for converting between any two currencies.
  static const Map<String, double> _ratesToInr = {
    'USD': 83.0,
    'INR': 1.0,
    'NPR': 0.63,
    'EUR': 90.0,
    'GBP': 105.0,
    'JPY': 0.56,
    'AUD': 55.0,
    'CAD': 61.0,
  };

  /// Controls the amount input field.
  /// Default value is set to 1.
  final TextEditingController _amountController = TextEditingController(
    text: '1',
  );

  /// Stores selected source currency.
  String _fromCurrency = 'USD';

  /// Stores selected destination currency.
  String _toCurrency = 'INR';

  /// Releases memory occupied by the controller
  /// when widget is removed from the widget tree.
  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  /// Calculates converted amount.
  ///
  /// Formula:
  /// Convert source currency to INR,
  /// then convert INR to destination currency.
  double get _convertedAmount {
    final amount = double.tryParse(_amountController.text) ?? 0;

    final fromRate = _ratesToInr[_fromCurrency] ?? 1;
    final toRate = _ratesToInr[_toCurrency] ?? 1;

    return amount * fromRate / toRate;
  }

  /// Swaps the selected source and destination currencies.
  /// Triggered when swap button is pressed.
  void _swapCurrencies() {
    setState(() {
      final previousFrom = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = previousFrom;
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Stores latest converted amount
    /// so it can be displayed in the UI.
    final result = _convertedAmount;

    return Scaffold(
      body: Container(
        // Background gradient of the application
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF3F7FF), Color(0xFFE6FFF9)],
          ),
        ),

        child: SafeArea(
          // Prevents UI from overlapping with status bar/notch
          child: Center(
            child: SingleChildScrollView(
              // Makes UI scrollable on smaller screens
              padding: const EdgeInsets.all(20),

              child: ConstrainedBox(
                // Limits maximum width for tablets/web
                constraints: const BoxConstraints(maxWidth: 520),

                child: Card(
                  // Main container holding calculator UI
                  elevation: 10,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(24),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        /// App heading
                        const Text(
                          'Currency Calculator',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 8),

                        /// Short description
                        Text(
                          'Sample exchange rates for quick conversions like USD to INR or INR to NPR.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.black54),
                        ),

                        const SizedBox(height: 24),

                        /// Input field where user enters amount
                        TextField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),

                          decoration: InputDecoration(
                            labelText: 'Amount',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),

                          /// Recalculate amount whenever user types
                          onChanged: (_) => setState(() {}),
                        ),

                        const SizedBox(height: 16),

                        /// Row containing:
                        /// Source Currency
                        /// Swap Button
                        /// Destination Currency
                        Row(
                          children: [
                            /// Source currency dropdown
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _fromCurrency,

                                decoration: InputDecoration(
                                  labelText: 'From',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),

                                items: _ratesToInr.keys
                                    .map(
                                      (currency) => DropdownMenuItem(
                                        value: currency,
                                        child: Text(currency),
                                      ),
                                    )
                                    .toList(),

                                onChanged: (value) {
                                  if (value == null) return;

                                  setState(() => _fromCurrency = value);
                                },
                              ),
                            ),

                            const SizedBox(width: 12),

                            /// Button to swap currencies
                            FloatingActionButton.small(
                              heroTag: 'swap',
                              onPressed: _swapCurrencies,
                              child: const Icon(Icons.swap_horiz),
                            ),

                            const SizedBox(width: 12),

                            /// Destination currency dropdown
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _toCurrency,

                                decoration: InputDecoration(
                                  labelText: 'To',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),

                                items: _ratesToInr.keys
                                    .map(
                                      (currency) => DropdownMenuItem(
                                        value: currency,
                                        child: Text(currency),
                                      ),
                                    )
                                    .toList(),

                                onChanged: (value) {
                                  if (value == null) return;

                                  setState(() => _toCurrency = value);
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        /// Card displaying converted amount
                        Container(
                          padding: const EdgeInsets.all(20),

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),

                            gradient: const LinearGradient(
                              colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
                            ),

                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x330F766E),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),

                          child: Column(
                            children: [
                              /// Result heading
                              const Text(
                                'Converted Amount',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),

                              const SizedBox(height: 10),

                              /// Displays converted value
                              FittedBox(
                                child: Text(
                                  '${_formatAmount(result)} $_toCurrency',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),

                              /// Shows exchange rate
                              Text(
                                '1 $_fromCurrency = ${_formatAmount(_ratesToInr[_fromCurrency]! / _ratesToInr[_toCurrency]!)} $_toCurrency',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// Displays some commonly used currency pairs
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: const [
                            _QuickPairChip(label: 'USD to INR'),
                            _QuickPairChip(label: 'INR to NPR'),
                            _QuickPairChip(label: 'EUR to USD'),
                            _QuickPairChip(label: 'GBP to INR'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Formats decimal values by removing
  /// unnecessary trailing zeros.
  ///
  /// Example:
  /// 150.00 → 150
  /// 150.50 → 150.5
  String _formatAmount(double value) {
    final fixed = value.toStringAsFixed(2);

    if (fixed.endsWith('.00')) {
      return fixed.substring(0, fixed.length - 3);
    }

    return fixed
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }
}

/// Widget representing a quick currency pair chip.
class _QuickPairChip extends StatelessWidget {
  const _QuickPairChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      // Displays currency pair name
      label: Text(label),

      // Background color of chip
      backgroundColor: Colors.white.withOpacity(0.85),

      // Border color
      side: BorderSide(color: Colors.tealAccent.shade100),
    );
  }
}
