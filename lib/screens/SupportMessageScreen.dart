// ignore_for_file: file_names, avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' as getx;
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:solaramps/dataModel/allTicketsModal.dart';
import 'package:solaramps/dataModel/reference_dto_list.dart';
import 'package:solaramps/dataModel/user_message_modal.dart';
import 'package:solaramps/screens/create_ticket_screen.dart';
import 'package:solaramps/theme/color.dart';
import 'package:solaramps/utility/app_url.dart';
import 'package:solaramps/utility/shared_preference.dart';
import 'package:solaramps/utility/top_level_variables.dart';
import '../utility/extensions.dart';
import '../widget/custom_appbar.dart';

class SupportMessageScreen extends StatefulWidget {
  const SupportMessageScreen({
    Key? key,
    required this.item,
    this.list,
  }) : super(key: key);

  final AllTicketsModal? item;
  final List<ReferenceDTOList>? list;

  @override
  State<SupportMessageScreen> createState() => _SupportMessageScreenState();
}

class _SupportMessageScreenState extends State<SupportMessageScreen> {
  String message = "";
  final TextEditingController _textEditingController = TextEditingController();
  List<UserMessageModal> messageItem = [];
  final List<AttachmentModel> _attatchmentList = [];
  Timer? _timer;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getPermission();
    });
    if (widget.item!.status != "Closed") {
      messageItem.clear();
      messageItem.addAll(widget.item!.conversationHistoryDTOList!);
      if (widget.list!.isNotEmpty) {
        messageItem.add(UserMessageModal(
            id: widget.item!.id,
            message: widget.item!.message,
            firstName: widget.item!.firstName,
            role: widget.item!.role,
            internal: false,
            priority: widget.item!.priority,
            conversationReferenceDTOList: widget.list!,
            createdAt: widget.item!.createdAt));
        setState(() {});
      }
      Timer.periodic(const Duration(seconds: 30), (t) {
        _timer = t;
        TopVariable.apiService
            .getConversationHead(widget.item!.id!)
            .then((value) => {
                  if (value.conversationHistoryDTOList != null)
                    {
                      setState(
                        () => {
                          messageItem = value.conversationHistoryDTOList!,
                        },
                      ),
                      if (widget.list!.isNotEmpty)
                        {
                          messageItem.add(UserMessageModal(
                              id: widget.item!.id,
                              message: widget.item!.message,
                              firstName: '-',
                              role: widget.item!.role,
                              internal: false,
                              priority: widget.item!.priority,
                              conversationReferenceDTOList: widget.list!,
                              createdAt: widget.item!.createdAt))
                        }
                    }
                  else
                    {
                      if (widget.list!.isNotEmpty)
                        {
                          messageItem.add(UserMessageModal(
                              id: widget.item!.id,
                              message: widget.item!.message,
                              firstName: '-',
                              role: widget.item!.role,
                              internal: false,
                              priority: widget.item!.priority,
                              conversationReferenceDTOList: widget.list!,
                              createdAt: widget.item!.createdAt))
                        }
                    }
                })
            .onError((error, stackTrace) => {});
      });
    }

    super.initState();
  }

  getPermission() async {
    await Permission.storage.request();
    if (kDebugMode) {
      print(
          'Permission.storage.request() ::::: ${await Permission.storage.request()}');
    }
  }

  getx.RxBool isloadingForIos = false.obs;
  getx.RxBool isloadingForAndroid = false.obs;
  @override
  void dispose() {
    widget.item!.conversationHistoryDTOList?.clear();
    widget.item!.conversationHistoryDTOList?.addAll(messageItem);
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                CustomAppbar(
                    title: "Ticket Number " + widget.item!.id.toString()),
                Container(
                  color: widget.item!.status == "Closed"
                      ? const Color.fromRGBO(241, 241, 241, 1)
                      : CustomColor.grenishColor,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 14, left: 15.0, right: 15),
                    child: Column(
                      children: [
                        Align(
                          child: Text(
                            widget.item!.summary,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.openSans().fontFamily,
                            ),
                          ),
                          alignment: Alignment.topLeft,
                        ),
                        widget.item!.message == ''
                            ? const SizedBox()
                            : Padding(
                                padding:
                                    const EdgeInsets.only(top: 6.0, bottom: 6),
                                child: Align(
                                  child: Text(
                                    widget.item!.message,
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      fontFamily:
                                          GoogleFonts.openSans().fontFamily,
                                    ),
                                  ),
                                  alignment: Alignment.topLeft,
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Align(
                            child: Text(
                              "${widget.item!.category} > ${widget.item!.subCategory}",
                              style: TextStyle(
                                // color: Theme.of(context).primaryColor,
                                color: widget.item!.status == "Closed"
                                    ? CustomColor.primary
                                    : Theme.of(context).primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontFamily: GoogleFonts.openSans().fontFamily,
                              ),
                            ),
                            alignment: Alignment.topLeft,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Align(
                            child: Text(
                              "Priority: " + widget.item!.priority,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontFamily: GoogleFonts.openSans().fontFamily,
                              ),
                            ),
                            alignment: Alignment.topLeft,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.item?.createdAt != ""
                                    ? widget.item!.createdAt
                                        .formatDate("MMM d, yyyy hh:mm aa")
                                        .toString()
                                    : "",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: GoogleFonts.openSans().fontFamily,
                                ),
                              ),
                              widget.item!.status == "Open"
                                  ? InkWell(
                                      onTap: () {
                                        _showDialogForCloseTicket();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          // color: Theme.of(context).primaryColor,
                                          color: CustomColor.grenishColor,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.white.withOpacity(0.8),
                                              spreadRadius: 1,
                                              blurRadius: 2,
                                              offset: const Offset(1,
                                                  1), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        padding: const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 5,
                                            bottom: 5),
                                        child: Text("CLOSE",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: GoogleFonts.openSans()
                                                  .fontFamily,
                                            )),
                                      ),
                                    )
                                  : SizedBox(
                                      height: 25,
                                      child: TextButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    const Color.fromRGBO(
                                                        226, 226, 226, 1)),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                            ))),
                                        child: Text(
                                          "CLOSED",
                                          style: TextStyle(
                                            color: const Color.fromRGBO(
                                                126, 126, 126, 1),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: GoogleFonts.openSans()
                                                .fontFamily,
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: widget.item!.status == "Open" ? 10 : 0,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: messageItem.isNotEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          padding: const EdgeInsets.only(
                              top: 4, left: 15.0, right: 15),
                          itemBuilder: (c, i) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                textDirection:
                                    messageItem[i].role == "ROLE_EPC_CUSTOMER"
                                        ? TextDirection.rtl
                                        : TextDirection.ltr,
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Colors.black,
                                    child: Text(
                                      messageItem[i].firstName != null
                                          ? messageItem[i]
                                              .firstName!
                                              .substring(0, 1)
                                              .toUpperCase()
                                          : "",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily:
                                            GoogleFonts.openSans().fontFamily,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 4, right: 4),
                                      padding: const EdgeInsets.only(
                                          top: 8.0,
                                          bottom: 8,
                                          right: 4,
                                          left: 4),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                          color: messageItem[i].role ==
                                                  "ROLE_EPC_CUSTOMER"
                                              ? const Color(0xFFFCE6DE)
                                              : const Color(0xFFECF2FF)),
                                      width: screenWidth! / 2,
                                      child: messageItem[i].role !=
                                              "ROLE_EPC_CUSTOMER"
                                          ?
                                          // Right side msgs
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      messageItem[i]
                                                                  .firstName !=
                                                              null
                                                          ? messageItem[i]
                                                                  .firstName ??
                                                              ""
                                                          : "",
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xFF1786C7),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily:
                                                            "open-medium",
                                                      ),
                                                    )),
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                      messageItem[i].message ??
                                                          "",
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontFamily:
                                                            "open-medium",
                                                      ),
                                                      maxLines: 4,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: AutoSizeText(
                                                      messageItem[i]
                                                          .createdAt!
                                                          .formatDate(
                                                              "hh:mm a"),
                                                      style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily:
                                                            "open-medium",
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ),
                                                _attatchmentWidget(messageItem[
                                                        i]
                                                    .conversationReferenceDTOList)
                                              ],
                                            )
                                          // Left side msgs
                                          : Column(
                                              children: [
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: Text(
                                                      messageItem[i].message ??
                                                          "",
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontFamily:
                                                            "open-medium",
                                                      ),
                                                      maxLines: 4,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ),
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: Text(
                                                      messageItem[i]
                                                                  .createdAt !=
                                                              null
                                                          ? messageItem[i]
                                                              .createdAt!
                                                              .formatDate(
                                                                  "hh:mm a")
                                                          : "",
                                                      style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12,
                                                        fontFamily:
                                                            "open-medium",
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ),
                                                _attatchmentWidget(messageItem[
                                                        i]
                                                    .conversationReferenceDTOList)
                                              ],
                                            ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          itemCount: messageItem.length,
                          shrinkWrap: true,
                        )
                      : Container(),
                ),
                widget.item!.status != "Open"
                    ? Container()
                    : _buildMessageComposer(),
              ],
            ),
            getx.Obx(() {
              return isloadingForIos.value == true || isloadingForAndroid.value
                  ? Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.black.withOpacity(0.3),
                      child: const Center(
                          child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        color: Colors.blue,
                      )),
                    )
                  : const SizedBox();
            }),
          ],
        ),
      ),
    );
  }

  void _showDialogForCloseTicket() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Close Ticket",
          ),
          content: const Text(
            "Are you sure to close the ticket?",
          ),
          actions: <Widget>[
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const SizedBox(
                height: 35,
                width: 50,
                child: Text(
                  'Cancel',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Map<String, dynamic> map = {
                  "id": widget.item!.id,
                  "status": "Closed",
                };

                TopVariable.apiService.closeTickets(map).then((value) async {
                  setState(() {
                    widget.item!.status = "Closed";
                  });
                  Navigator.pop(context);
                }).onError((error, stackTrace) {
                  if (kDebugMode) {
                    print(error);
                  }
                });
              },
              child: const SizedBox(
                height: 35,
                width: 100,
                child: Text(
                  'Close Ticket',
                  style: TextStyle(
                    color: CustomColor.grenishColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _attatchmentWidget(List<ReferenceDTOList>? ref) {
    // if (kDebugMode) {
    //   print('Ref ::::::: $ref');
    // }
    return ref != null
        ? ListView.builder(
            itemCount: ref.length,
            shrinkWrap: true,
            itemBuilder: (c, i) {
              String file = AppUrl.attatchmentPro +
                  ref[i]
                      .uri
                      .replaceFirst("%2Fcustomer%2Fsupport%2F", '')
                      .replaceAll(" ", "%20");

              if (kDebugMode) {
                print({"attmentUrl": file});
              }
              bool check = ref[i].uri.contains(".png") ||
                  ref[i].uri.contains(".jpg") ||
                  ref[i].uri.contains(".jpeg");

              return check
                  ? Card(
                      color: ref[i].uri.contains(".png") ||
                              ref[i].uri.contains(".jpg") ||
                              ref[i].uri.contains(".jpeg")
                          ? Colors.black
                          : Colors.red,
                      child: Image.network(
                        file,
                        width: 60,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    )
                  : InkWell(
                      onTap: () async {
                        var path = file;
                        if (kDebugMode) {
                          print('Tapping :::: 1 $path');
                          print('Tapping :::: 1 1 ${path.split('/').last}');
                        }
                        var name = path.split('/').last;

                        if (path != '') {
                          // before download get the permission
                          final status11 = await Permission.storage.request();
                          if (status11.isGranted) {
                            try {
                              if (Platform.isAndroid) {
                                setState(() {
                                  isloadingForAndroid.value = true;
                                });
                                FileDownloader.downloadFile(
                                    url: path,
                                    onProgress:
                                        (String? fileName, double? progress) {
                                      if (progress == 100) {
                                        getx.Get.closeAllSnackbars();
                                      } else {
                                        getx.Get.snackbar('Downloading',
                                            'File is downloading... ',
                                            backgroundColor:
                                                CustomColor.primary,
                                            colorText: Colors.white);
                                      }
                                    },
                                    onDownloadCompleted: (String path) {
                                      getx.Get.snackbar('Downloaded',
                                          'File downloaded successfully in mobile storage',
                                          backgroundColor: CustomColor.primary,
                                          colorText: Colors.white);
                                      setState(() {
                                        isloadingForAndroid.value = false;
                                      });
                                    },
                                    onDownloadError: (String error) {
                                      getx.Get.snackbar('Downloading Failed',
                                          'File downloaded failed due to $error',
                                          backgroundColor: Colors.red.shade400,
                                          colorText: Colors.white);
                                      setState(() {
                                        isloadingForAndroid.value = false;
                                      });
                                    });
                              } else {
                                openFile(url: path, name: name);
                              }

                              // setState(() {});
                            } catch (e) {
                              if (kDebugMode) {
                                print(
                                    'Exception ::: in Button *******)))====> :::::: $e');
                              }
                            }
                          } else {
                            getx.Get.snackbar(
                                'Alert', 'Storage permissions not granted',
                                backgroundColor: CustomColor.grenishColor,
                                colorText: Colors.white);
                            await Permission.storage.request();
                          }
                        } else {
                          getx.Get.snackbar('Error', 'Something went wrong',
                              backgroundColor: CustomColor.grenishColor,
                              colorText: Colors.white);
                        }
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  ref[i].uri.contains(".pdf")
                                      ? "assets/awesome-file-pdf.svg"
                                      : "assets/document.svg",
                                  width: 50,
                                  height: 35,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: getx.Get.width * 0.55,
                                  child: Text(
                                    ref[i]
                                        .uri
                                        .replaceFirst(
                                            "%2Fcustomer%2Fsupport%2F", '')
                                        .replaceAll(" ", "%20"),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                            InkWell(
                              onTap: () async {
                                var path = file;
                                if (kDebugMode) {
                                  print('Tapping :::: 1 $path');
                                  print(
                                      'Tapping :::: 1 1 ${path.split('/').last}');
                                }
                                var name = path.split('/').last;

                                if (path != '') {
                                  // before download get the permission
                                  final status11 =
                                      await Permission.storage.request();
                                  if (status11.isGranted) {
                                    try {
                                      if (Platform.isAndroid) {
                                        setState(() {
                                          isloadingForAndroid.value = true;
                                        });
                                        FileDownloader.downloadFile(
                                            url: path,
                                            onProgress: (String? fileName,
                                                double? progress) {
                                              if (progress == 100) {
                                                getx.Get.closeAllSnackbars();
                                              } else {
                                                getx.Get.snackbar('Downloading',
                                                    'File is downloading... ',
                                                    backgroundColor:
                                                        CustomColor.primary,
                                                    colorText: Colors.white);
                                              }
                                            },
                                            onDownloadCompleted: (String path) {
                                              getx.Get.snackbar('Downloaded',
                                                  'File downloaded successfully in mobile storage',
                                                  backgroundColor:
                                                      CustomColor.primary,
                                                  colorText: Colors.white);
                                              setState(() {
                                                isloadingForAndroid.value =
                                                    false;
                                              });
                                            },
                                            onDownloadError: (String error) {
                                              getx.Get.snackbar(
                                                  'Downloading Failed',
                                                  'File downloaded failed due to $error',
                                                  backgroundColor:
                                                      Colors.red.shade400,
                                                  colorText: Colors.white);
                                              setState(() {
                                                isloadingForAndroid.value =
                                                    false;
                                              });
                                            });
                                      } else {
                                        openFile(url: path, name: name);
                                      }

                                      // setState(() {});
                                    } catch (e) {
                                      if (kDebugMode) {
                                        print(
                                            'Exception ::: in Button *******)))====> :::::: $e');
                                      }
                                    }
                                  } else {
                                    getx.Get.snackbar('Alert',
                                        'Storage permissions not granted',
                                        backgroundColor:
                                            CustomColor.grenishColor,
                                        colorText: Colors.white);
                                    await Permission.storage.request();
                                  }
                                } else {
                                  getx.Get.snackbar(
                                      'Error', 'Something went wrong',
                                      backgroundColor: CustomColor.grenishColor,
                                      colorText: Colors.white);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 5, right: 5, left: 0, bottom: 5),
                                child: AutoSizeText(
                                  ref[i].uri.contains(".pdf") ? "PDF" : "DOCX",
                                  softWrap: true,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: "open-medium",
                                      fontSize: 10),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
            },
          )
        : const SizedBox.shrink();
  }

  Future openFile({required String? url, String? name}) async {
    setState(() {
      isloadingForIos.value = true;
    });
    final file = await downloadFile(url ?? "", name ?? "");
    setState(() {
      isloadingForIos.value = false;
    });
    if (file == null) {
      print('Path :::::::::::::: in file == null s :: $file');
      getx.Get.snackbar(
        'Error',
        'Something went wrong with file path',
        backgroundColor: CustomColor.primary,
        colorText: Colors.white,
      );
    } else {
      print('Path ::::::::::::::  :: ${file.path}');
      OpenFile.open(file.path);
    }
  }

  Future<File?> downloadFile(String url, String name) async {
    final externalDirectory = await getApplicationDocumentsDirectory();
    final file = File('${externalDirectory.path}/$name');

    try {
      final response = await Dio().get(url,
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              receiveTimeout: 0));

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    } catch (e) {
      print('Exception :::::::::::::: in download from dio is :: $e');
      getx.Get.snackbar('Error', 'Something went wrong');
    }
    return null;
  }

  _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFCACACA), width: 2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _textEditingController,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (e) {
                  setState(() {
                    message = e;
                  });
                },
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: GoogleFonts.openSans().fontFamily,
                ),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: "Type message here...",
                    hintStyle: TextStyle(color: Colors.grey),
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15)),
              ),
            ),
          ),
          // IconButton(
          //   icon: const Icon(Icons.attach_file),
          //   iconSize: 25.0,
          //   color: Colors.grey,
          //   onPressed: () {
          //     showModalBottomSheet<void>(
          //         context: context,
          //         builder: (BuildContext c) {
          //           return AttatchmentWidget(
          //             onPressed: (modal) {
          //               setState(() {
          //                 _attatchmentList = modal;
          //               });
          //             },
          //           );
          //         });
          //   },
          // ),

          IconButton(
            icon: const Icon(Icons.send),
            iconSize: 25.0,
            color: message.isEmpty
                ? Colors.grey
                : CustomColor.grenishColor, //Theme.of(context).primaryColor,
            onPressed: () {
              if (message.isEmpty) return;
              var data = {
                "internal": false,
                "priority": "Medium",
                "message": _textEditingController.text,
                "firstName": UserPreferences.user.firstName ?? "",
                "role": "ROLE_EPC_CUSTOMER",
              };
              var g0 = _attatchmentList
                  .map((f) async => await MultipartFile.fromFile(f.path))
                  .toList();
              var body = FormData.fromMap({
                "conversationHistoryDTO": jsonEncode(data),
                "multipartFiles": g0
              });
              TopVariable.getDioInstance()
                  .post(
                      AppUrl.baseUrl +
                          "/conversation/conversationHistory/${widget.item!.id}/DOCU",
                      data: body)
                  .then((value) => {
                        print(value),
                        setState(
                          () {
                            messageItem.add(UserMessageModal(
                                message: message,
                                role: "ROLE_EPC_CUSTOMER",
                                firstName: widget.item!.firstName,
                                createdAt: DateTime.now().toString()));
                          },
                        ),
                        _textEditingController.clear(),
                        setState(() {
                          message = "";
                        })
                      })
                  .catchError((error) => {
                        if (kDebugMode) {print("Error $error")}
                      });
            },
          ),
        ],
      ),
    );
  }
}

class DownloadClass {
  static void callback(String id, DownloadTaskStatus status, int progress) {
    if (kDebugMode) {
      print('ID :::: inSide MAin :::: $id');
      print('Status :::: inSide MAin :::: $status');
      print('Progress :::: inSide MAin :::: $progress');
    }
  }
}



// WITH FLUTTER DOWNLOAD
// // ignore_for_file: file_names, avoid_print

// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart' as getx;
// import 'package:google_fonts/google_fonts.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:solaramps/dataModel/allTicketsModal.dart';
// import 'package:solaramps/dataModel/reference_dto_list.dart';
// import 'package:solaramps/dataModel/user_message_modal.dart';
// import 'package:solaramps/screens/create_ticket_screen.dart';
// import 'package:solaramps/theme/color.dart';
// import 'package:solaramps/utility/app_url.dart';
// import 'package:solaramps/utility/shared_preference.dart';
// import 'package:solaramps/utility/top_level_variables.dart';
// import '../utility/extensions.dart';
// import '../widget/custom_appbar.dart';
// import 'dart:isolate';
// import 'dart:ui';

// class SupportMessageScreen extends StatefulWidget {
//   const SupportMessageScreen({
//     Key? key,
//     required this.item,
//     this.list,
//   }) : super(key: key);

//   final AllTicketsModal? item;
//   final List<ReferenceDTOList>? list;

//   @override
//   State<SupportMessageScreen> createState() => _SupportMessageScreenState();
// }

// class _SupportMessageScreenState extends State<SupportMessageScreen> {
//   String message = "";
//   final TextEditingController _textEditingController = TextEditingController();
//   List<UserMessageModal> messageItem = [];
//   final List<AttachmentModel> _attatchmentList = [];
//   Timer? _timer;
//   callregister() async {
//     await FlutterDownloader.registerCallback(
//         downloadingCallBack(id ?? "", status!, progress ?? -1));
//   }

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       getPermission();
//       initForSetState();
//       callregister();
//     });
//     if (widget.item!.status != "Closed") {
//       messageItem.clear();
//       messageItem.addAll(widget.item!.conversationHistoryDTOList!);
//       if (widget.list!.isNotEmpty) {
//         messageItem.add(UserMessageModal(
//             id: widget.item!.id,
//             message: widget.item!.message,
//             firstName: widget.item!.firstName,
//             role: widget.item!.role,
//             internal: false,
//             priority: widget.item!.priority,
//             conversationReferenceDTOList: widget.list!,
//             createdAt: widget.item!.createdAt));
//         setState(() {});
//       }
//       Timer.periodic(const Duration(seconds: 30), (t) {
//         _timer = t;
//         TopVariable.apiService
//             .getConversationHead(widget.item!.id!)
//             .then((value) => {
//                   if (value.conversationHistoryDTOList != null)
//                     {
//                       setState(
//                         () => {
//                           messageItem = value.conversationHistoryDTOList!,
//                         },
//                       ),
//                       if (widget.list!.isNotEmpty)
//                         {
//                           messageItem.add(UserMessageModal(
//                               id: widget.item!.id,
//                               message: widget.item!.message,
//                               firstName: '-',
//                               role: widget.item!.role,
//                               internal: false,
//                               priority: widget.item!.priority,
//                               conversationReferenceDTOList: widget.list!,
//                               createdAt: widget.item!.createdAt))
//                         }
//                     }
//                   else
//                     {
//                       if (widget.list!.isNotEmpty)
//                         {
//                           messageItem.add(UserMessageModal(
//                               id: widget.item!.id,
//                               message: widget.item!.message,
//                               firstName: '-',
//                               role: widget.item!.role,
//                               internal: false,
//                               priority: widget.item!.priority,
//                               conversationReferenceDTOList: widget.list!,
//                               createdAt: widget.item!.createdAt))
//                         }
//                     }
//                 })
//             .onError((error, stackTrace) => {});
//         // if (kDebugMode) {
//         //   print('Inside 2::::::::${messageItem.length}');
//         // }
//       });
//     }

//     super.initState();
//   }

//   getPermission() async {
//     await Permission.storage.request();
//     if (kDebugMode) {
//       print(
//           'Permission.storage.request() ::::: ${await Permission.storage.request()}');
//     }
//   }

//   ReceivePort recivePort = ReceivePort();
//   String? id;
//   DownloadTaskStatus? status;
//   int? progress;
//   initForSetState() async {
//     if (kDebugMode) {
//       print('Testing :::::::: ::::::: ::::::::');
//     }
//     try {
//       IsolateNameServer.registerPortWithName(
//           recivePort.sendPort, 'downloader_send_port');
//       recivePort.listen((dynamic data) async {
//         // setState(() {});
//         id = data[0];
//         status = DownloadTaskStatus(data[1]);
//         progress = data[2];
//         // setState(() {});
//         if (kDebugMode) {
//           print(
//               'Download task ($id) is in status ($status) and process ($progress)');
//         }
//         // ignore: unrelated_type_equality_checks
//         if (DownloadTaskStatus.canceled == true) {
//           getx.Get.snackbar('Canclled', 'File Download Failed',
//               backgroundColor: CustomColor.grenishColor,
//               colorText: Colors.white);
//         } else if (status == DownloadTaskStatus.complete) {
//           getx.Get.snackbar('File Download', 'File Download Complete',
//               backgroundColor: CustomColor.grenishColor,
//               colorText: Colors.white);
//         } else if (progress == 100) {
//           getx.Get.snackbar('File Download', 'File Downloaded Successfully',
//               backgroundColor: CustomColor.grenishColor,
//               colorText: Colors.white);
//           // setState(() {});
//         } else if (progress! < 0) {
//           getx.Get.snackbar('Failed', 'File Download Failed',
//               backgroundColor: CustomColor.grenishColor,
//               colorText: Colors.white);
//           // setState(() {});
//         } else {
//           if (kDebugMode) {
//             print('***:::*****:::::');
//             print('***:::*****:::::');
//           }
//         }
//         await FlutterDownloader.registerCallback(
//             downloadingCallBack(id ?? "", status!, progress ?? -1));
//       });
//     } catch (e) {
//       if (kDebugMode) {
//         print('***:::*****:::::Exception    $e');
//         print('***:::*****:::::');
//       }
//       // setState(() {});
//     }
//   }

//   @pragma('vm:entry-point')
//   static downloadingCallBack(
//       String id, DownloadTaskStatus status, int progress) {
//     final SendPort? sendPort =
//         IsolateNameServer.lookupPortByName('downloader_send_port');
//     sendPort!.send([id, status.value, progress]);
//     // sendPort?.send([id, status, progress]);
//     if (kDebugMode) {
//       print(
//         'Callback on background isolate: *****>>>>>>>'
//         'task ($id) is in status ($status) and process ($progress)',
//       );
//     }
//   }

//   @override
//   void dispose() {
//     IsolateNameServer.removePortNameMapping('downloader_send_port');
//     widget.item!.conversationHistoryDTOList?.clear();
//     widget.item!.conversationHistoryDTOList?.addAll(messageItem);
//     _timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             CustomAppbar(title: "Ticket Number " + widget.item!.id.toString()),
//             Container(
//               color: widget.item!.status == "Closed"
//                   ? const Color.fromRGBO(241, 241, 241, 1)
//                   : CustomColor.grenishColor,
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 14, left: 15.0, right: 15),
//                 child: Column(
//                   children: [
//                     Align(
//                       child: Text(
//                         widget.item!.summary,
//                         style: TextStyle(
//                           color: Colors.black87,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           fontFamily: GoogleFonts.openSans().fontFamily,
//                         ),
//                       ),
//                       alignment: Alignment.topLeft,
//                     ),
//                     widget.item!.message == ''
//                         ? const SizedBox()
//                         : Padding(
//                             padding: const EdgeInsets.only(top: 6.0, bottom: 6),
//                             child: Align(
//                               child: Text(
//                                 widget.item!.message,
//                                 style: TextStyle(
//                                   color: Colors.black54,
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w400,
//                                   fontFamily: GoogleFonts.openSans().fontFamily,
//                                 ),
//                               ),
//                               alignment: Alignment.topLeft,
//                             ),
//                           ),
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 6),
//                       child: Align(
//                         child: Text(
//                           "${widget.item!.category} > ${widget.item!.subCategory}",
//                           style: TextStyle(
//                             // color: Theme.of(context).primaryColor,
//                             color: widget.item!.status == "Closed"
//                                 ? CustomColor.primary
//                                 : Theme.of(context).primaryColor,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                             fontFamily: GoogleFonts.openSans().fontFamily,
//                           ),
//                         ),
//                         alignment: Alignment.topLeft,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 2),
//                       child: Align(
//                         child: Text(
//                           "Priority: " + widget.item!.priority,
//                           style: TextStyle(
//                             color: Colors.black54,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                             fontFamily: GoogleFonts.openSans().fontFamily,
//                           ),
//                         ),
//                         alignment: Alignment.topLeft,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 20),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             widget.item?.createdAt != ""
//                                 ? widget.item!.createdAt
//                                     .formatDate("MMM d, yyyy hh:mm aa")
//                                     .toString()
//                                 : "",
//                             style: TextStyle(
//                               color: Colors.black54,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                               fontFamily: GoogleFonts.openSans().fontFamily,
//                             ),
//                           ),
//                           widget.item!.status == "Open"
//                               ? InkWell(
//                                   onTap: () {
//                                     _showDialogForCloseTicket();
//                                     // showDialog(
//                                     //     context: context,
//                                     //     builder: (co) {
//                                     //       return ConfirmationDialog(
//                                     //         title: "Close Ticket",
//                                     //         description:
//                                     //             "Are you sure you want to close this ticket",
//                                     //         onConfirmed: () {
//                                     //           Map<String, dynamic> map = {
//                                     //             "id": widget.item!.id,
//                                     //             "status": "Closed",
//                                     //           };
//                                     //           TopVariable.apiService
//                                     //               .closeTickets(map)
//                                     //               .then((value) {
//                                     //             setState(() {
//                                     //               widget.item!.status =
//                                     //                   "Closed";
//                                     //             });
//                                     //             Navigator.pop(context);
//                                     //             Navigator.pop(context);
//                                     //             TopVariable.ticketsProvider
//                                     //                 .getAllTickets();
//                                     //           }).onError((error, stackTrace) {
//                                     //             if (kDebugMode) {
//                                     //               print(error);
//                                     //             }
//                                     //           });
//                                     //         },
//                                     //         confirmedText: "Close",
//                                     //       );
//                                     //     });
//                                   },
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       // color: Theme.of(context).primaryColor,
//                                       color: CustomColor.grenishColor,
//                                       borderRadius: BorderRadius.circular(5),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.white.withOpacity(0.8),
//                                           spreadRadius: 1,
//                                           blurRadius: 2,
//                                           offset: const Offset(1,
//                                               1), // changes position of shadow
//                                         ),
//                                       ],
//                                     ),
//                                     padding: const EdgeInsets.only(
//                                         left: 15, right: 15, top: 5, bottom: 5),
//                                     child: Text("CLOSE",
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.w600,
//                                           fontFamily:
//                                               GoogleFonts.openSans().fontFamily,
//                                         )),
//                                   ),
//                                 )
//                               : SizedBox(
//                                   height: 25,
//                                   child: TextButton(
//                                     onPressed: () {},
//                                     style: ButtonStyle(
//                                         backgroundColor:
//                                             MaterialStateProperty.all<Color>(
//                                                 const Color.fromRGBO(
//                                                     226, 226, 226, 1)),
//                                         shape: MaterialStateProperty.all<
//                                                 RoundedRectangleBorder>(
//                                             RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(18.0),
//                                         ))),
//                                     child: Text(
//                                       "CLOSED",
//                                       style: TextStyle(
//                                         color: const Color.fromRGBO(
//                                             126, 126, 126, 1),
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w600,
//                                         fontFamily:
//                                             GoogleFonts.openSans().fontFamily,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: widget.item!.status == "Open" ? 10 : 0,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//               child: messageItem.isNotEmpty
//                   ? ListView.builder(
//                       scrollDirection: Axis.vertical,
//                       physics: const BouncingScrollPhysics(
//                           parent: AlwaysScrollableScrollPhysics()),
//                       padding:
//                           const EdgeInsets.only(top: 4, left: 15.0, right: 15),
//                       itemBuilder: (c, i) {
//                         return Padding(
//                           padding: const EdgeInsets.only(top: 8.0),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.min,
//                             textDirection:
//                                 messageItem[i].role == "ROLE_EPC_CUSTOMER"
//                                     ? TextDirection.rtl
//                                     : TextDirection.ltr,
//                             children: [
//                               CircleAvatar(
//                                 radius: 18,
//                                 backgroundColor: Colors.black,
//                                 child: Text(
//                                   messageItem[i].firstName != null
//                                       ? messageItem[i]
//                                           .firstName!
//                                           .substring(0, 1)
//                                           .toUpperCase()
//                                       : "",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w500,
//                                     fontFamily:
//                                         GoogleFonts.openSans().fontFamily,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 5,
//                               ),
//                               Expanded(
//                                 child: Container(
//                                   margin:
//                                       const EdgeInsets.only(left: 4, right: 4),
//                                   padding: const EdgeInsets.only(
//                                       top: 8.0, bottom: 8, right: 4, left: 4),
//                                   decoration: BoxDecoration(
//                                       borderRadius: const BorderRadius.all(
//                                           Radius.circular(5)),
//                                       color: messageItem[i].role ==
//                                               "ROLE_EPC_CUSTOMER"
//                                           ? const Color(0xFFFCE6DE)
//                                           : const Color(0xFFECF2FF)),
//                                   width: screenWidth! / 2,
//                                   child: messageItem[i].role !=
//                                           "ROLE_EPC_CUSTOMER"
//                                       ?
//                                       // Right side msgs
//                                       Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           children: [
//                                             Align(
//                                                 alignment: Alignment.topLeft,
//                                                 child: Text(
//                                                   messageItem[i].firstName !=
//                                                           null
//                                                       ? messageItem[i]
//                                                               .firstName ??
//                                                           ""
//                                                       : "",
//                                                   style: const TextStyle(
//                                                     color: Color(0xFF1786C7),
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                     fontSize: 12,
//                                                     fontWeight: FontWeight.w500,
//                                                     fontFamily: "open-medium",
//                                                   ),
//                                                 )),
//                                             Align(
//                                               alignment: Alignment.topLeft,
//                                               child: Text(
//                                                   messageItem[i].message ?? "",
//                                                   style: const TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 14,
//                                                     fontFamily: "open-medium",
//                                                   ),
//                                                   maxLines: 4,
//                                                   overflow:
//                                                       TextOverflow.ellipsis),
//                                             ),
//                                             Align(
//                                               alignment: Alignment.bottomLeft,
//                                               child: AutoSizeText(
//                                                   messageItem[i]
//                                                       .createdAt!
//                                                       .formatDate("hh:mm a"),
//                                                   style: const TextStyle(
//                                                     color: Colors.grey,
//                                                     fontSize: 12,
//                                                     fontWeight: FontWeight.w500,
//                                                     fontFamily: "open-medium",
//                                                   ),
//                                                   maxLines: 1,
//                                                   overflow:
//                                                       TextOverflow.ellipsis),
//                                             ),
//                                             _attatchmentWidget(messageItem[i]
//                                                 .conversationReferenceDTOList)
//                                           ],
//                                         )
//                                       // Left side msgs
//                                       : Column(
//                                           children: [
//                                             Align(
//                                               alignment: Alignment.topRight,
//                                               child: Text(
//                                                   messageItem[i].message ?? "",
//                                                   style: const TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 14,
//                                                     fontFamily: "open-medium",
//                                                   ),
//                                                   maxLines: 4,
//                                                   overflow:
//                                                       TextOverflow.ellipsis),
//                                             ),
//                                             Align(
//                                               alignment: Alignment.topRight,
//                                               child: Text(
//                                                   messageItem[i].createdAt !=
//                                                           null
//                                                       ? messageItem[i]
//                                                           .createdAt!
//                                                           .formatDate("hh:mm a")
//                                                       : "",
//                                                   style: const TextStyle(
//                                                     color: Colors.grey,
//                                                     fontSize: 12,
//                                                     fontFamily: "open-medium",
//                                                   ),
//                                                   maxLines: 1,
//                                                   overflow:
//                                                       TextOverflow.ellipsis),
//                                             ),
//                                             _attatchmentWidget(messageItem[i]
//                                                 .conversationReferenceDTOList)
//                                           ],
//                                         ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         );
//                       },
//                       itemCount: messageItem.length,
//                       shrinkWrap: true,
//                     )
//                   : Container(),
//             ),
//             widget.item!.status != "Open"
//                 ? Container()
//                 : _buildMessageComposer(),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showDialogForCloseTicket() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text(
//             "Close Ticket",
//           ),
//           content: const Text(
//             "Are you sure to close the ticket?",
//           ),
//           actions: <Widget>[
//             InkWell(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: const SizedBox(
//                 height: 35,
//                 width: 50,
//                 child: Text(
//                   'Cancel',
//                   style:
//                       TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
//                 ),
//               ),
//             ),
//             InkWell(
//               onTap: () {
//                 Map<String, dynamic> map = {
//                   "id": widget.item!.id,
//                   "status": "Closed",
//                 };

//                 TopVariable.apiService.closeTickets(map).then((value) async {
//                   setState(() {
//                     widget.item!.status = "Closed";
//                   });
//                   Navigator.pop(context);
//                 }).onError((error, stackTrace) {
//                   if (kDebugMode) {
//                     print(error);
//                   }
//                 });
//               },
//               child: const SizedBox(
//                 height: 35,
//                 width: 100,
//                 child: Text(
//                   'Close Ticket',
//                   style: TextStyle(
//                     color: CustomColor.grenishColor,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//             )
//           ],
//         );
//       },
//     );
//   }

//   Widget _attatchmentWidget(List<ReferenceDTOList>? ref) {
//     // if (kDebugMode) {
//     //   print('Ref ::::::: $ref');
//     // }
//     return ref != null
//         ? ListView.builder(
//             itemCount: ref.length,
//             shrinkWrap: true,
//             itemBuilder: (c, i) {
//               String file = AppUrl.attatchment +
//                   ref[i]
//                       .uri
//                       .replaceFirst("%2Fcustomer%2Fsupport%2F", '')
//                       .replaceAll(" ", "%20");

//               if (kDebugMode) {
//                 print({"attmentUrl": file});
//               }
//               bool check = ref[i].uri.contains(".png") ||
//                   ref[i].uri.contains(".jpg") ||
//                   ref[i].uri.contains(".jpeg");

//               return check
//                   ? Card(
//                       color: ref[i].uri.contains(".png") ||
//                               ref[i].uri.contains(".jpg") ||
//                               ref[i].uri.contains(".jpeg")
//                           ? Colors.black
//                           : Colors.red,
//                       child: Image.network(
//                         file,
//                         width: 60,
//                         height: 50,
//                         fit: BoxFit.cover,
//                       ),
//                     )
//                   : InkWell(
//                       onTap: () {
//                         if (kDebugMode) {
//                           print('Tapping :::: $file');
//                         }
//                         // getx.Get.to(() => PDFScreen(
//                         //       path: file,
//                         //     ));
//                       },
//                       child: Align(
//                         alignment: Alignment.centerLeft,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             Row(
//                               children: [
//                                 SvgPicture.asset(
//                                   ref[i].uri.contains(".pdf")
//                                       ? "assets/awesome-file-pdf.svg"
//                                       : "assets/document.svg",
//                                   width: 50,
//                                   height: 35,
//                                 ),
//                                 const SizedBox(
//                                   width: 10,
//                                 ),
//                                 SizedBox(
//                                   width: getx.Get.width * 0.55,
//                                   child: Text(
//                                     ref[i]
//                                         .uri
//                                         .replaceFirst(
//                                             "%2Fcustomer%2Fsupport%2F", '')
//                                         .replaceAll(" ", "%20"),
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 )
//                               ],
//                             ),
//                             InkWell(
//                               onTap: () async {
//                                 // var path =
//                                 //     'https://devstoragesi.blob.core.windows.net/stage/tenant/1001%2Fcustomer%2Fsupport%2FsaafGharna_2023.11.22.13.55.27.pdf';
//                                 // var path = file;
//                                 var path =
//                                     'https://cdn.mos.cms.futurecdn.net/vChK6pTy3vN3KbYZ7UU7k3-320-80.jpg';
//                                 if (kDebugMode) {
//                                   print('Tapping :::: 1 $path');
//                                 }
//                                 if (path != '') {
//                                   // before download get the permission
//                                   final status =
//                                       await Permission.storage.request();
//                                   if (status.isGranted) {
//                                     final externalDirectory = Platform.isAndroid
//                                         ? await getExternalStorageDirectory()
//                                         : await getApplicationSupportDirectory();
//                                     // download process
//                                     // DateTime now = DateTime.now();
//                                     String? taskId;
//                                     try {
//                                       taskId = await FlutterDownloader.enqueue(
//                                           url: path,
//                                           headers: {
//                                             "auth": "test_for_sql_encoding"
//                                           },
//                                           savedDir: externalDirectory!.path,
//                                           showNotification: true,
//                                           openFileFromNotification: true);
//                                       if (kDebugMode) {
//                                         print('ID :::::: $taskId');
//                                       }
//                                       // setState(() {});
//                                     } catch (e) {
//                                       if (kDebugMode) {
//                                         print(
//                                             'Exception ::: in Button *******)))====> :::::: $e');
//                                       }
//                                     }
//                                   } else {
//                                     getx.Get.snackbar('Alert',
//                                         'Storage permissions not granted',
//                                         backgroundColor:
//                                             CustomColor.grenishColor,
//                                         colorText: Colors.white);
//                                     await Permission.storage.request();
//                                   }
//                                 } else {
//                                   getx.Get.snackbar(
//                                       'Error', 'File Download Failed',
//                                       backgroundColor: CustomColor.grenishColor,
//                                       colorText: Colors.white);
//                                 }
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                     top: 5, right: 5, left: 0, bottom: 5),
//                                 child: AutoSizeText(
//                                   ref[i].uri.contains(".pdf") ? "PDF" : "DOCX",
//                                   softWrap: true,
//                                   maxLines: 1,
//                                   textAlign: TextAlign.center,
//                                   style: const TextStyle(
//                                       color: Colors.black,
//                                       fontFamily: "open-medium",
//                                       fontSize: 10),
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     );
//             },
//           )
//         : const SizedBox.shrink();
//   }

//   _buildMessageComposer() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       height: 70.0,
//       color: Colors.white,
//       child: Row(
//         children: [
//           Expanded(
//             child: Container(
//               height: 40,
//               decoration: BoxDecoration(
//                 border: Border.all(color: const Color(0xFFCACACA), width: 2),
//                 borderRadius: BorderRadius.circular(25),
//               ),
//               child: TextField(
//                 controller: _textEditingController,
//                 textCapitalization: TextCapitalization.sentences,
//                 onChanged: (e) {
//                   setState(() {
//                     message = e;
//                   });
//                 },
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   fontFamily: GoogleFonts.openSans().fontFamily,
//                 ),
//                 decoration: const InputDecoration(
//                     border: InputBorder.none,
//                     enabledBorder: InputBorder.none,
//                     focusedBorder: InputBorder.none,
//                     disabledBorder: InputBorder.none,
//                     hintText: "Type message here...",
//                     hintStyle: TextStyle(color: Colors.grey),
//                     contentPadding: EdgeInsets.only(
//                         left: 15, bottom: 11, top: 11, right: 15)),
//               ),
//             ),
//           ),
//           // IconButton(
//           //   icon: const Icon(Icons.attach_file),
//           //   iconSize: 25.0,
//           //   color: Colors.grey,
//           //   onPressed: () {
//           //     showModalBottomSheet<void>(
//           //         context: context,
//           //         builder: (BuildContext c) {
//           //           return AttatchmentWidget(
//           //             onPressed: (modal) {
//           //               setState(() {
//           //                 _attatchmentList = modal;
//           //               });
//           //             },
//           //           );
//           //         });
//           //   },
//           // ),

//           IconButton(
//             icon: const Icon(Icons.send),
//             iconSize: 25.0,
//             color: message.isEmpty
//                 ? Colors.grey
//                 : CustomColor.grenishColor, //Theme.of(context).primaryColor,
//             onPressed: () {
//               if (message.isEmpty) return;
//               var data = {
//                 "internal": false,
//                 "priority": "Medium",
//                 "message": _textEditingController.text,
//                 "firstName": UserPreferences.user.firstName ?? "",
//                 "role": "ROLE_EPC_CUSTOMER",
//               };
//               var g0 = _attatchmentList
//                   .map((f) async => await MultipartFile.fromFile(f.path))
//                   .toList();
//               var body = FormData.fromMap({
//                 "conversationHistoryDTO": jsonEncode(data),
//                 "multipartFiles": g0
//               });
//               TopVariable.getDioInstance()
//                   .post(
//                       AppUrl.baseUrl +
//                           "/conversation/conversationHistory/${widget.item!.id}/DOCU",
//                       data: body)
//                   .then((value) => {
//                         print(value),
//                         setState(
//                           () {
//                             messageItem.add(UserMessageModal(
//                                 message: message,
//                                 role: "ROLE_EPC_CUSTOMER",
//                                 firstName: widget.item!.firstName,
//                                 createdAt: DateTime.now().toString()));
//                           },
//                         ),
//                         _textEditingController.clear(),
//                         setState(() {
//                           message = "";
//                         })
//                       })
//                   .catchError((error) => {
//                         if (kDebugMode) {print("Error $error")}
//                       });
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class DownloadClass {
//   static void callback(String id, DownloadTaskStatus status, int progress) {
//     if (kDebugMode) {
//       print('ID :::: inSide MAin :::: $id');
//       print('Status :::: inSide MAin :::: $status');
//       print('Progress :::: inSide MAin :::: $progress');
//     }
//   }
// }
