import 'package:flutter/material.dart';

import 'hometile.dart';

class HomeTileRepository {
  static List<HomeTile> loadHomeTile() {
    var allHomeTile = <HomeTile> [

      const HomeTile(
        icon: Icon(Icons.person),
        title: "My Profile",
        desc: "John Doe",
        navigationPath: '/myProfile',
      ),
      const HomeTile( icon: Icon(Icons.account_balance_wallet),
        title: "My Wallet",
        desc: "150 Credits",
        navigationPath: '/myWallet',
      ),
      // const HomeTile( icon: Icon(Icons.settings),
      //   title: "General Settings",
      //   desc: "Change alerts settings",
      //   navigationPath: '/myProfile',
      // ),
       const HomeTile( icon: Icon(Icons.person_add),
        title: "My Recipients",
        desc: "Notification recipients",
         navigationPath: '/myRecipients',
      ),
      // const HomeTile( icon: Icon(Icons.help),
      //   title: "Help",
      //   desc: "Questions",
      //   navigationPath: '/myProfile',
      // ),
    ];
    return allHomeTile;
  }
}
