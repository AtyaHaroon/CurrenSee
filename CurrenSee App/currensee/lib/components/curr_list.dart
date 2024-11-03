import 'package:flutter/material.dart';
import 'package:currensee/allcurrency.dart';

class AllCurrencyListItem extends StatelessWidget {
  final CurrencyModel currencyModel;
  final VoidCallback onDelete;

  AllCurrencyListItem({
    Key? key,
    required this.currencyModel,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      margin: EdgeInsets.all(14),
      width: screenWidth * 0.9,
      decoration: BoxDecoration(
        color: Colors.teal.shade800,
        borderRadius: BorderRadius.circular(10),
      ),
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
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
