// import 'package:currensee/login.dart';
import 'package:flutter/material.dart';
// import 'model/exchange_rate.dart';
// import 'services/exchange_rate_services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import '../model/exchange_rate.dart';

void main() {
  runApp(MaterialApp(
    title: 'CurrenSee',
    theme: ThemeData(),
    home: ExchangeRateScreen(),
  ));
}

class ExchangeRateScreen extends StatefulWidget {
  @override
  _ExchangeRateScreenState createState() => _ExchangeRateScreenState();
}

class _ExchangeRateScreenState extends State<ExchangeRateScreen> {
  late Future<List<ExchangeRate>> futureExchangeRates;
  final TextEditingController _searchController = TextEditingController();
  List<ExchangeRate> filteredRates = [];

  @override
  void initState() {
    super.initState();
    futureExchangeRates = ExchangeRateService().fetchExchangeRates();
  }

  void filterRates(String query) {
    if (query.isEmpty) {
      futureExchangeRates.then((rates) {
        setState(() {
          filteredRates = rates;
        });
      });
    } else {
      futureExchangeRates.then((rates) {
        setState(() {
          filteredRates = rates
              .where((rate) =>
                  rate.currency.toLowerCase().contains(query.toLowerCase()))
              .toList();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Rates Alert',
        ),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: Colors.white),
              onChanged: (query) {
                filterRates(query);
              },
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal)),
                focusColor: Colors.white,
                prefixIconColor: Colors.grey,
                labelStyle:
                    TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                labelText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.teal),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: FutureBuilder<List<ExchangeRate>>(
              future: futureExchangeRates,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No exchange rates available',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  if (filteredRates.isEmpty) {
                    filteredRates = snapshot.data!;
                  }

                  return ListView.builder(
                    itemCount: filteredRates.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Center(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: ListTile(
                                title: Text(
                                  '${filteredRates[index].currency}: ${filteredRates[index].rate}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.tealAccent,
                            thickness: 0.1,
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ExchangeRateService {
  final String apiKey = '2b27330afa23ac304a7ce5c7';
  final String baseUrl = 'https://v6.exchangerate-api.com/v6';

  Future<List<ExchangeRate>> fetchExchangeRates() async {
    final response = await http.get(Uri.parse('$baseUrl/$apiKey/latest/usd'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<ExchangeRate> rates = [];
      data['conversion_rates'].forEach((key, value) {
        rates.add(ExchangeRate(currency: key, rate: value));
      });
      return rates;
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }
}

class ExchangeRate {
  final String currency;
  final double rate;

  ExchangeRate({required this.currency, required this.rate});

  factory ExchangeRate.fromJson(Map<String, dynamic> json) {
    return ExchangeRate(
      currency: json['currency'],
      rate: json['rate'],
    );
  }
}
