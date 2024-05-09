import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({Key? key}) : super(key: key);

  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  bool scanSuccess = false;
  String qrData = '';
  Map<String, String> parsedQRData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'QRCategory: ${parsedQRData['QRCategory'] ?? 'Unknown'}',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          if (scanSuccess)
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.grey[200],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Name: ${parsedQRData['Name']}',
                      textAlign: TextAlign.center,
                    ),
                    if (parsedQRData['QRCategory'] == 'Motor')
                      Column(
                        children: [
                          Text(
                            'Vehicle Brand & Name: ${parsedQRData['Vehicle Brand & Name']}',
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Vehicle No.: ${parsedQRData['Vehicle No.']}',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _showContactNumber(parsedQRData['Contact No.']);
                          },
                          child: Text('Contact Number'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _showContactNumber(
                                parsedQRData['Emergency Contact No.']);
                          },
                          child: Text('Emergency Contact'),
                        ),
                        if (parsedQRData['QRCategory'] == 'Motor')
                          ElevatedButton(
                            onPressed: () {
                              _showMedicalInformation(parsedQRData);
                            },
                            child: Text('Medical Information'),
                          ),
                      ],
                    ),
                  ],
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
        _parseQRData(qrData);
        scanSuccess = true;
      });
    });
  }

  void _parseQRData(String data) {
    List<String> keyValuePairs = data.split(', ');

    parsedQRData = Map.fromIterable(
      keyValuePairs,
      key: (pair) => pair.split(': ')[0],
      value: (pair) => pair.split(': ')[1],
    );
  }

  void _showContactNumber(String? number) {
    if (number != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Contact Number'),
            content: Text(number),
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
  }

  void _showMedicalInformation(Map<String, String> data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Medical Information'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Blood Type: ${data['Blood Type']}'),
              Text('Blood Pressure: ${data['Blood Pressure']}'),
              Text('Allergies: ${data['Allergies']}'),
              Text('Medications: ${data['Medications']}'),
              Text('Organ Donor: ${data['Organ Donor']}'),
              Text('Medical Notes: ${data['Medical Notes']}'),
              Text('Disease: ${data['Disease']}'),
              Text('Immunizations: ${data['Immunizations']}'),
            ],
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
