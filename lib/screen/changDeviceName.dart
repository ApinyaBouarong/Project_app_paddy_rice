import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:paddy_rice/widgets/model.dart';

@RoutePage()
class ChangeDeviceNameRoute extends StatelessWidget {
  final Device device;

  ChangeDeviceNameRoute({required this.device});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController =
        TextEditingController(text: device.name);

    return Scaffold(
      appBar: AppBar(
        title: Text('Change Device Name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Device Name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newDevice =
                    Device(nameController.text, device.id, device.status);
                Navigator.pop(context, newDevice);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
