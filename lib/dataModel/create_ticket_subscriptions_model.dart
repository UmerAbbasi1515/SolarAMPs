class AllSubscriptionsModalForCreateTicket {
  int? id;
  String? subscriptionType;
  String? subscriptionTemplate;
  String? startDate;
  List<String>? customerSubscriptionMappings;

  AllSubscriptionsModalForCreateTicket(
      {this.id,
      this.subscriptionType,
      this.subscriptionTemplate,
      this.startDate,
      this.customerSubscriptionMappings});

  AllSubscriptionsModalForCreateTicket.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subscriptionType = json['subscriptionType'];
    subscriptionTemplate = json['subscriptionTemplate'];
    startDate = json['startDate'];
    customerSubscriptionMappings =
        json['customerSubscriptionMappings'].cast<String>();
  }

}
