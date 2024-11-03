import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  final List<String> history;

  const HistoryPage({Key? key, required this.history}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late List<String> _history; // Use a local copy of history for manipulation
  String? _deletedItem; // To store the deleted item for undo
  int? _deletedIndex; // To store the index of the deleted item

  @override
  void initState() {
    super.initState();
    _history = List.from(
        widget.history); // Copy the list to avoid modifying the original
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: _history.isEmpty
          ? Center(
              child: Text(
                'No conversion history yet!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(_history[index]), // Unique key for each item
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      _deletedItem = _history[index];
                      _deletedIndex = index;
                      _history.removeAt(index);
                      _saveHistory();
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Conversion history deleted'),
                        action: SnackBarAction(
                          label: 'Undo',
                          backgroundColor: Colors.teal,
                          onPressed: () {
                            if (_deletedItem != null && _deletedIndex != null) {
                              setState(() {
                                _history.insert(_deletedIndex!, _deletedItem!);
                                _saveHistory();
                              });
                            }
                          },
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.grey[900],
                    child: ListTile(
                      title: Text(
                        _history[index],
                        style: TextStyle(color: Colors.white),
                      ),
                      tileColor: Colors.black54,
                    ),
                  ),
                );
              },
            ),
      backgroundColor: Colors.black,
    );
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('conversionHistory', _history);
  }
}
