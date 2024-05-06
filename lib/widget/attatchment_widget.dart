import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:solaramps/dataModel/sub_cat_model.dart';
import 'package:solaramps/screens/create_ticket_screen.dart';
import 'package:get/get.dart' as getx;
import 'package:solaramps/theme/color.dart';
// import 'package:image_picker/image_picker.dart';

// List<XFile>? _imageFileList;
// final ImagePicker _picker = ImagePicker();

class AttatchmentWidget extends StatefulWidget {
  final Function(List<AttachmentModel> selected)? onPressed;
  final bool showFiles;
  final getx.RxList<PortalAttributeValuesTenant>? allowFiles;
  const AttatchmentWidget(
      {Key? key, this.onPressed, this.showFiles = true, this.allowFiles})
      : super(key: key);

  @override
  State<AttatchmentWidget> createState() => _AttatchmentWidgetState();
}

class _AttatchmentWidgetState extends State<AttatchmentWidget> {
  void _openCamera(BuildContext context) async {
    // final pickedFile = await ImagePicker().pickImage(
    //   source: ImageSource.camera,
    // );
    // final XFile? pickedFile = await _picker.pickImage(
    //   source: ImageSource.camera,
    //   imageQuality: 50,
    // );

    if (kDebugMode) {
      print('Cameraaaa::::');
    }
    final result = await ImagePicker()
        .pickImage(
      source: ImageSource.camera,
    )
        .whenComplete(() {
      setState(() {});
    });

    if (result != null) {
      File file = File(result.path);
      var mo = AttachmentModel(path: file.path, name: "picked", type: "jpg");
      widget.onPressed?.call([mo]);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[300],
            ),
            height: 6,
            width: 120,
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 18.0, left: 22, right: 22, bottom: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Upload Attachments",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontFamily: GoogleFonts.openSans().fontFamily),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Spacer(),
              // gallery
              Card(
                color: const Color(0xFFFFF1EC),
                elevation: 5,
                child: InkWell(
                  onTap: () async {
                    try {
                      final result = await FilePicker.platform
                          .pickFiles(type: FileType.image, allowMultiple: false)
                          .whenComplete(() {
                        setState(() {});
                      });
                      if (result != null) {
                        var get = result.files
                            .map((e) => AttachmentModel(
                                path: e.path ?? '', type: e.extension ?? ''))
                            .toList();

                        widget.onPressed?.call(get);
                      } else {
                        // User canceled the picker
                        log('User canceled the picker ::::::',
                            name: 'Picker error');
                      }

                      Navigator.pop(context);
                    } on Exception catch (e) {
                      if (kDebugMode) {
                        print('Exception of Gallery in catch :::::: $e');
                      }
                      var dia = AlertDialog(title: Text(e.toString()));
                      showDialog(context: context, builder: (c) => dia);
                    }
                  },
                  child: SizedBox(
                      height: 86,
                      width: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.collections),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.5),
                            child: Text("Gallery",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontFamily:
                                        GoogleFonts.openSans().fontFamily)),
                          )
                        ],
                      )),
                ),
              ),
              SizedBox(width: widget.showFiles == true ? 15 : 30),
              // camera
              Card(
                color: const Color(0xFFFFF1EC),
                elevation: 5,
                child: InkWell(
                  onTap: () async {
                    _openCamera(context);
                  },
                  child: SizedBox(
                      height: 86,
                      width: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.camera_alt),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.5),
                            child: Text("Camera",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontFamily:
                                        GoogleFonts.openSans().fontFamily)),
                          )
                        ],
                      )),
                ),
              ),
              SizedBox(width: widget.showFiles == true ? 15 : 30),
              widget.showFiles
                  ? Card(
                      color: const Color(0xFFFFF1EC),
                      elevation: 5,
                      child: InkWell(
                        onTap: () async {
                          try {
                            final result = await FilePicker.platform.pickFiles(
                                type: FileType.any, allowMultiple: true);
                            if (result != null) {
                              var get = result.files
                                  .map((e) => AttachmentModel(
                                      path: e.path!,
                                      type: e.extension!,
                                      name: e.name))
                                  .toList();
                              widget.onPressed?.call(get);
                              Navigator.pop(context);
                            }
                          } on PlatformException catch (e) {
                            AlertDialog(title: Text(e.message.toString()));
                          } catch (e) {
                            if (kDebugMode) {
                              print('Exception ::::: $e');
                            }
                          }
                        },
                        child: SizedBox(
                            height: 86,
                            width: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.folder_open),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.5),
                                  child: Text("Files",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: GoogleFonts.openSans()
                                              .fontFamily)),
                                )
                              ],
                            )),
                      ),
                    )
                  : Container(),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}

class AttatchmentWidgetForCreatTicket extends StatefulWidget {
  final Function(List<AttachmentModel> selected)? onPressed;
  final bool showFiles;
  final getx.RxList<PortalAttributeValuesTenant>? allowFiles;
  const AttatchmentWidgetForCreatTicket(
      {Key? key, this.onPressed, this.showFiles = true, this.allowFiles})
      : super(key: key);

  @override
  State<AttatchmentWidgetForCreatTicket> createState() =>
      _AttatchmentWidgetForCreatTicketState();
}

class _AttatchmentWidgetForCreatTicketState
    extends State<AttatchmentWidgetForCreatTicket> {
  void _openCamera(BuildContext context) async {
    // final pickedFile = await ImagePicker().pickImage(
    //   source: ImageSource.camera,
    // );
    // final XFile? pickedFile = await _picker.pickImage(
    //   source: ImageSource.camera,
    //   imageQuality: 50,
    // );

    if (kDebugMode) {
      print('Cameraaaa::::');
    }
    final result = await ImagePicker()
        .pickImage(
      source: ImageSource.camera,
    )
        .whenComplete(() {
      setState(() {});
    });

    if (result != null) {
      File file = File(result.path);
      var mo = AttachmentModel(path: file.path, name: "picked", type: "jpg");
      widget.onPressed?.call([mo]);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('Files:::: ${widget.allowFiles!.length}');
    }
    for (int i = 0; i < widget.allowFiles!.length; i++) {
      if (kDebugMode) {
        print(
            'Condition for image:::: ${(widget.allowFiles![i].description!.toUpperCase().contains('.JPG') || widget.allowFiles![i].description!.toLowerCase().contains('.jpg') || widget.allowFiles![i].description!.toUpperCase().contains('.PNG') || widget.allowFiles![i].description!.toLowerCase().contains('.png') || widget.allowFiles![i].description!.toUpperCase().contains('.GIF') || widget.allowFiles![i].description!.toLowerCase().contains('.gif') || widget.allowFiles![i].description!.toUpperCase().contains('.TIFF') || widget.allowFiles![i].description!.toLowerCase().contains('.tiif'))}');
      }
      if (kDebugMode) {
        print(
            'Condition for File:::: ${(widget.allowFiles![i].description!.contains('.pdf') || widget.allowFiles![i].description!.contains('.docx') || widget.allowFiles![i].description!.contains('.xlsx') || widget.allowFiles![i].description!.contains('.csv') || widget.allowFiles![i].description!.contains('.dwg') || widget.allowFiles![i].description!.contains('.pptx'))}');
      }
    }
    return Container(
      height: 200,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[300],
            ),
            height: 6,
            width: 120,
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 18.0, left: 22, right: 22, bottom: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Upload Attachments",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontFamily: GoogleFonts.openSans().fontFamily),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Spacer(),
              // gallery
              Card(
                color: const Color(0xFFFFF1EC),
                elevation: 5,
                child: InkWell(
                  onTap: () async {
                    bool isImageAllow = false;
                    for (int i = 0; i < widget.allowFiles!.length; i++) {
                      if (widget.allowFiles![i].description!
                              .toUpperCase()
                              .contains('.JPG') ||
                          widget.allowFiles![i].description!
                              .toLowerCase()
                              .contains('.jpg') ||
                          widget.allowFiles![i].description!
                              .toUpperCase()
                              .contains('.PNG') ||
                          widget.allowFiles![i].description!
                              .toLowerCase()
                              .contains('.png') ||
                          widget.allowFiles![i].description!
                              .toUpperCase()
                              .contains('.GIF') ||
                          widget.allowFiles![i].description!
                              .toLowerCase()
                              .contains('.gif') ||
                          widget.allowFiles![i].description!
                              .toUpperCase()
                              .contains('.TIFF') ||
                          widget.allowFiles![i].description!
                              .toLowerCase()
                              .contains('.tiif')) {
                        setState(() {
                          isImageAllow = true;
                        });
                      } else {
                        setState(() {
                          isImageAllow = false;
                        });
                      }
                    }
                    if (kDebugMode) {
                      print('Gallery   :::: $isImageAllow');
                    }
                    if (isImageAllow == false) {
                      getx.Get.snackbar('Alert',
                          'Image can not be uploaded yet, you can upload the file only',
                          colorText: Colors.white,
                          backgroundColor: CustomColor.grenishColor);
                      Navigator.pop(context);
                    } else {
                      try {
                        final result = await FilePicker.platform
                            .pickFiles(
                                type: FileType.image, allowMultiple: false)
                            .whenComplete(() {
                          setState(() {});
                        });
                        if (result != null) {
                          var get = result.files
                              .map((e) => AttachmentModel(
                                  path: e.path ?? '', type: e.extension ?? ''))
                              .toList();

                          widget.onPressed?.call(get);
                        } else {
                          // User canceled the picker
                          log('User canceled the picker ::::::',
                              name: 'Picker error');
                        }

                        Navigator.pop(context);
                      } on Exception catch (e) {
                        if (kDebugMode) {
                          print('Exception of Gallery in catch :::::: $e');
                        }
                        var dia = AlertDialog(title: Text(e.toString()));
                        showDialog(context: context, builder: (c) => dia);
                      }
                    }
                  },
                  child: SizedBox(
                      height: 86,
                      width: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.collections),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.5),
                            child: Text("Gallery",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontFamily:
                                        GoogleFonts.openSans().fontFamily)),
                          )
                        ],
                      )),
                ),
              ),
              SizedBox(width: widget.showFiles == true ? 15 : 30),
              // camera
              Card(
                color: const Color(0xFFFFF1EC),
                elevation: 5,
                child: InkWell(
                  onTap: () async {
                    bool isImageAllow = false;
                    for (int i = 0; i < widget.allowFiles!.length; i++) {
                      if (widget.allowFiles![i].description!
                              .toUpperCase()
                              .contains('.JPG') ||
                          widget.allowFiles![i].description!
                              .toLowerCase()
                              .contains('.jpg') ||
                          widget.allowFiles![i].description!
                              .toUpperCase()
                              .contains('.PNG') ||
                          widget.allowFiles![i].description!
                              .toLowerCase()
                              .contains('.png') ||
                          widget.allowFiles![i].description!
                              .toUpperCase()
                              .contains('.GIF') ||
                          widget.allowFiles![i].description!
                              .toLowerCase()
                              .contains('.gif') ||
                          widget.allowFiles![i].description!
                              .toUpperCase()
                              .contains('.TIFF') ||
                          widget.allowFiles![i].description!
                              .toLowerCase()
                              .contains('.tiif')) {
                        setState(() {
                          isImageAllow = true;
                        });
                      } else {
                        setState(() {
                          isImageAllow = false;
                        });
                      }
                    }
                    if (kDebugMode) {
                      print('Camera   :::: $isImageAllow');
                    }
                    if (isImageAllow == false) {
                      getx.Get.snackbar('Alert',
                          'Image can not be uploaded yet, you can upload the file only',
                          colorText: Colors.white,
                          backgroundColor: CustomColor.grenishColor);
                      Navigator.pop(context);
                    } else {
                      _openCamera(context);
                    }
                  },
                  child: SizedBox(
                      height: 86,
                      width: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.camera_alt),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.5),
                            child: Text("Camera",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontFamily:
                                        GoogleFonts.openSans().fontFamily)),
                          )
                        ],
                      )),
                ),
              ),
              SizedBox(width: widget.showFiles == true ? 15 : 30),
              widget.showFiles
                  ? Card(
                      color: const Color(0xFFFFF1EC),
                      elevation: 5,
                      child: InkWell(
                        onTap: () async {
                          bool isFileAllow = false;
                          for (int i = 0; i < widget.allowFiles!.length; i++) {
                            if (widget.allowFiles![i].description!
                                    .contains('.pdf') ||
                                widget.allowFiles![i].description!
                                    .contains('.docx') ||
                                widget.allowFiles![i].description!
                                    .contains('.xlsx') ||
                                widget.allowFiles![i].description!
                                    .contains('.csv') ||
                                widget.allowFiles![i].description!
                                    .contains('.dwg') ||
                                widget.allowFiles![i].description!
                                    .contains('.pptx')) {
                              setState(() {
                                isFileAllow = true;
                              });
                            } else {
                              setState(() {
                                isFileAllow = false;
                              });
                            }
                          }
                          if (kDebugMode) {
                            print('File   :::: $isFileAllow');
                          }
                          if (isFileAllow == true) {
                            try {
                              final result = await FilePicker.platform
                                  .pickFiles(
                                      type: FileType.any, allowMultiple: true);
                              if (kDebugMode) {
                                print(
                                    'Selected FIle Extension :::: ${result!.files.first.extension!}');

                                print(
                                    'Selected FIle Condition :::: ${(result.files.first.extension!.toUpperCase().contains('.JPG') || result.files.first.extension!.toLowerCase().contains('.jpg') || result.files.first.extension!.toUpperCase().contains('.PNG') || result.files.first.extension!.toLowerCase().contains('.png') || result.files.first.extension!.toUpperCase().contains('.GIF') || result.files.first.extension!.toLowerCase().contains('.gif') || result.files.first.extension!.toUpperCase().contains('.TIFF') || result.files.first.extension!.toLowerCase().contains('.tiif') || result.files.first.extension!.toUpperCase().contains('.jpeg') || result.files.first.extension!.toLowerCase().contains('.JPEG'))}');
                              }
                              if (result != null) {
                                if (result.files.first.extension!.toUpperCase() == 'JPG' ||
                                    result.files.first.extension!
                                            .toLowerCase() ==
                                        'jpg' ||
                                    result.files.first.extension!
                                            .toUpperCase() ==
                                        'PNG' ||
                                    result.files.first.extension!
                                            .toLowerCase() ==
                                        'png' ||
                                    result.files.first.extension!
                                            .toUpperCase() ==
                                        'GIF' ||
                                    result.files.first.extension!
                                            .toLowerCase() ==
                                        'gif' ||
                                    result.files.first.extension!
                                            .toUpperCase() ==
                                        'TIFF' ||
                                    result.files.first.extension!
                                            .toLowerCase() ==
                                        'tiif' ||
                                    result.files.first.extension! == 'JPEG' ||
                                    result.files.first.extension!
                                            .toLowerCase() ==
                                        'jpeg') {
                                  getx.Get.snackbar('Alert',
                                      'Image can not be uploaded yet, you can upload the file only',
                                      colorText: Colors.white,
                                      backgroundColor:
                                          CustomColor.grenishColor);
                                  return;
                                }
                                var get = result.files
                                    .map((e) => AttachmentModel(
                                        path: e.path!,
                                        type: e.extension!,
                                        name: e.name))
                                    .toList();
                                widget.onPressed?.call(get);
                                Navigator.pop(context);
                              }
                            } on PlatformException catch (e) {
                              AlertDialog(title: Text(e.message.toString()));
                            } catch (e) {
                              if (kDebugMode) {
                                print('Exception ::::: $e');
                              }
                            }
                          } else {
                            getx.Get.snackbar('Alert',
                                'Image can not be uploaded yet, you can upload the file only',
                                colorText: Colors.white,
                                backgroundColor: CustomColor.grenishColor);
                          }
                        },
                        child: SizedBox(
                            height: 86,
                            width: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.folder_open),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.5),
                                  child: Text("Files",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: GoogleFonts.openSans()
                                              .fontFamily)),
                                )
                              ],
                            )),
                      ),
                    )
                  : Container(),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
