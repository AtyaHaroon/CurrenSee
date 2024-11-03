import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final VoidCallback? onHistoryUpdated; // Callback for updating history

  const HomePage({Key? key, this.onHistoryUpdated}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String fromCurrency = "USD";
  String toCurrency = "EUR";
  double rate = 0.0;
  double total = 0.0;
  TextEditingController amountController = TextEditingController();
  List<String> currencies = [];
  List<String> conversionHistory = [];

  @override
  void initState() {
    super.initState();
    _getCurrencies();
    _loadHistory();
  }

  Future<void> _getCurrencies() async {
    try {
      var response = await http
          .get(Uri.parse('https://api.exchangerate-api.com/v4/latest/USD'));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          currencies = (data['rates'] as Map<String, dynamic>).keys.toList();
          rate = data['rates'][toCurrency];
          _updateTotal();
        });
      } else {
        throw Exception('Failed to load currencies');
      }
    } catch (e) {
      print('Error fetching currencies: $e');
    }
  }

  Future<void> _getRate() async {
    try {
      var response = await http.get(Uri.parse(
          'https://api.exchangerate-api.com/v4/latest/$fromCurrency'));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          rate = data['rates'][toCurrency];
          _updateTotal();
        });
      } else {
        throw Exception('Failed to load rate');
      }
    } catch (e) {
      print('Error fetching rate: $e');
    }
  }

  void _updateTotal() {
    if (amountController.text.isNotEmpty) {
      try {
        double amount = double.parse(amountController.text);
        setState(() {
          total = amount * rate;
          _addToHistory(amount);
        });
      } catch (e) {
        print('Error parsing amount: $e');
      }
    }
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      conversionHistory = prefs.getStringList('conversionHistory') ?? [];
    });
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('conversionHistory', conversionHistory);
  }

  void _addToHistory(double amount) {
    String historyEntry =
        "$amount $fromCurrency = ${total.toStringAsFixed(2)} $toCurrency";

    if (!conversionHistory.contains(historyEntry)) {
      setState(() {
        conversionHistory.add(historyEntry);
        _saveHistory();
        if (widget.onHistoryUpdated != null) {
          widget.onHistoryUpdated!(); // Notify parent to refresh history
        }
      });
    }
  }

  void _swapCurrencies() {
    setState(() {
      String temp = fromCurrency;
      fromCurrency = toCurrency;
      toCurrency = temp;
      _getRate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Removed the history icon from the app bar
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 180,
                width: 180,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/CurrenSee.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.tealAccent.shade700,
                    BlendMode.srcATop,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.teal,
                  decoration: InputDecoration(
                    labelText: "Amount",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.tealAccent.shade700),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _updateTotal();
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 100,
                      child: DropdownSearch<String>(
                        popupProps: PopupProps.dialog(
                          itemBuilder: (context, item, isSelected) {
                            return ListTile(
                              title: Text(
                                item,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.tealAccent.shade700
                                      : Colors.white,
                                ),
                              ),
                            );
                          },
                          searchFieldProps: TextFieldProps(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.white),
                              labelText: 'From',
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                            ),
                            cursorColor: Colors.tealAccent.shade700,
                          ),
                          dialogProps: DialogProps(
                            backgroundColor: Colors.black,
                          ),
                          scrollbarProps: ScrollbarProps(
                            fadeDuration: Duration(seconds: 3),
                            thumbColor: Colors.teal.shade800,
                          ),
                          showSearchBox: true,
                        ),
                        items: currencies,
                        selectedItem: fromCurrency,
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          baseStyle: TextStyle(color: Colors.white),
                          dropdownSearchDecoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.tealAccent.shade700),
                            ),
                          ),
                        ),
                        dropdownBuilder: (context, selectedItem) {
                          return Text(
                            selectedItem ?? "",
                            style: TextStyle(color: Colors.white),
                          );
                        },
                        onChanged: (newValue) {
                          setState(() {
                            fromCurrency = newValue!;
                            _getRate();
                          });
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: _swapCurrencies,
                      icon: Icon(
                        Icons.swap_horiz,
                        size: 40,
                        color: Colors.tealAccent.shade700,
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: DropdownSearch<String>(
                        popupProps: PopupProps.dialog(
                          itemBuilder: (context, item, isSelected) {
                            return ListTile(
                              title: Text(
                                item,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.tealAccent.shade700
                                      : Colors.white,
                                ),
                              ),
                            );
                          },
                          searchFieldProps: TextFieldProps(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.white),
                              labelText: 'To',
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                            ),
                            cursorColor: Colors.tealAccent.shade700,
                          ),
                          dialogProps: DialogProps(
                            backgroundColor: Colors.black,
                          ),
                          scrollbarProps: ScrollbarProps(
                            fadeDuration: Duration(seconds: 3),
                            thumbColor: Colors.teal.shade800,
                          ),
                          showSearchBox: true,
                        ),
                        items: currencies,
                        selectedItem: toCurrency,
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          baseStyle: TextStyle(color: Colors.white),
                          dropdownSearchDecoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.tealAccent.shade700),
                            ),
                          ),
                        ),
                        dropdownBuilder: (context, selectedItem) {
                          return Text(
                            selectedItem ?? "",
                            style: TextStyle(color: Colors.white),
                          );
                        },
                        onChanged: (newValue) {
                          setState(() {
                            toCurrency = newValue!;
                            _getRate();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Rate $rate",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(height: 20),
              Text(
                "${amountController.text} $fromCurrency = ${total.toStringAsFixed(2)} $toCurrency",
                style: TextStyle(
                  color: Colors.tealAccent.shade700,
                  fontSize: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
