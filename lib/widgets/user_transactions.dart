import 'package:flutter/material.dart';
import './new_transactions.dart';
import './transactions_list.dart';
import '../models/transactions.dart';

class UserTransactions extends StatefulWidget {
  const UserTransactions({Key? key}) : super(key: key);

  @override
  State<UserTransactions> createState() => _UserTransactionState();
}

class _UserTransactionState extends State<UserTransactions> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // NewTransaction(_addNewTransaction),
        // TransactionList(_userTransactions)
      ],
    );
  }
}
