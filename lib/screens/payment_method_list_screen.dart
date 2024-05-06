import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solaramps/utility/constants.dart';
import 'package:solaramps/widget/shimmer.dart';
import '../providers/advanced_profile_provider.dart';
import '../utility/top_level_variables.dart';
import '../widget/custom_appbar.dart';

class PaymentMethodListScreen extends StatefulWidget {
  const PaymentMethodListScreen({Key? key}) : super(key: key);

  @override
  _PaymentMethodListScreenState createState() =>
      _PaymentMethodListScreenState();
}

class _PaymentMethodListScreenState extends State<PaymentMethodListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Shimmer(
        linearGradient: Constants.shimmerGradient,
        child: SafeArea(
          child: Column(
            children: [
              const CustomAppbar(title: 'Payment Methods'),
              Expanded(
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Card(
                            margin: const EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: appTheme.primaryColor, width: 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextField(
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  TopVariable.advancedProfileProvider
                                      .getPaymentMethodsList();
                                } else {
                                  TopVariable.advancedProfileProvider
                                      .searchPaymentMethod(value);
                                }
                              },
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 15),
                                hintText: 'Search',
                                isDense: true,
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                suffixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                  size: 25,
                                ),
                              ),
                            ),
                          ),
                          Consumer<AdvancedProfileProvider>(builder:
                              (context, advancedProfileConsumer, child) {
                            child = Column(
                              children: advancedProfileConsumer
                                  .customerPaymentMethodTilesList,
                            );
                            return child;
                          }),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      )))
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    TopVariable.advancedProfileProvider.getPaymentMethodsList();
  }
}
