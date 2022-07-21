import 'package:flutter/material.dart';
import 'package:planner_app/models/transactions.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transactions> transactions;
  final Function deleteTx;
  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 450,
        child: transactions.isEmpty
            ? Column(
                children: <Widget>[
                  Text(
                    'No transactions added yet!',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 70),
                  Container(
                      height: 200,
                      child: Image.asset(
                        'assets/image/waiting.png',
                        fit: BoxFit.cover,
                      )),
                ],
              )
            : ListView.builder(
                itemBuilder: (ctx, index) {
                  return Card(
                      elevation: 5,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                      child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            child: Padding(
                                padding: EdgeInsets.all(10),
                                child: FittedBox(
                                    child: Text(
                                  'Rs.${transactions[index].amount}',
                                ))),
                          ),
                          title: Text(
                            transactions[index].title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          subtitle: Text(DateFormat.yMMMd()
                              .format(transactions[index].date)),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Theme.of(context).accentColor,
                            ),
                            onPressed: () => deleteTx(transactions[index].id),
                          )));
                },
                itemCount: transactions.length,
              ));
  }
}
