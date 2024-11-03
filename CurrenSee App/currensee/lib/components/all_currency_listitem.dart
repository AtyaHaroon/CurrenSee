import 'package:currensee/allcurrency.dart';
import 'package:flutter/material.dart';

class AllCurrencyListItem extends StatelessWidget {
  final CurrencyModel currencyModel;

  AllCurrencyListItem({Key? key, required this.currencyModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      margin: EdgeInsets.all(14),
      width: screenWidth * 0.9,
      decoration: BoxDecoration(
          color: Colors.teal.shade800, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            currencyModel.code.toString(),
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
          Text(
            currencyModel.value?.toStringAsFixed(2).toString() ?? "",
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
        ],
      ),
    );
  }
}
