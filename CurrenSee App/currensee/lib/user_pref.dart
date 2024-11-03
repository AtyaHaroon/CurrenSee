import 'dart:convert';
import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_picker_dropdown.dart';
import 'package:country_currency_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "CurrenSee",
      home: User_pref(),
      theme: ThemeData(
        textTheme: TextTheme(
            // ignore: deprecated_member_use
            // bodyText2: TextStyle(color: Colors.white),
            ),
      ),
    ),
  );
}

class User_pref extends StatefulWidget {
  const User_pref({Key? key}) : super(key: key);

  @override
  State<User_pref> createState() => _User_prefState();
}

class _User_prefState extends State<User_pref> {
  ApiService apiService = ApiService();
  List<Country> _selectedCountries = [];
  Map<String, CurrencyModel> _currencyDetails = {};

  @override
  void initState() {
    super.initState();
    _loadSelectedCurrencies();
  }

  Future<void> _loadSelectedCurrencies() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCountries = prefs.getStringList('selected_countries') ?? [];
    final savedDetails = prefs.getString('currency_details') ?? '{}';

    setState(() {
      _selectedCountries = savedCountries
          .map((code) => CountryPickerUtils.getCountryByCurrencyCode(code))
          // ignore: unnecessary_null_comparison
          .where((country) => country != null)
          .cast<Country>()
          .toList();

      _currencyDetails = Map<String, CurrencyModel>.from(
        json.decode(savedDetails).map(
              (key, value) => MapEntry(
                key,
                CurrencyModel.fromJson(value),
              ),
            ),
      );
    });
  }

  Future<void> _saveSelectedCurrencies() async {
    final prefs = await SharedPreferences.getInstance();
    final countryCodes = _selectedCountries
        .map((c) => c.currencyCode ?? '')
        .where((code) => code.isNotEmpty)
        .toList();
    final currencyDetailsJson = json.encode(
      _currencyDetails.map(
        (key, value) => MapEntry(
          key,
          value.toJson(),
        ),
      ),
    );

    await prefs.setStringList('selected_countries', countryCodes);
    await prefs.setString('currency_details', currencyDetailsJson);
  }

  void _addCurrency(Country country) async {
    setState(() {
      if (!_selectedCountries.contains(country)) {
        _selectedCountries.add(country);
      }
    });

    List<CurrencyModel> currencyModels =
        await apiService.getLatest([country.currencyCode!]);
    if (currencyModels.isNotEmpty) {
      setState(() {
        _currencyDetails[country.currencyCode!] = currencyModels.first;
      });
    }
    await _saveSelectedCurrencies();
  }

  void _removeCurrency(Country country) async {
    setState(() {
      _selectedCountries.remove(country);
      _currencyDetails.remove(country.currencyCode);
    });
    await _saveSelectedCurrencies();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.teal,
        content: Center(child: Text("${country.currencyName} removed")),
        duration: Duration(seconds: 6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade500,
        foregroundColor: Colors.white,
        title: Text(
          'Useer preferences',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 8),
            Text(
              "Base Currency",
              style: TextStyle(
                fontSize: 25,
                color: Colors.teal[800],
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: screenWidth * 0.9,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.teal),
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Colors.black,
                  scrollbarTheme: ScrollbarThemeData(
                    thumbColor: MaterialStateProperty.all(Colors.teal),
                  ),
                ),
                child: CountryPickerDropdown(
                  initialValue: 'us',
                  itemBuilder: _buildCurrencyDropdownItem,
                  onValuePicked: (Country? country) {
                    if (country != null) {
                      _addCurrency(country);
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Selected Currencies",
              style: TextStyle(
                fontSize: 25,
                color: Colors.teal[800],
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 6),
            Expanded(
              child: ListView.builder(
                itemCount: _selectedCountries.length,
                itemBuilder: (context, index) {
                  final country = _selectedCountries[index];
                  final currencyCode = country.currencyCode!;
                  final currencyDetails = _currencyDetails[currencyCode];

                  return Dismissible(
                    key: Key(country.currencyCode!),
                    background: Container(
                      color: Colors.red.shade700,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                      ),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red.shade700,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      _removeCurrency(country);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      margin: EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade800,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                CountryPickerUtils.getDefaultFlagImage(country),
                                SizedBox(width: 10),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    country.currencyName!,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    currencyCode,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    currencyDetails != null
                                        ? currencyDetails.value
                                                ?.toStringAsFixed(4) ??
                                            'Loading...'
                                        : 'Loading...',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyDropdownItem(Country country) => Container(
        child: Row(
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            SizedBox(width: 8.0),
            Center(
              child: Text(
                "${country.currencyName}",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
}

const base_url = "https://api.currencyapi.com/v3/";
const apikey = "cur_live_BehuLOkVIf4eaLkrPZnG3DDnXOZISJOgOn5nvvBK";

class ApiService {
  final _cache = <String, List<CurrencyModel>>{};

  Future<List<CurrencyModel>> getLatest(List<String> baseCurrencies) async {
    final key = baseCurrencies.join(',');
    if (_cache.containsKey(key)) {
      return _cache[key]!;
    }

    final response = await http.get(Uri.parse(
        'https://api.currencyapi.com/v3/latest?apikey=cur_live_BehuLOkVIf4eaLkrPZnG3DDnXOZISJOgOn5nvvBK&base_currency=$key'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final currencyModels = _parseJson(json);
      _cache[key] = currencyModels;
      return currencyModels;
    } else {
      return [];
    }
  }

  List<CurrencyModel> _parseJson(Map<String, dynamic> json) {
    List<CurrencyModel> currencyModelList = [];
    Map<String, dynamic> body = json['data'];
    Map<String, dynamic> rates = body['rates'];

    rates.forEach((key, value) {
      CurrencyModel currencyModel = CurrencyModel(
        code: key,
        value: double.parse(value.toString()),
      );
      currencyModelList.add(currencyModel);
    });
    return currencyModelList;
  }
}

class CurrencyModel {
  String? code;
  double? value;

  CurrencyModel({this.code, this.value});

  factory CurrencyModel.fromCodeAndValue(String code, double value) {
    return CurrencyModel(
      code: code,
      value: value,
    );
  }

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      code: json['code'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['value'] = value;
    return data;
  }
}
