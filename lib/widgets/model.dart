import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class Device {
  String name;
  final String id;
  final bool status;
  double frontTemp;
  double backTemp;
  BluetoothDevice? bluetoothDevice;

  Device(this.name, this.id, this.status,
      {this.frontTemp = 0.0, this.backTemp = 0.0, this.bluetoothDevice});
}

class DeviceModel extends ChangeNotifier {
  final List<Device> _devices = [];

  List<Device> get devices => _devices;

  void addDevice(Device device) {
    if (!_devices.any((d) => d.id == device.id)) {
      _devices.add(device);
      notifyListeners();
    }
  }

  void removeDevice(Device device) {
    _devices.removeWhere((d) => d.id == device.id);
    notifyListeners();
  }
}
