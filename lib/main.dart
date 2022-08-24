import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widgets/chart.dart';
import './widgets/transactions_list.dart';
import './widgets/new_transactions.dart';
import './models/transactions.dart';

void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  //SystemChrome.setPreferredOrientations([
  //  DeviceOrientation.portraitUp,
  //  DeviceOrientation.portraitDown,
  //]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //return Platform.isIOS?CupertinoApp(title: 'Personal Expenses',
    //  theme: CupertinoThemeData(
    //    primarySwatch: Colors.indigo,
    //    accentColor: Colors.indigoAccent,
    //    fontFamily: 'Quicksand',
    //  ),
    //  home: MyHomePage(),
    //):
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: Colors.indigoAccent,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
                titleSmall: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 18,
                    fontWeight: FontWeight.normal),
              )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //String? titleInput;

  final List<Transactions> _userTransactions = [
    //Transactions(
    //  id: "t1", title: "New Shoes", amount: 999.80, date: DateTime.now()),
    //Transactions(
    //  id: "t2", title: "Groceries", amount: 875.65, date: DateTime.now()),
  ];
  bool _showChart = false;

  List<Transactions>? get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transactions(
        title: txTitle,
        amount: txAmount,
        date: chosenDate,
        id: DateTime.now().toString());
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final ObstructingPreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Personal Expenses'),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              GestureDetector(
                child: Icon(CupertinoIcons.add),
                onTap: () => _startAddNewTransaction(context),
              )
            ]),
          )
        : AppBar(
            title: Text('Personal Expenses'),
            backgroundColor: Theme.of(context).primaryColorDark,
            actions: <Widget>[
              IconButton(
                  onPressed: () => _startAddNewTransaction(context),
                  icon: Icon(Icons.add))
            ],
          ) as ObstructingPreferredSizeWidget;
    final txListWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(_userTransactions, _deleteTransaction));
    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //Container(
            //  width: double.infinity,
            //  child: Card(
            //    child: Container(
            //        margin: EdgeInsets.all(10),
            //        child: Text(
            //          'Planner',
            //          style: TextStyle(fontSize: 25, color: Colors.white),
            //        )),
            //    color: Theme.of(context).accentColor,
            //    elevation: 5,
            //  ),
            //),
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Show Chart',
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 18,
                        fontWeight: FontWeight.normal),
                  ),
                  Switch.adaptive(
                      activeColor: Colors.indigoAccent,
                      value: _showChart,
                      onChanged: (val) {
                        setState(() {
                          _showChart = val;
                        });
                      })
                ],
              ),
            if (!isLandscape)
              Container(
                  height: (mediaQuery.size.height -
                          appBar.preferredSize.height -
                          mediaQuery.padding.top) *
                      0.3,
                  child: Chart(_recentTransactions!)),
            if (!isLandscape) txListWidget,
            if (isLandscape)
              _showChart
                  ? Container(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.7,
                      child: Chart(_recentTransactions!))
                  : Container(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          1,
                      child: TransactionList(
                          _userTransactions, _deleteTransaction)),
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context)),
          );
  }
}
