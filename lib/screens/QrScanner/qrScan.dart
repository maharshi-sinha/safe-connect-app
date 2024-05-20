import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({Key? key}) : super(key: key);

  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  String qrData = '';
  Map<String, String> parsedQRData = {};

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller.pauseCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'QR Scanner',
              style: TextStyle(
                fontFamily: 'Gilroy',
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            Icon(
              Icons.qr_code_scanner,
              color: Color(0xffFFB13D),
            ),
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'QR Category: ${parsedQRData['QRCategory'] ?? 'Unknown'}',
              style: TextStyle(
                fontFamily: 'Gilroy',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: Color(0xffFFB13D),
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: MediaQuery.of(context).size.width * 0.8,
                  ),
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      'Point your camera at a QR code',
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Name: ${parsedQRData['Name'] ?? 'N/A'}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffFFB13D),
                      ),
                    ),
                    if (parsedQRData['QRCategory'] == 'Motor')
                      Column(
                        children: [
                          SizedBox(height: 10),
                          Text(
                            'Vehicle Brand & Name: ${parsedQRData['Vehicle Brand & Name'] ?? 'N/A'}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 16,
                              color: Color(0xffFFB13D),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Vehicle No.: ${parsedQRData['Vehicle No.'] ?? 'N/A'}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 16,
                              color: Color(0xffFFB13D),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _showContactNumber(parsedQRData['Contact No.']);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffFFB13D),
                          ),
                          child: Text(
                            'Contact Number',
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _showContactNumber(parsedQRData['Emergency Contact No.']);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffFFB13D),
                          ),
                          child: Text(
                            'Emergency Contact',
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              color: Colors.white,
                            ),
                          ),
                        ),
                        if (parsedQRData['QRCategory'] == 'Motor')
                          ElevatedButton(
                            onPressed: () {
                              _showMedicalInformation(parsedQRData);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xffFFB13D),
                            ),
                            child: Text(
                              'Medical Information',
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrData = scanData.code!;
        print("Scanned Data: $qrData"); // Debug print
        _parseQRData(qrData);
      });
    });
  }

  void _parseQRData(String data) {
    List<String> keyValuePairs = data.split(', ');

    parsedQRData = Map.fromIterable(
      keyValuePairs,
      key: (pair) => pair.split(': ')[0],
      value: (pair) => pair.split(': ').length > 1 ? pair.split(': ')[1] : '',
    );

    print("Parsed Data: $parsedQRData"); // Debug print
  }

  void _showContactNumber(String? number) {
    if (number != null && number.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Contact Number',
              style: TextStyle(
                fontFamily: 'Gilroy',
                color: Color(0xffFFB13D),
              ),
            ),
            content: Text(number),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Close',
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    color: Color(0xffFFB13D),
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No contact number available')),
      );
    }
  }

  void _showMedicalInformation(Map<String, String> data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Medical Information'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Blood Type: ${data['Blood Type'] ?? 'N/A'}'),
                Text('Blood Pressure: ${data['Blood Pressure'] ?? 'N/A'}'),
                Text('Allergies: ${data['Allergies'] ?? 'N/A'}'),
                Text('Medications: ${data['Medications'] ?? 'N/A'}'),
                Text('Organ Donor: ${data['Organ Donor'] ?? 'N/A'}'),
                Text('Medical Notes: ${data['Medical Notes'] ?? 'N/A'}'),
                Text('Disease: ${data['Disease'] ?? 'N/A'}'),
                Text('Immunizations: ${data['Immunizations'] ?? 'N/A'}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
