import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../models/investment.dart';
import '../models/ppf_payment.dart';
import '../utils/number_formatter.dart';
import '../utils/date_utils.dart';
import '../providers/ppf_payment_provider.dart';

class PPFPaymentHistoryScreen extends StatefulWidget {
  final Investment ppfAccount;
  final bool showAddDialog;

  const PPFPaymentHistoryScreen({
    super.key,
    required this.ppfAccount,
    this.showAddDialog = false,
  });

  @override
  State<PPFPaymentHistoryScreen> createState() => _PPFPaymentHistoryScreenState();
}

class _PPFPaymentHistoryScreenState extends State<PPFPaymentHistoryScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.showAddDialog) {
      // Show add dialog after the widget is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAddPaymentDialog(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ppfPaymentProvider = context.watch<PPFPaymentProvider>();
    final accountId = widget.ppfAccount.bank ?? '';
    
    return FutureBuilder<List<PPFPayment>>(
      future: ppfPaymentProvider.getPaymentsForAccount(accountId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('PPF Payment History'),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        
        final allPayments = snapshot.data!;
        
        // Separate and sort payments
        final completedPayments = allPayments
            .where((p) => p.isCompleted)
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date)); // Oldest first
        
        final upcomingPayments = allPayments
            .where((p) => p.isUpcoming)
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date)); // Nearest first
        
        // Get last N completed payments (most recent ones from the sorted list)
        final limitedCompletedPayments = completedPayments.length > AppConstants.maxCompletedPaymentsToShow
            ? completedPayments.sublist(completedPayments.length - AppConstants.maxCompletedPaymentsToShow)
            : completedPayments;
        
        // Get next N upcoming payments
        final limitedUpcomingPayments = upcomingPayments.take(AppConstants.maxUpcomingPaymentsToShow).toList();
        
        final payments = [...limitedCompletedPayments, ...limitedUpcomingPayments];

        return _buildScreen(context, payments, ppfPaymentProvider, accountId);
      },
    );
  }

  Widget _buildScreen(BuildContext context, List<PPFPayment> payments, PPFPaymentProvider provider, String accountId) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('PPF Payment History'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Summary card
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.account_balance,
                        color: widget.ppfAccount.color,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'PPF Account: ${widget.ppfAccount.bank}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Total Invested: ${NumberFormatter.formatAmount(widget.ppfAccount.amount)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Current Balance: ${NumberFormatter.formatAmount(widget.ppfAccount.currentBalance)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Payments list header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text(
                  'Payment History',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    // Show dialog to add new payment
                    _showAddPaymentDialog(context);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Payment'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green,
                  ),
                ),
              ],
            ),
          ),

          // Payments list
          Expanded(
            child: ListView.builder(
              itemCount: payments.length,
              itemBuilder: (context, index) {
                final payment = payments[index];
                final isCompleted = payment.isCompleted;

                final cardContent = Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isCompleted
                          ? Colors.green.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      child: Icon(
                        isCompleted ? Icons.check_circle : Icons.schedule,
                        color: isCompleted ? Colors.green : Colors.orange,
                      ),
                    ),
                    title: Text(
                      NumberFormatter.formatAmount(payment.amount),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(DateFormatter.formatDate(payment.date)),
                        if (payment.referenceNumber != null)
                          Text(
                            'Ref: ${payment.referenceNumber}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        if (payment.notes != null)
                          Text(
                            payment.notes!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        if (payment.isRecurring)
                          Row(
                            children: [
                              Icon(
                                Icons.repeat,
                                size: 14,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                payment.recurringFrequency ?? 'Recurring',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    trailing: Chip(
                      label: Text(
                        isCompleted ? 'Completed' : 'Upcoming',
                        style: TextStyle(
                          color: isCompleted ? Colors.green : Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      backgroundColor: isCompleted
                          ? Colors.green.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      side: BorderSide.none,
                    ),
                  ),
                );
                
                // Only make upcoming recurring payments dismissible
                if (!isCompleted && payment.isRecurring) {
                  return Dismissible(
                    key: Key('payment_${payment.date.millisecondsSinceEpoch}_${payment.amount}'),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete, color: Colors.white),
                          SizedBox(height: 4),
                          Text(
                            'Delete',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Delete Payment'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Are you sure you want to delete this upcoming payment?',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.repeat, size: 18, color: Colors.grey[700]),
                                          const SizedBox(width: 8),
                                          Text(
                                            NumberFormatter.formatAmount(payment.amount),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Date: ${DateFormatter.formatDate(payment.date)}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      if (payment.recurringFrequency != null)
                                        Text(
                                          'Frequency: ${payment.recurringFrequency}',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('CANCEL'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                child: const Text('DELETE'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onDismissed: (direction) async {
                      await provider.deletePayment(accountId, payment);
                      
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Payment deleted'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      }
                    },
                    child: cardContent,
                  );
                }
                
                return cardContent;
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddPaymentDialog(BuildContext context) {
    final amountController = TextEditingController();
    final notesController = TextEditingController();
    final numberOfPaymentsController = TextEditingController(text: '12');
    DateTime selectedDate = DateTime.now();
    bool isRecurring = false;
    String? recurringFrequency = 'Monthly';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add New Payment'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    prefixText: '₹',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormatter.formatDate(selectedDate)),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('Recurring Payment'),
                  subtitle: const Text('Set up automatic recurring payments'),
                  value: isRecurring,
                  onChanged: (value) {
                    setState(() {
                      isRecurring = value ?? false;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                ),
                if (isRecurring) ...[
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: recurringFrequency,
                    decoration: const InputDecoration(
                      labelText: 'Frequency',
                      border: OutlineInputBorder(),
                    ),
                    items: ['Monthly', 'Quarterly', 'Half-Yearly', 'Yearly']
                        .map((String frequency) {
                      return DropdownMenuItem<String>(
                        value: frequency,
                        child: Text(frequency),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        recurringFrequency = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: numberOfPaymentsController,
                    decoration: const InputDecoration(
                      labelText: 'Number of Payments',
                      helperText: 'How many recurring payments to schedule',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () async {
                if (amountController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter an amount'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                if (isRecurring && numberOfPaymentsController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter number of payments'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                if (isRecurring) {
                  final numPayments = int.tryParse(numberOfPaymentsController.text);
                  if (numPayments == null || numPayments <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid number of payments'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                }
                
                // Add payment logic
                final amount = double.tryParse(amountController.text);
                if (amount == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invalid amount'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                final wasRecurring = isRecurring;
                final ppfPaymentProvider = context.read<PPFPaymentProvider>();
                final accountId = widget.ppfAccount.bank ?? '';
                
                // Create payment(s) and add via provider
                if (isRecurring) {
                  final numPayments = int.parse(numberOfPaymentsController.text);
                  final List<PPFPayment> newPayments = [];
                  
                  for (int i = 0; i < numPayments; i++) {
                    DateTime paymentDate = selectedDate;
                    
                    // Calculate payment date based on frequency
                    switch (recurringFrequency) {
                      case 'Monthly':
                        paymentDate = DateTime(selectedDate.year, selectedDate.month + i, selectedDate.day);
                        break;
                      case 'Quarterly':
                        paymentDate = DateTime(selectedDate.year, selectedDate.month + (i * 3), selectedDate.day);
                        break;
                      case 'Half-Yearly':
                        paymentDate = DateTime(selectedDate.year, selectedDate.month + (i * 6), selectedDate.day);
                        break;
                      case 'Yearly':
                        paymentDate = DateTime(selectedDate.year + i, selectedDate.month, selectedDate.day);
                        break;
                    }
                    
                    // Only the first payment (if today or past) is completed, rest are upcoming
                    final isPast = paymentDate.isBefore(DateTime.now()) || 
                                   paymentDate.isAtSameMomentAs(DateTime.now());
                    
                    newPayments.add(PPFPayment(
                      date: paymentDate,
                      amount: amount,
                      status: isPast ? 'Completed' : 'Upcoming',
                      referenceNumber: isPast ? 'PPF-${paymentDate.year}-${paymentDate.month.toString().padLeft(2, '0')}' : null,
                      notes: notesController.text.isNotEmpty ? notesController.text : null,
                      isRecurring: true,
                      recurringFrequency: recurringFrequency,
                    ));
                  }
                  
                  await ppfPaymentProvider.addPayments(accountId, newPayments);
                } else {
                  // One-time payment
                  final newPayment = PPFPayment(
                    date: selectedDate,
                    amount: amount,
                    status: 'Completed',
                    referenceNumber: 'PPF-${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}',
                    notes: notesController.text.isNotEmpty ? notesController.text : null,
                    isRecurring: false,
                  );
                  
                  await ppfPaymentProvider.addPayment(accountId, newPayment);
                }
                
                Navigator.pop(context);
                
                // If recurring payment was added, notify parent to refresh
                if (wasRecurring) {
                  Navigator.pop(context, true);
                }
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isRecurring
                          ? '${numberOfPaymentsController.text} recurring payments scheduled successfully'
                          : 'Payment added successfully',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.green,
              ),
              child: const Text('ADD'),
            ),
          ],
        ),
      ),
    );
  }
}
