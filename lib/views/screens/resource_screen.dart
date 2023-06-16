// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:exam_buddy/helper/helper_function.dart';
import 'package:exam_buddy/views/widgets/sidebar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ResourceScreen extends StatefulWidget {
  const ResourceScreen({Key? key}) : super(key: key);

  @override
  State<ResourceScreen> createState() => _ResourceScreenState();
}

class _ResourceScreenState extends State<ResourceScreen> {
  String email = "";
  List<Map<String, dynamic>> pdfData = [];
  @override
  void initState() {
    getEmail();
    super.initState();
  }

  Future<String> uploadPDF(String filename, File file) async {
    final stref =
        FirebaseStorage.instance.ref().child("Resources/$email/$filename.pdf");
    final upload = stref.putFile(file);
    await upload.whenComplete(() => () {});
    final link = await stref.getDownloadURL();
    return link;
  }

  void pickfile() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (pickedFile != null) {
      String filename = pickedFile.files[0].name;
      File file = File(pickedFile.files[0].path!);
      final url = await uploadPDF(filename, file);
      await FirebaseFirestore.instance
          .collection("Resources")
          .doc(email)
          .collection("pdfs")
          .add({
            "name": filename,
            "url": url,
          })
          .then((value) => Get.snackbar("Success", "File uploaded successfully",
              backgroundColor: Colors.green))
          .catchError((error) => Get.snackbar("Error", error.toString(),
              backgroundColor: Colors.red));
    }
  }

  getEmail() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(
        title: Text(
          "Resources",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: CircleAvatar(
                  radius: 20,
                  foregroundImage: AssetImage("assets/user.jpg"),
                ),
              ),
              SizedBox(
                width: 3.w,
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Resources")
            .doc(email)
            .collection("pdfs")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              itemCount: snapshot.data!.docs.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Get.to(() => PDFViewerScreen(
                          pdftitle: snapshot.data!.docs[index]['name'],
                          pdfUrl: snapshot.data!.docs[index]['url']));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              "assets/file.png",
                              height: 80,
                              width: 80,
                            ),
                            Text(
                              snapshot.data!.docs[index]['name'],
                              style: TextStyle(fontSize: 14),
                            ),
                          ]),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 10.0,
        backgroundColor: Colors.white,
        onPressed: () {
          pickfile();
        },
        child: Icon(
          Icons.file_upload,
          color: Colors.black,
        ),
      ),
    );
  }
}

class PDFViewerScreen extends StatefulWidget {
  final String pdfUrl;
  final String pdftitle;
  PDFViewerScreen({super.key, required this.pdfUrl, required this.pdftitle});

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  PDFDocument? pdfDocument;
  void initPdf() async {
    pdfDocument = await PDFDocument.fromURL(widget.pdfUrl);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initPdf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(widget.pdftitle),
        centerTitle: true,
      ),
      body: pdfDocument != null
          ? PDFViewer(
              document: pdfDocument!,
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
