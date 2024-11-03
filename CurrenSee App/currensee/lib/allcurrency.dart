import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_picker_dropdown.dart';
import 'package:country_currency_pickers/utils/utils.dart';
import 'package:currensee/components/all_currency_listitem.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Allcurrency(),
      theme: ThemeData(
        textTheme: TextTheme(
          // ignore: deprecated_member_use
          // bodyText2: TextStyle(color: Colors.white),
        ),
      ),
    ),
  );
}

class Allcurrency extends StatefulWidget {
  const Allcurrency({Key? key}) : super(key: key);

  @override
  State<Allcurrency> createState() => _AllcurrencyState();
}

class _AllcurrencyState extends State<Allcurrency> {
  ApiService apiService = ApiService();
  String _selectedCurrency = "USD";
  final TextEditingController _searchController = TextEditingController();
  List<CurrencyModel> _filteredCurrencyList = [];

  Widget _buildCurrencyDropdownItem(Country country) => Container(
        child: Row(
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            SizedBox(
              width: 8.0,
            ),
            Center(
              child: Text(
                "${country.currencyName}",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: Text(
          'Rate List',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        // actions: [

        // ],
      ),
      backgroundColor: Colors.black,
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 8,
            ),
            Text("Base Currency",
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.teal[800],
                    fontWeight: FontWeight.w700)),
            SizedBox(
              height: 8,
            ),
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
                  canvasColor: Colors.black, // background color of dropdown
                  scrollbarTheme: ScrollbarThemeData(
                    thumbColor: MaterialStateProperty.all(Colors.teal),
                  ),
                ),
                child: CountryPickerDropdown(
                  initialValue: 'us',
                  itemBuilder: _buildCurrencyDropdownItem,
                  onValuePicked: (Country? country) {
                    print("${country?.name}");
                    setState(() {
                      _selectedCurrency = country?.currencyCode ?? "";
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "All Currencies",
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.teal[800],
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 6,
            ),
            Container(
              width: screenWidth * 0.9,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  cursorColor: Colors.teal,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: TextStyle(
                        color: const Color.fromARGB(211, 255, 255, 255)),
                    border: OutlineInputBorder(),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    prefixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _filteredCurrencyList = [];
                        });
                      },
                    ),
                  ),
                  onChanged: (text) {
                    setState(() {
                      _filteredCurrencyList = [];
                    });
                    apiService.getLatest(_selectedCurrency).then((value) {
                      setState(() {
                        _filteredCurrencyList = value
                            .where((element) => element.code
                                .toString()
                                .toLowerCase()
                                .contains(text.toLowerCase()))
                            .toList();
                      });
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<CurrencyModel> currencyModelList = snapshot.data ?? [];
                    if (_filteredCurrencyList.isNotEmpty) {
                      currencyModelList = _filteredCurrencyList;
                    }
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return AllCurrencyListItem(
                          currencyModel: currencyModelList[index],
                        );
                      },
                      itemCount: currencyModelList.length,
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error occurred"),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
                future: apiService.getLatest(_selectedCurrency),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const base_url = "https://api.currencyapi.com/v3/";
const apikey = "cHi5rGdt1B9qK3hmyox5KhKuR1SVf48m0jOMseAJ";

class ApiService {
  Future<List<CurrencyModel>> getLatest(String baseCurrrency) async {
    List<CurrencyModel> currencyModelList = [];
    String url =
        '${base_url}latest?apikey=$apikey&base_currency=$baseCurrrency';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        Map<String, dynamic> body = json['data'];

        body.forEach((key, value) {
          CurrencyModel currencyModel = CurrencyModel.fromJson(value);
          currencyModelList.add(currencyModel);
        });
        return currencyModelList;
      } else {
        return [];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<CurrencyModel>> getExchange(
      String baseCurrrency, String targetCurrency) async {
    List<CurrencyModel> currencyModelList = [];

    String url =
        '${base_url}latest?apikey=$apikey&base_currency=$baseCurrrency&currencies=$targetCurrency';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        Map<String, dynamic> body = json['data'];

        body.forEach((key, value) {
          CurrencyModel currencyModel = CurrencyModel.fromJson(value);
          currencyModelList.add(currencyModel);
        });
        return currencyModelList;
      } else {
        return [];
      }
    } catch (e) {
      throw e.toString();
    }
  }
}

class CurrencyModel {
  String? code;
  double? value;

  CurrencyModel({this.code, this.value});

  CurrencyModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    value = double.parse(json['value'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['value'] = this.value;
    return data;
  }
}
