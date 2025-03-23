import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'View PDF from API',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SurveyForm(),
    );
  }
}

class SurveyForm extends StatefulWidget {
  @override
  _SurveyFormState createState() => _SurveyFormState();
}

class _SurveyFormState extends State<SurveyForm> {
  bool isLoading = false;
  String? pdfUrl;

  @override
  void initState() {
    super.initState();
    requestStoragePermission();
  }

  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
      status = await Permission.storage.status;
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('กรุณาอนุญาตให้เข้าถึงพื้นที่จัดเก็บข้อมูล')),
        );
      }
    }
  }

  final Map<String, String> surveyData = {
    "age": "30",
    "maritalStatus": "สมรส/มีคู่นอน",
    "children": "มี",
    "futureChildren": "ไม่ใช่",
    "healthIssues": "ไม่ใช่",
    "birthControlExperience": "ไม่มี",
    "sideEffects": "",
    "birthControlPlan": "ใช่",
    "yearsPlanned": "1-3 ปี",
  };

  // เปิด PDF จาก API
  Future<void> viewPdfFromApi() async {
    setState(() {
      isLoading = true;
    });

    try {
      final jsonData = json.encode(surveyData);

      final response = await http.post(
        Uri.parse('http://192.168.1.37:3000/pdf'),
        headers: {"Content-Type": "application/json"},
        body: jsonData,
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;

        // สร้างไฟล์ชั่วคราวสำหรับเปิด PDF
        final directory = await getTemporaryDirectory();
        final tempFilePath = '${directory.path}/temp_survey.pdf';
        final file = File(tempFilePath);

        // เขียนข้อมูลลงในไฟล์ชั่วคราว
        await file.writeAsBytes(bytes);

        // เปิด PDF viewer
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFViewPage(
              pdfFilePath: tempFilePath,
              pdfBytes: bytes,
              onDownload: downloadPdf,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'ไม่สามารถโหลด PDF จาก API ได้! สถานะ: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
      );
    }
  }

  // ดาวน์โหลด PDF ลงอุปกรณ์
  Future<void> downloadPdf() async {
    setState(() {
      isLoading = true;
    });

    try {
      // ขอสิทธิ์การเข้าถึงพื้นที่จัดเก็บข้อมูล
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
        status = await Permission.storage.status;
        if (!status.isGranted) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('กรุณาอนุญาตให้เข้าถึงพื้นที่จัดเก็บข้อมูล')),
          );
          return;
        }
      }

      final jsonData = json.encode(surveyData);

      final response = await http.post(
        Uri.parse('http://192.168.1.37:3000/pdf'),
        headers: {"Content-Type": "application/json"},
        body: jsonData,
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;

        // หาโฟลเดอร์สำหรับบันทึกไฟล์ (Downloads folder หรือ External Storage)
        Directory? downloadDir;

        if (Platform.isAndroid) {
          // สำหรับ Android
          downloadDir = Directory('/storage/emulated/0/Download');
          // ตรวจสอบว่าโฟลเดอร์มีอยู่จริง
          if (!await downloadDir.exists()) {
            // ถ้าไม่มีโฟลเดอร์ให้ใช้ External Storage ทั่วไป
            downloadDir = await getExternalStorageDirectory();
          }
        } else if (Platform.isIOS) {
          // สำหรับ iOS
          downloadDir = await getApplicationDocumentsDirectory();
        }

        if (downloadDir != null) {
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final filePath = '${downloadDir.path}/survey_$timestamp.pdf';
          final file = File(filePath);

          // บันทึกไฟล์
          await file.writeAsBytes(bytes);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('บันทึกไฟล์ PDF ที่: $filePath'),
              duration: Duration(seconds: 5),
              action: SnackBarAction(
                label: 'เปิด',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PDFViewPage(
                        pdfFilePath: filePath,
                        pdfBytes: bytes,
                        onDownload: downloadPdf,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('ไม่สามารถหาโฟลเดอร์สำหรับบันทึกไฟล์ได้')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'ไม่สามารถโหลด PDF จาก API ได้! สถานะ: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการดาวน์โหลด: $e')),
      );
    }
  }

  // เปิด PDF จาก URL ในเบราว์เซอร์ (สำหรับดาวน์โหลดผ่านเบราว์เซอร์)
  Future<void> openPdfInBrowser() async {
    setState(() {
      isLoading = true;
    });

    try {
      // ในตัวอย่างนี้ เราจะใช้การส่ง GET request แทน POST
      // คุณต้องปรับ API เพื่อรองรับการดาวน์โหลดผ่าน GET โดยส่งพารามิเตอร์ในรูปแบบ query string
      String queryParams = Uri.encodeQueryComponent(json.encode(surveyData));
      String url = 'http://192.168.1.37:3000/pdf?data=$queryParams';

      // ลองเปิด URL ในเบราว์เซอร์
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ไม่สามารถเปิด URL ในเบราว์เซอร์ได้')),
        );
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แบบฟอร์มสำรวจ'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? CircularProgressIndicator()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: viewPdfFromApi,
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                      child: Text('เปิด PDF จาก API'),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: downloadPdf,
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        backgroundColor: Colors.green,
                      ),
                      child: Text('ดาวน์โหลด PDF ลงอุปกรณ์'),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: openPdfInBrowser,
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        backgroundColor: Colors.orange,
                      ),
                      child: Text('เปิด PDF ในเบราว์เซอร์'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class PDFViewPage extends StatelessWidget {
  final String pdfFilePath;
  final List<int>? pdfBytes;
  final Function? onDownload;

  PDFViewPage({
    required this.pdfFilePath,
    this.pdfBytes,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
        actions: [
          if (pdfBytes != null)
            IconButton(
              icon: Icon(Icons.download),
              onPressed: () {
                if (onDownload != null) {
                  onDownload!();
                } else {
                  _savePdf(context);
                }
              },
              tooltip: 'ดาวน์โหลด PDF',
            ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () => _sharePdf(context),
            tooltip: 'แชร์ PDF',
          ),
        ],
      ),
      body: PDFView(
        filePath: pdfFilePath,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageSnap: true,
        defaultPage: 0,
        fitPolicy: FitPolicy.BOTH,
        onError: (error) {
          print('Error rendering PDF: $error');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('เกิดข้อผิดพลาดในการเปิดไฟล์ PDF')),
          );
        },
        onPageError: (page, error) {
          print('Error rendering page $page: $error');
        },
      ),
    );
  }

  // บันทึก PDF ลงอุปกรณ์
  Future<void> _savePdf(BuildContext context) async {
    try {
      // ขอสิทธิ์การเข้าถึงพื้นที่จัดเก็บข้อมูล
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
        status = await Permission.storage.status;
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('กรุณาอนุญาตให้เข้าถึงพื้นที่จัดเก็บข้อมูล')),
          );
          return;
        }
      }

      Directory? downloadDir;

      if (Platform.isAndroid) {
        // สำหรับ Android
        downloadDir = Directory('/storage/emulated/0/Download');
        // ตรวจสอบว่าโฟลเดอร์มีอยู่จริง
        if (!await downloadDir.exists()) {
          // ถ้าไม่มีโฟลเดอร์ให้ใช้ External Storage ทั่วไป
          downloadDir = await getExternalStorageDirectory();
        }
      } else if (Platform.isIOS) {
        // สำหรับ iOS
        downloadDir = await getApplicationDocumentsDirectory();
      }

      if (downloadDir != null) {
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final targetPath = '${downloadDir.path}/survey_$timestamp.pdf';

        // คัดลอกไฟล์จากที่ชั่วคราวไปยังที่ถาวร
        final file = File(pdfFilePath);
        await file.copy(targetPath);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('บันทึกไฟล์ PDF ที่: $targetPath')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ไม่สามารถหาโฟลเดอร์สำหรับบันทึกไฟล์ได้')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
      );
    }
  }

  // แชร์ PDF
  Future<void> _sharePdf(BuildContext context) async {
    try {
      await Share.shareXFiles([XFile(pdfFilePath)],
          text: 'แบบสอบถามความคิดเห็น');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ไม่สามารถแชร์ไฟล์ได้: $e')),
      );
    }
  }
}
