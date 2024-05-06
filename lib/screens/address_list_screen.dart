import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solaramps/providers/advanced_profile_provider.dart';
import 'package:solaramps/theme/color.dart';
import 'package:solaramps/utility/constants.dart';
import 'package:solaramps/utility/top_level_variables.dart';
import 'package:solaramps/widget/custom_appbar.dart';
import 'package:solaramps/widget/shimmer.dart';
import 'package:solaramps/widget/shimmer_loading.dart';

class AddressListScreen extends StatefulWidget {
  const AddressListScreen({Key? key}) : super(key: key);

  @override
  _AddressListScreenState createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Shimmer(
        linearGradient: Constants.shimmerGradient,
        child: SafeArea(
          child: Column(
            children: [
              const CustomAppbar(title: 'Addresses'),
              Expanded(
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Card(
                          margin: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                // color: appTheme.primaryColor,
                                color: CustomColor.grenishColor,
                                width: 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextField(
                            onChanged: (e) {
                              if (e.isEmpty) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  TopVariable.advancedProfileProvider
                                      .getSubscriptionAddressesList();
                                });
                              } else {
                                TopVariable.advancedProfileProvider
                                    .searchAddress(e);
                              }
                            },
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              hintText: 'Search address',
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
                        // If there is no data then will sizedBox return
                        Consumer<AdvancedProfileProvider>(
                            builder: (context, advancedProfileConsumer, child) {
                          child = advancedProfileConsumer
                                      .subscriptionsAddressesTilesList
                                      .isNotEmpty ==
                                  true
                              ? ShimmerLoading(
                                  isLoading: advancedProfileConsumer.isLoading,
                                  child: Column(
                                    children: advancedProfileConsumer
                                        .subscriptionsAddressesTilesList,
                                  ),
                                )
                              : SizedBox(
                                  height: 324,
                                  child: Center(
                                      child: Text(advancedProfileConsumer
                                              .subscriptionsAddressesTilesList
                                              .isEmpty
                                          ? ''
                                          : 'No Address Found')),
                                );
                          return child;
                        }),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TopVariable.advancedProfileProvider.getSubscriptionAddressesList();
    });
    super.initState();
  }
}
