import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({Key? key}) : super(key: key);

  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  int gems = 0;
  int currentJades = 0;
  int totalpull = 0;
  DateTime selectedDate = DateTime.now();
  bool isMonthlyPaid = false;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jades Calculator'),
        backgroundColor: const Color.fromARGB(255, 197, 198, 202),
      ),
       backgroundColor: const Color.fromARGB(255, 57, 52, 56),
      body: Center(
        child: Container(
          width: screenSize.width * 0.7,
          height: 600,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                  '*Note \n This system calculate based on your current date and select date. This will assume you have finish all daily challeges and weekly challenges \n',
                  style: TextStyle(color: Colors.red)),
              const Text('*Daily Jades: 60, Weekly Jades: 165 \n',
                  style: TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              const Text('Input your current Jades \n'),
              TextField(
                onChanged: (value) {
                  setState(() {
                    currentJades = int.tryParse(value) ?? 0;
                    calculateGems();
                  });
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Current Jades',
                  border: OutlineInputBorder(),
                ),
              ),
              Text('\n Total of Gems: $gems'),
              Text('\n Total of Pulls: $totalpull'),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2025),
                    selectableDayPredicate: (DateTime date) {
                      return date.isAfter(
                          DateTime.now().subtract(const Duration(days: 1)));
                    },
                  );
                  if (picked != null && picked != selectedDate) {
                    setState(() {
                      selectedDate = picked;
                      calculateGems();
                    });
                  }
                },
                child: const Text('Select Pull Date'),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isMonthlyPaid = false;
                        calculateGems();
                      });
                    },
                    child: const Text('F2P'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isMonthlyPaid = true;
                        calculateGems();
                      });
                    },
                    child: const Text('Monthly Paid'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void calculateGems() {
    final DateTime now = DateTime.now();
    final DateTime DateAdjusted = selectedDate.add(const Duration(days: 1));
    final int daysDifference = DateAdjusted.difference(now).inDays;
    int calculatedGems = (daysDifference * 60); // base gems per day

    if (isMonthlyPaid) {
      calculatedGems += daysDifference * 20; // additional gems per day
    }

    // Calculate additional weekly gems
    final DateTime currentDateWithoutTime =
        DateTime(now.year, now.month, now.day);
    final DateTime selectedDateWithoutTime =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final int daysSinceLastMonday =
        (currentDateWithoutTime.weekday + 7 - DateTime.monday) % 7;
    final DateTime nextMonday =
        currentDateWithoutTime.add(Duration(days: 7 - daysSinceLastMonday));
    int additionalWeeklyGems = 0;
    DateTime tempDate = nextMonday;
    while (tempDate.isBefore(selectedDateWithoutTime)) {
      additionalWeeklyGems += 165;
      tempDate = tempDate.add(Duration(days: 7));
    }

    calculatedGems += additionalWeeklyGems;

    setState(() {
      gems = calculatedGems + currentJades;
      totalpull = gems ~/ 160;
    });
  }
}
