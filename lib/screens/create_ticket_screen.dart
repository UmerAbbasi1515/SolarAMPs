// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' as getx;
import 'package:google_fonts/google_fonts.dart';
import 'package:solaramps/dataModel/all_categories_modal.dart';
import 'package:solaramps/dataModel/create_ticket_subscriptions_model.dart';
import 'package:solaramps/dataModel/sub_cat_model.dart';
import 'package:solaramps/theme/color.dart';
import 'package:solaramps/utility/app_url.dart';
import 'package:solaramps/utility/shared_preference.dart';
import 'package:solaramps/utility/top_level_variables.dart';
import 'package:solaramps/widget/attatchment_widget.dart';
import 'package:solaramps/widget/custom_appbar.dart';
import 'package:solaramps/widget/dropdown_button.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';

class AttachmentModel {
  String name, path, type;
  Icon? icon;

  AttachmentModel(
      {this.name = "", required this.path, required this.type, this.icon});
}

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({Key? key}) : super(key: key);

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

List<AttachmentModel> _files = [
  AttachmentModel(
      name: "Upload Attachments",
      path: "",
      type: "add",
      icon: const Icon(Icons.cloud_upload)),
];

class ThumbnailResult {
  final Image image;
  final int dataSize;
  final int height;
  final int width;

  const ThumbnailResult(
      {required this.image,
      required this.dataSize,
      required this.height,
      required this.width});
}

class ThumbnailRequest {
  final String video;
  final String thumbnailPath;
  // final ImageFormat imageFormat;
  final int maxHeight;
  final int maxWidth;
  final int timeMs;
  final int quality;

  const ThumbnailRequest(
      {required this.video,
      this.thumbnailPath = "",
      // required this.imageFormat,
      required this.maxHeight,
      required this.maxWidth,
      required this.timeMs,
      required this.quality});
}

Future<ThumbnailResult> genThumbnail(ThumbnailRequest r) async {
  final Completer<ThumbnailResult> completer = Completer();
  // Uint8List bytes = (await VideoThumbnail.thumbnailData(
  //     video: r.video,
  //     imageFormat: r.imageFormat,
  //     maxHeight: r.maxHeight,
  //     maxWidth: r.maxWidth,
  //     timeMs: r.timeMs,
  //     quality: r.quality))!;

  // int _imageDataSize = bytes.length;

  // final _image = Image.memory(
  //   bytes,
  //   fit: BoxFit.cover,
  // );
  // _image.image.resolve(ImageConfiguration()).addListener(ImageStreamListener(
  //   (ImageInfo info, bool _) {
  //     completer.complete(ThumbnailResult(
  //       image: _image,
  //       dataSize: _imageDataSize,
  //       height: info.image.height,
  //       width: info.image.width,
  //     ));
  //   },
  // ));
  return completer.future;
}

PortalAttributeValuesTenant _subCategory = PortalAttributeValuesTenant();
// AllCategoriesModal _subCategory = AllCategoriesModal();
AllCategoriesModal _category = AllCategoriesModal();
String selectedCat = _category.description;
List<PortalAttributeValuesTenant> listOfSubCat = [];
AllSubscriptionsModalForCreateTicket _subscriptions =
    AllSubscriptionsModalForCreateTicket();
AllCategoriesModal _priority = AllCategoriesModal();

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  bool _showAttachments = false;
  // ignore: unused_field
  bool _isShown = false;
  TextEditingController nameController = TextEditingController(text: "ffff");
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  bool _isSelectedCat = false;
  bool _isSelectedSubCat = false;
  bool _isSelectedPriority = false;

  @override
  void initState() {
    _category = AllCategoriesModal();
    // getLOVFutureFunc = TopVariable.apiService.getLov();
    // getCategoryFutureFunc = TopVariable.apiService.getCategory();
    // getSubCategoryFutureFunc = TopVariable.apiService.getSubCategory(56);
    // getPriorityFutureFunc = TopVariable.apiService.getPriority();
    TopVariable.ticketsProvider.getSubscriptionsForCreateTicket();
    TopVariable.ticketsProvider.getAllowFiles();

    super.initState();
  }

  void showSnack(String t) {
    setState(() {
      _isShown = true;
    });
    AppUrl.scaffoldMessangerKey.currentState!
        .showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 1),
            content: Text(
              t,
              style: TextStyle(
                  fontFamily: GoogleFonts.openSans().fontFamily, fontSize: 14),
            ),
          ),
        )
        .closed
        .then((value) => {
              ScaffoldMessenger.of(context).removeCurrentSnackBar(),
              setState(() {
                _isShown = false;
              })
            });
  }

  Future<void> createTicket(BuildContext context) async {
    // if (_formKey.currentState!.validate()) {
    setState(() {
      _disableClick = false;
    });

    var user = UserPreferences.user;

    Map<String, dynamic> map1 = {
      "summary": _summaryController.text,
      "message": _messageController.text,
      "category": _category.description,
      "subCategory": _subCategory.description,
      // "subCategory": _subCategory.description,
      "priority": _priority.description,
      "status": "Open",
      "raisedBy": user.acctId,
      "firstName": user.firstName,
      "lastName": user.lastName,
      "role": user.roles?[0],
      "channel": "web",
      "contractId": _subscriptions.id,
      "customerId": user.acctId,
      "sourceType": "ENTITY",
      "sourceId": user.acctId
    };
    if (_files.isNotEmpty) {
      for (int i = 0; i < _files.length; i++) {
        if (_files[i].path == '') {
          _files.removeAt(i);
        }
      }
      for (int i = 0; i < _files.length; i++) {
        print('name ::::::: ${_files[i].name}');
        print('Path ::::::: ${_files[i].path}');
        print('Type ::::::: ${_files[i].type}');
      }
    }
    var listOfFiles = _files
        .where((element) => element.type != "add")
        .map((f) => MultipartFile.fromFile(f.path))
        .toList();
    print('Files list length ::::: ${listOfFiles.length}');
    List<MultipartFile> listOfFiles1 = [];
    for (int i = 0; i < listOfFiles.length; i++) {
      listOfFiles1.add(await listOfFiles[i]);
    }
    var el = FormData.fromMap({
      "conversationHeadDTO": jsonEncode(map1),
      "multipartFiles": listOfFiles1,
    });
    var compKey = UserPreferences.compKey;
    print('Comp Key ::::::===>  $compKey');

    final _headers = <String, dynamic>{r'Comp-Key': compKey};
    TopVariable.getDioInstance()
        .post(AppUrl.baseUrl + AppUrl.createTicket,
            data: el, options: Options(headers: _headers))
        .then((value) => {
              print(value.data),
              print('Creation of the ticket  FD ::::: $el'),
              print('Creation of the ticket DATA ::::: ${value.data}'),
              print('Creation of the ticket HEADER ::::: ${value.headers}'),
              print('Creation of the ticket URL ::::: ${value.realUri}'),
              print('Creation of the ticket ::::: ${value.statusMessage}'),
              print('Creation of the ticket STCODE ::::: ${value.statusCode}'),
              showDialog(
                context: context,
                builder: (c) => AlertDialog(
                  title: const Text("Success"),
                  content: const Text("Ticket created successfully"),
                  actions: <Widget>[
                    TextButton(
                      child: const Text("OK"),
                      onPressed: () async => {
                        _summaryController.clear(),
                        _messageController.clear(),
                        _files.clear(),
                        _files.add(AttachmentModel(
                            name: "Upload Attachments",
                            path: "",
                            type: "add",
                            icon: const Icon(Icons.cloud_upload))),
                        Navigator.pop(context),
                        getx.Get.back()
                      },
                    )
                  ],
                ),
              )
            })
        .onError((error, stackTrace) => {print(error)})
        .whenComplete(
          () => {
            setState(() {
              _disableClick = true;
            })
          },
        );
    // }
  }
  // Future<void> createTicket(BuildContext context) async {
  //   // if (_formKey.currentState!.validate()) {
  //   setState(() {
  //     _disableClick = false;
  //   });

  //   var user = UserPreferences.user;
  //   // Map<String, dynamic> map = {
  //   //   "customerId": user.acctId,
  //   //   "raisedBy": user.acctId,
  //   //   "message": _messageController.text,
  //   //   "summary": _summaryController.text,
  //   //   "category": _category.description,
  //   //   "priority": _priority.description,
  //   //   "subCategory": _subCategory.description,
  //   //   "status": "Open",
  //   //   "role": user.roles?[0],
  //   //   "firstName": user.firstName,
  //   //   "lastName": user.lastName,
  //   // };

  //   Map<String, dynamic> map1 = {
  //     "summary": _summaryController.text,
  //     "message": _messageController.text,
  //     "category": _category.description,
  //     "subCategory": _subCategory.description,
  //     "priority": _priority.description,
  //     "status": "Open",
  //     "raisedBy": user.acctId,
  //     "firstName": user.firstName,
  //     "lastName": user.lastName,
  //     "role": user.roles?[0],
  //     "channel": "web",
  //     "contractId": _subscriptions.id,
  //     "customerId": user.acctId,
  //     "sourceType": "ENTITY",
  //     "sourceId": user.acctId
  //   };
  //   if (_files.isNotEmpty) {
  //     for (int i = 0; i < _files.length; i++) {
  //       if (_files[i].path == '') {
  //         _files.removeAt(i);
  //       }
  //     }
  //     for (int i = 0; i < _files.length; i++) {
  //       print('name ::::::: ${_files[i].name}');
  //       print('Path ::::::: ${_files[i].path}');
  //       print('Type ::::::: ${_files[i].type}');
  //     }
  //   }
  //   var listOfFiles = _files
  //       .where((element) => element.type != "add")
  //       .map((f) async => await MultipartFile.fromFile(f.path))
  //       .toList();
  //   print('Files list length ::::: ${listOfFiles.length}');
  //   var formData = FormData();
  //   for (int i = 0; i < listOfFiles.length; i++) {
  //     formData.files.addAll([
  //       MapEntry(
  //           "img",
  //           await MultipartFile.fromFile(_files[i].path,
  //               filename: _files[i].name))
  //     ]);
  //   }
  //   var el = FormData.fromMap({
  //     "conversationHeadDTO": jsonEncode(map1),
  //     "multipartFiles": formData.files, //listOfFiles,
  //   });
  //   var compKey = UserPreferences.compKey;
  //   final _headers = <String, dynamic>{r'Comp-Key': compKey};
  //   TopVariable.getDioInstance()
  //       .post(AppUrl.baseUrl + AppUrl.createTicket,
  //           data: el, options: Options(headers: _headers))
  //       .then((value) => {
  //             print(value.data),
  //             print('Creation of the ticket  FD ::::: $el'),
  //             print('Creation of the ticket DATA ::::: ${value.data}'),
  //             print('Creation of the ticket HEADER ::::: ${value.headers}'),
  //             print('Creation of the ticket URL ::::: ${value.realUri}'),
  //             print('Creation of the ticket ::::: ${value.statusMessage}'),
  //             print('Creation of the ticket STCODE ::::: ${value.statusCode}'),
  //             showDialog(
  //               context: context,
  //               builder: (c) => AlertDialog(
  //                 title: const Text("Success"),
  //                 content: const Text("Ticket created successfully"),
  //                 actions: <Widget>[
  //                   TextButton(
  //                     child: const Text("OK"),
  //                     onPressed: () async => {
  //                       _summaryController.clear(),
  //                       _messageController.clear(),
  //                       _files.clear(),
  //                       _files.add(AttachmentModel(
  //                           name: "Upload Attachments",
  //                           path: "",
  //                           type: "add",
  //                           icon: const Icon(Icons.cloud_upload))),
  //                       Navigator.pop(context),
  //                       getx.Get.back()
  //                     },
  //                   )
  //                 ],
  //               ),
  //             )
  //           })
  //       .onError((error, stackTrace) => {print(error)})
  //       .whenComplete(
  //         () => {
  //           setState(() {
  //             _disableClick = true;
  //           })
  //         },
  //       );
  //   // }
  // }

  final _formKey = GlobalKey<FormState>();
  final formCat = GlobalKey<FormFieldState>();
  bool _disableClick = true;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        bottomNavigationBar: getx.Obx(() {
          return TopVariable.ticketsProvider.crealteIsLoadingForGetTickets.value
              ? const SizedBox()
              : TopVariable.ticketsProvider.isLoadingCreateButton.value
                  ? SizedBox(
                      width: screenWidth,
                      child: const CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: screenWidth,
                        child: TextButton(
                          onPressed: !_disableClick
                              ? null
                              : () {
                                  if (_summaryController.text == "") {
                                    showSnack("Please enter Summary");
                                    return;
                                  }
                                  if (_messageController.text == "") {
                                    showSnack("Please enter message");
                                    return;
                                  }
                                  if (_category.description == "") {
                                    showSnack("Please select a category");
                                    return;
                                  }

                                  if (_subCategory.description == "") {
                                    showSnack("Please select a sub category");
                                    return;
                                  }
                                  // if (_subCategory.description == "") {
                                  //   showSnack("Please select a sub category");
                                  //   return;
                                  // }

                                  if (_priority.description == "") {
                                    showSnack("Please select a priority");
                                    return;
                                  }
                                  if (_isSelectedCat == false) {
                                    showSnack("Please select a category");
                                    return;
                                  }

                                  if (_isSelectedSubCat == false) {
                                    showSnack("Please select a sub category");
                                    return;
                                  }

                                  if (_isSelectedPriority == false) {
                                    showSnack("Please select a priority");
                                    return;
                                  } else {
                                    setState(() {
                                      TopVariable.ticketsProvider
                                          .isLoadingCreateButton.value = true;
                                    });
                                    createTicket(context);
                                    setState(() {
                                      TopVariable.ticketsProvider
                                          .isLoadingCreateButton.value = false;
                                    });
                                  }
                                },
                          style: ButtonStyle(
                              backgroundColor: !_disableClick
                                  ? MaterialStateProperty.all(
                                      // const Color(0xFF2E3850).withOpacity(0.4)
                                      CustomColor.grenishColor.withOpacity(0.4))
                                  : MaterialStateProperty.all(
                                      // const Color(0xFF2E3850)
                                      CustomColor.grenishColor)),
                          child: AutoSizeText(
                            "Create".toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: GoogleFonts.openSans().fontFamily),
                          ),
                        ),
                      ),
                    );
        }),
        body: SafeArea(
          child:
              /*Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 8),*/
              Form(
            key: _formKey,
            child: getx.Obx(() {
              return TopVariable
                      .ticketsProvider.crealteIsLoadingForGetTickets.value
                  ? SizedBox(
                      height: getx.Get.height * 0.9,
                      child: Column(
                        children: [
                          const CustomAppbar(
                            title: "Create Ticket",
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(top: getx.Get.height * 0.4),
                            child: const Center(
                                child: CircularProgressIndicator(
                              color: CustomColor.grenishColor,
                            )),
                          ),
                        ],
                      ))
                  : ListView(
                      children: [
                        const CustomAppbar(
                          title: "Create Ticket",
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 12.0, left: 8, right: 8),
                          child: SizedBox(
                            height: 40,
                            child: TextFormField(
                              initialValue:
                                  UserPreferences.getString('UserName') ?? "",
                              enabled: false,
                              decoration: InputDecoration(
                                hintText: "Name",
                                labelText: "Name",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  height: 1,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: GoogleFonts.openSans().fontFamily,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 1.5,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 3.0, left: 8, right: 8),
                          child: DropdownFieldWidget(
                            labelText: "Subscription *",
                            items: TopVariable
                                .ticketsProvider.subscriptionListForCreateTicket
                                .map((item) {
                              return '${item.subscriptionType} \n${item.subscriptionTemplate}';
                            }).toList(),
                            onChanged: (item) {
                              var cat = TopVariable.ticketsProvider
                                  .subscriptionListForCreateTicket
                                  .firstWhere((element) =>
                                      '${element.subscriptionType} \n${element.subscriptionTemplate}' ==
                                      item);
                              setState(() {
                                _subscriptions = cat;
                              });
                              print('Selected LOV ::::: $_subscriptions');
                              print('Selected LOV ::::: ${_subscriptions.id}');
                            },
                          ),
                          // child: FutureBuilder<List<AllSubscriptionsModal>>(
                          //   // future: TopVariable.apiService
                          //   //     .getLov(), //getLOVFutureFunc,
                          //   builder: (context, snapshot) {
                          //     var data = snapshot.data;
                          //     if (snapshot.hasData) {
                          //       return DropdownFieldWidget(
                          //         labelText: "Subscription *",
                          //         items: data!.map((item) {
                          //           return '${item.variantName} \n${item.subId}';
                          //         }).toList(),
                          //         onChanged: (item) {
                          //           var cat = data.firstWhere((element) =>
                          //               element.variantName == item);
                          //           setState(() {
                          //             _subscriptions = cat;
                          //           });
                          //           print('Selected LOV ::::: $_subscriptions');
                          //           print(
                          //               'Selected LOV ::::: ${_subscriptions.variantName}');
                          //         },
                          //       );
                          //     } else {
                          //       return Container();
                          //     }
                          //   },
                          // ),
                        ),

                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 1.0, left: 8, right: 8),
                          child: SizedBox(
                            // height: 60,
                            child: TextFormField(
                              onChanged: (value) {
                                if (value != '' ||
                                    value.isEmpty ||
                                    _summaryController.text != '') {
                                  return;
                                } else {
                                  return;
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter summary";
                                } else {
                                  return '';
                                }
                              },
                              maxLines: 1,
                              minLines: 1,
                              controller: _summaryController,
                              maxLength: 100,
                              decoration: InputDecoration(
                                hintText: "Summary *",
                                labelText: "Summary *",
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                isDense: true,
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  height: 1,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: GoogleFonts.openSans().fontFamily,
                                ),
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  height: 1,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: GoogleFonts.openSans().fontFamily,
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0.1),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(4),
                                    bottomLeft: Radius.circular(4),
                                    bottomRight: Radius.circular(4),
                                  ),
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.black87),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 12.0, left: 8, right: 8),
                          child: TextFormField(
                            maxLength: 250,
                            maxLines: 5,
                            controller: _messageController,
                            decoration: InputDecoration(
                              labelText: "Message *",
                              hintText: "Message *",
                              labelStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                height: 1,
                                fontWeight: FontWeight.w500,
                                fontFamily: GoogleFonts.openSans().fontFamily,
                              ),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                height: 1,
                                fontWeight: FontWeight.w500,
                                fontFamily: GoogleFonts.openSans().fontFamily,
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.1),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                  bottomLeft: Radius.circular(4),
                                  bottomRight: Radius.circular(4),
                                ),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.black87),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 12.0, left: 8, right: 8),
                          child: FutureBuilder<List<AllCategoriesModal>>(
                            future: TopVariable
                                .ticketsProvider.getCategoryFutureFunc,
                            builder: (context, snapshot) {
                              var data = snapshot.data;
                              if (snapshot.hasData) {
                                return DropdownFieldWidget(
                                  labelText: "Category *",
                                  items: data!.map((item) {
                                    return item.description;
                                  }).toList(),
                                  onChanged: (item) async {
                                    print('Item ::: $item');
                                    var cat = data.firstWhere((element) =>
                                        element.description == item);
                                    cat.id != 10001 ? cat.id = 56 : cat.id = 57;
                                    // cat.id == 10001 ? cat.id = 56 : cat.id = 57;
                                    setState(() {
                                      _category = cat;
                                      _isSelectedCat = true;
                                      selectedCat = item;
                                    });
                                    print('selectedCat ::: $selectedCat');
                                    listOfSubCat = await TopVariable.apiService
                                        .getSubCategory(selectedCat);
                                  },
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        _category.id != -1 && listOfSubCat.isNotEmpty
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: FutureBuilder<
                                    List<PortalAttributeValuesTenant>>(
                                  future: TopVariable.apiService
                                      .getSubCategory(selectedCat),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      var data = snapshot.data!;
                                      return DropdownFieldWidget(
                                        labelText: "Sub Category *",
                                        items: data.map((item) {
                                          return item.description ?? "";
                                        }).toList(),
                                        onChanged: (item) {
                                          setState(() {
                                            _subCategory = data.firstWhere(
                                                (element) =>
                                                    element.description ==
                                                    item);
                                            print(
                                                'Selected sub cat of latest  :::: ${_subCategory.description}');
                                            _isSelectedSubCat = true;
                                          });
                                        },
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                              )
                            : Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                              ),
                        // _subCategory.id != -1 &&
                        _category.id != -1
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    top: 12.0, left: 8, right: 8),
                                child: FutureBuilder<List<AllCategoriesModal>>(
                                  future: TopVariable
                                      .ticketsProvider.getPriorityFutureFunc,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      var data = snapshot.data;
                                      return DropdownFieldWidget<
                                          AllCategoriesModal>(
                                        labelText: "Priority *",
                                        items: data!.map((item) {
                                          return item.description;
                                        }).toList(),
                                        onChanged: (v) {
                                          setState(() {
                                            _priority = data.firstWhere(
                                                (element) =>
                                                    element.description == v);
                                            _isSelectedPriority = true;
                                          });
                                        },
                                      );
                                    } else {
                                      return Container(
                                        color: Colors.red,
                                        height: 20,
                                      );
                                    }
                                  },
                                ),
                              )
                            : Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          width: getx.Get.width * 0.8,
                          child: const Align(
                              child: Text(
                                "ATTACHMENTS",
                                style:
                                    TextStyle(color: CustomColor.grenishColor),
                                // style: TextStyle(color: Theme.of(context).primaryColor),
                              ),
                              alignment: Alignment.centerLeft),
                        ),

                        if (!_showAttachments)
                          Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            child: Card(
                              child: InkWell(
                                onTap: () {
                                  showBottom(context,
                                      TopVariable.ticketsProvider.allowFiles);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(0),
                                    color: Colors.grey[200],
                                  ),
                                  width: screenWidth,
                                  height: 120,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.cloud_upload,
                                          size: 40, color: Colors.grey),
                                      AutoSizeText(
                                        "Upload attachment",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontFamily: GoogleFonts.openSans()
                                                .fontFamily),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        else
                          Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            child: SizedBox(
                              height: 350,
                              width: getx.Get.width * 0.8,
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4),
                                shrinkWrap: true,
                                itemCount: _files.length,
                                itemBuilder: (c, i) {
                                  if (_files[i].path != "") {
                                    if (_files[i].type == "mp4") {
                                      return Card(
                                        child: FutureBuilder<ThumbnailResult>(
                                          builder: (c, n) {
                                            if (n.hasData) {
                                              final _im = n.data!.image;
                                              return Stack(
                                                children: [
                                                  _im,
                                                  Positioned(
                                                    child: InkWell(
                                                      child: SvgPicture.asset(
                                                          "assets/ic_close.svg"),
                                                      onTap: () {
                                                        setState(() {
                                                          _files.removeAt(i);
                                                        });
                                                      },
                                                    ),
                                                    top: 4,
                                                    right: 4,
                                                  ),
                                                  const Align(
                                                      child: Icon(
                                                          Icons.play_arrow,
                                                          size: 30,
                                                          color: Colors.white))
                                                ],
                                                fit: StackFit.expand,
                                              );
                                            } else {
                                              return const Text(
                                                  "Unable load preview");
                                            }
                                          },
                                          future: genThumbnail(ThumbnailRequest(
                                              video: _files[i].path,
                                              // imageFormat: ImageFormat.JPEG,
                                              maxHeight: 85,
                                              maxWidth: 85,
                                              timeMs: 0,
                                              quality: 100)),
                                        ),
                                      );
                                    }
                                    return SizedBox(
                                        width: getx.Get.width * 0.8,
                                        child: attachmentImage(i));
                                  } else {
                                    return Card(
                                      color: const Color(0xFFF2F2F2),
                                      child: InkWell(
                                        onTap: () => showBottom(
                                            context,
                                            TopVariable
                                                .ticketsProvider.allowFiles),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.cloud_upload,
                                                size: 20, color: Colors.grey),
                                            Text(
                                              "Upload attachments",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 8,
                                                  fontFamily:
                                                      GoogleFonts.openSans()
                                                          .fontFamily),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),

                        // Container(
                        //   padding: const EdgeInsets.symmetric(horizontal: 8),
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.end,
                        //     mainAxisSize: MainAxisSize.max,
                        //     children: [
                        //       Padding(
                        //         padding: const EdgeInsets.only(top: 12.0, bottom: 8),
                        //         child: Align(
                        //             child: Text(
                        //               "ATTACHMENTS",
                        //               style: TextStyle(
                        //                   color: Theme.of(context).primaryColor),
                        //             ),
                        //             alignment: Alignment.centerLeft),
                        //       ),
                        //       if (!_showAttachments)
                        //         Card(
                        //           child: InkWell(
                        //             onTap: () {
                        //               showBottom(context);
                        //             },
                        //             child: Container(
                        //               decoration: BoxDecoration(
                        //                 borderRadius: BorderRadius.circular(0),
                        //                 color: Colors.grey[200],
                        //               ),
                        //               width: screenWidth,
                        //               height: 120,
                        //               child: Column(
                        //                 mainAxisAlignment: MainAxisAlignment.center,
                        //                 children: [
                        //                   const Icon(Icons.cloud_upload,
                        //                       size: 40, color: Colors.grey),
                        //                   AutoSizeText(
                        //                     "Upload attachment",
                        //                     style: TextStyle(
                        //                         color: Colors.grey,
                        //                         fontFamily:
                        //                             GoogleFonts.openSans().fontFamily),
                        //                   ),
                        //                 ],
                        //               ),
                        //             ),
                        //           ),
                        //         )
                        //       else
                        //         SizedBox(
                        //           height: 350,
                        //           child: GridView.builder(
                        //             gridDelegate:
                        //                 const SliverGridDelegateWithFixedCrossAxisCount(
                        //                     crossAxisCount: 4),
                        //             shrinkWrap: true,
                        //             itemCount: _files.length,
                        //             itemBuilder: (c, i) {
                        //               if (_files[i].path != "") {
                        //                 if (_files[i].type == "mp4") {
                        //                   return Card(
                        //                     child: FutureBuilder<ThumbnailResult>(
                        //                       builder: (c, n) {
                        //                         if (n.hasData) {
                        //                           final _im = n.data!.image;
                        //                           return Stack(
                        //                             children: [
                        //                               _im,
                        //                               Positioned(
                        //                                 child: InkWell(
                        //                                   child: SvgPicture.asset(
                        //                                       "assets/ic_close.svg"),
                        //                                   onTap: () {
                        //                                     setState(() {
                        //                                       _files.removeAt(i);
                        //                                     });
                        //                                   },
                        //                                 ),
                        //                                 top: 4,
                        //                                 right: 4,
                        //                               ),
                        //                               const Align(
                        //                                   child: Icon(Icons.play_arrow,
                        //                                       size: 30,
                        //                                       color: Colors.white))
                        //                             ],
                        //                             fit: StackFit.expand,
                        //                           );
                        //                         } else {
                        //                           return const Text(
                        //                               "Unable load preview");
                        //                         }
                        //                       },
                        //                       future: genThumbnail(ThumbnailRequest(
                        //                           video: _files[i].path,
                        //                           // imageFormat: ImageFormat.JPEG,
                        //                           maxHeight: 85,
                        //                           maxWidth: 85,
                        //                           timeMs: 0,
                        //                           quality: 100)),
                        //                     ),
                        //                   );
                        //                 }
                        //                 return attachmentImage(i);
                        //               } else {
                        //                 return Card(
                        //                   color: const Color(0xFFF2F2F2),
                        //                   child: InkWell(
                        //                     onTap: () => showBottom(context),
                        //                     child: Column(
                        //                       mainAxisAlignment:
                        //                           MainAxisAlignment.center,
                        //                       children: [
                        //                         const Icon(Icons.cloud_upload,
                        //                             size: 25, color: Colors.grey),
                        //                         Text(
                        //                           "Upload attachments",
                        //                           textAlign: TextAlign.center,
                        //                           style: TextStyle(
                        //                               color: Colors.grey,
                        //                               fontSize: 12,
                        //                               fontFamily: GoogleFonts.openSans()
                        //                                   .fontFamily),
                        //                         ),
                        //                       ],
                        //                     ),
                        //                   ),
                        //                 );
                        //               }
                        //             },
                        //           ),
                        //         ),
                        //     ],
                        //   ),
                        //   alignment: Alignment.bottomCenter,
                        // ),
                      ],
                    );
            }),
          ),
        ),
      ),
    );
  }

  Card attachmentImage(int i) {
    return Card(
      color: _files[i].type == "pdf" || _files[i].type == "doc"
          ? const Color(0xFFF2F2F2)
          : Colors.white,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            decoration: _files[i].type != "pdf" || _files[i].type != "doc"
                ? BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: Image.file(File(_files[i].path)).image,
                    ),
                  )
                : const BoxDecoration(),
            child: _files[i].type == "pdf" || _files[i].type == "doc"
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        _files[i].type == "pdf"
                            ? "assets/awesome-file-pdf.svg"
                            : "assets/document.svg",
                        width: 40,
                        height: 40,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 2, right: 5, left: 5),
                        child: AutoSizeText(
                          _files[i].name,
                          softWrap: true,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: GoogleFonts.openSans().fontFamily,
                              fontSize: 10),
                        ),
                      )
                    ],
                  )
                : Container(),
          ),
          Positioned(
            child: InkWell(
              child: SvgPicture.asset("assets/ic_close.svg"),
              onTap: () {
                setState(() {
                  _files.removeAt(i);
                });
              },
            ),
            top: 4,
            right: 4,
          ),
        ],
      ),
    );
  }

  showBottom(BuildContext context,
      getx.RxList<PortalAttributeValuesTenant> allowFiles) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return AttatchmentWidgetForCreatTicket(
          allowFiles: allowFiles,
          onPressed: (e) {
            setState(() {
              _showAttachments = true;
              final first =
                  _files.firstWhere((element) => element.type == "add");
              final go = _files.indexOf(first);
              final f = _files.removeAt(go);
              _files.addAll(e);
              _files.add(f);
            });
          },
        );
      },
    );
  }
}
