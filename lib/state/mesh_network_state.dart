import 'dart:async';
import 'package:flutter/material.dart';
import '../data/models/mesh_node.dart';
import '../data/mock/mock_data.dart';

class MeshNetworkState extends ChangeNotifier {
  List<MeshNode> _nodes = MockData.meshNodes;
  bool _isScanning = false;
  String _scanStatusText = 'Scan for New Peers';
  String _bandwidth = '14.2 MB/s';
  String _packetLoss = '0.1%';
  String _nodeId = '#mesh-8821-x';

  List<MeshNode> get nodes => _nodes;
  bool get isScanning => _isScanning;
  String get scanStatusText => _scanStatusText;
  String get bandwidth => _bandwidth;
  String get packetLoss => _packetLoss;
  String get nodeId => _nodeId;
  int get activePeerCount => _nodes.where((n) => n.isOnline).length;

  Future<void> triggerScan() async {
    if (_isScanning) return;

    _isScanning = true;
    _scanStatusText = 'Broadcasting Radio Probes...';
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1200));
    _scanStatusText = 'Listening for Local Beacons...';
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1300));
    // Simulate discovering an extra peer or refreshing
    _isScanning = false;
    _scanStatusText = 'Scan for New Peers';
    _bandwidth = '15.8 MB/s';
    notifyListeners();
  }
}
