import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConsultaPorCiudad extends StatefulWidget {
  @override
  _ConsultaPorCiudadState createState() => _ConsultaPorCiudadState();
}

class _ConsultaPorCiudadState extends State<ConsultaPorCiudad> {
  final ciudadController = TextEditingController();
  String resultado = '';

  Future<void> fetchWeatherByCity() async {
    final apiKey = '7bd2b52dd6b6ad308ef69aded064d86c';
    final ciudad = ciudadController.text;
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$ciudad&appid=$apiKey&units=metric&lang=es';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        resultado = '''
        Clima: ${data['weather'][0]['description']}
        Temperatura: ${data['main']['temp']} °C
        Humedad: ${data['main']['humidity']}%
        ''';
      });
    } else {
      setState(() {
        resultado = 'Error al consultar el clima. Verifica el nombre de la ciudad.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Consulta por Ciudad',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
      ),
      body: Container(
        color: Colors.pink.shade50,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: ciudadController,
              decoration: InputDecoration(
                labelText: 'Nombre de la Ciudad',
                labelStyle: TextStyle(color: Colors.green),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: fetchWeatherByCity,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Consultar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              resultado,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.pink.shade800,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
