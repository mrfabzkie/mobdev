import 'package:expenses/widgets/new_transaction.dart';

import 'package:flutter/material.dart';

import 'model/transaction.dart';
import 'widgets/chart.dart';
import 'widgets/transaction_list.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //     id: 'T1',
    //     title: 'New shoes',
    //     amount: 99.00,
    //     date: DateTime.now().subtract(Duration(days: 2))),
    // Transaction(
    //     id: 'T2',
    //     title: 'Checken',
    //     amount: 110.00,
    //     date: DateTime.now().subtract(Duration(days: 4))),
    // Transaction(id: 'T3', title: 'Juice', amount: 20.00, date: DateTime.now()),
    // Transaction(id: 'T4', title: 'Fish', amount: 45.00, date: DateTime.now()),
  ];

  List<Transaction> get _getUserTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(_addNewTransaction);
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final Transaction tx = Transaction(
        title: txTitle,
        amount: txAmount,
        date: chosenDate,
        id: _userTransactions.length.toString());
    setState(() {
      _userTransactions.add(tx);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Personal Expenses",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _startAddNewTransaction(context)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
                width: double.infinity,
                child: Card(
                  child: Chart(_getUserTransactions),
                )),
            TransactionList(_userTransactions, _deleteTransaction),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
