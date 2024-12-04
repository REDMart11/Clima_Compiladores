import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConsultaPorCoordenadas extends StatefulWidget {
  @override
  _ConsultaPorCoordenadasState createState() => _ConsultaPorCoordenadasState();
}

class _ConsultaPorCoordenadasState extends State<ConsultaPorCoordenadas> {
  final latController = TextEditingController();
  final lonController = TextEditingController();
  String resultado = '';

  Future<void> fetchWeatherByCoordinates() async {
    final apiKey = '7bd2b52dd6b6ad308ef69aded064d86c';
    final lat = latController.text;
    final lon = lonController.text;
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=es';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        resultado = '''
        País: ${data['sys']['country']}
        Ciudad: ${data['name']}
        Clima: ${data['weather'][0]['description']}
        Temperatura: ${data['main']['temp']} °C
        Humedad: ${data['main']['humidity']}%
        ''';
      });
    } else {
      setState(() {
        resultado = 'Error al consultar el clima.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Consulta por Coordenadas',
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
              controller: latController,
              decoration: InputDecoration(
                labelText: 'Latitud',
                labelStyle: TextStyle(color: Colors.green),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: lonController,
              decoration: InputDecoration(
                labelText: 'Longitud',
                labelStyle: TextStyle(color: Colors.green),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: fetchWeatherByCoordinates,
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
