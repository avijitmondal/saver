import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/portfolio_provider.dart';
import '../providers/ppf_payment_provider.dart';
import '../models/investment.dart';
import '../widgets/ppf_card.dart';
import '../utils/number_formatter.dart';
import '../utils/date_utils.dart';
import 'add_ppf_screen.dart';
import 'ppf_payment_history_screen.dart';

class PPFScreen extends StatefulWidget {
  final String investmentType;
  final Color typeColor;

  const PPFScreen({
    super.key,
    required this.investmentType,
    required this.typeColor,
  });

  @override
  State<PPFScreen> createState() => _PPFScreenState();
}

class _PPFScreenState extends State<PPFScreen> {
  @override
  Widget build(BuildContext context) {
    final portfolio = context.watch<PortfolioProvider>();
    final investments = portfolio.investments
        .where((investment) => investment.type == widget.investmentType)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.investmentType),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: investments.isEmpty
            ? _buildEmptyState()
            : _buildInvestmentView(context, investments[0]),
      ),
      floatingActionButton:
          investments.isEmpty ? _buildAddButton(context) : null,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No PPF Account Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your PPF account to start tracking',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvestmentView(BuildContext context, Investment investment) {
    final ppfPaymentProvider = context.watch<PPFPaymentProvider>();
    final accountId = investment.bank ?? '';
    
    return FutureBuilder(
      future: ppfPaymentProvider.getPaymentsForAccount(accountId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final allPayments = snapshot.data!;
        final recurringSchedules = _groupRecurringPayments(allPayments);
        
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PPFCard(
                investment: investment,
                isMatured: false,
                typeColor: widget.typeColor,
              ),
              if (recurringSchedules.isNotEmpty) ...[
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recurring Payments',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PPFPaymentHistoryScreen(
                              ppfAccount: investment,
                              showAddDialog: true,
                            ),
                          ),
                        );
                        if (result == true && mounted) {
                          // Refresh the screen to show new recurring payment
                          setState(() {});
                        }
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...recurringSchedules.values.map((schedule) => _buildRecurringPaymentBanner(context, schedule, accountId, ppfPaymentProvider)),
              ],
              const SizedBox(height: 24),
              _buildPaymentHistoryButton(context, investment),
              const SizedBox(height: 100),
            ],
          ),
        );
      },
    );
  }

  Map<String, Map<String, dynamic>> _groupRecurringPayments(List<dynamic> payments) {
    final Map<String, Map<String, dynamic>> schedules = {};
    
    for (var payment in payments) {
      if (payment.isRecurring) {
        final key = '${payment.amount}_${payment.recurringFrequency}';
        if (!schedules.containsKey(key)) {
          schedules[key] = {
            'amount': payment.amount,
            'frequency': payment.recurringFrequency,
            'payments': <dynamic>[],
          };
        }
        schedules[key]!['payments'].add(payment);
      }
    }
    
    return schedules;
  }

  Widget _buildRecurringPaymentBanner(
    BuildContext context, 
    Map<String, dynamic> schedule,
    String accountId,
    PPFPaymentProvider provider,
  ) {
    final payments = schedule['payments'] as List<dynamic>;
    final amount = schedule['amount'] as double;
    final frequency = schedule['frequency'] as String?;
    
    // Sort payments by date
    payments.sort((a, b) => a.date.compareTo(b.date));
    
    final startDate = payments.first.date;
    final completedCount = payments.where((p) => p.isCompleted).length;
    final totalCount = payments.length;
    final hasUpcomingPayments = payments.any((p) => p.isUpcoming);
    final upcomingCount = payments.where((p) => p.isUpcoming).length;
    
    final bannerContent = Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.repeat,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      NumberFormatter.formatAmount(amount),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      frequency ?? 'Monthly',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$completedCount/$totalCount',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 6),
              Text(
                'Started: ${DateFormatter.formatDate(startDate)}',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
    
    if (!hasUpcomingPayments) {
      return bannerContent;
    }
    
    return Dismissible(
      key: Key('recurring_${amount}_${frequency}_${startDate.millisecondsSinceEpoch}'),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
              title: const Text('Delete Recurring Payment'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Are you sure you want to delete this recurring payment schedule?',
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
                              NumberFormatter.formatAmount(amount),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              ' • ${frequency ?? 'Monthly'}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$upcomingCount upcoming payment${upcomingCount > 1 ? 's' : ''} will be deleted',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          'Completed payments will be preserved',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.green[700],
                            fontStyle: FontStyle.italic,
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
        // Delete upcoming payments from this recurring schedule
        final upcomingPaymentsToDelete = payments
            .where((p) => p.isUpcoming)
            .toList();
        
        await provider.deletePayments(accountId, upcomingPaymentsToDelete.cast());
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$upcomingCount upcoming payment${upcomingCount > 1 ? 's' : ''} deleted'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      },
      child: bannerContent,
    );
  }

  Widget _buildPaymentHistoryButton(
      BuildContext context, Investment investment) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PPFPaymentHistoryScreen(
              ppfAccount: investment,
            ),
          ),
        );
      },
      icon: const Icon(Icons.history),
      label: const Text('View Payment History'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddPPFScreen(),
          ),
        );
      },
      backgroundColor: Colors.green,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
