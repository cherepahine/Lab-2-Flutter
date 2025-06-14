import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const FirstScreen(),
    );
  }
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  _FirstScreenState createState() => _FirstScreenState();
}


class _FirstScreenState extends State<FirstScreen>{
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  bool _isAgree = false;

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Черепахин Евгений Александрович', style: TextStyle(fontSize: 18.0),),
        backgroundColor: Colors.lightGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Вес (кг)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите вес';
                  }
                  double? weight = double.tryParse(value);
                  if (weight == null || weight <= 0 || weight > 500) {
                    return 'Введите корректный вес (0-500 кг)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Рост (см)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите рост';
                  }
                  double? height = double.tryParse(value);
                  if (height == null || height <= 0 || height > 300) {
                    return 'Введите корректный рост (0-300 см)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              FormField<bool>(
                initialValue: _isAgree,
                validator: (value){
                  if (value == null || !value){
                    return 'Пожалуйста, дайте согласие на обработку персональных данных';
                  }
                  return null;
                },
                builder: (FormFieldState<bool> field){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _isAgree,
                            onChanged: (value){
                              setState(() {
                                _isAgree = value ?? false;
                                field.didChange(value);
                              });
                            },
                          ),
                          const Expanded(
                              child: Text('Я ознакомлен с документом "Согласие на обработку персональных данных" и даю согласие на обработку моих персональных данных')
                          ),
                        ],
                      ),
                      if (field.hasError)
                        Padding(
                            padding: const EdgeInsets.only(left: 16.0, top:8.0),
                            child: Text(
                              field.errorText!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontSize: 12,
                              ),
                            ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _navigateToResult,
                child: const Text('Рассчитать ИМТ'),
              ),
            ],
          ),
        ),
      ),
    );
  }


void _navigateToResult() {
    if (_formKey.currentState!.validate()) {
      double weight = double.parse(_weightController.text);
      double height = double.parse(_heightController.text);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SecondScreen(
            weight: weight,
            height: height,
          ),
        ),
      );
    }
}

}

class SecondScreen extends StatelessWidget {
  
  final double weight;
  final double height;

  const SecondScreen({super.key, required this.weight, required this.height});

  String _calculateBMI(){
    double heightM = height/100;
    double bmi = weight / (heightM * heightM);
    return bmi.toStringAsFixed(1);
  }

    String _getBMICategory(double bmi) {
    if (bmi < 18.5) {
      return 'Недостаточный вес';
    } else if (bmi >= 18.5 && bmi < 25) {
      return 'Нормальный вес';
    } else if (bmi >= 25 && bmi < 30) {
      return 'Избыточный вес';
    } else {
      return 'Ожирение';
    }
  }

  @override
  Widget build(BuildContext context) {
    double bmi = double.parse(_calculateBMI());
    String category = _getBMICategory(bmi);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Черепахин Евгений Александрович', style: TextStyle(fontSize: 18.0),),
        backgroundColor: Colors.lightGreen,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ваш ИМТ: $bmi',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Категория: $category',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Вернуться'),
            ),
          ],
        ),
      ),
    );
  }
}


