import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class VehicleDataPage extends StatefulWidget {
  @override
  _VehicleDataPageState createState() => _VehicleDataPageState();
}

class _VehicleDataPageState extends State<VehicleDataPage> {
  late TextEditingController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _fetchVehicleData(String vehicleNumber) async {
    final Uri url = Uri.parse(
        'https://safeconnect-e81248c2d86f.herokuapp.com/vehicle/get_vehicle_data/$vehicleNumber');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load vehicle data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching vehicle data: $e');
      throw Exception('Failed to load vehicle data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter Vehicle Number',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                final vehicleNumber = _controller.text;
                if (vehicleNumber.isNotEmpty) {
                  try {
                    final data = await _fetchVehicleData(vehicleNumber);
                    // Navigate to the next screen to display data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VehicleDataScreen(data),
                      ),
                    );
                  } catch (e) {
                    // Show error dialog
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Error'),
                        content: Text('Failed to load vehicle data: $e'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                }
              },
              child:
                  _isLoading ? CircularProgressIndicator() : Text('Fetch Data'),
            ),
          ],
        ),
      ),
    );
  }
}

class VehicleDataScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  VehicleDataScreen(this.data);

  @override
  Widget build(BuildContext context) {
    final vehicleData = data['Data'][0];
    final qrCodeUrl = vehicleData['qrcode_url'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Owner Name: ${vehicleData['owner_name']}',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            SizedBox(height: 8),
            Text(
              'Vehicle Type: ${vehicleData['vehicle_type']}',
              style: TextStyle(fontSize: 18, color: Colors.orange),
            ),
            SizedBox(height: 8),
            Text(
              'Vehicle Brand: ${vehicleData['vehicle_brand']}',
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
            SizedBox(height: 8),
            Text(
              'Vehicle Number: ${vehicleData['vehicle_no']}',
              style: TextStyle(fontSize: 18, color: Colors.purple),
            ),
            SizedBox(height: 8),
            Text(
              'Email: ${vehicleData['email']}',
              style: TextStyle(fontSize: 18, color: Colors.indigo),
            ),
            SizedBox(height: 8),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () => _launchCaller(vehicleData['contact_number']),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text('Call'),
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () => _launchCaller(vehicleData['emergency_number']),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text('SOS'),
              ),
            ),
            SizedBox(height: 8),
            FutureBuilder<Uint8List?>(
              future: _fetchQrCodeImage(qrCodeUrl),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Failed to load QR code image');
                } else if (snapshot.hasData) {
                  return Image.memory(
                    snapshot.data!,
                    width: 100,
                    height: 100,
                  );
                } else {
                  return Text('No data available');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<Uint8List?> _fetchQrCodeImage(String qrCodeUrl) async {
    try {
      final response = await http.get(Uri.parse(qrCodeUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to load QR code image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching QR code image: $e');
      throw Exception('Failed to load QR code image: $e');
    }
  }

  void _launchCaller(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
