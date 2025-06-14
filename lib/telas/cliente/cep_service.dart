import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>?> buscarEnderecoPorCEP(String cep) async {
  final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data['erro'] == true) return null;
    return data;
  } else {
    return null;
  }
}
