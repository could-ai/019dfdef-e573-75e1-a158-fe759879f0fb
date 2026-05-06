import 'package:flutter/material.dart';

void main() {
  runApp(const SummerCampApp());
}

class SummerCampApp extends StatelessWidget {
  const SummerCampApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تقييم المخيم الصيفي',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Tajawal', // Assuming an Arabic font or default
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const CampEvaluationScreen(),
      },
      locale: const Locale('ar', 'DZ'),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
    );
  }
}

class CampEvaluationScreen extends StatefulWidget {
  const CampEvaluationScreen({super.key});

  @override
  State<CampEvaluationScreen> createState() => _CampEvaluationScreenState();
}

class _CampEvaluationScreenState extends State<CampEvaluationScreen> {
  // Constants based on requirements
  final double session1Price = 25000;
  final double session2Price = 23000;
  final double session3Price = 20000;
  
  final double mealsCost = 34650;
  final double otherCosts = 10000;
  final double tripCost = 3000;
  
  final int targetStudents = 21;

  // State variables for inputs
  int session1Students = 7;
  int session2Students = 7;
  int session3Students = 7;

  // Calculators
  int get totalStudents => session1Students + session2Students + session3Students;
  
  double get totalRevenue => 
    (session1Students * session1Price) + 
    (session2Students * session2Price) + 
    (session3Students * session3Price);
    
  double get totalExpenses => mealsCost + otherCosts + tripCost;
  
  double get netProfit => totalRevenue - totalExpenses;

  @override
  Widget build(BuildContext context) {
    final isTargetMet = totalStudents >= targetStudents;
    final isProfitable = netProfit >= 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تقييم الجدوى المالية للمخيم الصيفي'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSummaryCard(isTargetMet, isProfitable),
                    const SizedBox(height: 24),
                    _buildExpensesCard(),
                    const SizedBox(height: 24),
                    _buildRevenueCalculator(constraints.maxWidth),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildSummaryCard(bool isTargetMet, bool isProfitable) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'الخلاصة المالية',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('الإيرادات', '$totalRevenue د.ج', Colors.blue),
                _buildStatItem('المصاريف', '$totalExpenses د.ج', Colors.red),
                _buildStatItem('النتيجة (الربح)', '$netProfit د.ج', isProfitable ? Colors.green : Colors.red),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('إجمالي التلاميذ', '$totalStudents', Colors.black87),
                _buildStatItem('الهدف (21)', isTargetMet ? 'مُحقق' : 'غير مُحقق', isTargetMet ? Colors.green : Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpensesCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تفاصيل المصاريف الثابتة (أسبوعين)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildExpenseRow('الوجبات', mealsCost),
            _buildExpenseRow('مصاريف أخرى', otherCosts),
            _buildExpenseRow('الرحلة', tripCost),
            const Divider(),
            _buildExpenseRow('الإجمالي', totalExpenses, isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueCalculator(double maxWidth) {
    final isMobile = maxWidth < 600;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'حساب الإيرادات حسب الحصص',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            isMobile 
              ? Column(
                  children: [
                    _buildSessionInput('الحصة الأولى', session1Price, session1Students, (val) => setState(() => session1Students = val)),
                    const SizedBox(height: 16),
                    _buildSessionInput('الحصة الثانية', session2Price, session2Students, (val) => setState(() => session2Students = val)),
                    const SizedBox(height: 16),
                    _buildSessionInput('الحصة الثالثة', session3Price, session3Students, (val) => setState(() => session3Students = val)),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildSessionInput('الحصة الأولى', session1Price, session1Students, (val) => setState(() => session1Students = val))),
                    const SizedBox(width: 16),
                    Expanded(child: _buildSessionInput('الحصة الثانية', session2Price, session2Students, (val) => setState(() => session2Students = val))),
                    const SizedBox(width: 16),
                    Expanded(child: _buildSessionInput('الحصة الثالثة', session3Price, session3Students, (val) => setState(() => session3Students = val))),
                  ],
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(fontSize: 20, color: color, fontWeight: FontWeight.bold),
          textDirection: TextDirection.ltr,
        ),
      ],
    );
  }

  Widget _buildExpenseRow(String label, double amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
          Text(
            '$amount د.ج',
            style: TextStyle(fontSize: 16, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
            textDirection: TextDirection.ltr,
          ),
        ],
      ),
    );
  }

  Widget _buildSessionInput(String title, double price, int currentValue, Function(int) onChanged) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text('السعر: $price د.ج', style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: currentValue > 0 ? () => onChanged(currentValue - 1) : null,
                color: Colors.red,
              ),
              Text(
                '$currentValue تلاميذ',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => onChanged(currentValue + 1),
                color: Colors.green,
              ),
            ],
          ),
          const Divider(),
          Text(
            'الإجمالي: ${price * currentValue} د.ج',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            textDirection: TextDirection.ltr,
          )
        ],
      ),
    );
  }
}
