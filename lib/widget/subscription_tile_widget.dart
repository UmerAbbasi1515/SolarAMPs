// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solaramps/theme/color.dart';

import '../utility/top_level_variables.dart';

class SubscriptionTile extends StatefulWidget {
  final String subscriptionId,
      subscriptionStatus,
      subscriptionTemplete,
      garden,
      premiseNo,
      activationDate,
      terminationDate,
      inverterValue,variantAlias;
  bool selected;
  SubscriptionTile(
      {Key? key,
      this.subscriptionId = '',
      this.subscriptionStatus = '',
      this.subscriptionTemplete = "",
      this.garden = '',
      this.premiseNo = '',
      this.activationDate = '',
      this.terminationDate = '',
      this.inverterValue = '',
      this.variantAlias = '',
      this.selected = false})
      : super(key: key);

  @override
  State<SubscriptionTile> createState() => _SubscriptionTileState();
}

class _SubscriptionTileState extends State<SubscriptionTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Container(
        width: screenWidth,
        color: widget.subscriptionStatus == "INACTIVE"
            ? Colors.grey[300]
            : const Color.fromRGBO(245, 245, 245, 1),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  widget.subscriptionStatus == 'null' ||
                          widget.subscriptionStatus == ''
                      ? const SizedBox()
                      : Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 5),
                            alignment: Alignment.centerRight,
                            child: Text(
                              widget.subscriptionStatus,
                              style: widget.subscriptionStatus != "INACTIVE"
                                  ? TextStyle(
                                      color: appTheme.primaryColor,
                                      fontWeight: FontWeight.bold)
                                  : TextStyle(color: appTheme.primaryColor),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        )
                ],
              ),
              SizedBox(
                // height: 50,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 5),
                      alignment: Alignment.topLeft,
                      child: const Text('Subscription ID:'),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: Get.width * 0.5,
                      padding: const EdgeInsets.only(bottom: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.subscriptionId,
                        style: const TextStyle(color: CustomColor.grenishColor),
                        // style: TextStyle(color: appTheme.primaryColor),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    alignment: Alignment.centerLeft,
                    child: const Text('Garden:'),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.garden,
                      // style: TextStyle(color: appTheme.primaryColor),
                      style: const TextStyle(color: CustomColor.grenishColor),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    alignment: Alignment.centerLeft,
                    child: const Text('Premise No. '),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    alignment: Alignment.centerLeft,
                    child: Text(widget.premiseNo),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    alignment: Alignment.centerLeft,
                    child: const Text('Active Since:'),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    alignment: Alignment.centerLeft,
                    child: Text(widget.activationDate),
                  ),
                ],
              ),
              Visibility(
                visible: widget.terminationDate != '',
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 5),
                      alignment: Alignment.centerLeft,
                      child: const Text('Terminate On:'),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(widget.terminationDate),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
