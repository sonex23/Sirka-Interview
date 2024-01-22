import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BmiPage extends StatefulWidget {
  const BmiPage({super.key});

  @override
  State<BmiPage> createState() => _BmiPageState();
}

class _BmiPageState extends State<BmiPage> {
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  double hasil = 0;
  double sisa = 0;
  String conclusion = '';
  String tips = '';
  List<dynamic> history = [];

  void getHistory() async {
    var box = Hive.box('history');
    setState(() {
      history = box.get('history_list') ?? [];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Kalkulator BMI',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(label: Text('Tinggi Badan cm')),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(label: Text('Berat Badan Kg')),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  var box = Hive.box('history');

                  double height = (double.parse(heightController.text) / 100);
                  setState(() {
                    hasil = double.parse(weightController.text) / (height * height);
                    if (hasil >= 25) {
                      sisa = double.parse(weightController.text) - (24.99 * height * height);
                      tips = "Kamu harus menurunkan berat badan sebesar ${sisa.ceilToDouble()} kg";
                    } else if (hasil < 18.5) {
                      sisa = (18.5 * height * height) - double.parse(weightController.text);
                      tips = "Kamu harus menaikkan berat badan sebesar ${sisa.ceilToDouble()} kg";
                    } else {
                      sisa = 0;
                      tips = "Kamu memiliki tubuh yang ideal";
                    }

                    if (hasil < 18.5) {
                      conclusion = "Underweight";
                    } else if (hasil >= 18.5 && hasil < 25) {
                      conclusion = "Healty Weight";
                    } else if (hasil >= 25 && hasil < 30) {
                      conclusion = "Overweight";
                    } else {
                      conclusion = "Obesity";
                    }

                    if (history.length == 10) {
                      history.removeAt(0);
                    }
                    history.add({
                      'height': heightController.text,
                      'weight': weightController.text,
                      'result': hasil.toStringAsFixed(2),
                      'conclusion': conclusion,
                    });
                    box.put('history_list', history);
                  });
                },
                child: const Text(
                  'Hitung',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Hasil Perhitungan : ${hasil.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '$conclusion',
                style: const TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                tips,
                style: const TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 300,
                width: double.infinity,
                child: DataTable2(
                  columnSpacing: 10,
                  horizontalMargin: 1,
                  columns: const [
                    DataColumn(
                      label: Text('Tinggi'),
                    ),
                    DataColumn(
                      label: Text('Berat'),
                    ),
                    DataColumn(
                      label: Text('Hasil'),
                    ),
                    DataColumn(
                      label: Text('Kesimpulan'),
                    ),
                  ],
                  rows: history
                      .map(
                        (history) => DataRow(
                          cells: [
                            DataCell(
                              Text(
                                history['height'],
                              ),
                            ),
                            DataCell(
                              Text(
                                history['weight'],
                              ),
                            ),
                            DataCell(
                              Text(
                                history['result'].toString(),
                              ),
                            ),
                            DataCell(
                              Text(
                                history['conclusion'].toString(),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }
}
