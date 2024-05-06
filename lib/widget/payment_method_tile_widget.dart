import 'package:flutter/material.dart';

import '../utility/top_level_variables.dart';

class PaymentMethodTileWidget extends StatefulWidget {
  final String paymentMethodName,
      paymentSource,
      accountType,
      bankName,
      accountTitle,
      accountNo,
      routingNo;
  final int paymentMethodId;
  const PaymentMethodTileWidget({
    Key? key,
    this.paymentMethodName = '',
    this.paymentSource = '',
    this.accountType = '',
    this.bankName = '',
    this.accountTitle = '',
    this.paymentMethodId = 0,
    this.accountNo = '',
    this.routingNo = '',
  }) : super(key: key);

  @override
  _PaymentMethodTileWidgetState createState() =>
      _PaymentMethodTileWidgetState();
}

class _PaymentMethodTileWidgetState extends State<PaymentMethodTileWidget> {
  bool accountNoVisible = false, routingNoVisible = false;
  String accountNo = '**** **** **** ****', routingNo = '**** **** **** ****';
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Container(
        width: screenWidth,
        color: const Color.fromRGBO(245, 245, 245, 1),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.paymentMethodName,
                      style: TextStyle(color: appTheme.primaryColor),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    alignment: Alignment.centerLeft,
                    child: const Text('Payment Source:'),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    alignment: Alignment.centerLeft,
                    child: Text(widget.paymentSource),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    alignment: Alignment.centerLeft,
                    child: const Text('Account Type:'),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    alignment: Alignment.centerLeft,
                    child: Text(widget.accountType),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    alignment: Alignment.centerLeft,
                    child: const Text('Bank Name:'),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    alignment: Alignment.centerLeft,
                    child: Text(widget.bankName),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    alignment: Alignment.centerLeft,
                    child: const Text('Account Title:'),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    alignment: Alignment.centerLeft,
                    child: Text(widget.accountTitle),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    alignment: Alignment.centerLeft,
                    child: const Text('Account No.'),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                      padding: const EdgeInsets.only(bottom: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                          accountNoVisible ? widget.accountNo : accountNo)),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 5),
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(
                          accountNoVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          setState(() {
                            accountNoVisible = !accountNoVisible;
                          });
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    alignment: Alignment.centerLeft,
                    child: const Text('Routing No.'),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                      padding: const EdgeInsets.only(bottom: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                          routingNoVisible ? widget.routingNo : routingNo)),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 5),
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(
                          routingNoVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          setState(() {
                            routingNoVisible = !routingNoVisible;
                          });
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
