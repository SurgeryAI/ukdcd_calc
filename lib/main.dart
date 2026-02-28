import 'package:flutter/material.dart';
import 'infoscreen2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UK DCD Risk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
      ),
      home: const CalcRisk(title: 'UK DCD Risk Calc'),
    );
  }
}

class CalcRisk extends StatefulWidget {
  final String title;

  const CalcRisk({super.key, required this.title});

  @override
  State<CalcRisk> createState() => _CalcRiskState();
}

class _CalcRiskState extends State<CalcRisk> {
  // state
  Map<String, bool> risks = {
    "olderDonor": false,
    "hiBMI": false,
    "longColdIsch": false,
    "olderRecip": false,
    "hiRecipMELD": false,
    "reTxp": false,
  };
  
  int lengthWarmIsch = 0;
  
  static const points = {
    "olderDonor": 2.0,
    "hiBMI": 3.0,
    "longColdIsch": 2.0,
    "olderRecip": 3.0,
    "hiRecipMELD": 2.0,
    "reTxp": 9.0,
  };

  double get currentRiskScore {
    double score = 0;
    risks.forEach((key, value) {
      if (value) {
        score += points[key] ?? 0;
      }
    });
    score += (lengthWarmIsch * 3);
    return score;
  }

  String get riskCategory {
    final score = currentRiskScore;
    if (score < 6) return "Low Risk DCD";
    if (score <= 9) return "High Risk DCD";
    return "Futile DCD";
  }

  Color get riskColor {
    final score = currentRiskScore;
    if (score < 6) return Colors.green.shade300;
    if (score <= 9) return Colors.orange.shade300;
    return Colors.red.shade400;
  }

  void _updateRisk(String key, bool value) {
    setState(() {
      risks[key] = value;
    });
  }

  void _updateWarmIsch(int value) {
    setState(() {
      lengthWarmIsch = value;
    });
  }

  Widget _buildToggleRow(String title, String opt1, String opt2, String riskKey) {
    final bool isTrue = risks[riskKey] ?? false;
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Expanded(
                    child: _SelectButton(
                      label: opt1,
                      isSelected: !isTrue,
                      onTap: () => _updateRisk(riskKey, false),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _SelectButton(
                      label: opt2,
                      isSelected: isTrue,
                      onTap: () => _updateRisk(riskKey, true),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarmIschCard() {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Warm Ischemia Time (min)',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _SelectButton(
                    label: '< 20',
                    isSelected: lengthWarmIsch == 0,
                    onTap: () => _updateWarmIsch(0),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _SelectButton(
                    label: '20 to 30',
                    isSelected: lengthWarmIsch == 1,
                    onTap: () => _updateWarmIsch(1),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _SelectButton(
                    label: '> 30',
                    isSelected: lengthWarmIsch == 2,
                    onTap: () => _updateWarmIsch(2),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InfoScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 4),
                children: [
                  _buildToggleRow("Donor Age", "≤ 60 years", "> 60 years", "olderDonor"),
                  _buildToggleRow("Donor BMI (kg/m²)", "≤ 25", "> 25", "hiBMI"),
                  _buildToggleRow("Cold Ischemia", "≤ 6 hours", "> 6 hours", "longColdIsch"),
                  _buildToggleRow("Recipient Age", "≤ 60 years", "> 60 years", "olderRecip"),
                  _buildToggleRow("Recipient Lab MELD", "< 25", "≥ 25", "hiRecipMELD"),
                  _buildToggleRow("Retransplant", "No", "Yes", "reTxp"),
                  _buildWarmIschCard(),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    offset: const Offset(0, -4),
                    blurRadius: 10,
                  )
                ],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'UK DCD Risk Score',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currentRiskScore.toStringAsFixed(0),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: riskColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: riskColor.withValues(alpha: 0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ]
                      ),
                      child: Text(
                        riskCategory,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _SelectButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
